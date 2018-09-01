//
//  buttomCell.h
//  yunbaolive
//
//  Created by YangBiao on 2016/11/16.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveStateView.h"
@interface antNewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * imageV;//显示大图
@property (nonatomic, strong) LiveStateView * statusView;//直播状态
@property (nonatomic, strong) LiveTypeView * typeView;//直播类型

@property (nonatomic, strong) UIView * titleBgGradientView;
@property (nonatomic, strong) UILabel * titleLabel;

@end
