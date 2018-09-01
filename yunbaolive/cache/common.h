//
//  common.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/1/18.
//  Copyright © 2017年 cat. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "liveCommon.h"
@interface common : NSObject
+ (void)saveProfile:(liveCommon *)common;
+ (void)clearProfile;
+(liveCommon *)myProfile;
+(NSString *)share_title;
+(NSString *)share_des;
+(NSString *)wx_siteurl;
+(NSString *)ipa_ver;
+(NSString *)app_ios;
+(NSString *)ios_shelves;
+(NSString *)name_coin;
+(NSString *)name_votes;
+(NSString *)enter_tip_level;

+(NSString *)video_share_title;
+(NSString *)video_share_des;

+(NSString *)maintain_switch; //维护开关
+(NSString *)maintain_tips;   //维护内容
+(NSString *)live_pri_switch; //私密房间开关
+(NSString *)live_cha_switch; //收费房间开关
+(NSString *)live_time_switch;//计时收费房间开关
+(NSArray  *)live_time_coin;  //收费阶梯
+(NSArray  *)live_type;       //房间类型
+(NSArray  *)share_type;  //分享类型

+(void)saveagorakitid:(NSString *)agorakitid;//声网ID
+(NSString  *)agorakitid;


//保存个人中心选项缓存
+(void)savepersoncontroller:(NSArray *)arrays;
+(NSArray *)getpersonc;

@end
