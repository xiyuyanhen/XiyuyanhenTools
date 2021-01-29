//
//  MSALiOS-Swift.h
//  MSALiOS
//
//  Created by 细雨湮痕 on 2021/1/26.
//  Copyright © 2021 Microsoft. All rights reserved.
//

#ifndef MSALiOS_Swift_h
#define MSALiOS_Swift_h

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

// Internal MSAL Files
#import "MSAL_Internal.h"
#import "MSIDLogger+Internal.h"
#import "NSString+MSIDExtensions.h"
#import "NSDictionary+MSIDExtensions.h"
#import "NSOrderedSet+MSIDExtensions.h"
#import "MSIDOAuth2Constants.h"

#import "MSAL.h"




#endif /* MSALiOS_Swift_h */
