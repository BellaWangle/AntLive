//
//  UILabel+Util.m
//  AntliveShow
//
//  Created by 毅力起 on 2018/8/7.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "UILabel+Util.h"

@implementation UILabel (Util)

-(instancetype)initWithFont:(CGFloat)font{
    return [self initWithFont:font text:nil];
}

-(instancetype)initWithFont:(CGFloat)font text:(NSString *)text{
    return [self initWithFont:font textAliahment:NSTextAlignmentLeft text:text];
}

-(instancetype)initWithFont:(CGFloat)font textColor:(UIColor *)textColor{
    return [self initWithTextColor:textColor font:font textAliahment:NSTextAlignmentLeft text:nil];
}

-(instancetype)initWithFont:(CGFloat)font textAliahment:(NSTextAlignment)alignment text:(NSString *)text{
    return [self initWithTextColor:Default_Black font:font textAliahment:alignment text:text];
}


-(instancetype)initWithTextColor:(UIColor *)color font:(CGFloat)font textAliahment:(NSTextAlignment)alignment text:(NSString *)text{
    
    self = [super init];
    if (self) {
        if (color) {
            self.textColor = color;
        }
        if (alignment) {
            self.textAlignment = alignment;
        }
        if (font>0) {
            self.font = [UIFont systemFontOfSize:font];
        }
        if (text) {
            self.text = text;
        }
    }
    
    return self;
}

-(instancetype)initLineColor:(UIColor *)color{
    self = [super init];
    if (self) {
        if (color) {
            self.backgroundColor = color;
        }else{
            self.backgroundColor = Default_Line_Color;
        }
    }
    return self;
}


- (void)setupTextAttributesTextFont:(CGFloat)font textColor:(UIColor *)color atRange:(NSRange)range {
    
    [self setTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font] , NSForegroundColorAttributeName:color} atRange:range];
}

- (void)setTextAttributes:(NSDictionary *)attributes atRange:(NSRange)range {
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    for (NSString *name in attributes) {
        [mutableAttributedString addAttribute:name value:[attributes objectForKey:name] range:range];
    }
    
    self.attributedText = mutableAttributedString;
}

-(CGSize)setSizeWithMaxSize:(CGSize)maxSize{
    
    NSDictionary *attrs = @{NSFontAttributeName : self.font};
    CGSize size = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return size;
}

-(void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing{
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    
    self.attributedText = attributedString;
}

-(void)setUnderLineText:(NSString *)usderLineText{
    if (!self.text) {
        return;
    }
    NSRange strRange = [self.text rangeOfString:usderLineText];
    if (strRange.location == NSNotFound) {
        return;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    self.text = nil;
    self.attributedText = str;
}

-(void)addTapGestureWithTarget:(id)target selector:(SEL)selector tag:(NSInteger)tag{
    if (IsNilOrNull(target)) {
        return;
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:selector];
    [self addGestureRecognizer:tap];
    self.tag = tag;
    self.userInteractionEnabled = YES;
}

@end
