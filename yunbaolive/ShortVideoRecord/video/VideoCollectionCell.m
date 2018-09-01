//
//  VideoCollectionCell.m
//  iphoneLive
//
//  Created by YangBiao on 2017/9/5.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "VideoCollectionCell.h"
#import "UIView+Util.h"

@implementation VideoCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        @property (strong, nonatomic) UIImageView *bgImageV;
//        @property (strong, nonatomic) UILabel *titleLabel;
//        @property (strong, nonatomic) UIImageView *userAvatar;
//        @property (strong, nonatomic) UILabel *usernameLabel;
//        @property (strong, nonatomic) UILabel *distanceLabel;
//        @property (strong, nonatomic) UIImageView *distanceImage;
//        @property (strong, nonatomic) UIView *bottomView;
//        @property (strong, nonatomic) UILabel *label;
//        @property (strong, nonatomic) UIImageView *imageV;
//        @property (strong, nonatomic) UIView *view;
//        @property (nonatomic, strong) UIView * bgGradientView;
        _bgImageV = [[UIImageView alloc]init];
        _bgImageV.layer.cornerRadius = 6;
        _bgImageV.clipsToBounds = YES;
        _bgImageV.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_bgImageV];
        [_bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.mas_equalTo(2.5);
            make.trailing.bottom.mas_equalTo(-2.5);
        }];
        
        _bgGradientView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        [_bgGradientView gradientWithColors:@[[[UIColor blackColor]colorWithAlphaComponent:0], [[UIColor blackColor]colorWithAlphaComponent:0.3]] starPoint:CGPointMake(1, 0) endPoint:CGPointMake(1, 1)];
        [_bgImageV addSubview:_bgGradientView];
        [_bgGradientView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(0);
            make.height.mas_equalTo(80);
        }];
        
        _distanceImage = [[UIImageView alloc]init];
        _distanceImage.layer.cornerRadius = 8;
        _distanceImage.clipsToBounds = YES;
        [_bgImageV addSubview:_distanceImage];
        [_distanceImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-8);
            make.bottom.mas_equalTo(-8);
            make.width.height.mas_equalTo(16);
        }];
        
        _distanceLabel = [[UILabel alloc]initWithTextColor:[UIColor whiteColor] font:13 textAliahment:NSTextAlignmentRight text:nil];
        [_bgImageV addSubview:_distanceLabel];
        [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(_distanceImage.mas_leading).offset(-3);
            make.centerY.mas_equalTo(_distanceImage);
            make.width.height.mas_greaterThanOrEqualTo(0);
        }];
        
        _userAvatar = [[UIImageView alloc]init];
        _userAvatar.layer.cornerRadius = 8;
        _userAvatar.clipsToBounds = YES;
        [_bgImageV addSubview:_userAvatar];
        [_userAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(8);
            make.bottom.mas_equalTo(_distanceImage);
            make.width.height.mas_equalTo(_distanceImage);
        }];
        
        _usernameLabel = [[UILabel alloc]initWithFont:13 textColor:[UIColor whiteColor]];
        [_bgImageV addSubview:_usernameLabel];
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_userAvatar.mas_trailing).offset(3);
            make.centerY.mas_equalTo(_userAvatar);
            make.height.mas_greaterThanOrEqualTo(0);
            make.trailing.mas_equalTo(_distanceLabel.mas_leading).offset(-3);
        }];
        
        _locationlBgView = [[UIView alloc]init];
        _locationlBgView.clipsToBounds = YES;
        _locationlBgView.layer.cornerRadius = 10;
        _locationlBgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        [_bgImageV addSubview:_locationlBgView];
        [_locationlBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-7);
            make.leading.mas_greaterThanOrEqualTo(7);
            make.top.mas_equalTo(5);
            make.height.mas_equalTo(20);
            make.width.mas_greaterThanOrEqualTo(0);
        }];
        
        _locationLabel = [[UILabel alloc]initWithFont:10 textColor:[UIColor whiteColor]];
        [_locationlBgView addSubview:_locationLabel];
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(9);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_greaterThanOrEqualTo(0);
        }];
        
        _locationlImageV = [[UIImageView alloc]init];
        _locationlImageV.image = [UIImage imageNamed:@"定位小图标"];
        [_locationlBgView addSubview:_locationlImageV];
        [_locationlImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_locationLabel.mas_trailing).offset(3);
            make.trailing.mas_equalTo(-9);
            make.centerY.mas_equalTo(_locationlBgView);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(10);
        }];
    }
    return self;
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
        _locationlBgView.hidden = NO;
        self.distanceImage.image = [UIImage imageNamed:@"ic_message"];
        self.distanceLabel.text = model.commentNum;
        
        NSString *str = model.city;
        if (str.length <= 0 || !str || [str isEqualToString:@"(null)"]) {
            _locationlBgView.hidden = YES;
            return;
        }
        _locationLabel.text = str;
    }else{
        _locationlBgView.hidden = YES;
    }
    
}

@end
