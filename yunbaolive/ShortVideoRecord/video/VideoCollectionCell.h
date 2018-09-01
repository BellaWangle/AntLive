//
//  VideoCollectionCell.h
//  iphoneLive
//
//  Created by YangBiao on 2017/9/5.
//  Copyright © 2017年 cat. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NearbyVideoModel.h"
@interface VideoCollectionCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *bgImageV;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *userAvatar;
@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UIImageView *distanceImage;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UIImageView *locationlImageV;
@property (strong, nonatomic) UIView *locationlBgView;
@property (nonatomic, strong) UIView * bgGradientView;

@property (nonatomic,strong) NearbyVideoModel *model;
@property (nonatomic,copy) NSString *isAtten;   //是不是关注页面使用,如果是的话原来的定位图标、label显示时间
@property (nonatomic,copy) NSString *isList;    //是不是首页视频列表，如果是的话定位图标、label显示评论数，右上角添加定位view

@end
