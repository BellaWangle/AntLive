//
//  UIViewController+category.m
//  AntLive
//
//  Created by 毅力起 on 2018/8/24.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "UIViewController+category.h"

@implementation UIViewController (category)

-(AntLiveNavigationBar *)createNavigationBarWithTitle:(NSString *)title{
    return [self createNavigationBarWithTitle:title type:NavigationBarTypeWhite];
}

-(AntLiveNavigationBar *)createNavigationBarWithTitle:(NSString *)title type:(navigationBarType)type{
    AntLiveNavigationBar * navigationBar = [[AntLiveNavigationBar alloc]initWithTitle:title type:type];
    navigationBar.delegate = self;
    [self.view addSubview:navigationBar];
    
    [navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.equalTo(@NAVIGATION_BAR_HEIGHT);
    }];
    
    return navigationBar;
}

-(void)backButtonOnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
