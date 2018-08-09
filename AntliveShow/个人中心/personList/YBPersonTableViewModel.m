//
//  YBPersonTableViewModel.m
//  TCLVBIMDemo
//
//  Created by 王敏欣 on 2016/11/19.
//  Copyright © 2016年 tencent. All rights reserved.
//
#import "YBPersonTableViewModel.h"
@implementation YBPersonTableViewModel
-(instancetype)initWithDic:(NSDictionary *)subdic{
    self = [super init];
    if (self) {
        _avatar = minstr([subdic valueForKey:@"avatar"]);
        _user_nicename = minstr([subdic valueForKey:@"user_nicename"]);
        _sex = minstr([subdic valueForKey:@"sex"]);
        _level = minstr([subdic valueForKey:@"level"]);
        _ID = minstr([subdic valueForKey:@"id"]);
        _fans = minstr([subdic valueForKey:@"fans"]);
        _follows = minstr([subdic valueForKey:@"follows"]);
        _lives = minstr([subdic valueForKey:@"lives"]);
        _level_anchor = minstr([subdic valueForKey:@"level_anchor"]);
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)subdic{
    return [[self alloc]initWithDic:subdic];
}
@end
