//
//  YxtNavigationBar.m
//  YiXueTang
//
//  Created by ylq on 2017/9/12.
//  Copyright © 2017年 artschool. All rights reserved.
//

#import "AntLiveNavigationBar.h"
#import "UIView+Util.h"

@interface AntLiveNavigationBar()

@property (nonatomic, strong) UIView * loadingView;
@property (nonatomic, strong) UILabel * loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView * activityView;

#define SCREEN_HEIGHT_START ([[UIScreen mainScreen] bounds].size.height == 812.0 ? 44:20)

@end

@implementation AntLiveNavigationBar

-(instancetype)initWithTitle:(NSString *)title type:(navigationBarType)type{
    self = [super init];
    if (self) {
        _type = type;
        self.frame=CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT);
        if (type == NavigationBarTypeBlack) {
            self.backgroundColor = Default_Black;
        }
        if (type == NavigationBarTypeWhite) {
            self.backgroundColor = [UIColor whiteColor];
            [self addBottomLine];
        }
        if (type == NavigationBarTypeGradual) {
            [self gradientWithColors:@[HexColor(@"FEBC0A"),HexColor(@"FE950A")] starPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];
            [self addBottomLine];
        }
        
        [self setTitle:title];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title{
   
    return [self initWithTitle:title type:NavigationBarTypeBlack];
    
}

-(instancetype)init{
   return [self initWithTitle:@""];
}

-(void)setTitle:(NSString *)title{
    
    self.titleLabel.text = title;
    [self backButton];
}

/**添加底部横线*/
-(void)addBottomLine{
    if (!_bottomline) {
        _bottomline = [[UILabel alloc]initLineColor:nil];
        [self addSubview:_bottomline];
        
        [_bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(self);
            make.height.mas_equalTo(0.6);
        }];
    }
}

-(void)setBackBtnName:(NSString *)name{
    [_backImageView removeFromSuperview];
    [self.backButton setTitle:name forState:UIControlStateNormal];
}

-(void)setRightBtnName:(NSString *)name{
    [_rightImageView removeFromSuperview];
    [self.rightButton setTitle:name forState:UIControlStateNormal];
}

-(void)setBackImageName:(NSString *)imageName{
    [self.backButton setTitle:@"" forState:UIControlStateNormal];
    self.backImageView.image = [UIImage imageNamed:imageName];
}

-(void)setRightImageName:(NSString *)imageName{
    [self.rightButton setTitle:@"" forState:UIControlStateNormal];
    
    self.rightImageView.image = [UIImage imageNamed:imageName];
}

-(void)backBtnOnClick:(UIButton *)sender{
    if (self.backButtonClickBlock) {
        BOOL b = self.backButtonClickBlock();
        if (b) {
            return;
        }
    }
    if (self.delegate) {
        [self.delegate backButtonOnClick];
    }
}

-(void)rightBtnOnClick:(UIButton *)sender{
    if (self.rightButtonClickBlock) {
        self.rightButtonClickBlock();
    }
}

-(void)showLoadingTitle:(NSString *)title{
    if (!_loadingView) {
        _loadingView = [[UIView alloc]init];

        _loadingLabel = [[UILabel alloc]init];
        _loadingLabel.font = [UIFont systemFontOfSize:18];
        UIColor * color;
        if (_type == NavigationBarTypeBlack) {
            color = [UIColor whiteColor];
        }else{
            color = Default_Black;
        }
        _loadingLabel.textColor = color;
        
        _loadingLabel.textAlignment = NSTextAlignmentCenter;
        
        _activityView = [[UIActivityIndicatorView alloc]init];
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        if (_type == NavigationBarTypeBlack) {
            _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            _loadingView.backgroundColor = Default_Black;
        }else{
            _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            _loadingView.backgroundColor = [UIColor whiteColor];
        }
        
        [self addSubview:_loadingView];
        [_loadingView addSubview:_loadingLabel];
        [_loadingView addSubview:_activityView];
        
    }
    
    _loadingView.hidden = NO;
    [_activityView startAnimating];
    _loadingLabel.text = title;
    CGSize size = [_loadingLabel setSizeWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    if (size.width > _titleLabel.width - 30) {
        size.width = _titleLabel.width - 30;
    }
    
    _loadingView.frame = CGRectMake(0, 0, size.width+30, size.height);
    _loadingView.center = _titleLabel.center;
    
    [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.trailing.mas_equalTo(0);
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];
    
    _activityView.frame = CGRectMake(0, 0, 20, size.height);
}

-(void)endLoading{
    _loadingView.hidden = YES;
    [_activityView stopAnimating];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        
        UIColor * color;
        if (_type == NavigationBarTypeBlack || _type == NavigationBarTypeGradual) {
            color = [UIColor whiteColor];
        }else{
            color = Default_Black;
        }
        _titleLabel.textColor = color;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(iPhoneX_Top+20);
            make.width.mas_greaterThanOrEqualTo(0);
        }];
    }
    return _titleLabel;
}

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc]init];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:13];
        
        UIColor * color;
        if (_type == NavigationBarTypeBlack || _type == NavigationBarTypeGradual) {
            color = [UIColor whiteColor];
            
        }else{
            color = Default_Black;
        }
        [_backButton setTitleColor:color forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_backButton];
        
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(SCREEN_HEIGHT_START);
            make.leading.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(_backButton.mas_height);
        }];
        
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(iPhoneX_Top+20);
            make.leading.mas_equalTo(_backButton.mas_trailing);
        }];
        
        [self backImageView];
        
    }
    return _backButton;
}

-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc]init];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
        UIColor * color;
        if (_type == NavigationBarTypeBlack || _type == NavigationBarTypeGradual) {
            color = [UIColor whiteColor];
            
        }else{
            color = Default_Black;
        }
        [_rightButton setTitleColor:color forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_rightButton];
        
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(SCREEN_HEIGHT_START);
            make.trailing.equalTo(self).priority(100);
            make.bottom.equalTo(self);
            make.width.mas_greaterThanOrEqualTo(_backButton.mas_height);
        }];
        
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(iPhoneX_Top+20);
            make.trailing.mas_equalTo(_rightButton.mas_leading).priority(50);
        }];
        
        [_rightButton layoutIfNeeded];
    }
    return _rightButton;
}

-(UIImageView *)backImageView{
    if (!_backImageView) {
        
        _backImageView = [[UIImageView alloc]init];
        _backImageView.contentMode = UIViewContentModeScaleAspectFit;
        NSString * imageName;
        if (_type == NavigationBarTypeBlack) {
            imageName = @"ic_back";
        }else{
            imageName = @"pub_black_back";
        }
        
        _backImageView.image = [UIImage imageNamed:imageName];
        
        [self.backButton addSubview:_backImageView];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_backButton);
            make.height.width.equalTo(@20);
        }];
    }
    return _backImageView;
}

-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.rightButton addSubview:_rightImageView];
        [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_rightButton);
            make.height.width.equalTo(@20);
        }];
    }
    return _rightImageView;
}
@end
