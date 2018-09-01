//
//  YBNavi.h
//  WaWaJiClient
//
//  Created by Rookie on 2017/11/19.
//  Copyright © 2017年 zego. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^btnBlock)(id btnBack);

@interface AntNavi : UIView
//注意！！！ H5标题专用

@property (nonatomic,strong) UILabel *H5TL;

//注意！！！没有左右返回键一定设置 hidden = YES
@property (nonatomic,assign) BOOL leftHidden;
@property (nonatomic,assign) BOOL rightHidden;

/** 中间标题 */
-(void)ybNaviLeftName:(NSString *)imgL andLeft:(btnBlock)leftBtn andRightName:(NSString *)imgN andRight:(btnBlock)rightBtn andMidTitle:(NSString *)midTitle;

/** 中间图片 */
-(void)ybNaviLeftName:(NSString *)imgL andLeft:(btnBlock)leftBtn andRightName:(NSString *)imgN andRight:(btnBlock)rightBtn andMidImg:(NSString *)imgName;

@end
