//
//  TextFieldView.h
//  SKW
//
//  Created by 毅力起 on 2018/5/23.
//  Copyright © 2018年 陕西顺银恒信金融外包服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AntButton.h"

@class TextFieldView;

typedef NS_ENUM(NSInteger, TextFieldViewType) {
    TextFieldViewType_Normal,
    TextFieldViewType_Login,
};

@protocol TextFieldViewDelegate<NSObject>

@optional

-(void)textFiledDidChange:(TextFieldView *)textFiled;

-(void)textFiledReturnClick:(TextFieldView *)textFiled;

-(void)textFiledRightButtonOnClick:(TextFieldView *)textFiled;

-(void)textFiledTouch:(TextFieldView *)textFiled;

@end

@interface TextFieldView : UIView

-(instancetype)initWithTitile:(NSString *)title placeholder:(NSString *)placeholder;

-(void)resignFirstResponder;
-(void)becomeFirstResponder;
-(void)setRightButton:(UIButton *)rightButton tag:(NSInteger)tag;

@property(nonatomic, copy) NSString * text;
@property(nonatomic, assign) id<TextFieldViewDelegate>delegate;

@property(nonatomic, assign) BOOL secureTextEntry;

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * leftView;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, assign) TextFieldViewType textFieldViewType;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * placeholder;
@property (nonatomic, assign) CGFloat titleWidth;
@property (nonatomic, strong) UIButton * rightButton;

@property (nonatomic, assign) NSInteger maxlength;

@property(nonatomic) UIKeyboardType keyboardType;

@end
