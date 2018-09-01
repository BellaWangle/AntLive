//
//  YBUserInfoListTableViewCell.h
//  TCLVBIMDemo
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  个人中心列表cell
 */
@interface YBUserInfoListTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UILabel *nameL;

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *rightArrowImageView;

+ (instancetype)cellWithTabelView:(UITableView *)tableView;

@end
