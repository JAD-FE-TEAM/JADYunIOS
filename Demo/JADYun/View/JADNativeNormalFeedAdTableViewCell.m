//
//  JADNativeNormalFeedAdTableViewCell.m
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/11/23.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import "JADNativeNormalFeedAdTableViewCell.h"

#if __has_include(<JADYunCore/JADCommonMacros.h>)
#import <JADYunCore/JADCommonMacros.h>
#else
#import <JADYun/JADCommonMacros.h>
#endif


#define edge 15

@implementation JADNativeNormalFeedAdTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _separatorLine = [[UIView alloc] initWithFrame:CGRectMake(edge, 0, JADScreenWidth-edge*2, 0.5)];
    _separatorLine.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_separatorLine];
    
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = [self generateDynamickColor:[UIColor blackColor] darkColor:[UIColor whiteColor]];
    [self.contentView addSubview:_titleLabel];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.font = [UIFont systemFontOfSize:12];
    _descriptionLabel.textColor = [self generateDynamickColor:[UIColor blackColor] darkColor:[UIColor whiteColor]];
    [self.contentView addSubview:_descriptionLabel];
        
    _closeIncon = [[UIImageView alloc] init];
    [_closeIncon setImage:[UIImage imageNamed:@"anClose.png"]];
    [self.contentView addSubview:_closeIncon];
}

- (void)refreshUIWithModel:(JADNormalModel *)model {
    self.model = model;
    _titleLabel.text = model.adTitle;
    _descriptionLabel.text = model.adDescription;

    _descriptionLabel.frame= CGRectMake(edge, model.cellHeight - 12 - edge, 200, 12);
    _closeIncon.frame = CGRectMake(JADScreenWidth - 15 - edge, model.cellHeight - 12 - edge, 15, 12);
}

- (UIColor *)generateDynamickColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
    if (@available(iOS 13.0, *)) {
        UIColor *dyColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return lightColor;
            } else {
                return darkColor;
            }
        }];
        return dyColor;
    } else {
        return lightColor;
    }
}

@end

@implementation JADNativeNormalFeedTitleAdTableViewCell

- (void)setupView {
    [super setupView];
    
    self.titleLabel.frame = CGRectMake(edge, edge, JADScreenWidth-edge*2, 50);
}

- (void)refreshUIWithModel:(JADNormalModel *)model {
    [super refreshUIWithModel:model];
}

@end

@implementation JADNativeNormalFeedBigImgAdTableViewCell

- (void)setupView {
    [super setupView];
    
    self.titleLabel.frame = CGRectMake(edge, edge, JADScreenWidth-edge*2, 50);
    
    self.bigImg = [[UIImageView alloc] initWithFrame:CGRectMake(edge, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + edge, JADScreenWidth-edge*2, (JADScreenWidth-edge*2)*0.6)];
    self.bigImg.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.bigImg];
}

- (void)refreshUIWithModel:(JADNormalModel *)model {
    [super refreshUIWithModel:model];
}

@end

@implementation JADNativeNormalFeedSmallImgAdTableViewCell

- (void)setupView {
    [super setupView];
    
    self.titleLabel.frame = CGRectMake(edge, edge, JADScreenWidth-120-edge*3, 50);
    
    self.smallImg = [[UIImageView alloc] initWithFrame:CGRectMake(JADScreenWidth-edge-120, edge, 120, 80)];
    self.smallImg.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.smallImg];
}

- (void)refreshUIWithModel:(JADNormalModel *)model {
    [super refreshUIWithModel:model];
}

@end
