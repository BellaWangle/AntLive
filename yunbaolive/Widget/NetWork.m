//
//  NetWork.m
//  AntLive
//
//  Created by 毅力起 on 2018/8/27.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "NetWork.h"
#import "MBProgressHUD+MJ.h"


@implementation NetWork


+ (AFHTTPSessionManager *)shareAFNManager{
    
    AFHTTPSessionManager *manager             = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;//请求超时设定
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"image/jpeg",@"text/plain",@"text/xml", nil];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];//请求和返回的为JSON
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;//缓存策略
    manager.securityPolicy.allowInvalidCertificates = YES;//安全策略
    manager.securityPolicy.validatesDomainName      = NO;
    
    return manager;
}

// POST
+ (void)POSTWithURLString:(NSString *)urlString Parameters:(NSDictionary *)parameters HUD:(BOOL)isHud  successBlock:(AFNSuccessBlock)successBlock failure:(AFNFailureBlock)failure{
   
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    if (isHud) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        hud.label.text = @"请稍后...";
        hud.animationType = MBProgressHUDAnimationZoomOut; // MBProgressHUDAnimationFade,
    }
    if (![urlString hasPrefix:purl]) {
        urlString = [NSString stringWithFormat:@"%@%@",purl,urlString];
    }
    
    // 发起请求
    [session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (isHud) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSDictionary *MsgData = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[MsgData valueForKey:@"code"]];
            NSString *msg = [MsgData valueForKey:@"msg"];
            if([code isEqual:@"0"])
            {
                if (successBlock) {
                    successBlock(MsgData, nil);
                }
                
            }
            else {
                if (failure) {
                    if (!failure(code, msg)) {
                        [MBProgressHUD showError:msg];
                    }
                }else{
                    [MBProgressHUD showError:msg];
                }
                
            }
        }
        else{
            [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
            NSString * msg = [responseObject valueForKey:@"msg"];
            NSString * code = [NSString stringWithFormat:@"%@",number];
            if (failure) {
                if (!failure(code, msg)) {
                    [MBProgressHUD showError:msg];
                }
            }else{
                [MBProgressHUD showError:msg];
            }
                              
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败:  %@",error);
        if (isHud) {
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }
        
        if (failure) {
            if (!failure(@"20000", @"网络错误")) {
                [MBProgressHUD showError:@"网络错误"];
            }
        }else{
            [MBProgressHUD showError:@"网络错误"];
        }
        
    }];
}

@end
