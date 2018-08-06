//
//  shaixuanModel.h
//  yunbaolive
//
//  Created by zqm on 16/4/11.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shaixuanModel : NSObject


@property(nonatomic,copy)NSString *city;

@property(nonatomic,assign)NSNumber *num;

-(instancetype)initWithDic:(NSDictionary *)dic;


+(instancetype)modelWithDic:(NSDictionary *)dic;

@end
