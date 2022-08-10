//
//  JADNativeInterstitialViewController.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/11/16.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "JADNativeInterstitialViewController.h"
#if __has_include(<JADYunNative/JADNativeAd.h>)
#import <JADYunNative/JADNativeAd.h>
#else
#import <JADYun/JADNativeAd.h>
#endif

#if __has_include(<JADYunCore/JADNativeAdWidget.h>)
#import <JADYunCore/JADNativeAdWidget.h>
#import <JADYunCore/JADNativeShakeWidget.h>
#import <JADYunCore/JADNativeSwipeWidget.h>
#else
#import <JADYun/JADNativeAdWidget.h>
#import <JADYun/JADNativeShakeWidget.h>
#import <JADYun/JADNativeSwipeWidget.h>
#endif

#if __has_include(<JADYunCore/JADCommonMacros.h>)
#import <JADYunCore/JADCommonMacros.h>
#else
#import <JADYun/JADCommonMacros.h>
#endif

#if __has_include(<JADYunCore/JADLog.h>)
#import <JADYunCore/JADLog.h>
#else
#import <JADYun/JADLog.h>
#endif

#import <SDWebImage/SDWebImage.h>

static CGSize const closeSize = {20, 20};
static CGSize const logoSize = {26, 10};
#define edge 20
#define titleHeight 40

@interface JADNativeInterstitialViewController ()<JADNativeAdDelegate>

@property (assign, nonatomic) NSInteger interstitialSelectedIndex;
@property (strong, nonatomic) NSArray *interstitialIDList;
@property (strong, nonatomic) NSArray *interstitialSizeList;
@property (strong, nonatomic) UIAlertController *alertController;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *interstitialButtonList;
@property (weak, nonatomic) IBOutlet UITextField *slotIDTextField;

@property (strong, nonatomic) JADNativeAd *nativeAd;
@property (strong, nonatomic) JADNativeAdWidget *nativeAdWidget;
@property (strong, nonatomic) UIView *bgMaskView;
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIImageView *logoImgView;
@property (strong, nonatomic) UIImageView *interstitialAdView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *describeLabel;
@property (strong, nonatomic) UIButton *closeButton;

@end

@implementation JADNativeInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self loadData];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
        
    self.bgMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JADScreenWidth, JADScreenHeight)];
    self.bgMaskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    self.bgMaskView.hidden = YES;
    [self.view addSubview:self.bgMaskView];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.bgMaskView addSubview:self.bgView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.textColor = [UIColor blackColor];
    [self.bgView addSubview:self.titleLabel];
    
    self.describeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.describeLabel.textAlignment = NSTextAlignmentLeft;
    self.describeLabel.font = [UIFont systemFontOfSize:13];
    self.describeLabel.textColor = [UIColor lightGrayColor];
    [self.bgView addSubview:self.describeLabel];
    
    self.interstitialAdView = [[UIImageView alloc] init];
    self.interstitialAdView.contentMode = UIViewContentModeScaleAspectFill;
    self.interstitialAdView.clipsToBounds = YES;
    self.interstitialAdView.layer.masksToBounds = YES;
    self.interstitialAdView.layer.cornerRadius = 5;
    self.interstitialAdView.layer.borderWidth = 1.0;
    self.interstitialAdView.layer.borderColor = [UIColor orangeColor].CGColor;
    [self.bgView addSubview:self.interstitialAdView];
    
    self.nativeAdWidget = [[JADNativeAdWidget alloc] init];
    self.logoImgView = self.nativeAdWidget.logoAdWidget;
    [self.bgView addSubview:self.logoImgView];
    
    self.closeButton = self.nativeAdWidget.closeWidget;
    [self.closeButton setImage:[UIImage imageNamed:@"anCloseBg"] forState:UIControlStateNormal];
    [self.bgMaskView addSubview:self.closeButton];
}

- (void)loadData {
    self.interstitialSelectedIndex = 0;
    self.interstitialIDList = @[@"2522", @"2523"];
    self.slotIDTextField.text = self.interstitialIDList.firstObject;
    self.interstitialSizeList = @[[NSValue valueWithCGSize:CGSizeMake(300, 450)],
                                  [NSValue valueWithCGSize:CGSizeMake(300, 200)]];
}

/**
 * important: 传入图片尺寸，返回的素材大小
 * 0.61~0.75: 返回的图片尺寸 800 * 1200
 * 1.32~1.64: 返回的图片尺寸 480 * 320
 */
- (void)loadNativeAd {
    NSValue *sizeValue = self.interstitialSizeList[self.interstitialSelectedIndex];
    
    // 设置广告位图片的尺寸
    JADNativeSize *imgSize = [[JADNativeSize alloc] init];
    imgSize.width = [sizeValue CGSizeValue].width;
    imgSize.height = [sizeValue CGSizeValue].height;
    
    // 设置广告位
    JADNativeAdSlot *slot = [[JADNativeAdSlot alloc] init];
    slot.type = JADSlotTypeInterstitial;
    slot.slotID = self.slotIDTextField.text;
    slot.imgSize = imgSize;
    
    self.nativeAd = [[JADNativeAd alloc] initWithSlot:slot];
    self.nativeAd.rootViewController = self;
    self.nativeAd.delegate = self;
    
    [self.nativeAd loadAdData];
}

#pragma mark - JADNativeAdDelegate

- (void)jadNativeAdDidLoadSuccess:(JADNativeAd *)nativeAd {
    JADLogI(@"InterstitialAd Did Load Success");
    
    if (!nativeAd.data && nativeAd.data.count == 0) { return; }
    
    JADNativeAdData *adData = nativeAd.data.firstObject;
    self.titleLabel.text = adData.adTitle;
    self.describeLabel.text = adData.adDescription;
    
    NSValue *sizeValue = self.interstitialSizeList[self.interstitialSelectedIndex];
    CGSize adSlotImgSize = [sizeValue CGSizeValue];
    
    CGFloat contentWidth = JADScreenWidth - 2*edge - 2*5;
    CGFloat imageViewHeight = contentWidth * adSlotImgSize.height/adSlotImgSize.width;
    if (imageViewHeight > JADScreenHeight * 0.7) { imageViewHeight = JADScreenHeight * 0.7 - 80; }
    self.interstitialAdView.frame = CGRectMake(5, titleHeight, contentWidth, imageViewHeight);
    
    CGFloat bgViewHeight = titleHeight + imageViewHeight + 10 + 30;
    if (self.describeLabel.text.length > 0) {
        bgViewHeight = bgViewHeight + titleHeight + 10;
    }
    
    self.bgView.frame = CGRectMake(edge, (self.view.frame.size.height - bgViewHeight)/2, self.view.frame.size.width-2*edge, bgViewHeight);
    
    self.titleLabel.frame = CGRectMake(13, 0, self.bgView.frame.size.width - 2*13, titleHeight);
    self.describeLabel.frame = CGRectMake(0, 0, self.bgView.frame.size.width - 2*13, titleHeight);
    
    CGFloat margin = 5;
    CGFloat logoIconX = CGRectGetWidth(self.bgView.bounds) - logoSize.width - margin;
    CGFloat logoIconY = self.bgView.frame.size.height - logoSize.height - margin;
    self.logoImgView.frame = CGRectMake(logoIconX, logoIconY, logoSize.width, logoSize.height);
    
    self.closeButton.frame = CGRectMake(CGRectGetMaxX(self.bgView.frame)-closeSize.width , self.bgView.frame.origin.y-closeSize.height-10, closeSize.width, closeSize.height);
    
    if (adData.adImages.firstObject) {
        [self.interstitialAdView sd_setImageWithURL:[NSURL URLWithString:adData.adImages.firstObject] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            self.bgMaskView.hidden = NO;
        }];
    }
    
    [self.nativeAd registerContainer:self.bgView withClickableViews:@[self.titleLabel, self.interstitialAdView, self.describeLabel] withClosableViews:@[self.closeButton]];
}

- (void)jadNativeAdDidLoadFailure:(JADNativeAd *)nativeAd error:(NSError *)error {
    JADLogI(@"InterstitialAd Did Load Failure");
    
    self.alertController.message = error.description;
    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (void)jadNativeAdDidExposure:(JADNativeAd *)nativeAd {
    JADLogI(@"InterstitialAd Did Exposure");
}

- (void)jadNativeAdDidClick:(JADNativeAd *)nativeAd withView:(UIView * _Nullable)view {
    JADLogI(@"InterstitialAd Did Click");
}

- (void)jadNativeAdDidClose:(JADNativeAd *)nativeAd withView:(UIView * _Nullable)view {
    JADLogI(@"InterstitialAd Did Close");
    
    self.bgMaskView.hidden = YES;
    self.interstitialAdView.image = nil;
}

- (void)jadNativeAdDidCloseOtherController:(JADNativeAd *)nativeAd
                           interactionType:(JADInteractionType)interactionType {
    JADLogI(@"InterstitialAd Did Close Other Controller");
    NSString *str;
    if (interactionType == JADInteractionTypeURL) {
        str = @"ladingURL";
    }
}

#pragma mark - Button Action

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
}

- (IBAction)buttonPressedLoadAdAction:(UIButton *)sender {
    [self.slotIDTextField resignFirstResponder];
    
    self.nativeAd = nil;
    [self loadNativeAd];
}

- (IBAction)tapViewAction:(id)sender {
    [self.slotIDTextField resignFirstResponder];
}

#pragma mark - Setter & Getter

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
