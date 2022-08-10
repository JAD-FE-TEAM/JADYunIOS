//
//  JADNativeBannerAdTableViewCell.h
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/11/17.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JADBannerModel.h"

#if __has_include(<JADYunNative/JADNativeAd.h>)
#import <JADYunNative/JADNativeAd.h>
#else
#import <JADYun/JADNativeAd.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface JADNativeBannerAdTableViewCell : UITableViewCell

@property (strong, nonatomic) JADBannerModel *bannerModel;

- (void)refreshUIWithModel:(JADBannerModel *_Nullable)model;

@end

NS_ASSUME_NONNULL_END
