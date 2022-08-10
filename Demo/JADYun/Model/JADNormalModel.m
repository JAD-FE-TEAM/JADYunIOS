//
//  JADNormalModel.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/11/16.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "JADNormalModel.h"

@implementation JADNormalModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.adTitle = [dict valueForKey:@"title"];
        self.adDescription = [dict valueForKey:@"description"];
        self.adType = [dict valueForKey:@"type"];
        
        if ([self.adType isEqualToString:@"title"]) {
            self.cellHeight = 100;
        } else if ([self.adType isEqualToString:@"smallImg"]) {
            self.cellHeight = 130;
        } else if ([self.adType isEqualToString:@"bigImg"]) {
            self.cellHeight = 100+[UIScreen mainScreen].bounds.size.width*0.6;
        } else {
            return 0;
        }
    }
    return self;
}

@end
