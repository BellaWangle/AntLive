//
//  cityDefault.h
//  yunbaolive
//
//  Created by 王敏欣 on 2016/12/13.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userLocation.h"
@interface locationCache : NSObject



+ (void)saveProfile:(userLocation *)city;
+ (void)clearProfile;
+(void) updateProfile:(userLocation *)city;
+ (userLocation *)myProfile;
+(NSString *)getMyCity;
+(NSString *)getMylng;
+(NSString *)getMylat;
+(NSString *)getaddr;


//判断第一次登陆
+(void)saveisreg:(NSString *)isregs;
+(NSString *)getreg;
@end
