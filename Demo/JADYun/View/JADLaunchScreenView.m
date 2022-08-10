//
//  JADLaunchScreenView.m
//  JADYun_Example
//
//  Created by zhangdi208 on 2021/1/11.
//  Copyright © 2021 JD.COM. All rights reserved.
//

#import "JADLaunchScreenView.h"

@implementation JADLaunchScreenView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *imgBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anSplashBg"]];
        imgBG.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 100);
        imgBG.contentMode = UIViewContentModeScaleAspectFill;
        imgBG.clipsToBounds = YES;
        [self addSubview:imgBG];
        
        UIImageView *imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anSplashLogo"]];
        imgLogo.frame = CGRectMake(0, frame.size.height - 100, frame.size.width, 100);
        imgLogo.contentMode = UIViewContentModeScaleAspectFill;
        imgLogo.clipsToBounds = YES;
        [self addSubview:imgLogo];

    }
    return self;
}

- (void)setAutoCloseAfterTime:(NSInteger)time {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)),dispatch_get_main_queue(),^{
        [self removeFromSuperview];
    });
}

@end
