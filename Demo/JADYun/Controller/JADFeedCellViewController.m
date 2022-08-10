//
//  JADFeedCellViewController.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/10/20.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "JADFeedCellViewController.h"
#import "JADListFeedTableViewController.h"

@interface JADFeedCellViewController ()

@property (weak, nonatomic) IBOutlet UISlider *widthSlider;
@property (weak, nonatomic) IBOutlet UISlider *scaleSlider;
@property (weak, nonatomic) IBOutlet UILabel *widthLabel;
@property (weak, nonatomic) IBOutlet UILabel *scaleLabel;
@property (weak, nonatomic) IBOutlet UITextField *slotIDTextField;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *feedScaleList;

@end

@implementation JADFeedCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

#pragma mark Load Data

- (void)loadData {
    // 信息流列表控制器加载信息流广告
    [[self getFeedListTableVC] loadSlotID:self.slotIDTextField.text adSize:CGSizeMake(self.widthSlider.value, (self.widthSlider.value/self.scaleSlider.value))];
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
    [[self getFeedListTableVC] resetDataSource];
    
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

- (IBAction)buttonPressedLoadAdAction:(id)sender {
    [self.slotIDTextField resignFirstResponder];
    [self loadData];
}

#pragma mark - Privacy Method

- (void)updateRangeLabel {
    self.scaleLabel.text  = [NSString stringWithFormat:@"比例:%.1f", self.scaleSlider.value];
    self.heightLabel.text = [NSString stringWithFormat:@"当前高度: %.2f", (self.widthSlider.value/self.scaleSlider.value)];
}

#pragma mark - Get ViewController

// storyboard 获取信息流列表控制器
- (JADListFeedTableViewController *)getFeedListTableVC {
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isMemberOfClass:[JADListFeedTableViewController class]]) {
            return (JADListFeedTableViewController *)vc;
        }
    }
    return nil;
}

@end
