//
//  VideoCollectionCell.m
//  iphoneLive
//
//  Created by YangBiao on 2017/9/5.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "VideoCollectionCell.h"

@implementation VideoCollectionCell
{
    UILabel *label;
    UIImageView *imageV;
    UIView *view;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userAvatar.layer.masksToBounds = YES;
    self.userAvatar.layer.cornerRadius = self.userAvatar.width / 2;
}

- (void)setModel:(NearbyVideoModel *)model{
    _model = model;
    [self.bgImageV sd_setImageWithURL:[NSURL URLWithString:model.videoImage]];
    self.titleLabel.text = model.videoTitle;
    [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:model.userAvatar]];
    self.usernameLabel.text = model.userName;
    self.distanceLabel.text = model.distance;
    if ([self.isAtten isEqual:@"1"]) {
        self.distanceImage.image = [UIImage imageNamed:@"时间小图标"];
        self.distanceLabel.text = model.time;
    }
    if ([self.isList isEqual:@"1"]) {
        self.distanceImage.image = [UIImage imageNamed:@"评论小图标"];
        self.distanceLabel.text = model.commentNum;
        //添加右上角定位view
        if (view) {
            [view removeFromSuperview];
            view = nil;
            [label removeFromSuperview];
            label = nil;
            [imageV removeFromSuperview];
            imageV = nil;
        }
        NSString *str = model.city;
        if (str.length <= 0 || !str || [str isEqualToString:@"(null)"]) {
            return;
        }
        CGSize size = [str boundingRectWithSize:CGSizeMake(_window_width*0.65, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
        if (!view) {
            view = [[UIView alloc]init];
            view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
            view.layer.borderColor = [UIColor blackColor].CGColor;
            view.layer.borderWidth = 0.6;
            view.layer.cornerRadius = 14;
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(6);
                make.trailing.mas_equalTo(-6);
                make.width.mas_greaterThanOrEqualTo(0);
                make.height.mas_equalTo(28);
                make.leading.mas_greaterThanOrEqualTo(6);
            }];
            
            imageV = [[UIImageView alloc] init];
            imageV.image = [UIImage imageNamed:@"定位小图标"];
            imageV.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:imageV];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(-10);
                make.centerY.mas_equalTo(view);
                make.width.mas_equalTo(8);
                make.height.mas_equalTo(10);
            }];
            
            label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor whiteColor];
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.mas_equalTo(imageV.mas_leading).offset(-6);
                make.centerY.mas_equalTo(view);
                make.width.height.mas_greaterThanOrEqualTo(0);
                make.leading.mas_equalTo(10);
            }];
        }
        
        label.text = str;
        
    }
    
}

@end
