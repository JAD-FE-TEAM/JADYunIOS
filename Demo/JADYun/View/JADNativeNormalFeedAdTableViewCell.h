//
//  JADNativeNormalFeedAdTableViewCell.h
//  JADYun_Example
//
//  Created by wangshuai331 on 2020/11/23.
//  Copyright © 2020 JD.COM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JADNormalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JADNativeNormalFeedAdTableViewCell : UITableViewCell

@property (strong, nonatomic) JADNormalModel *model;
@property (strong, nonatomic, nullable) UIView *separatorLine;
@property (strong, nonatomic, nullable) UILabel *titleLabel;
@property (strong, nonatomic, nullable) UILabel *descriptionLabel;
@property (strong, nonatomic, nullable) UIImageView *closeIncon;

- (void)refreshUIWithModel:(JADNormalModel *_Nonnull)model;

@end

@interface JADNativeNormalFeedTitleAdTableViewCell : JADNativeNormalFeedAdTableViewCell

@end

@interface JADNativeNormalFeedSmallImgAdTableViewCell : JADNativeNormalFeedAdTableViewCell

@property (strong, nonatomic, nullable) UIImageView *smallImg;

@end

@interface JADNativeNormalFeedBigImgAdTableViewCell : JADNativeNormalFeedAdTableViewCell

@property (strong, nonatomic, nullable) UIImageView *bigImg;

@end

NS_ASSUME_NONNULL_END
