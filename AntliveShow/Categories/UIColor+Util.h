//
//  UIColor+Util.h
//  iosapp
//
//  Created by chenhaoxiang on 14-10-18.
//  Copyright (c) 2014年 oschina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexValue;

//+ (UIColor *)themeColor;
//+ (UIColor *)nameColor;
//+ (UIColor *)titleColor;
//+ (UIColor *)separatorColor;
//+ (UIColor *)cellsColor;
//+ (UIColor *)titleBarColor;
//+ (UIColor *)selectTitleBarColor;
//+ (UIColor *)navigationbarColor;
//+ (UIColor *)selectCellSColor;
//+ (UIColor *)labelTextColor;
//+ (UIColor *)teamButtonColor;

//+ (UIColor *)infosBackViewColor;
//+ (UIColor *)lineColor;

//+ (UIColor *)contentTextColor;
//+ (UIColor *)borderColor;
//+ (UIColor *)refreshControlColor;


@end
