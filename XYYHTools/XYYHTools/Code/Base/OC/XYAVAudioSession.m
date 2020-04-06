//
//  XYAVAudioSession.m
//  EStudy
//
//  Created by 细雨湮痕 on 2018/11/1.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

#import "XYAVAudioSession.h"

@implementation XYAVAudioSession

NS_ASSUME_NONNULL_BEGIN
+ (nullable NSError* )SetCategory:(AVAudioSession *)audioSession category:(AVAudioSessionCategory)category options:(AVAudioSessionCategoryOptions)options {
    
    NSError *sessionError = nil;
    
    [audioSession setCategory:category withOptions:options error:&sessionError];
    
    if(sessionError) {
        
        return sessionError;
    }
    
    return nil;
}

@end
NS_ASSUME_NONNULL_END
