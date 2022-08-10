//
//  JADLaunchScreenView.h
//  JADYun_Example
//
//  Created by zhangdi208 on 2021/1/11.
//  Copyright © 2021 JD.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JADLaunchScreenView : UIView

/// 设置几秒后关闭
/// @param time 秒
- (void)setAutoCloseAfterTime:(NSInteger)time;
@end

NS_ASSUME_NONNULL_END
