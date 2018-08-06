//
//  YBPullData.h
//  YBmyth
//
//  Created by YunBao on 2018/1/18.
//  Copyright © 2018年 Rookie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PullSuccessBlock)(id data, id code, id msg);
typedef void (^PullFailBlock)(id fail);

@interface YBPullData : NSObject


/**
 网络封装
 @param url 接口名称
 @param dic 接口参数dic
 @param sucBack 成功回调
 @param failBack 失败回调
 */
+(void)pullWithUrl:(NSString *)url Dic:(NSDictionary *)dic Suc:(PullSuccessBlock)sucBack Fail:(PullFailBlock)failBack;

@end
