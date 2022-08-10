//
//  JADFeedViewController.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/8/17.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "JADFeedViewController.h"
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


@interface JADFeedViewController ()<JADFeedViewDelegate>

@property (strong, nonatomic) JADFeedView *feedView;
@property (strong, nonatomic) UIAlertController *alertController;

@property (weak, nonatomic) IBOutlet UISlider *widthSlider;
@property (weak, nonatomic) IBOutlet UISlider *scaleSlider;
@property (weak, nonatomic) IBOutlet UILabel *widthLabel;
@property (weak, nonatomic) IBOutlet UILabel *scaleLabel;
@property (weak, nonatomic) IBOutlet UIButton *loadAdButton;
@property (weak, nonatomic) IBOutlet UITextField *slotIDTextField;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *feedScaleList;
@property (assign, nonatomic) NSInteger feedSelectedIndex;


@end

@implementation JADFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}

- (void)setupViews {
    self.slotIDTextField.text = @"2515";
    
    /**
     * important: 支持的广告位尺寸比例范围（图文类）
     * 1.2~1.8
     * 2.8~3.2
     */
    self.widthSlider.maximumValue = CGRectGetWidth(self.view.frame);
    self.widthSlider.value = [UIScreen mainScreen].bounds.size.width;
    self.widthLabel.text = [NSString stringWithFormat:@"宽:%@", @(self.widthSlider.value)];
        
    self.scaleSlider.minimumValue = 1.2;
    self.scaleSlider.maximumValue = 1.8;
    self.scaleSlider.value = 1.8;

    [self updateRangeLabel];
}

#pragma mark - Load Ad Method

// 加载信息流广告视图
- (void)loadData {
    [self.feedView removeFromSuperview];
        
    self.feedView = [[JADFeedView alloc] initWithSlotID:self.slotIDTextField.text adSize:CGSizeMake(self.widthSlider.value,     (self.widthSlider.value/self.scaleSlider.value))];
    self.feedView.delegate = self;
    [self.feedView loadAdData];
}

#pragma mark - Action Method

- (IBAction)sliderPositionHChanged:(id)sender {
    self.scaleLabel.text = [NSString stringWithFormat:@"比例:%.1f", self.scaleSlider.value];
    
    [self updateRangeLabel];
}

- (IBAction)sliderPositonWChanged:(id)sender {
    self.widthLabel.text = [NSString stringWithFormat:@"宽:%.0f", self.widthSlider.value];
    
    [self updateRangeLabel];
}
- (IBAction)buttonPressedScaleSelectedAction:(UIButton *)sender {
    [self.feedView removeFromSuperview];
    self.feedView = nil;
    
    if (sender.selected == YES) {
        return;
    }
    
    for (UIButton *button in self.feedScaleList) {
        button.selected = NO;
    }
    sender.selected = YES;
        
    if (sender.tag - 100 == 0) {
        self.scaleSlider.minimumValue = 1.2;
        self.scaleSlider.maximumValue = 1.8;
        self.scaleSlider.value = 1.8;
    } else {
        self.scaleSlider.minimumValue = 2.8;
        self.scaleSlider.maximumValue = 3.2;
        self.scaleSlider.value = 3.2;
    }

    [self updateRangeLabel];
}

// 加载广告按钮 点击事件
- (IBAction)buttonPressedLoadAdAction:(id)sender {
    [self.slotIDTextField resignFirstResponder];
    [self loadData];
}

// 控制器视图 Tap事件
- (IBAction)tapViewAction:(id)sender {
    [self.slotIDTextField resignFirstResponder];
}

#pragma mark - Privacy Method

- (void)updateRangeLabel {
    self.scaleLabel.text  = [NSString stringWithFormat:@"比例:%.1f", self.scaleSlider.value];
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

#pragma mark - JADFeedDelegate

// 加载成功回调
- (void)jadFeedViewDidLoadSuccess:(JADFeedView *)feedView {
    JADLogI(@"FeedView Did Load Success");
}

// 返回的错误码（error），表示广告加载失败的原因，所有错误码详情，请见接入文档/iOS/错误码
- (void)jadFeedViewDidLoadFailure:(JADFeedView *)feedView error:(NSError *)error {
    JADLogI(@"FeedView Did Load Failure");
    
    self.alertController.message = error.description;
    [self presentViewController:self.alertController animated:YES completion:nil];
}

// 渲染成功回调
- (void)jadFeedViewDidRenderSuccess:(JADFeedView *)feedView {
    JADLogI(@"FeedView Did Render Success");
    
    if (!feedView) { return;}
    
    CGRect frame = feedView.frame;
    frame.origin.y = self.loadAdButton.frame.origin.y + 60;
    feedView.frame = frame;
    [self.view addSubview:feedView];
}

// 渲染失败，网络原因或者硬件原因导致渲染失败，可以更换手机或者网络环境测试。
- (void)jadFeedViewDidRenderFailure:(JADFeedView *)feedView error:(NSError *)error {
    JADLogI(@"FeedView Did Render Failure");
    
    self.alertController.message = error.description;
    [self presentViewController:self.alertController animated:YES completion:nil];
}

// 信息流广告即将展示
- (void)jadFeedViewDidExposure:(JADFeedView *)feedView {
    JADLogI(@"FeedView Did Exposure");
}

// 点击回调
- (void)jadFeedViewDidClick:(JADFeedView *)feedView {
    JADLogI(@"FeedView Did Click");
}

// 关闭回调，建议在此回调方法中直接进行广告对象的移除动作，并将广告对象置为nil
- (void)jadFeedViewDidClose:(JADFeedView *)feedView {
    JADLogI(@"FeedView Did Close");
    
    [self.feedView removeFromSuperview];
    self.feedView = nil;
}

// 此回调在广告跳转到其他控制器时，该控制器被关闭时调用
- (void)jadFeedViewDidCloseOtherController:(JADFeedView *)feedView
                           interactionType:(JADInteractionType)interactionType {
    JADLogI(@"FeedView Did Close Other Controller");
    NSString *str;
    if (interactionType == JADInteractionTypeURL) {
        str = @"ladingURL";
    }
}

@end
