//
//  YBUserInfoListTableViewCell.m
//  TCLVBIMDemo
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 tencent. All rights reserved.
//
#import "YBUserInfoListTableViewCell.h"
@implementation YBUserInfoListTableViewCell

+ (instancetype)cellWithTabelView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"YBUserInfoListTableViewCell";
    YBUserInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        YBUserInfoListTableViewCell *cell = [[YBUserInfoListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YBUserInfoListTableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = UIColorFromRGB(0x4C4C4C);
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UIAccessibilityTraitNone;
    [self setUI];
    return self;
}
-(void)setUI
{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    _bgView = [[UIView alloc]init];
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
    }];
    
    
    
    _rightArrowImageView = [[UIImageView alloc]init];
    _rightArrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    _rightArrowImageView.image = [UIImage imageNamed:@"ic_right_in"];
    [_bgView addSubview:_rightArrowImageView];
    [_rightArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bgView);
        make.width.height.mas_equalTo(12);
        make.trailing.mas_equalTo(-DEFAULT_MARGIN_ENDS);
    }];
    
    _iconImage = [[UIImageView alloc]init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    
    _nameL = [[UILabel alloc]init];
    _nameL.textColor = [UIColor blackColor];
    _nameL.font = fontThin(14);
    
    
    [_bgView addSubview:_nameL];
    [_bgView addSubview:_iconImage];
    

    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(DEFAULT_MARGIN_ENDS);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(22);
    }];
    
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_iconImage.mas_trailing).offset(10);
        make.trailing.mas_equalTo(_rightArrowImageView.mas_leading).offset(-10);
        make.centerY.equalTo(_iconImage.mas_centerY);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    UILabel * line = [[UILabel alloc]initLineColor:nil];
    [_bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}



@end
