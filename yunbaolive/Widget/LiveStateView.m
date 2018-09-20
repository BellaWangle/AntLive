//
//  LiveStateView.m
//  AntLive
//
//  Created by 毅力起 on 2018/8/30.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "LiveStateView.h"
#import "UIView+Util.h"
#import "YYImage.h"

@interface LiveTypeView()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, assign) BOOL big;

@end

@implementation LiveTypeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

-(instancetype)init{
    return [self initWithFrame:CGRectZero];
}

-(instancetype)initWithBig{
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _big = YES;
        [self createSubviews];
    }
    return self;
}

-(void)createSubviews{
    self.clipsToBounds = YES;
    _gradientLayer = [self gradientWithColors:@[HexColor(@"FFFFFF")] starPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];
    
    CGFloat imageWidth = _big ? 16 : 14;
    CGFloat leading = _big? 3 : 2;
    CGFloat trailing = _big? -9 : -5;
    CGFloat font = _big? 13 : 10;
    
    _imageView = [[UIImageView alloc]init];
    _imageView.layer.cornerRadius = imageWidth/2;
    
    
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(leading);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(imageWidth);
    }];
    
    _titleLabel = [[UILabel alloc]initWithFont:font textColor:[UIColor whiteColor]];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_imageView.mas_trailing).offset(leading);
        make.trailing.mas_equalTo(trailing);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_greaterThanOrEqualTo(0);
    }];
    
    
}

-(void)setLiveType:(NSInteger)liveType{
    _liveType = liveType;//0是一般直播，1是私密直播，2是收费直播，3是计时直播
    UIColor * color1;
    UIColor * color2;
    switch (_liveType) {
        case 0:
            [_imageView setImage:[UIImage imageNamed:@"icon_live_state_normal"]];
            _titleLabel.text = YZMsg(@"普通直播");
            color1 = HexColor(@"8ACA00");
            color2 = HexColor(@"BEE700");
            break;
        case 1:
            [_imageView setImage:[UIImage imageNamed:@"icon_live_state_pwd"]];
            _titleLabel.text = YZMsg(@"私密直播");
            color1 = HexColor(@"1A74FF");
            color2 = HexColor(@"00B4FF");
            break;
        case 2:
            [_imageView setImage:[UIImage imageNamed:@"icon_live_state_charge"]];
            _titleLabel.text = YZMsg(@"收费直播");
            color1 = HexColor(@"FF62A5");
            color2 = HexColor(@"FF8960");
            break;
        case 3:
            [_imageView setImage:[UIImage imageNamed:@"icon_live_state_time"]];
            _titleLabel.text = YZMsg(@"计时直播");
            color1 = HexColor(@"6950FB");
            color2 = HexColor(@"B83AF3");
            break;
        default:
            [_imageView setImage:[UIImage imageNamed:@"icon_live_state_star"]];
            _titleLabel.text = YZMsg(@"明星直播");
            color1 = HexColor(@"6950FB");
            color2 = HexColor(@"B83AF3");
            break;
    }
    [self layoutIfNeeded];
    _gradientLayer.colors = @[(__bridge id)color1.CGColor,(__bridge id)color2.CGColor];
    _gradientLayer.frame = self.bounds;
    
}

@end

@interface LiveStateView()

@property (nonatomic, strong) UIImageView * hotImageView;
@property (nonatomic, assign) BOOL focus;

@end

@implementation LiveStateView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

-(instancetype)init{
    return [self initWithFrame:CGRectZero];
}

-(instancetype)initWithFocus{
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _focus = YES;
        [self createSubviews];
    }
    return self;
}

-(void)createSubviews{
    self.clipsToBounds = YES;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];

    CGFloat imageWidth = 12;
    CGFloat margin = 5;
    CGFloat trailing = _focus? -9 : -5;
    CGFloat font = _focus? 13 : 10;

    YYImage * image = [YYImage imageNamed:@"yinping.gif"];
    YYAnimatedImageView * animatedImageView = [[YYAnimatedImageView alloc] initWithImage:image];
    [self addSubview:animatedImageView];
    [animatedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(imageWidth);
    }];
    
    _hotImageView = [[UIImageView alloc]init];
    _hotImageView.image = [UIImage imageNamed:@"ic_live_hot"];
    _hotImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_hotImageView];
    [_hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.leading.mas_equalTo(animatedImageView.mas_trailing);
        make.height.mas_equalTo(12);
        if (_focus) {
            make.width.mas_equalTo(0);
        }else{
            make.width.mas_equalTo(20);
        }
    }];
    
    _titleLabel = [[UILabel alloc]initWithFont:font textColor:[UIColor whiteColor]];
    if (_focus) {
        _titleLabel.text = @"直播中";
    }
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_focus) {
            make.leading.mas_equalTo(_hotImageView.mas_trailing).offset(margin);
        }else{
            make.leading.mas_equalTo(_hotImageView.mas_trailing).offset(0);
        }
        make.trailing.mas_equalTo(trailing);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_greaterThanOrEqualTo(0);
    }];
}


@end

