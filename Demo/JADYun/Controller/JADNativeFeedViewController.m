//
//  JADNativeFeedViewController.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/11/16.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "JADNativeFeedViewController.h"
#import "JADNativeBannerAdTableViewCell.h"
#import "JADNativeNormalFeedAdTableViewCell.h"
#import "JADNativeFeedAdTableViewCell.h"
#import "NSString+JSON.h"

#if __has_include(<JADYunCore/JADLog.h>)
#import <JADYunCore/JADLog.h>
#else
#import <JADYun/JADLog.h>
#endif

#import <SDWebImage/SDWebImage.h>


@interface JADNativeFeedViewController () <JADNativeAdDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *feedDatas;

@end

@implementation JADNativeFeedViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self setupData];
    [self loadNativeAd];
}

/**
 * important: 传入图片尺寸，返回的素材大小
 * 1.64~1.92: 返回的图片尺寸 1280 * 720，对应上图下文 1.78比例模板
 * 1.36~1.64: 返回的图片尺寸 480 * 320，对应左图右文 1.50比例模板
 */
- (void)setupData {
    [self.feedDatas removeAllObjects];
    
    // 设置广告位图片的尺寸
    JADNativeSize *imgSize150 = [[JADNativeSize alloc] init];
    imgSize150.width = 480;
    imgSize150.height = 320;
    
    // 设置广告位图片的尺寸
    JADNativeSize *imgSize178 = [[JADNativeSize alloc] init];
    imgSize178.width = 1280;
    imgSize178.height = 720;
    
    // 设置广告位
    JADNativeAdSlot *slot150 = [[JADNativeAdSlot alloc] init];
    slot150.type = JADSlotTypeFeed;
    slot150.slotID = @"2517";
    slot150.imgSize = imgSize150;
    
    // 设置广告位
    JADNativeAdSlot *slot178 = [[JADNativeAdSlot alloc] init];
    slot178.type = JADSlotTypeFeed;
    slot178.slotID = @"2515";
    slot178.imgSize = imgSize178;
    
    JADNativeAd *nativeAd150 = [[JADNativeAd alloc] initWithSlot:slot150];
    nativeAd150.rootViewController = self;
    nativeAd150.delegate = self;
    
    JADNativeAd *nativeAd178 = [[JADNativeAd alloc] initWithSlot:slot178];
    nativeAd178.rootViewController = self;
    nativeAd178.delegate = self;
    
    [self.feedDatas addObject:nativeAd150];
    [self.feedDatas addObject:nativeAd178];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[JADNativeFeedAdTableViewCell class] forCellReuseIdentifier:@"JADNativeFeedAdTableViewCell"];
    [self.tableView registerClass:[JADNativeFeedSmallImageAdTableViewCell class] forCellReuseIdentifier:@"JADNativeFeedSmallImageAdTableViewCell"];
    [self.tableView registerClass:[JADNativeFeedBigImageAdTableViewCell class] forCellReuseIdentifier:@"JADNativeFeedBigImageAdTableViewCell"];
    [self.tableView registerClass:[JADNativeNormalFeedAdTableViewCell class] forCellReuseIdentifier:@"JADNativeNormalFeedAdTableViewCell"];
    [self.tableView registerClass:[JADNativeBannerAdTableViewCell class] forCellReuseIdentifier:@"JADNativeBannerAdTableViewCell"];
    [self.tableView registerClass:[JADNativeNormalFeedTitleAdTableViewCell class] forCellReuseIdentifier:@"JADNativeNormalFeedTitleAdTableViewCell"];
    [self.tableView registerClass:[JADNativeNormalFeedSmallImgAdTableViewCell class] forCellReuseIdentifier:@"JADNativeNormalFeedSmallImgAdTableViewCell"];
    [self.tableView registerClass:[JADNativeNormalFeedBigImgAdTableViewCell class] forCellReuseIdentifier:@"JADNativeNormalFeedBigImgAdTableViewCell"];
    
    NSString *feedPath = [[NSBundle mainBundle] pathForResource:@"normalInfo" ofType:@"cactus"];
    NSString *feedString = [NSString stringWithContentsOfFile:feedPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *datas = [feedString objectFromJSONString];
    
    self.dataSource = [NSMutableArray new];
    for (int i = 0; i < datas.count; i++) {
        NSUInteger index = rand() % (datas.count - 2) + 1;
        JADNormalModel *model = [[JADNormalModel alloc] initWithDict:[datas objectAtIndex:index]];
        [self.dataSource addObject:model];
    }
    [self.tableView reloadData];
    
    self.feedDatas = [[NSMutableArray alloc] init];
}

- (void)loadNativeAd {
    NSMutableArray *dataSources = [self.dataSource mutableCopy];
    [dataSources enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[JADNativeAd class]]) {
            [dataSources removeObject:obj];
        }
    }];
    self.dataSource = [dataSources mutableCopy];
    [self.tableView reloadData];
    
    for (JADNativeAd *nativeAd in self.feedDatas) {
        [nativeAd loadAdData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    id model = self.dataSource[index];
    if ([model isKindOfClass:[JADNativeAd class]]) {
        JADNativeAd *nativeAd = (JADNativeAd *)model;
        
        CGFloat range = (CGFloat)nativeAd.adSlot.imgSize.width / nativeAd.adSlot.imgSize.height;
        NSString *clazz = [self classNameWithCellSizeRange:range];
        
        JADNativeFeedAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:clazz forIndexPath:indexPath];
        if (!cell) {
            cell = [(JADNativeFeedAdTableViewCell *)[NSClassFromString(clazz) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:clazz];
        }
        
        [cell refreshUIWithModel:nativeAd];
        
        return cell;
        
    } else if ([model isKindOfClass:[JADNormalModel class]]) {
        NSString *clazz = [self classNameWithCellType:[(JADNormalModel *)model adType]];
        
        JADNativeNormalFeedAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:clazz forIndexPath:indexPath];
        if(!cell){
            cell = [(JADNativeNormalFeedAdTableViewCell *)[NSClassFromString(clazz) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:clazz];
        }
        
        if (indexPath.row == 0) {
            cell.separatorLine.hidden = YES;
        }
        
        [cell refreshUIWithModel:model];
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @"Unknown";
    
    return cell;
}

- (NSString *)classNameWithCellType:(NSString *)type {
    if ([type isEqualToString: @"title"]) {
        return @"JADNativeNormalFeedTitleAdTableViewCell";
    } else if ([type isEqualToString: @"smallImg"]){
        return @"JADNativeNormalFeedSmallImgAdTableViewCell";
    } else if ([type isEqualToString: @"bigImg"]){
        return @"JADNativeNormalFeedBigImgAdTableViewCell";
    } else {
        return @"unkownCell";
    }
}

- (NSString *)classNameWithCellSizeRange:(CGFloat)range {
    if (range >= 1.64 && range <= 1.92) {
        return @"JADNativeFeedBigImageAdTableViewCell";
    }
    else if (range >= 1.36 && range < 1.64) {
        return @"JADNativeFeedSmallImageAdTableViewCell";
    } else {
        return @"unknownCell";
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    id model = self.dataSource[index];
    if ([model isKindOfClass:[JADNativeAd class]]) {
        JADNativeAd *nativeAd = (JADNativeAd *)model;
        CGFloat width = CGRectGetWidth(self.tableView.bounds);
        
        CGFloat range = (CGFloat)nativeAd.adSlot.imgSize.width / nativeAd.adSlot.imgSize.height;
        if (range >= 1.64 && range <= 1.92) {
            return [JADNativeFeedBigImageAdTableViewCell cellHeightWithModel:nativeAd width:width];;
        } else if (range >= 1.36 && range < 1.64) {
            return [JADNativeFeedSmallImageAdTableViewCell cellHeightWithModel:nativeAd width:width];
        }
    
    } else if ([model isKindOfClass:[JADNormalModel class]]){
        return [(JADNormalModel *)model cellHeight];
    }
    return 80;
}

#pragma mark - Button Action

- (IBAction)buttonPressedRefreshAction:(id)sender {
    [self setupData];
    [self loadNativeAd];
}

#pragma mark - JADNativeAdDelegate

- (void)jadNativeAdDidLoadSuccess:(JADNativeAd *)nativeAd {
    JADLogI(@"FeedAd Did Load Success");
    
    if (!nativeAd.data) { return; }
        
    NSUInteger index = rand() % (self.dataSource.count-3)+2;
    [self.dataSource insertObject:nativeAd atIndex:index];
    
    [self.tableView reloadData];
}

- (void)jadNativeAdDidLoadFailure:(JADNativeAd *)nativeAd error:(NSError *)error {
    JADLogI(@"FeedAd Did Load Failure");
}

- (void)jadNativeAdDidExposure:(JADNativeAd *)nativeAd {
    JADLogI(@"FeedAd Did Exposure");
}

- (void)jadNativeAdDidClick:(JADNativeAd *)nativeAd withView:(UIView * _Nullable)view {
    JADLogI(@"FeedAd Did Click");
}

- (void)jadNativeAdDidClose:(JADNativeAd *)nativeAd withView:(UIView * _Nullable)view {
    JADLogI(@"FeedAd Did Close");
    
    NSMutableArray *dataSources = [self.dataSource mutableCopy];
    [dataSources removeObject:nativeAd];
    self.dataSource = [dataSources mutableCopy];
    [self.tableView reloadData];
}

- (void)jadNativeAdDidCloseOtherController:(JADNativeAd *)nativeAd
                           interactionType:(JADInteractionType)interactionType {
    JADLogI(@"FeedAd Did Close Other Controller");
    NSString *str;
    if (interactionType == JADInteractionTypeURL) {
        str = @"ladingURL";
    }
}

@end
