//
//  JADBannerModel.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/11/17.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "JADBannerModel.h"

@implementation JADBannerModel

- (instancetype)initWithNativeAd:(JADNativeAd *)nativeAd {
    self = [super init];
    if (self) {
        self.nativeAd = nativeAd;
        self.imgViewHeight = self.nativeAd.adSlot.imgSize.height;
    }
    return self;
}

@end
