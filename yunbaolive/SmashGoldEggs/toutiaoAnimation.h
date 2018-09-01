//
//  toutiaoAnimation.h
//  iphoneLive
//
//  Created by Boom on 2017/6/16.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol toutiaoDelegate <NSObject>

-(void)animationlogin;
- (void)bofangjieshu;
@end

@interface toutiaoAnimation : UIView

@property(nonatomic,assign)id<toutiaoDelegate>delegate;
@property(nonatomic,strong)UIImageView *toutiaoMoveImageV;//进入动画背景
@property(nonatomic,assign)int  isUserMove;// 限制用户进入动画
@property(nonatomic,strong)NSMutableArray *userLogin;//用户进入数组，存放动画
@property (nonatomic,assign)BOOL isDelloc;

-(void)addUserMove:(NSDictionary *)dic;
@end
