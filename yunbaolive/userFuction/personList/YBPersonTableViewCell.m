//
//  YBPersonTableViewCell.m
//  TCLVBIMDemo
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "YBPersonTableViewCell.h"
#import "UIView+Additions.h"
//底部View
#import "AntBottomView.h"
#import "YBPersonTableViewModel.h"
#import "backLiveVC.h"
@interface YBPersonTableViewCell ()<YBBottpmViewDelegate>
{
    //名字宽度
    CGSize nameLabelWidth;
    UIFont *font1;//ID字体
    MASConstraint *cos;
    UIView *middleView;
}
//底部view
@property (nonatomic, strong) AntBottomView *bottomView;
@end
@implementation YBPersonTableViewCell
-(void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx,10);
    CGContextSetStrokeColorWithColor(ctx,[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0].CGColor);
    CGContextMoveToPoint(ctx,0,170);
    CGContextAddLineToPoint(ctx,(self.frame.size.width),170);
    CGContextStrokePath(ctx);
}
-(void)perform:(NSString *)text{
    if ([text rangeOfString:YZMsg(@"直播")].location != NSNotFound) {
    
        [self.personCellDelegate pushLiveNodeList];
        
    }else if ([text rangeOfString:YZMsg(@"粉丝")].location != NSNotFound){
        
        [self.personCellDelegate pushFansList];
        
    }else if ([text rangeOfString:YZMsg(@"关注2")].location != NSNotFound){
        
        [self.personCellDelegate pushAttentionList];
        
    }
}
-(void)setModel:(YBPersonTableViewModel *)model{
    
    
    _model = model;
    _nameLabel.text = _model.user_nicename;
    CGSize sizes= [_nameLabel.text boundingRectWithSize:CGSizeMake(90, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontThin(14)} context:nil].size;
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        {
            make.left.mas_equalTo(self.iconView.mas_right).offset(10);
            make.top.equalTo(self.iconView.mas_top).offset(20);
            make.height.mas_equalTo(20);
            
            if (IS_IPHONE_5) {
                make.width.mas_equalTo(sizes.width);
            }
        }
    }];
    NSString *laingname = minstr([Config getliang]);
    if ([laingname isEqual:@"0"]) {
        _IDL.text = [NSString stringWithFormat:@"ID:%@",_model.ID];
    }
    else{
        _IDL.text = [NSString stringWithFormat:@"%@:%@",YZMsg(@"靓"),laingname];
    }
    if ([_model.sex isEqualToString:@"1"]) {
        [_sexView setImage:[UIImage imageNamed:@"choice_sex_nanren"]];
    }
    else{
        [_sexView setImage:[UIImage imageNamed:@"choice_sex_nvren"]];
    }
    [_levelView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"leve%@",_model.level]]];
    [_level_anchorView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"host_%@",_model.level_anchor]]];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:[UIImage imageNamed:@"bg1"]];
    [self.bottomView setAgain:@[_model.lives,_model.follows,_model.fans]];
    
}
+ (instancetype)cellWithTabelView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"YBPersonTableViewCell";
    YBPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[YBPersonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupView];
        [self layoutUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
//MARK:-设置控件
-(void)setupView
{
    //头像
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.frame = CGRectMake(0,0,80,80);
    [iconView setClipsToBounds:YES];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius =40;
    [iconView sizeToFit];
    self.iconView = iconView;
    [self.contentView addSubview:iconView];
    self.contentView.backgroundColor = [UIColor whiteColor];
    //姓名
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [nameLabel setFont:fontThin(14)];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    //性别
    UIImageView *sexView = [[UIImageView alloc]init];
    [sexView setClipsToBounds:YES];
    [sexView setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:sexView];
    self.sexView = sexView;
    //等级
    UIImageView *levelView = [[UIImageView alloc]init];
    [levelView setClipsToBounds:YES];
    [levelView setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:levelView];
    self.levelView = levelView;
    
    UIImageView *levelViewhost = [[UIImageView alloc]init];
    [levelViewhost setClipsToBounds:YES];
    [levelViewhost setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:levelViewhost];
    self.level_anchorView = levelViewhost;
    //编辑按钮
    UIButton *editBtn = [[UIButton alloc]init];
    [editBtn setImage:[UIImage imageNamed:getImagename(@"编辑资料")] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(doEdit) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editBtn];
    self.editBtn = editBtn;
    UIButton *editBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn2 addTarget:self action:@selector(doEdit) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editBtn2];
    self.editBtn2 = editBtn2;

    //ID
    UILabel *ID = [[UILabel alloc]init];
    ID.backgroundColor = [UIColor clearColor];
    ID.textAlignment = NSTextAlignmentCenter;
    ID.textColor = [UIColor grayColor];
    [ID setFont:fontThin(14)];
    [self.contentView addSubview:ID];
    self.IDL = ID;
    
    //底部view
    AntBottomView *bottomView = [[AntBottomView alloc]init];
    bottomView.BottpmViewDelegate = self;
    [self.contentView addSubview:bottomView];
    
    self.bottomView = bottomView;
    LiveUser *user = [Config myProfile];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:user.avatar]];
    _nameLabel.text = user.user_nicename;
    _IDL.text = [NSString stringWithFormat:@"ID:%@",user.ID];
    NSString *sexS = [NSString stringWithFormat:@"%@",user.sex];
    if ([sexS isEqualToString:@"1"]) {
        [_sexView setImage:[UIImage imageNamed:@"choice_sex_nanren"]];
    }
    else{
        [_sexView setImage:[UIImage imageNamed:@"choice_sex_nvren"]];
    }
    
    [_levelView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level%@",user.level]]];
    [_level_anchorView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"host_%@",user.level_anchor]]];
    
}
-(void)doEdit
{
    [self.personCellDelegate pushEditView];    
}
//MARK:-layoutSubviews
-(void)layoutUI
{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.height.mas_equalTo(80);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(28);
    }];
     [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconView.mas_right).offset(15);
            make.top.equalTo(self.iconView.mas_top).offset(20);
            make.height.mas_equalTo(20);
            
        }];
    
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(3);
        make.topMargin.equalTo(self.nameLabel.mas_topMargin);
        make.top.mas_equalTo(self.nameLabel.mas_top).offset(3);
        make.width.height.mas_equalTo(16);
    }];
    
    [self.level_anchorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sexView.mas_right).offset(3);
        make.top.mas_equalTo(self.nameLabel.mas_top).offset(3);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.level_anchorView.mas_right).offset(3);
        make.top.mas_equalTo(self.nameLabel.mas_top).offset(3);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.top.equalTo(self.nameLabel.mas_top);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    [self.editBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.editBtn);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(60);
    }];
    [self.IDL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(9);
        make.height.equalTo(self.nameLabel.mas_height);
        make.left.equalTo(self.nameLabel);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.height.mas_equalTo(60);
    }];
}
//MARK:-动态返回label文字宽度
+(CGSize)sizeWithText:(NSString *)text textFont:(UIFont *)font textMaxSize:(CGSize)maxSize {
    // 计算文字时要几号字体
    NSDictionary *attr = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
}
//MARK:-懒加载
//头像
- (UIImageView *)iconView
{
    if (!_iconView) {
        UIImageView *iconImageView = [[UIImageView alloc]init];
        _iconView = iconImageView;
    }
    return _iconView;
}
//性别
- (UIImageView *)sexView
{
    if (!_sexView) {
        UIImageView *sexView = [[UIImageView alloc]init];
        _sexView = sexView;
    }
    return _sexView;
}
//等级
- (UIImageView *)levelView
{
    if (!_levelView) {
        UIImageView *levelView = [[UIImageView alloc]init];
        _levelView = levelView;
    }
    return _levelView;
}
- (UIImageView *)level_anchorView
{
    if (!_level_anchorView) {
        UIImageView *levelViewhost = [[UIImageView alloc]init];
        _level_anchorView = levelViewhost;
    }
    return _level_anchorView;
}
//姓名
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        UILabel *nameLabel = [[UILabel alloc]init];
        _nameLabel = nameLabel;
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}
//编辑按钮
- (UIButton *)editBtn
{
    if (!_editBtn) {
        UIButton *editBtn = [[UIButton alloc]init];
        _editBtn = editBtn;
    }
    return _editBtn;
}
//签名
-(UILabel *)IDL
{
    if (!_IDL) {
        UILabel *IDLLL = [[UILabel alloc]init];
        _IDL = IDLLL;
    }
    return _IDL;
}
//底部view
-(AntBottomView *)bottomView
{
    if (!_bottomView) {
        AntBottomView *bottomView = [[AntBottomView alloc]init];
        _bottomView = bottomView;
    }
    return _bottomView;
}
@end
