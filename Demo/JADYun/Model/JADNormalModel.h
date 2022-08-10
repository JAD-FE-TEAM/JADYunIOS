//
//  JADNormalModel.h
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/11/16.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JADNormalModel : NSObject

@property (strong, nonatomic) NSString *adTitle;
@property (strong, nonatomic) NSString *adDescription;
@property (strong, nonatomic) NSString *adType;
@property (assign, nonatomic) CGFloat cellHeight;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
