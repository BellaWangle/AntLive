//
//  UIView+Util.h
//  yunbaolive
//
//  Created by 毅力起 on 2018/8/7.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Util)

-(CAGradientLayer *)gradientWithColors:(NSArray *)colors;
-(CAGradientLayer *)gradientWithColors:(NSArray *)colors starPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

-(UILabel *)addBottomLineWithHeight:(CGFloat)height color:(UIColor *)color;
-(UILabel *)addBottomLineWithHeight:(CGFloat)height color:(UIColor *)color leading:(CGFloat)leading;
-(UILabel *)addBottomLineWithHeight:(CGFloat)height color:(UIColor *)color leading:(CGFloat)leading trailing:(CGFloat)trailing;

@end
