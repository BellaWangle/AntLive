//
//  ZYTabBarController.m
//  tabbar增加弹出bar
//
//  Created by tarena on 16/7/2.
//  Copyright © 2016年 张永强. All rights reserved.
//
#import "ZYTabBarController.h"
#import "ZYTabBar.h"
#import "startplay.h"
#import "homepageController.h"
#import "YBUserInfoViewController.h"
#import "NearVC.h"
#import "RankVC.h"
#import "LiveOrDynamicView.h"
#import "VideoRecordViewController.h"

@interface ZYTabBarController ()<ZYTabBarDelegate,UIAlertViewDelegate>
{
    UIAlertView *alertupdate;
    LiveOrDynamicView *startWhich;

}
@property(nonatomic,strong)NSString *Build;
@end
@implementation ZYTabBarController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self buildUpdate];
    //设置子视图
    [self setUpAllChildVc];
    [self configureMXtabbar];
}
- (void)configureMXtabbar {
    ZYTabBar *tabBar = [ZYTabBar new];
    tabBar.delegate = self;
    tabBar.backgroundColor = [UIColor whiteColor];
    [self setValue:tabBar forKeyPath:@"tabBar"];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
#pragma mark  在这里更换 左右tabbar的image
- (void)setUpAllChildVc {    
    
    //首页
    homepageController *v3 = [[homepageController alloc]init];
    
    //附近
    NearVC *nVC = [[NearVC alloc]init];
    
    //排行
    RankVC *rVC = [[RankVC alloc]init];
    
    //我的
    YBUserInfoViewController *userInfo = [YBUserInfoViewController new];
    
    [self setUpOneChildVcWithVc:v3 Image:@"tab_home" selectedImage:@"tab_home_sel" title:nil];
    [self setUpOneChildVcWithVc:nVC Image:@"tab_near" selectedImage:@"tab_near_sel" title:nil];
    [self setUpOneChildVcWithVc:rVC Image:@"tab_rank" selectedImage:@"tab_rank_sel" title:nil];
    [self setUpOneChildVcWithVc:userInfo Image:@"tab_mine" selectedImage:@"tab_mine_sel" title:nil];
}
#pragma mark - 初始化设置tabBar上面单个按钮的方法
/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Vc];
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.selectedImage = mySelectedImage;
    Vc.tabBarItem.title = title;
    Vc.navigationItem.title = title;
    [self addChildViewController:nav];
}
//点击开始直播
- (void)pathButton:(MXtabbar *)MXtabbar clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
//    startplay *start = [[startplay alloc]init];
////   [self presentViewController:start animated:YES completion:nil];
//    [[MXBADelegate sharedAppDelegate] pushViewController:start animated:YES];
    if (startWhich) {
        [startWhich removeFromSuperview];
        startWhich = nil;
    }
    if (!startWhich) {
        startWhich = [[LiveOrDynamicView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height) andLiveBtn:^{
            startplay *start = [[startplay alloc]init];
            [self.navigationController pushViewController:start animated:NO];
            [startWhich removeFromSuperview];
            startWhich = nil;
        } andDynamicBtn:^{
            VideoConfigure *videoConfig = [[VideoConfigure alloc] init];
            videoConfig.videoResolution = VIDEO_RESOLUTION_720_1280;
            VideoRecordViewController *videoRecord = [[VideoRecordViewController alloc]initWithConfigure:videoConfig];
            [self.navigationController pushViewController:videoRecord animated:NO];
            [startWhich removeFromSuperview];
            startWhich = nil;
        } andCancelBtn:^{
            [startWhich removeFromSuperview];
            startWhich = nil;
        }];
        UIWindow *mainwindow = [UIApplication sharedApplication].keyWindow;
        [mainwindow addSubview:startWhich];
    }
}
-(void)buildUpdate{
    
    // 在这里加载后台配置文件
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Home.getConfig"];
    
    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSDictionary *subdic = [[data valueForKey:@"info"] firstObject];
                if (![subdic isEqual:[NSNull null]]) {
                    
                    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                    NSString *ios_shelves = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"ios_shelves"]];
                    //ios_shelves 为上架版本号，与本地一致则为上架版本,需要隐藏一些东西
                    NSNumber *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];//本地 build
                    NSString *build = [NSString stringWithFormat:@"%@",app_build];
                    if (![ios_shelves isEqual:build]) {
                    //  NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];version
                    //  NSLog(@"当前应用软件版本:%@",appCurVersion);
                      NSString *ipa_des = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"ipa_des"]];
                        NSNumber *build = [subdic valueForKey:@"ipa_ver"];//远程
                        NSComparisonResult r = [app_build compare:build];
                        _Build =[NSString stringWithFormat:@"%@",[subdic valueForKey:@"ipa_url"]];
                        if (r == NSOrderedAscending || r == NSOrderedDescending) {//可改为if(r == -1L)
//                            alertupdate = [[UIAlertView alloc]initWithTitle:YZMsg(@"提示") message:minstr(ipa_des) delegate:self cancelButtonTitle:YZMsg(@"使用旧版") otherButtonTitles:YZMsg(@"前往更新"), nil];
//                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                                 [alertupdate show];
//                            });
                        }
                    }
                    else{
                        
                        
                    }
                    NSString *maintain_switch = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"maintain_switch"]];
                    NSString *maintain_tips = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"maintain_tips"]];
                    if ([maintain_switch isEqual:@"1"]) {
                        UIAlertView *alertMaintain = [[UIAlertView alloc]initWithTitle:@"维护信息" message:maintain_tips delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
                        [alertMaintain show];
                    }
                    liveCommon *commons = [[liveCommon alloc]initWithDic:subdic];
                    [common saveProfile:commons];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if (buttonIndex == 0) {
            
            return;
        }
        else{
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_Build]];
            
        }
}
@end
