//
//  JADFeedListTableViewController.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/10/20.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "JADListFeedTableViewController.h"

#if __has_include(<JADYunCore/JADYunUmbrella.h>)
#import <JADYunCore/JADYunUmbrella.h>
#else
#import <JADYun/JADYunUmbrella.h>
#endif

#if __has_include(<JADYunFeed/JADFeedView.h>)
#import <JADYunFeed/JADFeedView.h>
#else
#import <JADYun/JADFeedView.h>
#endif


@interface JADListFeedTableViewController ()<JADFeedViewDelegate>

@property (strong, nonatomic) JADFeedView *feed;
@property (strong, nonatomic) UIView *feedView;
@property (assign, nonatomic) NSUInteger insertIndex;
@property (assign, nonatomic) CGSize adSize;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *feedDatas;

@end

@implementation JADListFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
}

- (void)setupData {
    self.dataSource = [[NSMutableArray alloc] init];
    self.feedDatas = [[NSMutableArray alloc] init];
    for (int i = 0; i < 15; i++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"Cell item %d", i]];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[UIView class]]) {
        UIView *feedView = (UIView *)model;
        return feedView.frame.size.height;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedCell" forIndexPath:indexPath];
    
    // Configure the cell...
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[UIView class]]) {
        [cell.contentView addSubview:model];
        [cell.textLabel setText:@""];
    } else {
        cell.textLabel.text = self.dataSource[indexPath.row];
    }
    
    return cell;
}


#pragma mark - Public

// 加载信息流广告
- (void)loadSlotID:(NSString *)slotID adSize:(CGSize)adSize {
    [self setupData];
    
    for (int i = 0; i < 3; i++) {
        JADFeedView *feed = [[JADFeedView alloc] initWithSlotID:slotID adSize:adSize];
        [feed setDelegate:self];
        [feed loadAdData];
        [self.feedDatas addObject:feed];
    }
    
    [self setAdSize:adSize];
}

- (void)resetDataSource {
    [self setupData];
}

#pragma mark - JADFeedDelegate

// 加载成功回调
- (void)jadFeedViewDidLoadSuccess:(JADFeedView *)feedView {
    JADLogI(@"FeedAd Did Load");
}

// 返回的错误码（error），表示广告加载失败的原因，所有错误码详情，请见接入文档/iOS/错误码
- (void)jadFeedViewDidLoadFailure:(JADFeedView *)feedView error:(NSError *)error {
    JADLogI(@"FeedAd Did Fail");
}

// 渲染成功回调
- (void)jadFeedViewDidRenderSuccess:(JADFeedView *)feedView {
    JADLogI(@"FeedAd Render Success");
    
    if (!feedView) { return; }

    NSUInteger index = rand() % (self.dataSource.count-3)+2;
    [self.dataSource insertObject:feedView atIndex:index];
    
    [self.tableView reloadData];
}

// 渲染失败，网络原因或者硬件原因导致渲染失败，可以更换手机或者网络环境测试。
- (void)jadFeedViewDidRenderFailure:(JADFeedView *)feedView error:(NSError *)error {
    JADLogI(@"FeedAd Render Fail");
}

// 信息流广告即将展示
- (void)jadFeedViewDidExposure:(JADFeedView *)feedView {
    JADLogI(@"FeedAd Will Visible");
}

// 点击回调
- (void)jadFeedViewDidClick:(JADFeedView *)feedView {
    JADLogI(@"FeedAd Did Click");
}

// 关闭回调，建议在此回调方法中直接进行广告对象的移除动作，并将广告对象置为nil
- (void)jadFeedViewDidClose:(JADFeedView *)feedView {
    JADLogI(@"FeedAd Did Close");
    
    [self.dataSource removeObject:feedView];
    [self.tableView reloadData];
}

// 此回调在广告跳转到其他控制器时，该控制器被关闭时调用
- (void)jadFeedViewDidCloseOtherController:(JADFeedView *)feedView
                           interactionType:(JADInteractionType)interactionType {
    NSString *str;
    if (interactionType == JADInteractionTypeURL) {
        str = @"ladingURL";
    }
}

@end
