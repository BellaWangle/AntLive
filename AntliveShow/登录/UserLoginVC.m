//
//  UserLoginVC.m
//  AntliveShow
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
#import "AntButton.h"
#import "UIView+Util.h"

@interface UserLoginVC ()
{
    UIActivityIndicatorView *testActivityIndicator;//菊花
    NSArray *platformsarray;
}

@property(nonatomic,strong)NSString *isreg;

@end

@implementation UserLoginVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [testActivityIndicator stopAnimating]; // 结束旋转
    [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
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

    
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = CGPointMake(_window_width/2 - 10, _window_height/2 - 10);
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
   
    
    
    
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
    [self createSubviews];
}

-(void)createSubviews{
    UIImageView * bgImageView = [[UIImageView alloc]init];
    bgImageView.image = [UIImage imageNamed:@"ic_login_bg"];
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(0);
        make.height.mas_equalTo(bgImageView.mas_width).multipliedBy(2.174);
    }];
    
    AntButton * registerButton = [self buttonWithTitle:YZMsg(@"注册新账号")];
    [registerButton addTarget:self action:@selector(registerButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.height.mas_equalTo(44);
        make.bottom.mas_equalTo(-50);
    }];
    
    UILabel * segmentationLabel = [[UILabel alloc]initWithTextColor:[UIColor whiteColor] font:13 textAliahment:NSTextAlignmentCenter text:YZMsg(@"或")];
    [self.view addSubview:segmentationLabel];
    [segmentationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(13);
        make.bottom.mas_equalTo(registerButton.mas_top).offset(-35);
    }];
    
    UIView * lineView1 = [[UIView alloc]init];
    [self.view addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(segmentationLabel.mas_leading);
        make.height.mas_equalTo(0.5);
        make.centerY.mas_equalTo(segmentationLabel);
    }];
    
    
    UIView * lineView2 = [[UIView alloc]init];
    [self.view addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-20);
        make.leading.mas_equalTo(segmentationLabel.mas_trailing);
        make.height.mas_equalTo(lineView1);
        make.centerY.mas_equalTo(segmentationLabel);
    }];
    
    AntButton * emailLoginButton = [self buttonWithTitle:YZMsg(@"使用电子邮箱登录")];
    [emailLoginButton addTarget:self action:@selector(emailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:emailLoginButton];
    [emailLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.height.mas_equalTo(registerButton);
        make.bottom.mas_equalTo(segmentationLabel.mas_top).offset(-35);
    }];
    
    AntButton * phoneLoginButton = [self buttonWithTitle:YZMsg(@"使用手机号登录")];
    [phoneLoginButton addTarget:self action:@selector(clickPhoneLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneLoginButton];
    [phoneLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.height.mas_equalTo(registerButton);
        make.bottom.mas_equalTo(emailLoginButton.mas_top).offset(-15);
    }];
    
    AntButton * faceBookButton = [[AntButton alloc]init];
    faceBookButton.buttonTitleColor = [UIColor whiteColor];
    faceBookButton.buttonTitleFontSize = 17;
    faceBookButton.layer.cornerRadius = 3;
    faceBookButton.backgroundColor = HexColor(@"3A579D");
    faceBookButton.HorizontalWidth = 6;
    faceBookButton.buttonImageWidth = 20;
    NSString * string = [NSString stringWithFormat:@"facebook %@",YZMsg(@"账号登录")];
    [faceBookButton setTitle:string imageName:@"ic_facebook"];
    
    [faceBookButton addTarget:self action:@selector(faceBookButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:faceBookButton];
    [faceBookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.height.mas_equalTo(registerButton);
        make.bottom.mas_equalTo(phoneLoginButton.mas_top).offset(-15);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [lineView1 layoutIfNeeded];
        [lineView1 gradientWithColors:@[[[UIColor whiteColor]colorWithAlphaComponent:0],[[UIColor whiteColor]colorWithAlphaComponent:1]] starPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];
        [lineView2 layoutIfNeeded];
        [lineView2 gradientWithColors:@[[[UIColor whiteColor]colorWithAlphaComponent:1],[[UIColor whiteColor]colorWithAlphaComponent:0]] starPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];
    });
    
}


-(AntButton *)buttonWithTitle:(NSString *)title{
    AntButton * button = [[AntButton alloc]init];
    button.title = title;
    button.backgroundColor = [UIColor clearColor];
    button.buttonTitleColor = [UIColor whiteColor];
    button.buttonTitleFontSize = 17;
    button.layer.cornerRadius = 3;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 0.5;
    return button;
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

#pragma mark - click -

-(void)registerButtonOnClick{
    hahazhucedeview *regist = [[hahazhucedeview alloc]init];
    regist.isEmail = NO;
    [self.navigationController pushViewController:regist animated:YES];
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

- (void)faceBookButtonOnClick{
    [self login:@"facebook" platforms:SSDKPlatformTypeFacebook];
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
