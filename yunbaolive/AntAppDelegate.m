#import "AntAppDelegate.h"//
/******shark sdk *********/
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
/******shark sdk  end*********/
//腾讯bug监控
#import <Bugly/Bugly.h>
#import "AntLoginTypeVC.h"
#import "AntTabBarController.h"
#import <FBSDKMessengerShareKit/FBSDKMessengerSharer.h>
#import <Twitter/Twitter.h>
#import "IQKeyboardManager.h"
@import CoreLocation;
@interface AntAppDelegate ()<CLLocationManagerDelegate,JMessageDelegate>
{
    CLLocationManager   *_lbsManager;
}
@property(nonatomic,strong)NSArray *scrollarrays;//轮播
@end
@implementation AntAppDelegate
{
    NSNotification * sendEmccBack;
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
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //获取当前设备语言
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    NSLog(@"当前语言为===%@",languageName);

    //app 保持当前语言,默认柬埔寨文
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLanguage]);
    if (![[NSUserDefaults standardUserDefaults] objectForKey:CurrentLanguage]) {
        if ([languageName isEqual:@"zh-Hans-CN"]) {
            [[NSUserDefaults standardUserDefaults] setObject:ZW forKey:CurrentLanguage];
        }else if ([languageName rangeOfString:@"km"].location!=NSNotFound){
            [[NSUserDefaults standardUserDefaults] setObject:KH forKey:CurrentLanguage];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:EN forKey:CurrentLanguage];
        }
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[RookieTools shareInstance] resetLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLanguage] withFrom:@"appdelegate"];
    
    [[SDWebImageManager sharedManager].imageDownloader setValue: nil forHTTPHeaderField:@"Accept"];
    [Bugly startWithAppId:BuglyId];
    self.window = [[UIWindow alloc]initWithFrame:CGRectMake(0,0,_window_width, _window_height)];
    [self antLiveStartlocation];
    [self shareSDKRegist];
    //后台运行定时器
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.shouldShowToolbarPlaceholder = NO; // 不显示占位文字
    keyboardManager.shouldResignOnTouchOutside = YES;
    
    if ([Config getOwnID]) {
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[AntTabBarController alloc] init]];
        [self.window makeKeyAndVisible];
    }
    else{
        AntLoginTypeVC *login = [[AntLoginTypeVC alloc]init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:login];
        [self.window makeKeyAndVisible];
    }
    
    
    
    //推送
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    //集成 极光IM
    [JMessage setupJMessage:launchOptions appKey:JMessageAppKey channel:nil apsForProduction:isProduction category:nil messageRoaming:NO];

    if ([Config getOwnID]) {
        NSString *aliasStr = [NSString stringWithFormat:@"%@PUSH",[Config getOwnID]];
        [JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
        [JPUSHService setupWithOption:launchOptions appKey:JMessageAppKey
                              channel:@"Publish channel"
                     apsForProduction:isProduction
                advertisingIdentifier:nil];
        [JMSGUser loginWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,[Config getOwnID]] password:aliasStr completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                NSLog(@"appdelegate-极光IM登录成功");
            } else {
                NSLog(@"appdelegate-极光IM登录失败");
            }
        }];
    }
    [JMessage resetBadge];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }

    //InstallUncaughtExceptionHandler();
    return YES;
}
-(void)antLiveStartlocation{
    if (!_lbsManager) {
        _lbsManager = [[CLLocationManager alloc] init];
        [_lbsManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _lbsManager.delegate = self;
        // 兼容iOS8定位
        SEL requestSelector = NSSelectorFromString(@"requestWhenInUseAuthorization");
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined && [_lbsManager respondsToSelector:requestSelector]) {
            [_lbsManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
        } else {
            [_lbsManager startUpdatingLocation];
        }
    }
}
-(void)shareSDKRegist{
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeMail),
                                        @(SSDKPlatformTypeSMS),
                                        @(SSDKPlatformTypeCopy),
                                        @(SSDKPlatformTypeQQ),
                                        @(SSDKPlatformTypeRenren),
                                        @(SSDKPlatformTypeFacebook),
                                        @(SSDKPlatformTypeTwitter),
                                        @(SSDKPlatformTypeGooglePlus),
                                        ] onImport:^(SSDKPlatformType platformType) {
                                            switch (platformType)
                                            {
                                                case SSDKPlatformTypeFacebook:
                                                    [ShareSDKConnector connectFacebookMessenger:[FBSDKMessengerSharer class]];
                                                    break;
                                                case SSDKPlatformTypeFacebookMessenger:
                                                    [ShareSDKConnector connectFacebookMessenger:[FBSDKMessengerSharer class]];
                                                    break;
                                                    
                                                case SSDKPlatformTypeQQ:
                                                    [ShareSDKConnector connectQQ:[QQApiInterface class]
                                                               tencentOAuthClass:[TencentOAuth class]];
                                                    break;
                                                case SSDKPlatformTypeTwitter:
                                                    break;
                                                default:
                                                    break;
                                            }
                                        } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                            switch (platformType)
                                            {
                                                case SSDKPlatformTypeQQ:
                                                    [appInfo SSDKSetupQQByAppId:QQAppId
                                                                         appKey:QQAppKey
                                                                       authType:SSDKAuthTypeBoth];
                                                    break;
                                                case SSDKPlatformTypeFacebook:
                                    [appInfo SSDKSetupFacebookByApiKey:FacebookApiKey
                                                                appSecret:FacebookAppSecret
                                                                           displayName: @"AntLive"
                                                                              authType:SSDKAuthTypeBoth];
                                                    break;
                                                case SSDKPlatformTypeTwitter:
                                                    [appInfo SSDKSetupTwitterByConsumerKey:TwitterKey consumerSecret:TwitterSecret redirectUri:TwitterRedirectUri];
                                                    break;
                                                default:
                                                    break;
                                            }
                                        }];
}
//杀进程
- (void)applicationWillTerminate:(UIApplication *)application{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shajincheng" object:nil];
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
     [JMessage registerDeviceToken:deviceToken];
     [JPUSHService registerDeviceToken:deviceToken];
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
    [JMessage resetBadge];
     [JPUSHService setBadge:0];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application cancelAllLocalNotifications];
     [JMessage resetBadge];
     [JPUSHService setBadge:0];
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    [JMessage resetBadge];
}
#pragma mark --- 支付宝接入
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return YES;
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return YES;
}
@end
