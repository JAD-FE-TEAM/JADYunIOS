//
//  JADNativeBannerAdTableViewCell.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/11/17.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "JADNativeBannerAdTableViewCell.h"
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

#import <SDWebImage/SDWebImage.h>

static CGSize const logoSize = {26, 10};

@interface JADNativeBannerAdTableViewCell ()

@property (strong, nonatomic) JADNativeAdWidget *adWidget;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIImageView *adLogo;

@end

@implementation JADNativeBannerAdTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.adWidget = [[JADNativeAdWidget alloc] init];
    self.closeButton = self.adWidget.closeWidget;
    self.adLogo = self.adWidget.logoAdWidget;
    
    [self.contentView addSubview:self.containerView];
    [self.contentView addSubview:self.closeButton];
    [self.contentView addSubview:self.adLogo];
}

#pragma mark - Public Method

- (void)refreshUIWithModel:(JADBannerModel *)model {
    self.bannerModel = model;
    
    for (UIView *view in self.containerView.subviews) {
        [view removeFromSuperview];
    }
    
    JADNativeAdData *adData = model.nativeAd.data.firstObject;
    
    CGFloat contentWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    self.containerView.frame = CGRectMake(0, 0, contentWidth, model.imgViewHeight);
    
    UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, model.imgViewHeight)];
    adImageView.contentMode = UIViewContentModeScaleAspectFill;
    adImageView.clipsToBounds = YES;
    
    [adImageView sd_setImageWithURL:[NSURL URLWithString:adData.adImages.firstObject] placeholderImage:nil];
    [self.containerView addSubview:adImageView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[
                             (id)[[UIColor blackColor] colorWithAlphaComponent:0].CGColor,
                             (id)[[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor];
    gradientLayer.frame = CGRectMake(0, model.imgViewHeight-60, contentWidth, 60);
    [adImageView.layer addSublayer:gradientLayer];

    UILabel *titleLable = self.adWidget.adDescriptionWidget;
    titleLable.frame = CGRectMake(10, model.imgViewHeight-10-20, contentWidth-100, 20);
    titleLable.textColor = [UIColor whiteColor];
    titleLable.font = [UIFont boldSystemFontOfSize:18];
    titleLable.text = @"这里是描述描述描述描述！！！";
    [adImageView addSubview:titleLable];
    
    [self.bannerModel.nativeAd registerContainer:adImageView withClickableViews:nil withClosableViews:@[self.closeButton]];
    
    self.closeButton.frame = CGRectMake(contentWidth - self.closeButton.frame.size.width - 15,
                                        model.imgViewHeight+(bottomHeight - self.closeButton.frame.size.height)/2,
                                        self.closeButton.frame.size.width,
                                        self.closeButton.frame.size.height);
    self.adLogo.frame = CGRectMake(self.closeButton.frame.origin.x-logoSize.width - 20,
                                   model.imgViewHeight+(bottomHeight-logoSize.height)/2,
                                   logoSize.width,
                                   logoSize.height);
    
}

@end
