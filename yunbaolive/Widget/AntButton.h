//
//  AntButton.h
//  yunbaolive
//
//  Created by 毅力起 on 2018/8/7.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ButtonDirectionType){
    DirectionHorizontalImageLeft,   //横向排列图片居左
    DirectionHorizontalImageRight,  //横向排列图片居右
    DirectionVertical               //纵向排列
};

typedef NS_ENUM(NSInteger, MyButtonType){
    MyButtonTypeNormal,
    MyButtonTypeConfirm             //确认样式
};

@interface AntButton : UIButton

@property (nonatomic, strong) UIView * centerBgView;

@property (nonatomic, assign) CGFloat buttonWidth;
@property (nonatomic, assign) CGFloat buttonHeight;
@property (nonatomic, assign) CGFloat buttonImageWidth;
@property (nonatomic, assign) CGFloat buttonTitleFontSize;
@property (nonatomic, assign) CGFloat verticalHeight;
@property (nonatomic, assign) CGFloat HorizontalWidth;
@property (nonatomic, strong) UIColor * buttonTitleColor;
@property (nonatomic, strong) UIFont * buttonTitleFont;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) UIImage * image;


-(instancetype)initWithDirectionWithType:(ButtonDirectionType)type;
-(instancetype)initWithButtonType:(MyButtonType)type;
-(instancetype)initDefaultButtonWithTitle:(NSString *)title cornerRadius:(CGFloat)cornerRadius;

-(void)setTitle:(NSString *)title imageName:(NSString *)imageName;
-(void)setSelectTitle:(NSString *)title imageName:(NSString *)imageName;

@end
