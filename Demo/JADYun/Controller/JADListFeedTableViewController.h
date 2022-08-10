//
//  JADFeedListTableViewController.h
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/10/20.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JADListFeedTableViewController : UITableViewController

- (void)loadSlotID:(NSString *)slotID adSize:(CGSize)adSize;

- (void)resetDataSource;

@end

NS_ASSUME_NONNULL_END
