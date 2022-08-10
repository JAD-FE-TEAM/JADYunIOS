//
//  JADNativeBannerViewController.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/11/16.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "JADNativeBannerViewController.h"
#import "JADNativeBannerAdTableViewCell.h"
#import "JADNativeNormalFeedAdTableViewCell.h"
#import "NSString+JSON.h"



#if __has_include(<JADYunCore/JADLog.h>)
#import <JADYunCore/JADLog.h>
#else
#import <JADYun/JADLog.h>
#endif

#if __has_include(<JADYunCore/JADCommonMacros.h>)
#import <JADYunCore/JADCommonMacros.h>
#else
#import <JADYun/JADCommonMacros.h>
#endif


@interface JADNativeBannerViewController ()<JADNativeAdDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) JADNativeAd *nativeAd;
@property (nonatomic, strong) JADBannerModel *bannerModel;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UIAlertController *alertController;

@end

@implementation JADNativeBannerViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self loadNativeAd];
}

#pragma mark - Setup

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
}

- (void)loadNativeAd {
    [self.nativeAd loadAdData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.dataSource[indexPath.row];
    if ([model isKindOfClass:[JADBannerModel class]]) {
        return [(JADBannerModel *)model imgViewHeight] + bottomHeight;
    } else {
        return [(JADNormalModel *)model cellHeight];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    id model = self.dataSource[index];
    if ([model isKindOfClass:[JADBannerModel class]]) {
        JADNativeBannerAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JADNativeBannerAdTableViewCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[JADNativeBannerAdTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JADNativeBannerAdTableViewCell"];
        }
        [cell refreshUIWithModel:model];
        return cell;
    } else {
        NSString *clazz = [self classNameWithCellType:[(JADNormalModel *)model adType]];
        JADNativeNormalFeedAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:clazz forIndexPath:indexPath];
        if (!cell) {
            cell = [(JADNativeNormalFeedAdTableViewCell *)[NSClassFromString(clazz) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:clazz];
        }
        [cell refreshUIWithModel:model];
        return cell;
    }
    
    return nil;
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

#pragma mark - Button Action

// 刷新按钮 点击事件
- (IBAction)buttonPressedRefreshAction:(id)sender {
    NSMutableArray *dataSources = [self.dataSource mutableCopy];
    id model = [dataSources objectAtIndex:0];
    if ([model isKindOfClass:[JADBannerModel class]]) {
        [dataSources removeObject:model];
    }
    self.dataSource = [dataSources mutableCopy];
    [self.tableView reloadData];
    
    [self loadNativeAd];
}


#pragma mark - JADNativeAdDelegate

- (void)jadNativeAdDidLoadSuccess:(JADNativeAd *)nativeAd {
    JADLogI(@"BannerAd Did Load Success");
    
    if (!nativeAd.data) { return; }
    if (!(nativeAd == self.nativeAd)) { return; }
    
    self.nativeAd = nil;
    self.bannerModel = [[JADBannerModel alloc] initWithNativeAd:nativeAd];
    
    NSMutableArray *dataSources = [self.dataSource mutableCopy];
    id model = [dataSources objectAtIndex:0];
    if ([model isKindOfClass:[JADBannerModel class]]) {
        [dataSources removeObject:model];
    }
    [dataSources insertObject:self.bannerModel atIndex:0];
    self.dataSource = [dataSources copy];
    [self.tableView reloadData];
}

- (void)jadNativeAdDidLoadFailure:(JADNativeAd *)nativeAd error:(NSError *)error {
    JADLogI(@"BannerAd Did Load Failure");
    
    self.alertController.message = error.description;
    [self presentViewController:self.alertController animated:YES completion:nil];
}

- (void)jadNativeAdDidExposure:(JADNativeAd *)nativeAd {
    JADLogI(@"BannerAd Did Exposure");
}

- (void)jadNativeAdDidClick:(JADNativeAd *)nativeAd withView:(UIView * _Nullable)view {
    JADLogI(@"BannerAd Did Click");
}

- (void)jadNativeAdDidClose:(JADNativeAd *)nativeAd withView:(UIView * _Nullable)view {
    JADLogI(@"BannerAd Did Close");
    
    NSMutableArray *dataSources = [self.dataSource mutableCopy];
    id model = [dataSources objectAtIndex:0];
    if ([model isKindOfClass:[JADBannerModel class]] && [[(JADBannerModel *)model nativeAd] isEqual:nativeAd]) {
        [dataSources removeObject:model];
    }
    self.dataSource = [dataSources copy];
    [self.tableView reloadData];
}

- (void)jadNativeAdDidCloseOtherController:(JADNativeAd *)nativeAd
                           interactionType:(JADInteractionType)interactionType {
    JADLogI(@"BannerAd Did Close Other Controller");
    NSString *str;
    if (interactionType == JADInteractionTypeURL) {
        str = @"ladingURL";
    }
}

#pragma mark - Setter & Getter
/**
 * important: 传入图片尺寸，返回的素材大小
 * 5.63~7.17: 返回的图片尺寸 640 * 100
 * 3.52~4.48: 返回的图片尺寸 640 * 160
 * 2.15~2.57: 返回的图片尺寸 644 * 280
 * 1.76~2.15: 返回的图片尺寸 720 * 360
 */
- (JADNativeAd *)nativeAd { 
    if (!_nativeAd) {
        // 设置广告位图片的尺寸
        JADNativeSize *imgSize = [[JADNativeSize alloc] init];
        imgSize.width = JADScreenWidth;
        imgSize.height = JADScreenWidth/2;
        
        // 设置广告位
        JADNativeAdSlot *slot = [[JADNativeAdSlot alloc] init];
        slot.slotID = @"2521";
        slot.type = JADSlotTypeBanner;
        slot.imgSize = imgSize;
        
        _nativeAd = [[JADNativeAd alloc] initWithSlot:slot];
        _nativeAd.rootViewController = self;
        _nativeAd.delegate = self;
    }
    return _nativeAd;
}

- (UIAlertController *)alertController {
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:@"错误信息" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [_alertController addAction:okAction];
    }
    return _alertController;
}

@end
