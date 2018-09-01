//
//  buttomCell.m
//  yunbaolive
//
//  Created by YangBiao on 2016/11/16.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "antNewCell.h"
#import "UIView+Util.h"

@implementation antNewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //创建显示大图
        self.imageV = [[UIImageView alloc]init];
        self.imageV.clipsToBounds = YES;
        self.imageV.layer.cornerRadius = 6;
        [self.imageV setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"无结果"]]];
        [self.contentView addSubview:self.imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        
        
        self.typeView = [[LiveTypeView alloc]init];
        self.typeView.layer.cornerRadius = 11;
        [self.imageV addSubview:_typeView];
        [_typeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.mas_equalTo(8);
            make.height.mas_equalTo(22);
            make.width.mas_greaterThanOrEqualTo(0);
        }];
        
        //直播状态
        self.statusView = [[LiveStateView alloc]init];
        self.statusView.layer.cornerRadius = 11;
        [self.imageV addSubview:self.statusView];
        [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.trailing.mas_equalTo(-8);
            make.height.mas_equalTo(22);
            make.width.mas_greaterThanOrEqualTo(0);
        }];
        
        _titleBgGradientView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        [_titleBgGradientView gradientWithColors:@[[[UIColor blackColor]colorWithAlphaComponent:0], [[UIColor blackColor]colorWithAlphaComponent:0.3]] starPoint:CGPointMake(1, 0) endPoint:CGPointMake(1, 1)];
        [self.imageV addSubview:_titleBgGradientView];
        [_titleBgGradientView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(0);
            make.height.mas_equalTo(80);
        }];
        
        self.titleLabel = [[UILabel alloc]initWithFont:15 textColor:[UIColor whiteColor]];
        [_titleBgGradientView addSubview:self.titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(8);
            make.trailing.mas_equalTo(-8);
            make.bottom.mas_equalTo(-10);
            make.height.mas_equalTo(21);
        }];
    }
    return self;
}

@end
