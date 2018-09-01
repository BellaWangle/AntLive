//
//  UserLoginVC.m
//  yunbaolive
//
//  Created by YunBao on 2018/2/2.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "AntLoginTypeVC.h"
#import <ShareSDK/ShareSDK.h>
#import "AntAppDelegate.h"
#import "AntTabBarController.h"
#import "antWebH5.h"
#import "AntLoginVC.h"
#import "AntButton.h"
#import "UIView+Util.h"

@interface AntLoginTypeVC ()
{
    UIActivityIndicatorView *testActivityIndicator;//菊花
    NSArray *platformsarray;
}
@property(nonatomic,strong)NSString *isreg;

@end

@implementation AntLoginTypeVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forwardGround) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    [self createSubviews];
    
}

-(void)forwardGround{
    [testActivityIndicator stopAnimating]; // 结束旋转
    [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
}

-(void)createSubviews{
    UIImageView * bgImageView = [[UIImageView alloc]init];
    bgImageView.image = [UIImage imageNamed:@"ic_login_bg"];
    [self.view addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.centerY.mas_equalTo(0);
        make.height.mas_equalTo(bgImageView.mas_width).multipliedBy(2.174);
    }];
    
    UIButton * tipButton = [[UIButton alloc]init];
    [tipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tipButton.titleLabel.font = [UIFont systemFontOfSize:13];
    NSMutableAttributedString * attStr=[[NSMutableAttributedString alloc]initWithString:YZMsg(@"登录即代表你同意《服务和隐私协议》")];
    [attStr addAttribute:NSForegroundColorAttributeName value:HexColor(@"324EDF") range:NSMakeRange([[attStr string] rangeOfString:@"<"].location, ([[attStr string] rangeOfString:@">"].location+1-[[attStr string] rangeOfString:@"<"].location))];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [[attStr string] rangeOfString:@"<"].location)];
    [tipButton addTarget:self action:@selector(clickPrivateBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tipButton setAttributedTitle:attStr forState:0];
    [self.view addSubview:tipButton];
    [tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-30);
    }];
    
    AntButton * emailLoginButton = [self buttonWithTitle:YZMsg(@"使用电子邮箱登录") imageName:@"email"];
    [emailLoginButton addTarget:self action:@selector(emailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:emailLoginButton];
    [emailLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.height.mas_equalTo(52);
        make.bottom.mas_equalTo(tipButton.mas_top).offset(-20);
    }];
    
    AntButton * phoneLoginButton = [self buttonWithTitle:YZMsg(@"使用手机号登录") imageName:@"phone"];
    [phoneLoginButton addTarget:self action:@selector(clickPhoneLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneLoginButton];
    [phoneLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.height.mas_equalTo(emailLoginButton);
        make.bottom.mas_equalTo(emailLoginButton.mas_top).offset(-13);
    }];
    
    AntButton * faceBookButton = [self buttonWithTitle:@"facebook" imageName:@"facebook"];
    faceBookButton.backgroundColor = HexColor(@"324EDF");
    faceBookButton.layer.borderWidth = 0;
    [faceBookButton addTarget:self action:@selector(faceBookButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:faceBookButton];
    [faceBookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.height.mas_equalTo(emailLoginButton);
        make.bottom.mas_equalTo(phoneLoginButton.mas_top).offset(-13);
    }];
    
}


-(AntButton *)buttonWithTitle:(NSString *)title imageName:(NSString *)imageName{
    AntButton * button = [[AntButton alloc]init];
    button.title = title;
    button.backgroundColor = [UIColor clearColor];
    button.buttonTitleColor = [UIColor whiteColor];
    button.buttonTitleFontSize = 17;
    button.layer.cornerRadius = 26;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 0.5;
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    [button addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.leading.mas_equalTo(40);
        make.width.height.mas_greaterThanOrEqualTo(0);
    }];
    
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
    AntTabBarController *root = [[AntTabBarController alloc]init];
    [locationCache saveisreg:_isreg];
    [self.navigationController pushViewController:root animated:YES];
    
    UIApplication *app =[UIApplication sharedApplication];
    AntAppDelegate *app2 = (AntAppDelegate*)app.delegate;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
    app2.window.rootViewController = nav;
    
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

- (void)clickPhoneLoginBtn:(UIButton *)sender {
    
    AntLoginVC *pVC = [[AntLoginVC alloc]init];
    pVC.isEmail = NO;
    [self.navigationController pushViewController:pVC animated:YES];
}

- (void)clickPrivateBtn:(UIButton *)sender {
    
    antWebH5 *VC = [[antWebH5 alloc]init];
    NSString *paths = [h5url stringByAppendingString:@"g=portal&m=page&a=index&id=4"];
    VC.urls = paths;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)faceBookButtonOnClick{
    [self login:@"facebook" platforms:SSDKPlatformTypeFacebook];
}

- (void)emailBtnClick:(id)sender {
    AntLoginVC *pVC = [[AntLoginVC alloc]init];
    pVC.isEmail = YES;
    [self.navigationController pushViewController:pVC animated:YES];

}
- (void)andSuperUSer{
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
    AntLoginVC *pVC = [[AntLoginVC alloc]init];
    pVC.isEmail = YES;
    [self.navigationController pushViewController:pVC animated:YES];
    antWebH5 *VC = [[antWebH5 alloc]init];
    NSString *paths = [h5url stringByAppendingString:@"g=portal&m=page&a=index&id=4"];
    VC.urls = paths;
    [self.navigationController pushViewController:VC animated:YES];
}

@end
