#import "PhoneLoginVC.h"
#import "hahazhucedeview.h"
#import <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"
#import "getpasswordview.h"
#import "ZYTabBarController.h"
#import "webH5.h"
@interface PhoneLoginVC ()<UIPickerViewDelegate,UIPickerViewDataSource> {
    UIActivityIndicatorView *testActivityIndicator;//菊花
    UIView *bottomView;
    NSMutableArray *countryArray;//国家区号
    NSInteger selectIndex;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VIewH;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)NSString *isreg;
@property (weak, nonatomic) IBOutlet UIButton *privateBtn;

- (IBAction)EULA:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *logTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *logBtn;
@property (weak, nonatomic) IBOutlet UIButton *regBtn1;
@property (weak, nonatomic) IBOutlet UIButton *regBtn2;
@property (weak, nonatomic) IBOutlet UIButton *forgotPwdBtn;

@end
@implementation PhoneLoginVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [testActivityIndicator stopAnimating]; // 结束旋转
    [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.VIewH.constant<80) {
        self.VIewH.constant+=statusbarHeight;
    }
    
    self.logTitleLabel.text = YZMsg(@"登录");
    [self.regBtn2 setTitle:YZMsg(@"立即注册") forState:0];
    [self.forgotPwdBtn setTitle:YZMsg(@"忘记密码") forState:0];
    [self.logBtn setTitle:YZMsg(@"立即登录") forState:0];
    _phoneT.placeholder = YZMsg(@"请填写手机号");
    _passWordT.placeholder = YZMsg(@"请填写密码");
    if (_isEmail) {
        _phoneT.placeholder = YZMsg(@"请填写邮箱账号");
        _phoneT.keyboardType = UIKeyboardTypeEmailAddress;
        [self.regBtn1 setTitle:YZMsg(@"手机登录") forState:0];
    }else{
        _phoneT.placeholder = YZMsg(@"请填写手机号");
        _phoneT.keyboardType = UIKeyboardTypeNumberPad;
        [self.regBtn1 setTitle:YZMsg(@"邮箱登录") forState:0];
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeBtnBackground) name:UITextFieldTextDidChangeNotification object:nil];
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = CGPointMake(_window_width/2 - 10, _window_height/2 - 10);
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    
    //隐私
    _privateBtn.titleLabel.textColor = RGB(111, 111, 111);
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:YZMsg(@"登录即代表你同意《服务和隐私协议》")];
    [attStr addAttribute:NSForegroundColorAttributeName value:Main_Color range:NSMakeRange([[attStr string] rangeOfString:@"<"].location, ([[attStr string] rangeOfString:@">"].location+1-[[attStr string] rangeOfString:@"<"].location))];
    [_privateBtn setAttributedTitle:attStr forState:0];
    
    [_phoneT addBottomLineWithHeight:0.5 color:nil];
    [_passWordT addBottomLineWithHeight:0.5 color:nil];
}
-(void)ChangeBtnBackground {
    if (_phoneT.text.length >0 && _passWordT.text.length >0)
    {
        [_doLoginBtn setBackgroundColor:normalColors];
        _doLoginBtn.userInteractionEnabled = YES;
    }
    else
    {
        [_doLoginBtn setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0]];
        _doLoginBtn.userInteractionEnabled = NO;
    }
}

- (IBAction)mobileLogin:(id)sender {
    [self.view endEditing:YES];
    if (_isEmail){
        if (![self isEmailAddress:_phoneT.text]) {
            [MBProgressHUD showError:YZMsg(@"请输入正确的邮箱")];
            return;
        }
    }
    [testActivityIndicator startAnimating]; // 开始旋转
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *str = [purl stringByAppendingFormat:@"service=Login.userLogin"];
    NSDictionary *Login = @{
                            @"user_login":_phoneT.text,
                            @"user_pass":_passWordT.text
                            };
    [session POST:str parameters:Login progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *MsgData = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[MsgData valueForKey:@"code"]];
            NSString *msg = [MsgData valueForKey:@"msg"];
            if([code isEqual:@"0"])
            {
                NSDictionary *info = [[MsgData valueForKey:@"info"] objectAtIndex:0];
                LiveUser *userInfo = [[LiveUser alloc] initWithDic:info];
                [Config saveProfile:userInfo];
                [self LoginJM];
                self.navigationController.navigationBarHidden = YES;
                //判断第一次登陆
                NSString *isreg = minstr([info valueForKey:@"isreg"]);
                _isreg = isreg;
                [self login];
            }
            else {
                [MBProgressHUD showError:msg];
            }
        }
        else{
            [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
        }
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              [testActivityIndicator stopAnimating]; // 结束旋转
              [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
              [MBProgressHUD showError:YZMsg(@"无网络")];
          }];
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
    AppDelegate *app2 = (AppDelegate *)app.delegate;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
    app2.window.rootViewController = nav;
    
}

- (BOOL)isEmailAddress:(NSString *)email{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [predicate evaluateWithObject:email];
    return isValid;
}

- (IBAction)regist:(id)sender {
    hahazhucedeview *regist = [[hahazhucedeview alloc]init];
    regist.isEmail = _isEmail;
    [self.navigationController pushViewController:regist animated:YES];
}
- (IBAction)forgetPass:(id)sender {
    getpasswordview *getpass = [[getpasswordview alloc]init];
    getpass.isEmail = _isEmail;
    [self.navigationController pushViewController:getpass animated:YES];
}

- (IBAction)clickBackBtn:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//键盘的隐藏
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)EULA:(id)sender {
    webH5 *VC = [[webH5 alloc]init];
    NSString *paths = [h5url stringByAppendingString:@"g=portal&m=page&a=index&id=4"];
    VC.urls = paths;
//    VC.titles = @"服务和隐私条款";
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)changeLoginType:(id)sender {
    _isEmail = !_isEmail;
    [_phoneT resignFirstResponder];
    [_passWordT resignFirstResponder];
    if (_isEmail) {
        _phoneT.placeholder = YZMsg(@"请填写邮箱账号");
        _phoneT.keyboardType = UIKeyboardTypeEmailAddress;
        [self.regBtn1 setTitle:YZMsg(@"手机登录") forState:0];
        
    }else{
        _phoneT.placeholder = YZMsg(@"请填写手机号");
        _phoneT.keyboardType = UIKeyboardTypeNumberPad;
        [self.regBtn1 setTitle:YZMsg(@"邮箱登录") forState:0];
    }
}

@end
