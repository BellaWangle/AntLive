//
//  NewestVC.h
//  yunbaolive
//
//  Created by 王敏欣 on 2016/12/24.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "MainListRootViewController.h"
@interface AntNewestVC : MainListRootViewController

@property(nonatomic,copy)NSString *url;

@property(nonatomic,assign)BOOL isHot;

@end
