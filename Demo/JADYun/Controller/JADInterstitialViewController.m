//
//  JADInterstitialViewController.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/8/17.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "JADInterstitialViewController.h"
#if __has_include(<JADYunInterstitial/JADInterstitialAd.h>)
#import <JADYunInterstitial/JADInterstitialAd.h>
#else
#import <JADYun/JADInterstitialAd.h>
#endif

#if __has_include(<JADYunCore/JADLog.h>)
#import <JADYunCore/JADLog.h>
#else
#import <JADYun/JADLog.h>
#endif


@interface JADInterstitialViewController () <JADInterstitialAdDelegate>

@property (strong, nonatomic) JADInterstitialAd *interstitialAd;
@property (assign, nonatomic) NSInteger interstitialSelectedIndex;
@property (strong, nonatomic) NSArray *interstitialIDList;
@property (strong, nonatomic) NSArray *interstitialSizeList;
@property (strong, nonatomic) UIAlertController *alertController;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *interstitialButtonList;
@property (weak, nonatomic) IBOutlet UILabel *widthLabel;
@property (weak, nonatomic) IBOutlet UISlider *widthSlider;
@property (weak, nonatomic) IBOutlet UITextField *slotIDTextField;

@property (weak, nonatomic) IBOutlet UILabel *scaleLabel;
@property (weak, nonatomic) IBOutlet UISlider *scaleSlider;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;

@end

@implementation JADInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self loadData];
    
    [self updateRangeLabel];
}

- (void)setupViews {
    self.widthSlider.maximumValue = CGRectGetWidth(self.view.frame);
    self.widthSlider.value = [UIScreen mainScreen].bounds.size.width;
    self.widthLabel.text = [NSString stringWithFormat:@"宽:%@", @(self.widthSlider.value)];
    
    self.scaleSlider.minimumValue = 0.64;
    self.scaleSlider.maximumValue = 0.75;
    self.scaleSlider.value = 0.67;
}

- (void)loadData {
    self.interstitialSelectedIndex = 0;
    self.interstitialIDList = @[@"2522", @"2523"];
    self.slotIDTextField.text = self.interstitialIDList.firstObject;
    self.interstitialSizeList = @[[NSValue valueWithCGSize:CGSizeMake(300, 450)],
                                  [NSValue valueWithCGSize:CGSizeMake(300, 200)]];
}

#pragma mark - Load Ad Method

// 加载插屏广告视图
- (void)loadInterstitialWithSlotID:(NSString *)slotID size:(CGSize)size {
    self.interstitialAd = nil;
    
    /**
     * important: 支持的广告位尺寸比例范围
     * 0.64~0.75
     * 1.32~1.64
     */

    CGFloat interstitialWidth = self.widthSlider.value;
    CGFloat interstitialHeight = self.widthSlider.value/self.scaleSlider.value;
    
    self.interstitialAd = [[JADInterstitialAd alloc] initWithSlotID:slotID adSize:CGSizeMake(interstitialWidth, interstitialHeight)];
    self.interstitialAd.delegate = self;
    [self.interstitialAd loadAdData];
}

#pragma mark - Action Method

// 尺寸按钮 点击事件
- (IBAction)buttonPressedClickAction:(UIButton *)sender {
    if (sender.selected == YES) {
        return;
    }
    
    for (UIButton *button in self.interstitialButtonList) {
        button.selected = NO;
    }
    sender.selected = YES;
    self.interstitialSelectedIndex = sender.tag - 100;
    self.slotIDTextField.text = [self.interstitialIDList objectAtIndex:self.interstitialSelectedIndex];
    
    if (sender.tag - 100 == 0) {
        self.scaleSlider.minimumValue = 0.64;
        self.scaleSlider.maximumValue = 0.75;
        self.scaleSlider.value = 0.67;
    } else if (sender.tag - 100 == 1) {
        self.scaleSlider.minimumValue = 1.32;
        self.scaleSlider.maximumValue = 1.64;
        self.scaleSlider.value = 1.5;
    }

    [self updateRangeLabel];
}

// 加载广告按钮 点击事件
- (IBAction)buttonPressedLoadAdAction:(UIButton *)sender {
    [self.slotIDTextField resignFirstResponder];
    
    NSString *slotID = self.slotIDTextField.text;
    NSValue *sizeValue    = self.interstitialSizeList[self.interstitialSelectedIndex];
    
    [self loadInterstitialWithSlotID:slotID size:[sizeValue CGSizeValue]];

}

// slider 滑动事件
- (IBAction)sliderPositionChanged:(id)sender {
    self.widthLabel.text = [NSString stringWithFormat:@"宽:%.0f", self.widthSlider.value];
    
    [self updateRangeLabel];
}

// slider 比例调整
- (IBAction)sliderScaleChanged:(id)sender {
    self.scaleLabel.text = [NSString stringWithFormat:@"比例:%.2f", self.scaleSlider.value];
    
    [self updateRangeLabel];
}

// 控制器视图 Tap事件
- (IBAction)tapViewAction:(id)sender {
    [self.slotIDTextField resignFirstResponder];
}

#pragma mark - Private Method

- (void)updateRangeLabel {
    self.scaleLabel.text  = [NSString stringWithFormat:@"比例:%.2f", self.scaleSlider.value];
    self.heightLabel.text = [NSString stringWithFormat:@"当前高度: %.2f", (self.widthSlider.value/self.scaleSlider.value)];
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

#pragma mark - JADInterstitialDelegate

// 加载成功回调
- (void)jadInterstitialAdDidLoadSuccess:(JADInterstitialAd *)interstitialAd {
    JADLogI(@"InterstitialAd Did Load Success");
}

// 返回的错误码（error），表示广告加载失败的原因，所有错误码详情，请见接入文档/iOS/错误码
- (void)jadInterstitialAdDidLoadFailure:(JADInterstitialAd *)interstitialAd error:(NSError *)error {
    JADLogI(@"InterstitialAd Did Load Failure");
    
    self.alertController.message = error.description;
    [self presentViewController:self.alertController animated:YES completion:nil];
}

// 渲染成功回调
- (void)jadInterstitialAdDidRenderSuccess:(JADInterstitialAd *)interstitialAd {
    JADLogI(@"InterstitialAd Did Render Success");
    
    [self.interstitialAd showAdFromRootViewController:self];
}

// 渲染失败，网络原因或者硬件原因导致渲染失败，可以更换手机或者网络环境测试。
- (void)jadInterstitialAdDidRenderFailure:(JADInterstitialAd *)interstitialAd error:(NSError *)error {
    JADLogI(@"InterstitialAd Did Render Failure");
    
    self.alertController.message = error.description;
    [self presentViewController:self.alertController animated:YES completion:nil];
}

// 插屏广告即将展示
- (void)jadInterstitialAdDidExposure:(JADInterstitialAd *)interstitialAd {
    JADLogI(@"InterstitialAd Did Exposure");
}

// 点击回调
- (void)jadInterstitialAdDidClose:(JADInterstitialAd *)interstitialAd {
    JADLogI(@"InterstitialAd Did Close");
    
    self.interstitialAd = nil;
}

// 关闭回调，建议在此回调方法中直接进行广告对象的移除动作，并将广告对象置为nil
- (void)jadInterstitialAdDidClick:(JADInterstitialAd *)interstitialAd {
    JADLogI(@"InterstitialAd Did Click");
}

// 此回调在广告跳转到其他控制器时，该控制器被关闭时调用
- (void)jadInterstitialAdDidCloseOtherController:(JADInterstitialAd *)interstitialAd
                                 interactionType:(JADInteractionType)interactionType {
    JADLogI(@"InterstitialAd Did Close OtherController");
    NSString *str;
    if (interactionType == JADInteractionTypeURL) {
        str = @"ladingURL";
    }
}

@end
