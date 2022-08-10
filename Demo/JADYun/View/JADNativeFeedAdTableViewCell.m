//
//  JADNativeFeedAdTableViewCell.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/11/25.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "JADNativeFeedAdTableViewCell.h"

#if __has_include(<JADYunCore/JADCommonMacros.h>)
#import <JADYunCore/JADCommonMacros.h>
#else
#import <JADYun/JADCommonMacros.h>
#endif

#import <SDWebImage/SDWebImage.h>

static CGFloat const margin = 15;
static CGSize const logoSize = {26, 10};
static UIEdgeInsets const padding = {10, 15, 10, 15};

@implementation JADNativeFeedAdTableViewCell
@synthesize nativeAd, nativeAdWidget;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.separatorLine = [[UIView alloc] initWithFrame:CGRectMake(margin, 0, JADScreenWidth-margin*2, 0.5)];
    self.separatorLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.separatorLine];
    
    self.adImageView = [[UIImageView alloc] init];
    self.adImageView.userInteractionEnabled = YES;
    self.adImageView.clipsToBounds = YES;
    self.adImageView.layer.masksToBounds = YES;
    self.adImageView.layer.cornerRadius = 5;
    self.adImageView.layer.borderWidth = 1.0;
    self.adImageView.layer.borderColor = [UIColor orangeColor].CGColor;

    [self.contentView addSubview:self.adImageView];

    self.nativeAdWidget = [[JADNativeAdWidget alloc] init];

    self.adTitleLabel = self.nativeAdWidget.adTitleWidget;
    [self.contentView addSubview:self.adTitleLabel];
    
    self.adDescriptionLabel = self.nativeAdWidget.adDescriptionWidget;
    [self.contentView addSubview:self.adDescriptionLabel];
}

+ (CGFloat)cellHeightWithModel:(JADNativeAd *)model width:(CGFloat)width {
    return 0;
}

- (void)refreshUIWithModel:(JADNativeAd *)modle {
    self.nativeAd = modle;
    [self.adImageView addSubview:self.nativeAdWidget.logoAdWidget];
    [self.contentView addSubview:self.nativeAdWidget.closeWidget];
}

@end

@implementation JADNativeFeedSmallImageAdTableViewCell

- (void)refreshUIWithModel:(JADNativeAd *)model {
    [super refreshUIWithModel:model];
    
    JADNativeAdData *adData = model.data.firstObject;
    
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat y = padding.top;
    
    const CGFloat imageWidth = (width - 2 * margin) / 2;
    const CGFloat imageHeight = imageWidth/1.5;
    CGFloat imageX = width - margin - imageWidth;
    self.adImageView.frame = CGRectMake(imageX, y, imageWidth, imageHeight);
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:adData.adImages.firstObject] placeholderImage:nil];
    self.nativeAdWidget.logoAdWidget.frame = CGRectMake(imageWidth - logoSize.width - 5, imageHeight - logoSize.height - 5, logoSize.width, logoSize.height);
    
    CGFloat maxTitleWidth =  contentWidth - imageWidth - margin;
    self.adTitleLabel.text = adData.adTitle;
    self.adTitleLabel.frame = CGRectMake(padding.left, y, maxTitleWidth, 15);
    
    y += imageHeight;
    y += 5;
        
    CGFloat dislikeX = width - 24 - padding.right;
    self.nativeAdWidget.closeWidget.frame = CGRectMake(dislikeX, y, 24, 20);
    
    CGFloat maxInfoWidth = width - 2 * margin - 24 - 24 - 10;
    self.adDescriptionLabel.frame = CGRectMake(padding.left , y , maxInfoWidth, 20);
    self.adDescriptionLabel.text = @"这里是描述描述描述！！！！";
    
    [self.nativeAd registerContainer:self withClickableViews:@[self.adImageView, self.adTitleLabel] withClosableViews:@[self.nativeAdWidget.closeWidget]];
}

+ (CGFloat)cellHeightWithModel:(JADNativeAd *)model width:(CGFloat)width {
    const CGFloat contentWidth = (width - 2 * margin) / 2;
    const CGFloat imageHeight = contentWidth/1.5;
    return padding.top + imageHeight + 10 + 20 + padding.bottom;
}

@end

@implementation JADNativeFeedBigImageAdTableViewCell

- (void)refreshUIWithModel:(JADNativeAd *)model {
    [super refreshUIWithModel:model];
    
    JADNativeAdData *adData = model.data.firstObject;
    
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat y = padding.top;

    self.adTitleLabel.text = adData.adTitle;
    self.adTitleLabel.frame = CGRectMake(padding.left, y, contentWidth, 15);
    
    y += 30;
    
    const CGFloat imageWidth = (width - 2 * margin);
    const CGFloat imageHeight = imageWidth/1.78;
    CGFloat imageX = (width - imageWidth)/2;
    self.adImageView.frame = CGRectMake(imageX, y, imageWidth, imageHeight);
    [self.adImageView sd_setImageWithURL:[NSURL URLWithString:adData.adImages.firstObject] placeholderImage:nil];
    self.nativeAdWidget.logoAdWidget.frame = CGRectMake(imageWidth - logoSize.width - 5, imageHeight - logoSize.height - 5, logoSize.width, logoSize.height);
    
    CGFloat dislikeX = width - 24 - padding.right;
    self.nativeAdWidget.closeWidget.frame = CGRectMake(dislikeX, y - 30, 24, 20);
    
    CGFloat maxInfoWidth = width - 2 * margin - 24 - 24 - 10;
    self.adDescriptionLabel.frame = CGRectMake(padding.left , y + imageHeight + 10 , maxInfoWidth, 20);
    self.adDescriptionLabel.text = @"这里是描述描述描述！！！！";
    
    [self.nativeAd registerContainer:self withClickableViews:@[self.adImageView, self.adTitleLabel] withClosableViews:@[self.nativeAdWidget.closeWidget]];
}

+ (CGFloat)cellHeightWithModel:(JADNativeAd *)model width:(CGFloat)width {
    const CGFloat contentWidth = (width - 2 * margin);
    const CGFloat imageHeight = contentWidth/1.78;
    return padding.top + imageHeight + 10 + 30 + 20 + padding.bottom;
}

@end
