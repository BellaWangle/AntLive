//
//  UserLoginVC.m
//  yunbaolive
//
//  Created by YunBao on 2018/2/2.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "UserLoginVC.h"
#import "hahazhucedeview.h"
#import <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"
#import "getpasswordview.h"
#import "ZYTabBarController.h"
#import "webH5.h"
#import "PhoneLoginVC.h"

@interface UserLoginVC ()
{
    UIActivityIndicatorView *testActivityIndicator;//菊花
    NSArray *platformsarray;
}
@property(nonatomic,strong)NSString *isreg;
@property (weak, nonatomic) IBOutlet UILabel *logTypeLabel;

@end

@implementation UserLoginVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [testActivityIndicator stopAnimating]; // 结束旋转
    [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
//    [self getLoginThird];
    [self setthirdview];
}
//获取三方登录方式
-(void)getLoginThird{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Home.getLogin"];
    
    [session POST:url parameters:nil
         progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
             NSNumber *number = [responseObject valueForKey:@"ret"] ;
             if([number isEqualToNumber:[NSNumber numberWithInt:200]])
             {
                 NSArray *data = [responseObject valueForKey:@"data"];
                 NSNumber *code = [data valueForKey:@"code"];
                 if([code isEqualToNumber:[NSNumber numberWithInt:0]])
                 {
                     NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                     platformsarray = [info valueForKey:@"login_type"];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self setthirdview];
                     });
                 }
             }
             [testActivityIndicator stopAnimating]; // 结束旋转
             [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
         }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [testActivityIndicator stopAnimating]; // 结束旋转
         [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
     }];
}
//添加登陆方式
-(void)setthirdview{
    //进入此方法钱，清除所有按钮，防止重复添加
    platformsarray = @[@"facebook"];

    for (UIButton *btn in _platformview.subviews) {
        [btn removeFromSuperview];
    }
    //如果返回为空，登陆方式字样隐藏
    if (platformsarray.count == 0) {
        _otherviews.hidden = YES;
    }
    else{
        _otherviews.hidden = NO;
    }
    //注意：此处涉及到精密计算，轻忽随意改动
    CGFloat w = 50;
    CGFloat x;
    CGFloat centerX = _window_width/2;
    if (platformsarray.count % 2 == 0) {
        x =  centerX - platformsarray.count/2*w - (platformsarray.count - 1)*5;
    }
    else{
        x =  centerX - (platformsarray.count - 1)/2*w - w/2 - (platformsarray.count - 1)*5;
    }
    
    for (int i=0; i<platformsarray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.tag = 1000 + i;
        [btn setImage:[UIImage imageNamed:platformsarray[i]] forState:UIControlStateNormal];
        [btn setTitle:platformsarray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(thirdlogin:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(x,0,w,w);
        x+=w+10;
        [_platformview addSubview:btn];
    }
}
//若要添加登陆方式，在此处添加
-(void)thirdlogin:(UIButton *)sender{
    /*
     1 qq
     2 wx
     3 facebook
     4 twitter
     */
    [self.view endEditing:YES];
    int type;
    if ([sender.titleLabel.text isEqual:@"qq"]) {
        type = 1;
    }else if ([sender.titleLabel.text isEqual:@"wx"]) {
        type = 2;
    }else if ([sender.titleLabel.text isEqual:@"facebook"]) {
        type = 3;
    }else if ([sender.titleLabel.text isEqual:@"twitter"]) {
        type = 4;
    }
    
    switch (type) {
        case 1:
            [self login:@"qq" platforms:SSDKPlatformTypeQQ];
            break;
        case 2:
            [self login:@"wx" platforms:SSDKPlatformTypeWechat];
            break;
        case 3:
            [self login:@"facebook" platforms:SSDKPlatformTypeFacebook];
            break;
        case 4:
            [self login:@"twitter" platforms:SSDKPlatformTypeTwitter];
            break;
        default:
            break;
    }
}
-(void)login:(NSString *)types platforms:(SSDKPlatformType)platform{
    [testActivityIndicator startAnimating]; // 开始旋转
    [ShareSDK getUserInfo:platform
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             [self RequestLogin:user LoginType:types];
             
         } else if (state == 2 || state == 3) {
             [testActivityIndicator stopAnimating]; // 结束旋转
             [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
         }
         
     }];
    
}
-(void)forwardGround{
    [testActivityIndicator stopAnimating]; // 结束旋转
    [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
//    platformsarray = @[@"facebook"];
    self.logTypeLabel.text = YZMsg(@"使用以下方式登录");
    
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = CGPointMake(_window_width/2 - 10, _window_height/2 - 10);
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    //手机登录、注册
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:YZMsg(@"手机号登录/注册")];
    NSRange strRange = {0,[str length]};
    [str addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSUnderlineStyleAttributeName,RGB(111, 111, 111), NSForegroundColorAttributeName,nil] range:strRange];
    [_phoneLoginBtn setAttributedTitle:str forState:UIControlStateNormal];
    
    //邮箱登录、注册
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:YZMsg(@"邮箱登录/注册")];
    NSRange strRange2 = {0,[str2 length]};
    [str2 addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSUnderlineStyleAttributeName,RGB(111, 111, 111), NSForegroundColorAttributeName,nil] range:strRange2];
    [_emailBtn setAttributedTitle:str2 forState:UIControlStateNormal];
    //隐私
    _privateBtn.titleLabel.textColor = RGB(111, 111, 111);
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:YZMsg(@"登录即代表你同意《服务和隐私协议》")];
    [attStr addAttribute:NSForegroundColorAttributeName value:RGB(248, 208, 119) range:NSMakeRange([[attStr string] rangeOfString:@"<"].location, ([[attStr string] rangeOfString:@">"].location+1-[[attStr string] rangeOfString:@"<"].location))];
    [_privateBtn setAttributedTitle:attStr forState:0];
    
//    [self setthirdview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forwardGround) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];  //开始监听 防止第一次安装不显示
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status == AFNetworkReachabilityStatusNotReachable) {
//            [self getLoginThird];
            return;
        }else if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable){
            NSLog(@"nonetwork-------");
//            [self getLoginThird];
        }else if ((status == AFNetworkReachabilityStatusReachableViaWWAN)||(status == AFNetworkReachabilityStatusReachableViaWiFi)){
//            [self getLoginThird];
            NSLog(@"wifi-------");
        }
    }];
    
    
    
}
-(void)RequestLogin:(SSDKUser *)user LoginType:(NSString *)LoginType
{
    
    [testActivityIndicator startAnimating]; // 结束旋转
    
    NSString *icon = nil;
    if ([LoginType isEqualToString:@"qq"]) {
        icon = [user.rawData valueForKey:@"figureurl_qq_2"];
    }
    else
    {
        icon = user.icon;
    }
    NSString *unionID;//unionid
    unionID = user.uid;
    if (!icon || !unionID) {
        [testActivityIndicator stopAnimating]; // 结束旋转
        [MBProgressHUD showError:@"未获取到授权，请重试"];
        return;
    }
    
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Login.userLoginByThird"];
    [session POST:url parameters:@{
                                   @"openid":[NSString stringWithFormat:@"%@",unionID],
                                   @"type":[NSString stringWithFormat:@"%@",[self encodeString:LoginType]],
                                   @"nicename":[NSString stringWithFormat:@"%@",[self encodeString:user.nickname]],
                                   @"avatar":[NSString stringWithFormat:@"%@",[self encodeString:icon]],
                                   }
         progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
             NSNumber *number = [responseObject valueForKey:@"ret"] ;
             if([number isEqualToNumber:[NSNumber numberWithInt:200]])
             {
                 NSArray *data = [responseObject valueForKey:@"data"];
                 NSNumber *code = [data valueForKey:@"code"];
                 if([code isEqualToNumber:[NSNumber numberWithInt:0]])
                 {
                     NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                     LiveUser *userInfo = [[LiveUser alloc] initWithDic:info];
                     [Config saveProfile:userInfo];
                     [self LoginJM];
                     //判断第一次登陆
                     NSString *isreg = minstr([info valueForKey:@"isreg"]);
                     _isreg = isreg;
                     [self login];
                 }
                 else{
                     [MBProgressHUD showError:[data valueForKey:@"msg"]];
                 }
             }
             [testActivityIndicator stopAnimating]; // 结束旋转
             [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
         }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [testActivityIndicator stopAnimating]; // 结束旋转
         [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
     }];
}
-(NSString *)getQQunionID:(NSString *)IDID{
    
    //************为了和PC互通，获取QQ的unionID,需要注意的是只有腾讯开放平台的数据打通之后这个接口才有权限访问，不然会报错********
    NSString *url1 = [NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/me?access_token=%@&unionid=1",IDID];
    url1 = [url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSString stringWithContentsOfURL:[NSURL URLWithString:url1] encoding:NSUTF8StringEncoding error:nil];
    NSRange rang1 = [str rangeOfString:@"{"];
    NSString *str2 = [str substringFromIndex:rang1.location];
    NSRange rang2 = [str2 rangeOfString:@")"];
    NSString *str3 = [str2 substringToIndex:rang2.location];
    NSString *str4 = [str3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSData *data = [str4 dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [data JSONValue];
    NSString *unionID = [dic valueForKey:@"unionid"];
    //************为了和PC互通，获取QQ的unionID********
    
    return unionID;
}
-(NSString*)encodeString:(NSString*)unencodedString{
    NSString*encodedString=(NSString*)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}


-(void)LoginJM{
    NSString *aliasStr = [NSString stringWithFormat:@"%@PUSH",[Config getOwnID]];
    [JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
    [JMSGUser registerWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,[Config getOwnID]] password:aliasStr completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            NSLog(@"login-极光IM注册成功");
        } else {
            NSLog(@"login-极光IM注册失败，可能是已经注册过了");
        }
        NSString *aliasStr = [NSString stringWithFormat:@"%@PUSH",[Config getOwnID]];
        [JMSGUser loginWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,[Config getOwnID]] password:aliasStr completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                NSLog(@"login-极光IM登录成功");
            } else {
                NSLog(@"login-极光IM登录失败");
            }
        }];
    }];
}
-(void)login{
    ZYTabBarController *root = [[ZYTabBarController alloc]init];
    [cityDefault saveisreg:_isreg];
    [self.navigationController pushViewController:root animated:YES];
    
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = (AppDelegate*)app.delegate;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
    app2.window.rootViewController = nav;
    
}

- (IBAction)clickPhoneLoginBtn:(UIButton *)sender {
    
    PhoneLoginVC *pVC = [[PhoneLoginVC alloc]initWithNibName:@"PhoneLoginVC" bundle:nil];
    pVC.isEmail = NO;
    [self.navigationController pushViewController:pVC animated:YES];
}

- (IBAction)clickPrivateBtn:(UIButton *)sender {
    
    webH5 *VC = [[webH5 alloc]init];
    NSString *paths = [h5url stringByAppendingString:@"g=portal&m=page&a=index&id=4"];
    VC.urls = paths;
//    VC.titles = @"服务和隐私条款";
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)emailBtnClick:(id)sender {
    PhoneLoginVC *pVC = [[PhoneLoginVC alloc]initWithNibName:@"PhoneLoginVC" bundle:nil];
    pVC.isEmail = YES;
    [self.navigationController pushViewController:pVC animated:YES];

}

@end
