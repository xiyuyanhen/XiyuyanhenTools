//
//  XYAVAudioSession.h
//  EStudy
//
//  Created by 细雨湮痕 on 2018/11/1.
//  Copyright © 2018 xiyuyanhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYAVAudioSession : NSObject

+ (nullable NSError *)SetCategory:(AVAudioSession *)audioSession category:(AVAudioSessionCategory)category options:(AVAudioSessionCategoryOptions)options;

@end

NS_ASSUME_NONNULL_END
