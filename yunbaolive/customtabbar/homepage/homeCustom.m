#import "homeCustom.h"
#import "AntHotpage.h"
#import "AntNewestVC.h"
#import "searchVC.h"
#import "messageC.h"
#import "Loginbonus.h"  //每天第一次登录
#import "myVideoV.h"

@import CoreLocation;
@interface homeCustom ()<CLLocationManagerDelegate,FirstLogDelegate,JMessageDelegate>
{
    CLLocationManager   *_lbsManager;
    /********* firstLV -> ************/
    Loginbonus *firstLV;
    NSString *bonus_switch;
    NSString *bonus_day;
    NSArray  *bonus_list;
    NSMutableArray  *coins;
    NSMutableArray  *days;
    //测试用变量
    NSString *testDay;//仅仅测试用（已注释）
    /********* <- firstLV ************/
}
@property(nonatomic,strong)NSArray *infoArrays;
@end
@implementation homeCustom
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUnreadNums];
}

-(void)viewDidAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)getUnreadNums{
    [self labeiHid];
}
-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    //显示消息数量
    [self labeiHid];
}
-(void)onUnreadChanged:(NSUInteger)newCount{
    [self labeiHid];
}
-(void)labeiHid{
    unRead = [[JMSGConversation getAllUnreadCount] intValue];
    label.text = [NSString stringWithFormat:@"%d",unRead];
    if ([label.text isEqual:@"0"]) {
        label.hidden =YES;
    }else{
        label.hidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // 支持定位才开启lbs
    if (!_lbsManager)
    {
        _lbsManager = [[CLLocationManager alloc] init];
        [_lbsManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _lbsManager.delegate = self;
        // 兼容iOS8定位
        SEL requestSelector = NSSelectorFromString(@"requestWhenInUseAuthorization");
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined && [_lbsManager respondsToSelector:requestSelector]) {
            [_lbsManager requestWhenInUseAuthorization];//调用了这句,就会弹出允许框了.
        } else {
            [_lbsManager startUpdatingLocation];
        }
    }
    self.adjustStatusBarHeight = NO;
    self.cellSpacing = 8;
    self.infoArrays = [NSArray arrayWithObjects:YZMsg(@"关注"),YZMsg(@"热门"),YZMsg(@"最新"),YZMsg(@"视频"),nil];
    [self setBarStyle:TYPagerBarStyleNoneView];
    [self setContentFrame];
    [self setNaviView];
    self.view.backgroundColor = [UIColor whiteColor];
    //获取所有未读消息
    [JMessage addDelegate:self withConversation:nil];
    [self getUnreadNums];
}
-(void)setNaviView{
    //每天第一次登录
    [self pullInternet];
    //登录奖励后台回到前台
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIApplicationWillEnterForegroundNotification
                                                 object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    AntLiveNavigationBar * navigationBar = [self createNavigationBarWithTitle:nil type:NavigationBarTypeGradual];
    [navigationBar setBackImageName:@"icon_search"];
    [navigationBar setRightImageName:@"ic_message"];
    
    navigationBar.backButtonClickBlock = ^BOOL{
        [self searchBtnClick];
        return YES;
    };
    
    navigationBar.rightButtonClickBlock = ^{
        [self sixinBtnClick];
    };
    
    self.collectionViewBar.backgroundColor = [UIColor clearColor];
    [self.pagerBarView addSubview:navigationBar];
    [self.pagerBarView sendSubviewToBack:navigationBar];
    
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(12, -8, 16, 16)];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8;
    label.hidden = YES;
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    label.text = [NSString stringWithFormat:@"%d",unRead];
    label.textAlignment = NSTextAlignmentCenter;
    [navigationBar.rightImageView addSubview:label];
}
/**********************每天第一次登录-->>**********************/
-(void)pullInternet {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.Bonus"];
    NSDictionary *dic = @{@"uid":[Config getOwnID],
                          @"token":[Config getOwnToken]
                          };
    [session POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if ([number isEqual:@200]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if ([code isEqual:@0]) {
                NSArray *infos = [data valueForKey:@"info"];
                bonus_switch = [NSString stringWithFormat:@"%@",[[infos lastObject] valueForKey:@"bonus_switch"]];
                bonus_day = [[infos lastObject] valueForKey:@"bonus_day"];
                bonus_list = [[infos lastObject] valueForKey:@"bonus_list"];
                
                //测试
                //bonus_day = testDay;
                
                int day = [bonus_day intValue];
                
                if ([bonus_switch isEqual:@"1"] && day > 0 ) {
                    
                    [self firstLog];
        
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)onAppWillEnterForeground:(UIApplication*)app {
    //firstLV不存在 (避免一整天不杀进程第二天登录无奖励)
    //这里加uid判断或者把网络请求改为get请求
    NSString *uid = [Config getOwnID];
    if (!firstLV && uid) {
        [self pullInternet];
    }
}
-(void)firstLog{
    
    firstLV = [[Loginbonus alloc]initWithFrame:CGRectMake(_window_width*0.1, -_window_height*0.9 - 50, _window_width*0.8, _window_height*0.6)AndNSArray:bonus_list AndDay:bonus_day];
    firstLV.delegate = self;
    firstLV.layer.cornerRadius = 5;
    firstLV.layer.masksToBounds = YES;
    [self.view addSubview:firstLV];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.8 animations:^{
                firstLV.frame = CGRectMake(_window_width*0.1, _window_height*0.2, _window_width*0.8, _window_height*0.6);
            }];
        });
    });
}
#pragma mark - 代理  动画结束释放空视图
-(void)removeView:(NSDictionary*)dic{
    
    CGFloat x = [[dic valueForKey:@"x"]floatValue];
    CGFloat y = [[dic valueForKey:@"y"]floatValue];
    CGFloat w = [[dic valueForKey:@"w"]floatValue];
    CGFloat h = [[dic valueForKey:@"h"]floatValue];
    
    //奖励数量
    UIImageView *bonusIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banner"]];
    bonusIV.center = CGPointMake(self.view.center.x, self.view.center.y+w);
    UILabel *bonusL = [[UILabel alloc]init];
    //bonusL.backgroundColor = [UIColor orangeColor];
    bonusL.frame = bonusIV.frame;
    bonusL.center = CGPointMake(self.view.center.x, self.view.center.y+w-5);
    bonusL.textAlignment = NSTextAlignmentCenter;
    int day = [bonus_day intValue];
    NSDictionary *selDic = bonus_list[day-1];
    bonusL.text = [selDic valueForKey:@"coin"];
    bonusL.textColor = [UIColor whiteColor];
    [self.view addSubview:bonusIV];
    [self.view addSubview:bonusL];
    
    UIImage *image = [dic valueForKey:@"image"];
    //添加动画
    UIImageView *animationIV=[[UIImageView alloc]initWithFrame:CGRectMake(x+_window_width*0.1, y+_window_height*0.2, w, h)];
    animationIV.image = image;
    [self.view addSubview:animationIV];
    [UIView animateWithDuration:1.0 animations:^{
        //移到屏幕中心位置
        animationIV.frame=CGRectMake(_window_width/2-animationIV.size.width, _window_height/2-animationIV.size.height, animationIV.size.width*1.5,animationIV.size.height*1.5);
        animationIV.transform = CGAffineTransformRotate(animationIV.transform, M_1_PI);
    } completion:^(BOOL finished) {
        animationIV.image = [UIImage imageNamed:@"star2"];
        [UIView animateWithDuration:0.8 animations:^{
            animationIV.frame = CGRectMake(_window_width*0.8, _window_height*0.95, animationIV.size.width/5, animationIV.size.height/5);
        }];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.8 animations:^{
            firstLV.frame = CGRectMake(_window_width*0.1, _window_height*1.2, _window_width*0.8, _window_height*0.6);
        }];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [bonusL removeFromSuperview];
        [bonusIV removeFromSuperview];
        [animationIV removeFromSuperview];
        [firstLV removeFromSuperview];
        firstLV = nil;
    });
    
    //测试
    //testDay = @"0";
    
    
}
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                  name:UIApplicationWillEnterForegroundNotification
                object:nil];
}
/**********************<<--每天第一次登录**********************/
-(void)sixinBtnClick{
    messageC *messageVC = [[messageC alloc]init];
    [[MXBADelegate sharedAppDelegate]pushViewController:messageVC animated:YES];
}
-(void)searchBtnClick{
    searchVC *seaVC = [[searchVC alloc]init];
    [[MXBADelegate sharedAppDelegate]pushViewController:seaVC animated:YES];
}
#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController
{
    return self.infoArrays.count;
}
- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index
{
    return self.infoArrays[index];
}
- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index
{
    if (index == 0) {
        AntHotpage *followView= [[AntHotpage alloc]init];
        followView.url = @"Home.getFollow";
        return followView;
    }
    else if(index == 1){
//        AntHotpage *hotView= [[AntHotpage alloc]init];
//        hotView.url = @"Home.getHot";
//
//
//        return hotView;
        
        AntNewestVC *newView= [[AntNewestVC alloc]init];
        NSString *url = [purl stringByAppendingFormat:@"service=Home.getHot"];
        newView.url = url;
        newView.isHot = YES;
        return newView;
    }else if(index == 2){
        AntNewestVC *newView= [[AntNewestVC alloc]init];
        NSString *url = [purl stringByAppendingFormat:@"service=Home.getNew&lng=%@&lat=%@",[locationCache getMylng],[locationCache getMylat]];
        
        newView.url = url;
//        newView.type = 1;
        return newView;
    }
    else  {
        myVideoV *videoVC= [[myVideoV alloc]init];
        videoVC.ismyvideo = 0;
        NSString *url = [purl stringByAppendingFormat:@"service=Video.getVideoList&uid=%@",[Config getOwnID]];
        videoVC.url = url;
        return videoVC;
    }
}
#pragma mark - override delegate
- (void)pagerController:(TYTabPagerController *)pagerController configreCell:(MXTabCell *)cell forItemTitle:(NSString *)title atIndexPath:(NSIndexPath *)indexPath
{
   [super pagerController:pagerController configreCell:cell forItemTitle:title atIndexPath:indexPath];
}
- (void)stopLbs {
    [_lbsManager stopUpdatingHeading];
    _lbsManager.delegate = nil;
    _lbsManager = nil;
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        [self stopLbs];
        
    } else {
        [_lbsManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self stopLbs];

}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocatioin = locations[0];
    userLocation *cityU = [locationCache myProfile];
    cityU.lat = [NSString stringWithFormat:@"%f",newLocatioin.coordinate.latitude];
    cityU.lng = [NSString stringWithFormat:@"%f",newLocatioin.coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocatioin completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error)
        {
            CLPlacemark *placeMark = placemarks[0];
            NSString *city      = placeMark.locality;
            NSString *addr = [NSString stringWithFormat:@"%@%@%@%@%@",placeMark.country,placeMark.administrativeArea,placeMark.locality,placeMark.subLocality,placeMark.thoroughfare];
            LiveUser *user = [Config myProfile];
            user.city = city;
            cityU.addr = addr;
            [Config updateProfile:user];
            cityU.city = city;
            [locationCache saveProfile:cityU];
        }
    }];
    [self stopLbs];
}
@end
