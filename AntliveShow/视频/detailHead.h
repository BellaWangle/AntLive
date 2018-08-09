//
//  detailHead.h
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/7.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mylabels.h"

typedef void (^commectdetailblock)(id type);

@interface detailHead : UIView

@property(nonatomic,copy)commectdetailblock commentblock;

-(void)justdoit:(NSDictionary *)dic comment:(commectdetailblock)comment;

@property(nonatomic,assign)CGRect contentRect;
@property(nonatomic,strong)UIButton *bigbtn;

@property(nonatomic,strong)UIButton *avatar_Button;//头像
@property(nonatomic,strong)UIButton *zan_Button;//赞
@property(nonatomic,strong)UILabel *nameL;//名称
@property(nonatomic,strong)mylabels *contentL;//回复的内容
@property(nonatomic,strong)UILabel *timeL;//时间
@property(nonatomic,strong)UILabel *allComments;//回复数量
@property(nonatomic,strong)UILabel *lineL;
@property(nonatomic,strong)NSDictionary *hostdic;

@end
