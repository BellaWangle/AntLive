//
//  UserinfoHeaderView.m
//  AntLive
//
//  Created by 毅力起 on 2018/8/31.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "UserinfoHeaderView.h"

@interface UserinfoHeaderView()

@property (nonatomic, strong) UIImageView * avatarImageView;

@property (nonatomic, strong) UILabel * nickNameLabel;
@property (nonatomic, strong) UILabel * IDNumLabel;

@property (nonatomic, strong) UIImageView * sexImageView;
@property (nonatomic, strong) UIImageView * levelImageView;
@property (nonatomic, strong) UIImageView * levelAnchorView;

@property (nonatomic, strong) UILabel * liveNumLabel;
@property (nonatomic, strong) UILabel * guanzhuNumLabel;
@property (nonatomic, strong) UILabel * fansNumLabel;

@end

@implementation UserinfoHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

-(instancetype)init{
    return [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 337)];
}

-(void)createSubviews{
    UIImageView * bgImagView = [[UIImageView alloc]init];
    bgImagView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.666);
    bgImagView.image = [UIImage imageNamed:@"ic_userinfo_head_bg"];
    [self addSubview:bgImagView];
    
    UIView * bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 8;
    bgView.layer.shadowOffset = CGSizeMake(0, 10);
    bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    bgView.layer.shadowOpacity = 0.1;
    bgView.layer.shadowRadius = 10;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(108);
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.height.mas_equalTo(210);
    }];
    
    _avatarImageView = [[UIImageView alloc]init];
    _avatarImageView.layer.cornerRadius = 47;
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.image = [UIImage imageNamed:@"default_head"];
    [self addSubview:_avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(61);
        make.centerX.mas_equalTo(self);
        make.width.height.mas_equalTo(94);
    }];
    
    _nickNameLabel = [[UILabel alloc]initWithTextColor:Default_Black font:24 textAliahment:NSTextAlignmentCenter text:@""];
    [self addSubview:_nickNameLabel];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_avatarImageView.mas_bottom).offset(13);
        make.centerX.mas_equalTo(self);
        make.trailing.mas_lessThanOrEqualTo(-94);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(36);
    }];
    
    _sexImageView = [[UIImageView alloc]init];
    _sexImageView.image = [UIImage imageNamed:@"man"];
    [self addSubview:_sexImageView];
    [_sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_nickNameLabel);
        make.leading.mas_equalTo(_nickNameLabel.mas_trailing).offset(5);
        make.width.height.mas_equalTo(18);
    }];
    
    _levelImageView = [[UIImageView alloc]init];
    _levelImageView.layer.cornerRadius = 9;
    _levelImageView.clipsToBounds = YES;
    [self addSubview:_levelImageView];
    [_levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_nickNameLabel);
        make.leading.mas_equalTo(_sexImageView.mas_trailing).offset(5);
        make.width.height.mas_equalTo(18);
        
    }];
    
    _levelAnchorView = [[UIImageView alloc]init];
    _levelAnchorView.layer.cornerRadius = 9;
    _levelAnchorView.clipsToBounds = YES;
    [self addSubview:_levelAnchorView];
    [_levelAnchorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_nickNameLabel);
        make.leading.mas_equalTo(_levelImageView.mas_trailing).offset(5);
        make.width.height.mas_equalTo(18);
    }];
    
    _IDNumLabel = [[UILabel alloc]initWithTextColor:Default_Gray font:15 textAliahment:NSTextAlignmentCenter text:@""];
    [self addSubview:_IDNumLabel];
    [_IDNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nickNameLabel.mas_bottom).offset(1);
        make.centerX.mas_equalTo(self);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(21);
    }];
    
    
    UILabel * line = [[UILabel alloc]initLineColor:nil];
    [bgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(140);
        make.leading.trailing.mas_equalTo(0);
        make.height.mas_equalTo(0.6);
    }];
    
    [bgView layoutIfNeeded];
    
    NSArray * titleArr = @[YZMsg(@"直播"),YZMsg(@"粉丝"),YZMsg(@"关注2")];
    CGFloat width = bgView.mj_w/titleArr.count;
    for (int i = 0; i < titleArr.count; i++) {
        UIButton * button = [[UIButton alloc]init];
        button.tag = 2500+i;
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(i * width);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(width);
            make.top.mas_equalTo(line.mas_bottom);
        }];
        
        UILabel * titleLabel = [[UILabel alloc]initWithTextColor:Default_Gray font:12 textAliahment:NSTextAlignmentCenter text:titleArr[i]];
        [button addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(8);
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(17);
        }];
        
        UILabel * numLabel = [[UILabel alloc]initWithTextColor:Default_Black font:17 textAliahment:NSTextAlignmentCenter text:@"0"];
        [button addSubview:numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(3);
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(24);
        }];
        
        if (i == 0) {
            _liveNumLabel = numLabel;
            continue;
        }
        if (i == 1) {
            _guanzhuNumLabel = numLabel;
            continue;
        }
        if (i == 2) {
            _fansNumLabel = numLabel;
            continue;
        }
    }
    
    UIButton * button = [[UIButton alloc]init];
    button.tag = 2000;
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_avatarImageView);
        make.bottom.mas_equalTo(_IDNumLabel);
        make.width.mas_equalTo(165);
    }];
    
    LiveUser *user = [Config myProfile];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"default_head"]];
    _nickNameLabel.text = user.user_nicename;
    _IDNumLabel.text = [NSString stringWithFormat:@"ID:%@",user.ID];
     NSString *sexS = [NSString stringWithFormat:@"%@",user.sex];
    if ([sexS isEqual:@"0"]) {
        [_sexImageView setImage:[UIImage imageNamed:@"man"]];
    }
    else{
        [_sexImageView setImage:[UIImage imageNamed:@"woman"]];
    }
    [_levelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"leve%@",[Config getLevel]]]];
    [_levelAnchorView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"host_%@",user.level_anchor]]];
}

-(void)onClick:(UIButton *)button{
    if (button.tag == 2000) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pushEditView)]) {
            [self.delegate pushEditView];
        }
        return;
    }
    
    if (button.tag == 2500) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pushLiveNodeList)]) {
             [self.delegate pushLiveNodeList];
        }
        return;
    }
    
    if (button.tag == 2501) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pushFansList)]) {
             [self.delegate pushFansList];
        }
        return;
    }
    
    if (button.tag == 2502) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(pushAttentionList)]) {
             [self.delegate pushAttentionList];
        }
        return;
    }
}

-(void)setModel:(YBPersonTableViewModel *)model{
    [self layoutIfNeeded];
    dispatch_async(dispatch_get_main_queue(), ^{
        _model = model;
        _nickNameLabel.text = _model.user_nicename;
        _IDNumLabel.text = [NSString stringWithFormat:@"ID:%@",@"22222"] ;
        _liveNumLabel.text = _model.lives;
        _guanzhuNumLabel.text = _model.follows;
        _fansNumLabel.text = _model.fans;
        
        NSString *laingname = minstr([Config getliang]);
        if ([laingname isEqual:@"0"]) {
            _IDNumLabel.text = [NSString stringWithFormat:@"ID:%@",_model.ID];
        }
        else{
            _IDNumLabel.text = [NSString stringWithFormat:@"%@:%@",YZMsg(@"靓"),laingname];
        }
        if ([_model.sex isEqualToString:@"1"]) {
            [_sexImageView setImage:[UIImage imageNamed:@"choice_sex_nanren"]];
        }
        else{
            [_sexImageView setImage:[UIImage imageNamed:@"choice_sex_nvren"]];
        }
        [_levelImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"leve%@",_model.level]]];
        [_levelAnchorView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"host_%@",_model.level_anchor]]];
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:[UIImage imageNamed:@"default_head"]];
    });
    
    
    
}

@end
