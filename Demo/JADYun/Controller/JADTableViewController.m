//
//  JADTableViewController.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/9/14.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "JADTableViewController.h"
#if __has_include(<JADYunCore/JADYunUmbrella.h>)
#import <JADYunCore/JADYunUmbrella.h>
#else
#import <JADYun/JADYunUmbrella.h>
#endif


@interface JADTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLable;

@end

@implementation JADTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.versionLable.text = [NSString stringWithFormat:@"v%@ - Build:%@", [JADYunSDK sdkVersion], [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
}

@end
