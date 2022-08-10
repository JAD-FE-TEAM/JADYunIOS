//
//  NSString+JSON.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/11/17.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "NSString+JSON.h"

@implementation NSString (JSON)

- (id)objectFromJSONString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

@end
