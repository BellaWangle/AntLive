//
//  TextFieldView.m
//  SKW
//
//  Created by 毅力起 on 2018/5/23.
//  Copyright © 2018年 陕西顺银恒信金融外包服务有限公司. All rights reserved.
//

#import "TextFieldView.h"
#import "NSString+category.h"
#import "UIView+MJExtension.h"
#import "UIView+Util.h"

@interface TextFieldView()<UITextFieldDelegate>

@property (nonatomic, strong)UILabel * bottomLine;
@property (nonatomic, strong)UILabel * LoginLine;

@end

@implementation TextFieldView

-(instancetype)initWithTitile:(NSString *)title placeholder:(NSString *)placeholder{
    _title = title;
    _placeholder = placeholder;
    return [self init];
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self createSubviews];
    }
    return self;
}

-(void)createSubviews{
    _maxlength = 1000;
    
    self.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc]initWithFont:14];
    _titleLabel.clipsToBounds = YES;
    [self addSubview:_titleLabel];
    
    _textField = [[UITextField alloc]init];
    _textField.font = _titleLabel.font;
    _textField.placeholder = _placeholder;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_titleLabel.mas_trailing);
        make.top.bottom.mas_equalTo(self);
        make.trailing.mas_equalTo(-DEFAULT_MARGIN_ENDS);
    }];
    
    [self setLayout];
}

-(void)setLayout{
    _titleLabel.text = _title;
    if (!IsNilOrNull(_leftView)) {
        [_leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(_leftView.mj_h);
            make.width.mas_equalTo(_leftView.mj_w);
        }];
        if (!IsEmptyStr(_title)) {
            _titleLabel.hidden = NO;
            [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(_leftView.mas_trailing).offset(10);
                make.top.bottom.mas_equalTo(self);
                if (_titleWidth > 0) {
                    make.width.mas_equalTo(_titleWidth);
                }else{
                    make.width.mas_greaterThanOrEqualTo(0);
                }
            }];
            
            [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(_titleLabel.mas_trailing).offset(10);
                make.top.bottom.mas_equalTo(self);
            }];
        }else{
            _titleLabel.hidden = YES;
            
            [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(_leftView.mas_trailing).offset(10);
                make.top.bottom.mas_equalTo(self);
            }];
        }
        
        
        
        
    }else if (!IsEmptyStr(_title)) {
        _titleLabel.hidden = NO;
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(DEFAULT_MARGIN_ENDS);
            make.top.bottom.mas_equalTo(self);
            if (_titleWidth > 0) {
                make.width.mas_equalTo(_titleWidth);
            }else{
                make.width.mas_greaterThanOrEqualTo(0);
            }
        }];
        
        [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_titleLabel.mas_trailing).offset(10);
            make.top.bottom.mas_equalTo(self);
        }];
    }else{
        _titleLabel.hidden = YES;
        
        [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(0);
            make.top.bottom.mas_equalTo(self);
        }];
    }
    
    [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
        if (_rightButton) {
            make.trailing.mas_equalTo(_rightButton.mas_leading).offset(-5);
        }else{
            make.trailing.mas_equalTo(0);
        }
    }];
}

-(void)resignFirstResponder{
    [_textField resignFirstResponder];
}
-(void)becomeFirstResponder{
    [_textField becomeFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string containsEmoji]) {
        return NO;
    }
    if ([string isEqualToString:@"\n"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(textFiledReturnClick:)]) {
            [self.delegate textFiledReturnClick:self];
        }
    }
    if (range.location >= _maxlength||string.length>0){
        NSString *txt = textField.text;
        if(txt.length >= _maxlength){
            textField.text=[txt substringToIndex:_maxlength];
            return NO;
        }
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_textFieldViewType == TextFieldViewType_Login) {
        [UIView animateWithDuration:0.2 animations:^{
            _LoginLine.alpha = 1;
        }];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (_textFieldViewType == TextFieldViewType_Login) {
        [UIView animateWithDuration:0.2 animations:^{
            _LoginLine.alpha = 0;
        }];
    }
    return YES;
}

-(void)textFieldTextChange:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFiledDidChange:)]) {
        [self.delegate textFiledDidChange:self];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFiledTouch:)]) {
        [self.delegate textFiledTouch:self];
    }
}

-(void)setTitle:(NSString *)title{
    _title = title;
    [self setLayout];
}

-(void)setLeftView:(UIView *)leftView{
    if (_leftView) {
        [_leftView removeFromSuperview];
    }
    _leftView = leftView;
    [self addSubview:_leftView];
    [self setLayout];
}

-(void)setSecureTextEntry:(BOOL)secureTextEntry{
    _textField.secureTextEntry = secureTextEntry;
    NSString *tempStr = self.textField.text;
    _textField.text = nil;
    _textField.text = tempStr;
}

-(void)setKeyboardType:(UIKeyboardType)keyboardType{
    _textField.keyboardType = keyboardType;
}

-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _textField.placeholder = placeholder;
}

-(void)setText:(NSString *)text{
    _textField.text = text;
}

-(NSString *)text{
    return _textField.text;
}

-(void)setRightButton:(UIButton *)rightButton{
    [self setRightButton:rightButton tag:rightButton.tag];
}

-(void)setRightButton:(UIButton *)rightButton tag:(NSInteger)tag{
    _rightButton = rightButton;
    if (_rightButton) {
        _rightButton.tag = tag;
        [self addSubview:_rightButton];
        [_rightButton addTarget:self action:@selector(rightButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.trailing.mas_equalTo(-DEFAULT_MARGIN_ENDS);
            make.width.mas_equalTo(_rightButton.mj_w);
            make.height.mas_equalTo(_rightButton.mj_h);
        }];
    }else{
        [_rightButton removeFromSuperview];
    }
    [self setLayout];
}

-(void)rightButtonOnClick:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFiledRightButtonOnClick:)]) {
        [self.delegate textFiledRightButtonOnClick:self];
    }
}

-(void)setTitleWidth:(CGFloat)titleWidth{
    _titleWidth = titleWidth;
    [self setLayout];
}

-(void)setTextFieldViewType:(TextFieldViewType)textFieldViewType{
    _textFieldViewType = textFieldViewType;
    if (_textFieldViewType == TextFieldViewType_Login) {
        if (!_bottomLine) {
            _bottomLine = [[UILabel alloc]initLineColor:nil];
            [self addSubview:_bottomLine];
            [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.bottom.mas_equalTo(0);
                make.height.mas_equalTo(0.6);
            }];
            
            _LoginLine = [[UILabel alloc]initLineColor:nil];
            _LoginLine.clipsToBounds = YES;
            _LoginLine.alpha = 0;
            [self addSubview:_LoginLine];
            [_LoginLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.bottom.mas_equalTo(0);
                make.height.mas_equalTo(2);
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_LoginLine gradientWithColors:@[HexColor(@"FFD328"),HexColor(@"FF9912")] starPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];
            });
            
        }
        
    }
}

@end
