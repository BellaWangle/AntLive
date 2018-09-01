//
//  NetWork.h
//  AntLive
//
//  Created by 毅力起 on 2018/8/27.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AFNSuccessBlock)(NSDictionary * responseDic, NSError *error);
typedef BOOL(^AFNFailureBlock)(NSString * code, NSString * msg);

@interface NetWork : NSObject

+ (void)POSTWithURLString:(NSString *)urlString Parameters:(NSDictionary *)parameters HUD:(BOOL)isHud  successBlock:(AFNSuccessBlock)successBlock failure:(AFNFailureBlock)failure;

@end
