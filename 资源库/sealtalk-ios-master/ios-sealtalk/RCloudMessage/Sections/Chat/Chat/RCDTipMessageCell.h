//
//  RCDTipMessageCell.h
//  SealTalk
//
//  Created by 张改红 on 2019/6/19.
//  Copyright © 2019 RongCloud. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCDTipMessageCell : RCMessageBaseCell

@property (nonatomic, strong) RCTipLabel *tipMessageLabel;

- (void)setDataModel:(RCMessageModel *)model;
@end

NS_ASSUME_NONNULL_END
