// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "MSIDBrokerKeyProvider.h"
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>
#import "NSData+MSIDExtensions.h"
#import "MSIDConstants.h"
#import "MSIDKeychainUtil.h"

@interface MSIDBrokerKeyProvider()

@property (nonatomic) NSString *keychainAccessGroup;

@end

@implementation MSIDBrokerKeyProvider

- (instancetype)initWithGroup:(NSString *)keychainGroup
{
    self = [super init];

    if (self)
    {
        if (!keychainGroup)
        {
            keychainGroup = [[NSBundle mainBundle] bundleIdentifier];
        }

        if (!MSIDKeychainUtil.teamId)
        {
            MSID_LOG_ERROR(nil, @"Failed to read teamID from keychain");
            return nil;
        }

        // Add team prefix to keychain group if it is missed.
        if (![keychainGroup hasPrefix:MSIDKeychainUtil.teamId])
        {
            keychainGroup = [MSIDKeychainUtil accessGroup:keychainGroup];
        }

        _keychainAccessGroup = keychainGroup;
    }

    return self;
}

- (NSData *)brokerKeyWithError:(NSError **)error
{
    OSStatus err = noErr;

    NSData *symmetricTag = [MSID_BROKER_SYMMETRIC_KEY_TAG dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *symmetricKeyQuery =
    @{
      (id)kSecClass : (id)kSecClassKey,
      (id)kSecAttrApplicationTag : symmetricTag,
      (id)kSecAttrKeyType : @(CSSM_ALGID_AES),
      (id)kSecReturnData : @(YES),
      (id)kSecAttrAccessGroup : self.keychainAccessGroup
      };

    // Get the key bits.
    CFDataRef symmetricKey = nil;
    err = SecItemCopyMatching((__bridge CFDictionaryRef)symmetricKeyQuery, (CFTypeRef *)&symmetricKey);
    if (err == errSecSuccess)
    {
        NSData *result = (__bridge NSData*)symmetricKey;
        CFRelease(symmetricKey);
        return result;
    }

    // Try to read previous format without keychain access groups
    NSMutableDictionary *query = [symmetricKeyQuery mutableCopy];
    [query removeObjectForKey:(id)kSecAttrAccessGroup];

    /*
     SecItemCopyMatching will look for items in all access groups that app has access to.
     This means there might be multiple items if app declares multiple access groups.
     However, we specifically don't set kSecMatchLimit, so it will take the first match.
     That will mimic previous ADAL behavior.

     From Apple documentation:

     By default, this function returns only the first match found. To obtain
     more than one matching item at a time, specify kSecMatchLimit with a value
     greater than 1. The result will be a CFArrayRef containing up to that
     number of matching items; the items' types are described above.
     */

    err = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&symmetricKey);

    if (err == errSecSuccess)
    {
        NSData *result = (__bridge NSData*)symmetricKey;
        CFRelease(symmetricKey);
        return result;
    }

    return [self createBrokerKeyWithError:error];
}

- (NSData *)createBrokerKeyWithError:(NSError **)error
{
    uint8_t *symmetricKey = NULL;
    OSStatus err = errSecSuccess;

    symmetricKey = calloc( 1, kChosenCipherKeySize * sizeof(uint8_t));
    if (!symmetricKey)
    {
        MSIDFillAndLogError(error, MSIDErrorBrokerKeyFailedToCreate, @"Could not create broker key.", nil);
        return nil;
    }

    err = SecRandomCopyBytes(kSecRandomDefault, kChosenCipherKeySize, symmetricKey);
    if (err != errSecSuccess)
    {
        MSID_LOG_ERROR(nil, @"Failed to copy random bytes for broker key. Error code: %d", (int)err);
        MSIDFillAndLogError(error, MSIDErrorBrokerKeyFailedToCreate, @"Could not create broker key.", nil);
        free(symmetricKey);
        return nil;
    }

    NSData *keyData = [[NSData alloc] initWithBytes:symmetricKey length:kChosenCipherKeySize * sizeof(uint8_t)];
    free(symmetricKey);

    NSData *symmetricTag = [MSID_BROKER_SYMMETRIC_KEY_TAG dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *symmetricKeyAttr =
    @{
      (id)kSecClass : (id)kSecClassKey,
      (id)kSecAttrKeyClass : (id)kSecAttrKeyClassSymmetric,
      (id)kSecAttrApplicationTag : (id)symmetricTag,
      (id)kSecAttrKeyType : @(CSSM_ALGID_AES),
      (id)kSecAttrKeySizeInBits : @(kChosenCipherKeySize << 3),
      (id)kSecAttrEffectiveKeySize : @(kChosenCipherKeySize << 3),
      (id)kSecAttrCanEncrypt : @YES,
      (id)kSecAttrCanDecrypt : @YES,
      (id)kSecValueData : keyData,
      (id)kSecAttrAccessible : (id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
      (id)kSecAttrAccessGroup : self.keychainAccessGroup
      };

    // First delete current symmetric key.
    if (![self deleteSymmetricKeyWithError:error])
    {
        return nil;
    }

    err = SecItemAdd((__bridge CFDictionaryRef)symmetricKeyAttr, NULL);

    if (err != errSecSuccess)
    {
        NSString *descr = [NSString stringWithFormat:@"Could not write broker key %ld", (long)err];
        MSIDFillAndLogError(error, MSIDErrorBrokerKeyFailedToCreate, descr, nil);
        return nil;
    }

    return keyData;
}

- (BOOL)deleteSymmetricKeyWithError:(NSError **)error
{
    OSStatus err = noErr;

    NSData *symmetricTag = [MSID_BROKER_SYMMETRIC_KEY_TAG dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary* symmetricKeyQuery =
    @{
      (id)kSecClass : (id)kSecClassKey,
      (id)kSecAttrApplicationTag : symmetricTag,
      (id)kSecAttrKeyType : @(CSSM_ALGID_AES),
      (id)kSecAttrAccessGroup : self.keychainAccessGroup
      };

    // Delete the symmetric key.
    err = SecItemDelete((__bridge CFDictionaryRef)symmetricKeyQuery);

    // Try to delete something that doesn't exist isn't really an error
    if (err != errSecSuccess && err != errSecItemNotFound)
    {
        NSString *descr = [NSString stringWithFormat:@"Failed to delete broker key with error: %d", (int)err];
        MSIDFillAndLogError(error, MSIDErrorBrokerKeyFailedToCreate, descr, nil);
        return NO;
    }

    return YES;
}

@end
