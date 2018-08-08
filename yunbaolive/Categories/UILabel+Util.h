//
//  UILabel+Util.h
//  yunbaolive
//
//  Created by 毅力起 on 2018/8/7.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Util)

-(instancetype)initWithFont:(CGFloat)font;

-(instancetype)initWithFont:(CGFloat)font text:(NSString *)text;

-(instancetype)initWithFont:(CGFloat)font textColor:(UIColor *)textColor;

-(instancetype)initWithFont:(CGFloat)font textAliahment:(NSTextAlignment)alignment text:(NSString *)text;

-(instancetype)initWithTextColor:(UIColor *)color font:(CGFloat)font textAliahment:(NSTextAlignment)alignment text:(NSString *)text;/*UILabel分类*/

-(instancetype)initLineColor:(UIColor *)color;

- (void)setupTextAttributesTextFont:(CGFloat)font textColor:(UIColor *)color atRange:(NSRange)range; /**< 富文本的颜色字体 */

/**获取label高度*/
-(CGSize)setSizeWithMaxSize:(CGSize)maxSize;
/**获取设置行间距*/
-(void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing;
/**设置带下划线的字*/
-(void)setUnderLineText:(NSString *)usderLineText;
/**添加一个tap手势*/
-(void)addTapGestureWithTarget:(id)target selector:(SEL)selector tag:(NSInteger)tag;

@end
