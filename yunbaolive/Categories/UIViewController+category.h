//
//  UIViewController+category.h
//  AntLive
//
//  Created by 毅力起 on 2018/8/24.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AntLiveNavigationBar.h"

@interface UIViewController (category)<AntLiveNavigationBarDelegate>

/**navigationBar初始化*/
-(AntLiveNavigationBar *)createNavigationBarWithTitle:(NSString *)title;
-(AntLiveNavigationBar *)createNavigationBarWithTitle:(NSString *)title type:(navigationBarType)type;

@end
