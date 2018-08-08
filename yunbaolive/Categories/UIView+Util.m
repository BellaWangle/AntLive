//
//  UIView+Util.m
//  yunbaolive
//
//  Created by 毅力起 on 2018/8/7.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "UIView+Util.h"

@implementation UIView (Util)

-(CAGradientLayer *)gradientWithColors:(NSArray *)colors{
    return [self gradientWithColors:colors starPoint:CGPointMake(1, 0) endPoint:CGPointMake(1, 1)];
}

-(CAGradientLayer *)gradientWithColors:(NSArray *)colors starPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    if (IsEmptyList(colors)) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    
    NSMutableArray * cgColors = [NSMutableArray arrayWithCapacity:colors.count];
    
    for (UIColor * color in colors) {
        [cgColors addObject:(__bridge id)color.CGColor];
    }
    
    gradientLayer.colors = cgColors;
    
    gradientLayer.startPoint = startPoint;
    
    gradientLayer.endPoint = endPoint;
    
    gradientLayer.frame = self.bounds;
    
    [self.layer addSublayer:gradientLayer];
    return gradientLayer;
}

-(UILabel *)addBottomLineWithHeight:(CGFloat)height color:(UIColor *)color{
    return [self addBottomLineWithHeight:height color:color leading:0 trailing:0];
}

-(UILabel *)addBottomLineWithHeight:(CGFloat)height color:(UIColor *)color leading:(CGFloat)leading{
    return [self addBottomLineWithHeight:height color:color leading:leading trailing:0];
}

-(UILabel *)addBottomLineWithHeight:(CGFloat)height color:(UIColor *)color leading:(CGFloat)leading trailing:(CGFloat)trailing{
    UILabel * line = [[UILabel alloc]initLineColor:color];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(leading);
        make.trailing.mas_equalTo(trailing);
        make.height.mas_equalTo(height);
        make.bottom.mas_equalTo(self);
    }];
    return line;
}

@end
