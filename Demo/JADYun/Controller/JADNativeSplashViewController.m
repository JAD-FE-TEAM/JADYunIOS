//
//  JADNativeSplashViewController.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/11/16.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "JADNativeSplashViewController.h"
#import <SDWebImage/SDWebImage.h>

#if __has_include(<JADYunNative/JADNativeAd.h>)
#import <JADYunNative/JADNativeAd.h>
#else
#import <JADYun/JADNativeAd.h>
#endif

#if __has_include(<JADYunCore/JADLog.h>)
#import <JADYunCore/JADLog.h>
#else
#import <JADYun/JADLog.h>
#endif

#if __has_include(<JADYunCore/JADNativeAdWidget.h>)
#import <JADYunCore/JADNativeAdWidget.h>
#import <JADYunCore/JADNativeShakeWidget.h>
#import <JADYunCore/JADNativeSwipeWidget.h>
#import <JADYunCore/JADCommonMacros.h>
#else
#import <JADYun/JADNativeAdWidget.h>
#import <JADYun/JADNativeShakeWidget.h>
#import <JADYun/JADNativeSwipeWidget.h>
#import <JADYun/JADCommonMacros.h>
#endif

#define JADScreenRate       (375.0/self.widthSlider.value)

@interface JADNativeSplashViewController ()<JADNativeAdDelegate>

@property (strong, nonatomic) UIView *clickMaskView;                        // 点击特定区域蒙版视图
@property (strong, nonatomic) UILabel *clickMaskLable;
@property (strong, nonatomic) UIImageView *rightSkipView;
@property (strong, nonatomic) UIButton *skipButton;
@property (strong, nonatomic) UIImageView *logoAdView;
@property (strong, nonatomic) UIImageView *splashAdView;
@property (strong, nonatomic) UIAlertController *alertController;

@property (strong, nonatomic) JADNativeAd *nativeAd;
@property (strong, nonatomic) JADNativeAdWidget *nativeAdWidget;
@property (strong, nonatomic) JADNativeShakeWidget *shakeView;              // 摇一摇视图
@property (strong, nonatomic) JADNativeSwipeWidget *swipeView;              // 滑动视图

@property (assign, nonatomic) NSInteger eventInteractionSelectedIndex;

@property (weak, nonatomic) IBOutlet UILabel *widthLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;

@property (weak, nonatomic) IBOutlet UISlider *widthSlider;
@property (weak, nonatomic) IBOutlet UISlider *heightSlider;

@property (weak, nonatomic) IBOutlet UITextField *slotIDTextField;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *eventInteractionList;

@end

@implementation JADNativeSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self setupStoryBoardView];
}

- (void)setupStoryBoardView {
    self.slotIDTextField.text = @"2514";
    
    self.widthSlider.maximumValue = CGRectGetWidth(self.view.frame);
    self.widthSlider.value = [UIScreen mainScreen].bounds.size.width;
    self.widthLabel.text = [NSString stringWithFormat:@"宽:%@", @(self.widthSlider.value)];
    
    self.heightSlider.maximumValue = CGRectGetHeight(self.view.frame);
    self.heightSlider.value = [UIScreen mainScreen].bounds.size.height;
    self.heightLabel.text = [NSString stringWithFormat:@"高:%@", @(self.heightSlider.value)];
}

- (void)setupView {
    self.splashAdView = [[UIImageView alloc] init];
    self.splashAdView.contentMode = UIViewContentModeScaleToFill;
    
    self.nativeAdWidget = [[JADNativeAdWidget alloc] init];
    
    self.shakeView = self.nativeAdWidget.shakeWidget;
    [self.shakeView setFrame:CGRectMake((self.widthSlider.value - 90)/2, self.heightSlider.value * 0.8, 90, 90)];
    
    self.swipeView = self.nativeAdWidget.swipeWidget;
    [self.swipeView setFrame:CGRectMake(30, self.heightSlider.value * 0.8, (self.widthSlider.value - 60), 100)];
    
    self.logoAdView = self.nativeAdWidget.logoAdWidget;
    [self.splashAdView addSubview:self.logoAdView];
    
    self.skipButton = self.nativeAdWidget.skipWidget;
    [self.skipButton setTitle:@"跳过 5" forState:UIControlStateNormal];
    
    [self.splashAdView addSubview:self.skipButton];
    
    // 点击区域蒙版视图
    self.clickMaskView = [[UIView alloc] initWithFrame:CGRectMake(0 , self.view.frame.size.height - 70, self.view.frame.size.width, 70)];
    self.clickMaskView.layer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7].CGColor;
    
    UILabel *clickMaskLable = [[UILabel alloc] initWithFrame:CGRectMake(16, 19.5, self.view.frame.size.width - 32, 31)];
    clickMaskLable.text = @"点击前往第三方应用或页面";
    clickMaskLable.textColor = [UIColor whiteColor];
    clickMaskLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 22];
    self.clickMaskLable = clickMaskLable;
    [self.clickMaskView addSubview:self.clickMaskLable];
    
    UIImageView *rightSkipView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow"]];
    rightSkipView.frame = CGRectMake(self.clickMaskView.frame.size.width - 23, 27, 8.5, 16);
    self.rightSkipView = rightSkipView;
    [self.clickMaskView addSubview:self.rightSkipView];
}

- (void)loadNativeAd {
    // 设置广告位图片的尺寸
    JADNativeSize *imgSize = [[JADNativeSize alloc] init];
    imgSize.width = self.widthSlider.value;
    imgSize.height = self.heightSlider.value;
    
    // 设置广告位
    JADNativeAdSlot *slot = [[JADNativeAdSlot alloc] init];
    slot.type = JADSlotTypeSplash;
    slot.slotID = self.slotIDTextField.text;
    slot.imgSize = imgSize;
    slot.skipTime = 8;
    slot.eventInteractionType = self.eventInteractionSelectedIndex;
        
    self.nativeAd = [[JADNativeAd alloc] initWithSlot:slot];
    self.nativeAd.rootViewController = self;
    self.nativeAd.delegate = self;

    [self.nativeAd loadAdData];
}

#pragma mark - Action Method

- (IBAction)buttonPressedLoadAdAction:(id)sender {
    [self.slotIDTextField resignFirstResponder];
    [self.splashAdView removeFromSuperview];
    [self setSplashAdView:nil];
    
    [self setupView];
    [self loadNativeAd];
}

- (IBAction)buttonPressedInteractionAction:(UIButton *)sender {
    if (sender.selected == YES) {
        return;
    }
    
    for (UIButton *button in self.eventInteractionList) {
        button.selected = NO;
    }
    sender.selected = YES;
    self.eventInteractionSelectedIndex = sender.tag - 100;
}

- (IBAction)sliderPositonWChanged:(id)sender {
    self.widthLabel.text = [NSString stringWithFormat:@"宽:%.0f", self.widthSlider.value];
}

- (IBAction)sliderPositionHChanged:(id)sender {
    self.heightLabel.text = [NSString stringWithFormat:@"高:%.0f", self.heightSlider.value];
}

#pragma mark - UITapGesture Action

- (IBAction)tapViewAction:(id)sender {
    [self.slotIDTextField resignFirstResponder];
}


#pragma mark - JADNativeAdDelegate

- (void)jadNativeAdDidLoadSuccess:(JADNativeAd *)nativeAd {
    JADLogI(@"SplashAd Did Load Success");
    if (!nativeAd.data && nativeAd.data.count == 0) { return; }
    if (!(nativeAd == self.nativeAd)) { return; }
    
    JADNativeAdData *adData = nativeAd.data.firstObject;
    [self.splashAdView sd_setImageWithURL:[NSURL URLWithString:adData.adImages.firstObject] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!error) {
            [self.splashAdView setFrame:CGRectMake(0, 0, self.widthSlider.value, self.heightSlider.value)];
            [self.skipButton setFrame:CGRectMake(self.splashAdView.frame.size.width - 75, 45, 57, 24)];
            [self.logoAdView setFrame:CGRectMake(16, 52, 26, 10)];
            
            [self.clickMaskView removeFromSuperview];
            [self.shakeView removeFromSuperview];
            
            if (self.eventInteractionSelectedIndex == JADEventInteractionTypeNormal) {
                // 更新限点图层布局
                [self.clickMaskView setFrame:CGRectMake(0 , self.heightSlider.value - 70/JADScreenRate, self.widthSlider.value, 70/JADScreenRate)];
                [self.clickMaskLable setFrame:CGRectMake(16/JADScreenRate, 19.5/JADScreenRate, self.widthSlider.value, 31/JADScreenRate)];
                [self.clickMaskLable setFont:[UIFont fontWithName:@"PingFangSC-Regular" size: 22/JADScreenRate]];
                [self.rightSkipView setFrame:CGRectMake(self.clickMaskView.frame.size.width - 23/JADScreenRate, 27/JADScreenRate, 8.5/JADScreenRate, 16/JADScreenRate)];
                
                [self.splashAdView addSubview:self.clickMaskView];
                [self.nativeAd registerContainer:self.splashAdView withClickableViews:@[self.clickMaskView] withClosableViews:@[self.skipButton]];
            } else if (self.eventInteractionSelectedIndex == JADEventInteractionTypeShake) {
                // 更新摇一摇组件布局
                [self.shakeView setFrame:CGRectMake((self.widthSlider.value - 90/JADScreenRate)/2, self.heightSlider.value * 0.8, 90/JADScreenRate, 90/JADScreenRate)];
                
                [self.splashAdView addSubview:self.shakeView];
                [self.nativeAd registerContainer:self.splashAdView withClickableViews:@[self.shakeView] withClosableViews:@[self.skipButton]];
                [self.shakeView play];
            } else {
                // 更新滑动组件布局
                [self.swipeView setFrame:CGRectMake(30, self.heightSlider.value * 0.8, (self.widthSlider.value - 60), 100/JADScreenRate)];
                
                [self.splashAdView addSubview:self.swipeView];
                [self.nativeAd registerContainer:self.splashAdView withClickableViews:@[self.swipeView] withClosableViews:@[self.skipButton]];
                [self.swipeView play];
            }
            [[UIApplication sharedApplication].keyWindow addSubview:self.splashAdView];
        }
    }];
}

- (void)jadNativeAdDidLoadFailure:(JADNativeAd *)nativeAd error:(NSError *)error {
    JADLogI(@"SplashAd Did Load Failure");
    self.alertController.message = error.description;
    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (void)jadNativeAdDidExposure:(JADNativeAd *)nativeAd {
    JADLogI(@"SplashAd Did Exposure");
}

- (void)jadNativeAdDidClick:(JADNativeAd *)nativeAd withView:(UIView * _Nullable)view {
    JADLogI(@"SplashAd Did Click");
}

- (void)jadNativeAdDidClose:(JADNativeAd *)nativeAd withView:(UIView * _Nullable)view {
    JADLogI(@"SplashAd Did Close");
    [self.splashAdView removeFromSuperview];
    self.splashAdView = nil;
    
    if (self.eventInteractionSelectedIndex == JADEventInteractionTypeShake) {
        // 关闭摇一摇
        [self.shakeView stop];
    } else if (self.eventInteractionSelectedIndex == JADEventInteractionTypeSwipe) {
        // 关闭滑动
        [self.swipeView stop];
    } else {
        // 默认的点击交互方式
    }
}

- (void)jadNativeAdDidCloseOtherController:(JADNativeAd *)nativeAd
                           interactionType:(JADInteractionType)interactionType {
    JADLogI(@"SplashAd Did Close Other Controller");
    NSString *str;
    if (interactionType == JADInteractionTypeURL) {
        str = @"ladingURL";
    }
}

- (void)jadNativeAdForSplash:(JADNativeAd *)nativeAd countDown:(int)countDown {
    JADLogI(@"SplashAd countDown : %d",countDown);
    NSString *titleStr = [NSString stringWithFormat:@"跳过 %d", countDown];
    [self.skipButton setTitle:titleStr forState:UIControlStateNormal];
}

#pragma mark - Setter/Getter

- (UIAlertController *)alertController {
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:@"错误信息" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [_alertController addAction:okAction];
    }
    return _alertController;
}

@end
