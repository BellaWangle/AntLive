//
//  shaixuanModel.m
//  yunbaolive
//
//  Created by zqm on 16/4/11.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "shaixuanModel.h"

@implementation shaixuanModel


-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        
        
        self.city = [dic valueForKey:@"province"];
        self.num = [dic valueForKey:@"total"];
        
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    
    return  [[self alloc]initWithDic:dic];
}
@end
