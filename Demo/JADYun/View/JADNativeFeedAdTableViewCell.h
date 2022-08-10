//
//  JADNativeFeedAdTableViewCell.h
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/11/25.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

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


NS_ASSUME_NONNULL_BEGIN

@protocol JADFeedCellProtocol <NSObject>

@property (strong, nonatomic) JADNativeAd *nativeAd;
@property (strong, nonatomic) JADNativeAdWidget *nativeAdWidget;

- (void)refreshUIWithModel:(JADNativeAd *_Nullable)model;
+ (CGFloat)cellHeightWithModel:(JADNativeAd *_Nullable)model width:(CGFloat)width;

@end

@interface JADNativeFeedAdTableViewCell : UITableViewCell <JADFeedCellProtocol>

@property (strong, nonatomic, nullable) UIView *separatorLine;
@property (strong, nonatomic, nullable) UIImageView *adImageView;
@property (strong, nonatomic, nullable) UILabel *adTitleLabel;
@property (strong, nonatomic, nullable) UILabel *adDescriptionLabel;

- (void)setupView;

@end

@interface JADNativeFeedSmallImageAdTableViewCell :JADNativeFeedAdTableViewCell

@end

@interface JADNativeFeedBigImageAdTableViewCell :JADNativeFeedAdTableViewCell

@end


NS_ASSUME_NONNULL_END
