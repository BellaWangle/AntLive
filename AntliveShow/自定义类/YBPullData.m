//
//  YBPullData.m
//  YBmyth
//
//  Created by YunBao on 2018/1/18.
//  Copyright © 2018年 Rookie. All rights reserved.
//

#import "YBPullData.h"

@implementation YBPullData

+(void)pullWithUrl:(NSString *)url Dic:(NSDictionary *)dic Suc:(PullSuccessBlock)sucBack Fail:(PullFailBlock)failBack {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *pullUrl = [purl stringByAppendingFormat:@"service=%@",url];
    [session POST:pullUrl parameters:dic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]]) {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            NSString *msg = [NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]];
            //回调
            sucBack(data,code,msg);
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error)     {
        [MBProgressHUD showError:YZMsg(@"无网络")];
        failBack(error);
    }];
    
}

@end
