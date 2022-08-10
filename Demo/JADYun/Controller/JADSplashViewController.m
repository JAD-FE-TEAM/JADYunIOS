//
//  JADSplashViewController.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/8/14.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "JADSplashViewController.h"

#if __has_include(<JADYunCore/JADYunUmbrella.h>)
#import <JADYunCore/JADYunUmbrella.h>
#else
#import <JADYun/JADYunUmbrella.h>
#endif


#if __has_include(<JADYunSplash/JADSplashView.h>)
#import <JADYunSplash/JADSplashView.h>
#else
#import <JADYun/JADSplashView.h>
#endif

@interface JADSplashViewController () <JADSplashViewDelegate>

@property (strong, nonatomic) JADSplashView *splashView;
@property (strong, nonatomic) UIAlertController *alertController;

@property (weak, nonatomic) IBOutlet UILabel *borderWidthLabel;
@property (weak, nonatomic) IBOutlet UILabel *borderScaleLabel;
@property (weak, nonatomic) IBOutlet UISlider *borderWidthSlider;
@property (weak, nonatomic) IBOutlet UISlider *borderScaleSlider;
@property (weak, nonatomic) IBOutlet UITextField *slotIDTextField;
@property (weak, nonatomic) IBOutlet UILabel *borderHeightLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *splashStyleButtonList;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *splashSizeButtonList;

@property (weak, nonatomic) IBOutlet UISwitch *borderTestSwitch;

@property (weak, nonatomic) IBOutlet UIView *screenConfigView;
@property (weak, nonatomic) IBOutlet UIView *borderConfigView;

@property (weak, nonatomic) IBOutlet UILabel *screenWidthLabel;
@property (weak, nonatomic) IBOutlet UISlider *screenWidthSlider;
@property (weak, nonatomic) IBOutlet UISlider *screenHeightSlider;
@property (weak, nonatomic) IBOutlet UILabel *screenHeightLabel;

@property (assign, nonatomic) NSInteger splashStyleSelectedIndex;

@property (weak, nonatomic) IBOutlet UILabel *nativeSlashStyleTitleLabel;
@property (weak, nonatomic) IBOutlet UIStackView *nativeSplashStyleUpperView;
@property (weak, nonatomic) IBOutlet UIStackView *nativeSplashStyleLowerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *screenConfigHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopConstraint;
@property (weak, nonatomic) IBOutlet UISwitch *forbidDynamicSwitch;

@end

@implementation JADSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)setupViews {
    self.slotIDTextField.text = @"2514";
    
    self.screenWidthSlider.maximumValue = CGRectGetWidth(self.view.frame);
    self.screenWidthSlider.value = [UIScreen mainScreen].bounds.size.width;
    self.screenWidthLabel.text = [NSString stringWithFormat:@"宽:%@", @(self.screenWidthSlider.value)];
    
    self.screenHeightSlider.maximumValue = CGRectGetHeight(self.view.frame);
    self.screenHeightSlider.value = [UIScreen mainScreen].bounds.size.height;
    self.screenHeightLabel.text = [NSString stringWithFormat:@"高:%@", @(self.screenHeightSlider.value)];
}

#pragma mark - Load Ad Method

// 加载开屏广告视图
- (void)loadData {
    CGFloat splashWidth = 0.0;
    CGFloat splashHeight = 0.0;
    if (self.borderTestSwitch.on) {
        splashWidth = self.borderWidthSlider.value;
        splashHeight = self.borderWidthSlider.value/self.borderScaleSlider.value;
    } else {
        splashWidth = self.screenWidthSlider.value;
        splashHeight = self.screenHeightSlider.value;
    }
    
    self.splashView = [[JADSplashView alloc] initWithSlotID:self.slotIDTextField.text
                                                          adSize:CGSizeMake(splashWidth, splashHeight)];
    
    self.splashView.tolerateTime = 5; // Optional  加载广告最大容忍时长，默认5s
    self.splashView.skipTime = 10; // Optional  开屏广告跳过时长，默认5s
    self.splashView.delegate = self;
    self.splashView.rootViewController = self;

    
    if (self.splashStyleSelectedIndex == 0) {
        self.splashView.splashStyle = JADSplashStyleServerConfig;   // 采用服务器配置
    } else if (self.splashStyleSelectedIndex == 1) {
        self.splashView.splashStyle = JADSplashStyleNormal;         // 默认不处理，全屏可点击
    } else if (self.splashStyleSelectedIndex == 2) {
        self.splashView.splashStyle = JADSplashStyleOnlyText;       // 显示小文案，全屏可点击
    } else if (self.splashStyleSelectedIndex == 3) {
        self.splashView.splashStyle = JADSplashStyleOnlyTextClick;  // 显示点击文案，点击文案区域可点击
    } else if (self.splashStyleSelectedIndex == 4) {
        self.splashView.splashStyle = JADSplashStyleTextNormal;     // 显示点击文案，全屏可点击
    }
    
    [self.splashView loadAdData];
}

- (void)removeSplashAdView {
    if (self.splashView) {
        [self.splashView removeFromSuperview];
        self.splashView = nil;
    }
}

#pragma mark - Action Method

// 加载广告按钮 点击事件
- (IBAction)buttonPressedLoadAdAction:(id)sender {
    [self removeSplashAdView];
    
    [self.slotIDTextField resignFirstResponder];
    [self loadData];
}

- (IBAction)borderSliderPositonWChanged:(id)sender {
    self.borderWidthLabel.text = [NSString stringWithFormat:@"宽:%.0f", self.borderWidthSlider.value];
    
    [self updateRangeLabel];
}

// slider 比例调整
- (IBAction)borderSliderScaleChanged:(id)sender {
    self.borderScaleLabel.text = [NSString stringWithFormat:@"比例:%.2f", self.borderScaleSlider.value];
    
    [self updateRangeLabel];
}

- (IBAction)screenSliderPositionWChanged:(id)sender {
    self.screenWidthLabel.text = [NSString stringWithFormat:@"宽:%.0f", self.screenWidthSlider.value];
}

- (IBAction)screenSliderPositionHChanged:(id)sender {
    self.screenHeightLabel.text = [NSString stringWithFormat:@"高:%.0f", self.screenHeightSlider.value];
}

// 控制器视图 Tap事件
- (IBAction)tapViewAction:(id)sender {
    [self.slotIDTextField resignFirstResponder];
}

- (IBAction)buttonPressedSplashStyleSelectedAction:(UIButton *)sender {
    if (sender.selected == YES) {
        return;
    }
    
    for (UIButton *button in self.splashStyleButtonList) {
        button.selected = NO;
    }
    sender.selected = YES;
    self.splashStyleSelectedIndex = sender.tag - 100;
}

- (IBAction)buttonPressedSplashAdSizeSelectedAction:(UIButton *)sender {
    if (sender.selected == YES) {
        return;
    }
    
    for (UIButton *button in self.splashSizeButtonList) {
        button.selected = NO;
    }
    sender.selected = YES;

    if (sender.tag - 200 == 0) {
        self.borderScaleSlider.minimumValue = 0.61;
        self.borderScaleSlider.maximumValue = 0.75;
        self.borderScaleSlider.value = 0.67;
    } else if (sender.tag - 200 == 1) {
        self.borderScaleSlider.minimumValue = 0.49;
        self.borderScaleSlider.maximumValue = 0.61;
        self.borderScaleSlider.value = 0.56;
    }

    [self updateRangeLabel];

}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    
    if (sender.isOn) {
        self.screenConfigHeightConstraint.constant = 162;
        
        
        self.screenConfigView.hidden = YES;
        self.borderConfigView.hidden = NO;
        
        self.borderWidthSlider.maximumValue = CGRectGetWidth(self.view.frame);
        self.borderWidthSlider.value = [UIScreen mainScreen].bounds.size.width;
        self.borderWidthLabel.text = [NSString stringWithFormat:@"宽:%@", @(self.borderWidthSlider.value)];
        
        self.borderScaleSlider.minimumValue = 0.61;
        self.borderScaleSlider.maximumValue = 0.75;
        self.borderScaleSlider.value = 0.67;
        
        [self updateRangeLabel];

    } else {
        self.screenConfigHeightConstraint.constant = 110;
        
        self.screenConfigView.hidden = NO;
        self.borderConfigView.hidden = YES;

        self.screenWidthSlider.maximumValue = CGRectGetWidth(self.view.frame);
        self.screenWidthSlider.value = [UIScreen mainScreen].bounds.size.width;
        self.screenWidthLabel.text = [NSString stringWithFormat:@"宽:%@", @(self.screenWidthSlider.value)];
        
        self.screenHeightSlider.maximumValue = CGRectGetHeight(self.view.frame);
        self.screenHeightSlider.value = [UIScreen mainScreen].bounds.size.height;
        self.screenHeightLabel.text = [NSString stringWithFormat:@"高:%@", @(self.screenHeightSlider.value)];
    }
}
- (IBAction)nativeRenderSwitchValueChanged:(UISwitch *)sender {
    if (sender.isOn) {
        self.buttonTopConstraint.constant = 155;
        self.nativeSlashStyleTitleLabel.hidden = NO;
        self.nativeSplashStyleUpperView.hidden = NO;
        self.nativeSplashStyleLowerView.hidden = NO;
    } else {
        self.buttonTopConstraint.constant = 20;
        self.nativeSlashStyleTitleLabel.hidden = YES;
        self.nativeSplashStyleUpperView.hidden = YES;
        self.nativeSplashStyleLowerView.hidden = YES;
    }
}

#pragma mark - Private Method

- (void)updateRangeLabel {
    self.borderScaleLabel.text  = [NSString stringWithFormat:@"比例:%.2f", self.borderScaleSlider.value];
    self.borderHeightLabel.text = [NSString stringWithFormat:@"当前高度: %.2f", (self.borderWidthSlider.value/self.borderScaleSlider.value)];
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


#pragma mark - JADSplashDelegate

// 加载成功回调
- (void)jadSplashViewDidLoadSuccess:(JADSplashView *)splashView {
    JADLogI(@"SplashView Did Load Successs");
}

// 返回的错误码（error），表示广告加载失败的原因，所有错误码详情，请见接入文档/iOS/错误码
- (void)jadSplashViewDidLoadFailure:(JADSplashView *)splash error:(NSError *)error {
    JADLogI(@"SplashView Did Load Failure");
    
    [self removeSplashAdView];
    
    self.alertController.message = error.description;
    [self presentViewController:self.alertController animated:YES completion:nil];
}

// 渲染成功回调
- (void)jadSplashViewDidRenderSuccess:(JADSplashView *)splashView {
    JADLogI(@"SplashView Did Render Success");
    if (self.splashView != splashView) { return; }
    
    [self.navigationController.view addSubview:splashView];
}

// 渲染失败，网络原因或者硬件原因导致渲染失败，可以更换手机或者网络环境测试。
- (void)jadSplashViewDidRenderFailure:(JADSplashView *)splashView error:(NSError *)error {
    JADLogI(@"SplashView Did Render Failure");

    [self removeSplashAdView];
    
    self.alertController.message = error.description;
    [self presentViewController:self.alertController animated:YES completion:nil];
}

// 开屏广告即将展示
- (void)jadSplashViewDidExposure:(JADSplashView *)splashView {
    JADLogI(@"SplashView Did Exposure");
}

// 点击回调
- (void)jadSplashViewDidClick:(JADSplashView *)splashView {
    JADLogI(@"SplashView Did Click");
}

// 关闭回调，当点击跳过按钮或者用户点击广告时会直接触发此回调，建议在此回调方法中直接进行广告对象的移除动作，并将广告对象置为nil
- (void)jadSplashViewDidClose:(JADSplashView *)splashView {
    JADLogI(@"SplashView Did Close");
    
    [self removeSplashAdView];
}

// 此回调在广告跳转到其他控制器时，该控制器被关闭时调用
- (void)jadSplashViewDidCloseOtherController:(JADSplashView *)splashView
                             interactionType:(JADInteractionType)interactionType {
    JADLogI(@"SplashView Did Close Other Controller");
    NSString *str;
    if (interactionType == JADInteractionTypeURL) {
        str = @"ladingURL";
    }
}

@end
