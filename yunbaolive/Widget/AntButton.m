//
//  AntButton.m
//  AntliveShow
//
//  Created by 毅力起 on 2018/8/7.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "AntButton.h"
#import "UIView+Util.h"

@interface AntButton()

@property (nonatomic, strong) UIImageView * myImageView;
@property (nonatomic, strong) UILabel * myTitleLabel;
@property (nonatomic, strong) UIView * confirmCoverView;
@property (nonatomic, assign) ButtonDirectionType directionType;
@property (nonatomic, assign) MyButtonType myButtonType;

@property (nonatomic, strong) UIImage * normalImage;
@property (nonatomic, strong) UIImage * selectImage;

@property (nonatomic, strong) NSString * normalTitle;
@property (nonatomic, strong) NSString * selectTitle;

@end

@implementation AntButton

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _myButtonType = MyButtonTypeNormal;
        _buttonTitleFontSize = 17;
        _buttonTitleColor = Default_Gray;
        _directionType = DirectionHorizontalImageLeft;
        [self createSubviews];
    }
    return self;
}

-(instancetype)init{
    return [self initWithDirectionWithType:DirectionHorizontalImageLeft];
}

-(instancetype)initWithDirectionWithType:(ButtonDirectionType)type{
    self = [super init];
    if (self) {
        _myButtonType = MyButtonTypeNormal;
        _buttonTitleFontSize = 12;
        _buttonTitleColor = Default_Black;
        _directionType = type;
        [self createSubviews];
    }
    return self;
}

-(instancetype)initWithButtonType:(MyButtonType)type{
    self = [super init];
    if (self) {
        _myButtonType = type;
        _buttonTitleFontSize = 12;
        _buttonTitleColor = Default_Black;
        _directionType = DirectionHorizontalImageLeft;
        [self createSubviews];
    }
    return self;
}

-(instancetype)initConfirmButtonWithTitle:(NSString *)title cornerRadius:(CGFloat)cornerRadius{
    self = [super init];
    if (self) {
        _directionType = DirectionHorizontalImageLeft;
        _buttonTitleFontSize = 17;
        _buttonTitleColor = [UIColor whiteColor];
        _normalTitle = title;
        _selectTitle = title;
        _myButtonType = MyButtonTypeConfirm;
        self.userInteractionEnabled = NO;
        self.backgroundColor = Main_Color;
        self.layer.cornerRadius = cornerRadius;
        self.clipsToBounds = YES;
        [self createSubviews];
        [self setLayout];
        _myTitleLabel.text = _normalTitle;
    }
    return self;
}

//-(void)setFrame:(CGRect)frame{
//    super.frame = frame;
//    [self setLayout];
//}

-(void)createSubviews{
    switch (_myButtonType) {
        case MyButtonTypeNormal:
            [self createDirectionSubviews];
            break;
        case MyButtonTypeConfirm:
            [self createDirectionSubviews];
            break;
        default:
            break;
    }
}


-(void)createDirectionSubviews{
    
    _centerBgView = [[UIView alloc]init];
    _myImageView = [[UIImageView alloc]init];
    _myTitleLabel = [[UILabel alloc]initWithTextColor:_buttonTitleColor font:_buttonTitleFontSize textAliahment:NSTextAlignmentCenter text:nil];
    
    if (_myButtonType == MyButtonTypeConfirm) {
        UIView * view = [[UIView alloc]init];
        view.userInteractionEnabled = NO;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view gradientWithColors:@[HexColor(@"FFD328"),HexColor(@"FF9912")] starPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];
        });
        
        _confirmCoverView = [[UIView alloc]init];
        _confirmCoverView.backgroundColor = [UIColor whiteColor];
        _confirmCoverView.alpha = 0.8;
        _confirmCoverView.userInteractionEnabled = NO;
        [self addSubview:_confirmCoverView];
        [_confirmCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    
    [self addSubview:_centerBgView];
    [_centerBgView addSubview:_myImageView];
    [_centerBgView addSubview:_myTitleLabel];
    
    _verticalHeight = 6;
    _HorizontalWidth = 3;
    _buttonImageWidth = 18;
    
    [self setLayout];
    
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    if (!IsEmptyStr(_normalTitle)) {
        _myTitleLabel.text = _normalTitle;
    }
    
    [_centerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.height.mas_greaterThanOrEqualTo(0);
    }];
    
    _myImageView.contentMode = UIViewContentModeScaleAspectFit;
    _myImageView.clipsToBounds = YES;
    
    _centerBgView.userInteractionEnabled = NO;
    
}

-(void)setButtonImageWidth:(CGFloat)buttonImageWith{
    _buttonImageWidth = buttonImageWith;
    [self setLayout];
}

-(void)setButtonTitleFontSize:(CGFloat)buttonTitleFontSize{
    _myTitleLabel.font = [UIFont systemFontOfSize:buttonTitleFontSize];
    [self setLayout];
}

-(void)setButtonTitleFont:(UIFont *)buttonTitleFont{
    _myTitleLabel.font = buttonTitleFont;
    [self setLayout];
}

-(void)setButtonTitleColor:(UIColor *)buttonTitleColor{
    _myTitleLabel.textColor = buttonTitleColor;
}
-(void)setLayout{
    switch (_myButtonType) {
        case MyButtonTypeNormal:
            [self setDirectionLayout];
            break;
        case MyButtonTypeConfirm:
            [self setDirectionLayout];
            break;
        default:
            break;
    }
    
}

-(void)setDirectionLayout{
    CGSize labelSize = [_myTitleLabel setSizeWithMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    if (_directionType == DirectionVertical) {
        
        [_myImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.mas_equalTo(_centerBgView);
            if (_myImageView.image) {
                make.width.height.mas_equalTo(_buttonImageWidth);
            }else{
                make.width.height.mas_equalTo(0);
            }
        }];
        
        [_myTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(_centerBgView);
            
            make.width.mas_greaterThanOrEqualTo(labelSize.width);
            if (!IsEmptyStr(_myTitleLabel.text)) {
                make.top.mas_equalTo(_myImageView.mas_bottom).offset(_verticalHeight);
                make.height.mas_greaterThanOrEqualTo(0);
            }else{
                make.top.mas_equalTo(_myImageView.mas_bottom).offset(0);
                make.height.mas_equalTo(0);
            }
            make.bottom.mas_equalTo(0);
        }];
        
        self.buttonWidth = labelSize.width < _buttonImageWidth ? _buttonImageWidth : labelSize.width;
        self.buttonHeight =  labelSize.height ? _buttonImageWidth + _verticalHeight + labelSize.height : _buttonImageWidth;
        
    }else{
        if (_directionType == DirectionHorizontalImageLeft) {
            
            [_myImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.bottom.mas_equalTo(_centerBgView);
                make.height.mas_equalTo(_buttonImageWidth);
                if (_myImageView.image) {
                    make.width.mas_equalTo(_buttonImageWidth);
                }else{
                    make.width.mas_equalTo(0);
                }
            }];
            
            [_myTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_centerBgView);
                if (!_myImageView.image || IsEmptyStr(_myTitleLabel.text)) {
                    make.leading.mas_equalTo(_myImageView.mas_trailing);
                }else{
                    make.leading.mas_equalTo(_myImageView.mas_trailing).offset(_HorizontalWidth);
                }
                make.width.mas_greaterThanOrEqualTo(labelSize.width);
                make.height.mas_greaterThanOrEqualTo(0);
                make.trailing.mas_equalTo(0);
            }];
            
            
        }else {
            
            [_myTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_centerBgView);
                make.leading.mas_equalTo(0);
                make.width.mas_greaterThanOrEqualTo(labelSize.width);
                make.height.mas_greaterThanOrEqualTo(0);
            }];
            
            [_myImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.trailing.mas_equalTo(_centerBgView);
                make.height.mas_equalTo(_buttonImageWidth);
                if (!_myImageView.image || IsEmptyStr(_myTitleLabel.text)) {
                    make.leading.mas_equalTo(_myTitleLabel.mas_trailing);
                    make.width.mas_equalTo(0);
                }else{
                    make.leading.mas_equalTo(_myTitleLabel.mas_trailing).offset(_HorizontalWidth);
                    make.width.mas_equalTo(_buttonImageWidth);
                }
            }];
            
        }
        
        self.buttonWidth = _myImageView.image? labelSize.width + _HorizontalWidth + _buttonImageWidth : labelSize.width;
        self.buttonHeight = _myImageView.image ? _buttonImageWidth : labelSize.height;
    }
}

-(void)setSelectTitle:(NSString *)title imageName:(NSString *)imageName{
    _selectImage = [UIImage imageNamed:imageName];
    _selectTitle = title;
}

-(void)setTitle:(NSString *)title imageName:(NSString *)imageName{
    _normalImage = [UIImage imageNamed:imageName];
    _normalTitle = title;
    
    _myImageView.image = _normalImage;
    _myTitleLabel.text = title;
    
    [self setLayout];
}

-(void)setSelected:(BOOL)selected{
    
    super.selected = selected;
    
    if (_myButtonType == MyButtonTypeConfirm) {
        if (selected) {
            self.userInteractionEnabled = YES;
            [UIView animateWithDuration:0.2 animations:^{
                _confirmCoverView.alpha = 0;
            }];
        }else{
            self.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.2 animations:^{
                _confirmCoverView.alpha = 0.8;
            }];
        }
    }
    
    if (super.selected && _selectImage) {
        _myImageView.image = _selectImage;
    }else{
        _myImageView.image = _normalImage;
    }
    
    if (super.selected && _selectTitle) {
        _myTitleLabel.text = _selectTitle;
    }else{
        _myTitleLabel.text = _normalTitle;
    }
    [self setLayout];
}

-(NSString *)title{
    return _myTitleLabel.text;
}

-(void)setTitle:(NSString *)title{
    _normalImage = nil;
    _normalTitle = title;
    
    _myImageView.image = nil;
    _myTitleLabel.text = title;
    switch (_myButtonType) {
        case MyButtonTypeNormal:
            [self setLayout];
            break;
            
        default:
            break;
    }
}

-(UIImage *)image{
    return _myImageView.image;
}

-(void)setImage:(UIImage *)image{
    _normalImage = image;
    _normalTitle = nil;
    
    _myImageView.image = _normalImage;
    _myTitleLabel.text = nil;
    
    [self setLayout];
}

@end
