//
//  JADBannerModel.h
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/11/17.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<JADYunNative/JADNativeAd.h>)
#import <JADYunNative/JADNativeAd.h>
#else
#import <JADYun/JADNativeAd.h>
#endif

NS_ASSUME_NONNULL_BEGIN

static CGFloat const bottomHeight = 30;

@interface JADBannerModel : NSObject

@property (strong, nonatomic) JADNativeAd *nativeAd;
@property (assign, nonatomic) CGFloat imgViewHeight;

- (instancetype)initWithNativeAd:(JADNativeAd *)nativeAd;

@end

NS_ASSUME_NONNULL_END
