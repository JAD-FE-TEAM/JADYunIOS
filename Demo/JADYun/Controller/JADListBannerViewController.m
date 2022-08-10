//
//  JADListBannerViewController.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2021/12/2.
//  Copyright © 2021 JD.COM. All rights reserved.
//

#import "JADListBannerViewController.h"

#if __has_include(<JADYunCore/JADYunUmbrella.h>)
#import <JADYunCore/JADYunUmbrella.h>
#else
#import <JADYun/JADYunUmbrella.h>
#endif

#if __has_include(<JADYunBanner/JADBannerView.h>)
#import <JADYunBanner/JADBannerView.h>
#else
#import <JADYun/JADBannerView.h>
#endif

#define NumberOfCellMax 3
#define BannerCellHeight 300

@interface JADListBannerHeader : UICollectionReusableView @end
@implementation JADListBannerHeader @end

@interface JADBannerCollectionViewCell : UICollectionViewCell @end
@implementation JADBannerCollectionViewCell @end

@interface JADListBannerViewController () <JADBannerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) JADBannerView *bannerView;

@property (assign, nonatomic) NSInteger bannerSelectedIndex;
@property (strong, nonatomic) NSArray *bannerSizeList;
@property (strong, nonatomic) NSArray *bannerSlotIDList;
@property (strong, nonatomic) UIAlertController *alertController;
@property (strong, nonatomic) NSMutableArray *bannerViewArray;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *bannerButtonList;

@property (weak, nonatomic) IBOutlet UILabel *widthLabel;
@property (weak, nonatomic) IBOutlet UILabel *scaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;

@property (weak, nonatomic) IBOutlet UITextField *slotIDTextField;

@property (weak, nonatomic) IBOutlet UISlider *widthSlider;
@property (weak, nonatomic) IBOutlet UISlider *scaleSlider;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *collectionHeaderView;

@end

@implementation JADListBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
    [self setupData];
    
    [self updateRangeLabel];
}

- (void)setupViews {
    self.widthSlider.maximumValue = CGRectGetWidth(self.view.frame);
    self.widthSlider.value = [UIScreen mainScreen].bounds.size.width;
    self.widthLabel.text = [NSString stringWithFormat:@"宽:%@", @(self.widthSlider.value)];
    
    self.scaleSlider.minimumValue = 5.63;
    self.scaleSlider.maximumValue = 7.17;
    self.scaleSlider.value = 6.4;
    
    self.collectionHeaderView.frame = CGRectMake(0, 0, JADScreenWidth, 400);
    
    [self.collectionView registerClass:[JADBannerCollectionViewCell class] forCellWithReuseIdentifier:@"JADBannerCollectionViewCell"];
    [self.collectionView registerClass:[JADListBannerHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JADBannerCollectionViewHeader"];
}

- (void)setupData {
    self.bannerSelectedIndex = 0;
    self.bannerSlotIDList = @[@"2518", @"2519", @"2520", @"2521"];
    self.slotIDTextField.text = self.bannerSlotIDList.firstObject;
    self.bannerSizeList = @[[NSValue valueWithCGSize:CGSizeMake(640, 100)],
                            [NSValue valueWithCGSize:CGSizeMake(640, 160)],
                            [NSValue valueWithCGSize:CGSizeMake(644, 280)],
                            [NSValue valueWithCGSize:CGSizeMake(720, 360)]];
    
    self.bannerViewArray = [[NSMutableArray alloc] init];
}


#pragma mark - Load Ad Method

// 加载模板Banner广告
- (void)loadBannerWithSlotID:(NSString *)slotID size:(CGSize)size {
    /**
     * important: 支持的广告位尺寸比例范围
     * 5.63~7.17
     * 3.52~4.48
     * 2.15~2.57
     * 1.76~2.15
     */
    
    [self.bannerViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.bannerViewArray removeAllObjects];

    CGFloat bannerWidth = self.widthSlider.value;
    CGFloat bannerHeight = self.widthSlider.value/self.scaleSlider.value;
    for (int i = 0; i < NumberOfCellMax; i++) {
        JADBannerView *bannerView = [[JADBannerView alloc] initWithSlotID:slotID adSize:CGSizeMake(bannerWidth, bannerHeight) rootViewController:self];
        bannerView.frame = CGRectMake(0, 0, bannerWidth, bannerHeight);
        bannerView.delegate = self;
        [bannerView loadAdData];
        if (bannerView) {
            [self.bannerViewArray addObject:bannerView];
        }
    }
}

- (void)showBanner {
    [self.collectionView reloadData];
}

#pragma mark - Action Method

// Banner尺寸按钮 点击事件
- (IBAction)buttonPressedClickAction:(UIButton *)sender {
    if (sender.selected == YES) {
        return;
    }
    
    for (UIButton *button in self.bannerButtonList) {
        button.selected = NO;
    }
    sender.selected = YES;
    self.bannerSelectedIndex = sender.tag - 100;
    self.slotIDTextField.text = self.bannerSlotIDList[self.bannerSelectedIndex];
    
    if (sender.tag - 100 == 0) {
        self.scaleSlider.minimumValue = 5.63;
        self.scaleSlider.maximumValue = 7.17;
        self.scaleSlider.value = 6.4;
    } else if (sender.tag - 100 == 1) {
        self.scaleSlider.minimumValue = 3.52;
        self.scaleSlider.maximumValue = 4.48;
        self.scaleSlider.value = 4.0;
    } else if (sender.tag - 100 == 2) {
        self.scaleSlider.minimumValue = 2.15;
        self.scaleSlider.maximumValue = 2.57;
        self.scaleSlider.value = 2.3;
    } else {
        self.scaleSlider.minimumValue = 1.76;
        self.scaleSlider.maximumValue = 2.15;
        self.scaleSlider.value = 2.0;
    }

    [self updateRangeLabel];
}

// Banner加载广告按钮 点击事件
- (IBAction)buttonPressedLoadAdAction:(UIButton *)sender {
    [self.slotIDTextField resignFirstResponder];
    
    NSString *slotID = self.slotIDTextField.text;
    NSValue *sizeValue    = self.bannerSizeList[self.bannerSelectedIndex];

    [self loadBannerWithSlotID:slotID size:[sizeValue CGSizeValue]];
}

// slider 滑动事件
- (IBAction)sliderPositionChanged:(id)sender {
    self.widthLabel.text = [NSString stringWithFormat:@"宽:%.0f", self.widthSlider.value];
    
    [self updateRangeLabel];
}

// slider 比例调整
- (IBAction)sliderScaleChanged:(id)sender {
    self.scaleLabel.text = [NSString stringWithFormat:@"比例:%.2f", self.scaleSlider.value];
    
    [self updateRangeLabel];
}

// 控制器视图 Tap事件
- (IBAction)tapViewAction:(id)sender {
    [self.slotIDTextField resignFirstResponder];
}

#pragma mark - Private Method

- (void)updateRangeLabel {
    self.scaleLabel.text  = [NSString stringWithFormat:@"比例:%.2f", self.scaleSlider.value];
    self.heightLabel.text = [NSString stringWithFormat:@"当前高度: %.2f", (self.widthSlider.value/self.scaleSlider.value)];
}

#pragma mark - Setter/Getter

- (UIAlertController *)alertController {
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:@"错误信息" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [_alertController addAction:okAction];
    }
    return _alertController;
}

#pragma mark - JADBannerDelegate

// 加载成功回调
- (void)jadBannerViewDidLoadSuccess:(JADBannerView *)bannerView {
    JADLogI(@"BannerView Did Load");
}

// 返回的错误码（error），表示广告加载失败的原因，所有错误码详情，请见接入文档/iOS/错误码
- (void)jadBannerViewDidLoadFailure:(JADBannerView *)bannerView error:(NSError *)error {
    JADLogI(@"BannerView Did Fail");
    
    [self.bannerViewArray removeObject:bannerView];
}

// 渲染成功回调
- (void)jadBannerViewDidRenderSuccess:(JADBannerView *)bannerView {
    JADLogI(@"BannerView Render Success");
    
    // 展示横幅广告视图
    [self showBanner];
}

// 渲染失败，网络原因或者硬件原因导致渲染失败，可以更换手机或者网络环境测试。
- (void)jadBannerViewDidRenderFailure:(JADBannerView *)bannerView error:(NSError *)error {
    JADLogI(@"BannerView Render Fail");
    
    [self.bannerViewArray removeObject:bannerView];
}

// 开屏广告即将展示
- (void)jadBannerViewDidExposure:(JADBannerView *)bannerView {
    JADLogI(@"BannerView Will Visible");
}

// 点击回调
- (void)jadBannerViewDidClick:(JADBannerView *)bannerView {
    JADLogI(@"BannerView Did Click");
}

// 关闭回调，建议在此回调方法中直接进行广告对象的移除动作，并将广告对象置为nil
- (void)jadBannerViewDidClose:(JADBannerView *)bannerView {
    JADLogI(@"BannerView Did Close");
    // 移除横幅广告视图
    [self.bannerView removeFromSuperview];
    self.bannerView = nil;
}

// 此回调在广告跳转到其他控制器时，该控制器被关闭时调用
- (void)jadBannerViewDidCloseOtherController:(JADBannerView *)bannerView
                             interactionType:(JADInteractionType)interactionType {
    NSString *str;
    if (interactionType == JADInteractionTypeURL) {
        str = @"ladingURL";
    }
}

#pragma mark - UICollectionViewDelete DataSource

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JADBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JADBannerCollectionViewCell" forIndexPath:indexPath];
    JADBannerView *bannerView = [self.bannerViewArray objectAtIndex:indexPath.row];
    
    CGRect bannerViewFrame = bannerView.frame;
    bannerViewFrame.origin.x = (JADScreenWidth - bannerViewFrame.size.width)/2.0;
    bannerViewFrame.origin.y = (BannerCellHeight - bannerViewFrame.size.height)/2.0;
    bannerView.frame = bannerViewFrame;
    
    [cell addSubview:bannerView];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        JADListBannerHeader *view = (JADListBannerHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JADBannerCollectionViewHeader" forIndexPath:indexPath];
        [view addSubview:self.collectionHeaderView];
        [view setBackgroundColor:[UIColor redColor]];
        return view;
    }
    return [[JADListBannerHeader alloc] init];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bannerViewArray.count <= indexPath.row) {
        return CGSizeZero;
    }
    return CGSizeMake(JADScreenWidth, BannerCellHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return self.collectionHeaderView.frame.size;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bannerViewArray.count;
}

@end
