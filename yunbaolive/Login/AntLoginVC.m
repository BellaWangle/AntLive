#import "AntLoginVC.h"
#import "registerVC.h"
#import <ShareSDK/ShareSDK.h>
#import "AntAppDelegate.h"
#import "AntForgotPwdVC.h"
#import "AntTabBarController.h"
#import "antWebH5.h"
#import "TextFieldView.h"
#import "NetWork.h"

@interface AntLoginVC ()<TextFieldViewDelegate>

@property(nonatomic,strong)NSString *isreg;

@property (nonatomic, strong) TextFieldView * loginNameTextField;
@property (nonatomic, strong) TextFieldView * passwordTextField;
@property (nonatomic, strong) AntButton * loginButton;

@end
@implementation AntLoginVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    AntLiveNavigationBar * navigationBar = [self createNavigationBarWithTitle:nil];
    navigationBar.bottomline.hidden = YES;
    navigationBar.rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [navigationBar setRightBtnName:[NSString stringWithFormat:@" %@ ",YZMsg(@"忘记密码")]];
    navigationBar.rightButtonClickBlock = ^{
        [self forgetPass];
    };
    
    UILabel * titleLabel = [[UILabel alloc]initWithTextColor:Default_Black font:24 textAliahment:NSTextAlignmentCenter text:YZMsg(@"手机登录")];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(navigationBar.mas_bottom).offset(15);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    _loginNameTextField = [[TextFieldView alloc]initWithTitile:nil placeholder:YZMsg(@"请填写手机号")];
    _loginNameTextField.delegate = self;
    _loginNameTextField.textField.font = [UIFont systemFontOfSize:17];
    _loginNameTextField.textFieldViewType = TextFieldViewType_Login;
    _loginNameTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:_loginNameTextField];
    [_loginNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIGATION_BAR_HEIGHT+95);
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.height.mas_equalTo(35);
    }];
    
    _passwordTextField = [[TextFieldView alloc]initWithTitile:nil placeholder:YZMsg(@"请填写密码")];
    _passwordTextField.delegate = self;
    _passwordTextField.textField.font = [UIFont systemFontOfSize:17];
    _passwordTextField.textFieldViewType = TextFieldViewType_Login;
    _passwordTextField.secureTextEntry = YES;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_loginNameTextField.mas_bottom).offset(35);
        make.leading.trailing.height.mas_equalTo(_loginNameTextField);
    }];
    
    _loginButton = [[AntButton alloc]initConfirmButtonWithTitle:YZMsg(@"登录") cornerRadius:25];
    [_loginButton addTarget:self action:@selector(mobileLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(_loginNameTextField);
        make.top.mas_equalTo(_passwordTextField.mas_bottom).offset(38);
        make.height.mas_equalTo(50);
    }];
    
    UILabel * label = [[UILabel alloc]initWithTextColor:Default_Gray font:13 textAliahment:NSTextAlignmentCenter text:[NSString stringWithFormat:@"%@?%@",YZMsg(@"还没有账号"),YZMsg(@"立即注册")]];
    [label setupTextAttributesTextFont:13 textColor:Main_Color atRange:[label.text rangeOfString:YZMsg(@"立即注册")]];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_greaterThanOrEqualTo(0);
        make.top.mas_equalTo(_loginButton.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
    }];
    
    UIButton * registerButton = [[UIButton alloc]init];
    [registerButton addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.mas_equalTo(label);
    }];
    
    if (_isEmail) {
        titleLabel.text = YZMsg(@"邮箱登录");
        _loginNameTextField.placeholder = YZMsg(@"请填写邮箱账号");
        _loginNameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    }
}
-(void)textFiledDidChange:(TextFieldView *)textFiled {
    _loginButton.selected = !IsEmptyStr(_loginNameTextField.text) && !IsEmptyStr(_passwordTextField.text);
}

- (void)mobileLogin:(id)sender {
    if (_isEmail){
        if (![self isEmailAddress:_loginNameTextField.text]) {
            [MBProgressHUD showError:YZMsg(@"请输入正确的邮箱")];
            return;
        }
    }
    
    NSDictionary *Login = @{
                            @"user_login":_loginNameTextField.text,
                            @"user_pass":_passwordTextField.text
                            };
    [NetWork POSTWithURLString:@"service=Login.userLogin" Parameters:Login HUD:YES successBlock:^(NSDictionary *responseDic, NSError *error) {
        NSDictionary *info = [[responseDic valueForKey:@"info"] objectAtIndex:0];
        LiveUser *userInfo = [[LiveUser alloc] initWithDic:info];
        [Config saveProfile:userInfo];
        [self LoginJM];
        self.navigationController.navigationBarHidden = YES;
        //判断第一次登陆
        NSString *isreg = minstr([info valueForKey:@"isreg"]);
        _isreg = isreg;
        [self login];
    } failure:nil];

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
    AntAppDelegate *app2 = (AntAppDelegate *)app.delegate;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
    app2.window.rootViewController = nav;
    
}
- (void)regist{
    registerVC *regist = [[registerVC alloc]init];
    regist.isEmail = _isEmail;
    [self.navigationController pushViewController:regist animated:YES];
}
- (void)forgetPass{
    registerVC *regist = [[registerVC alloc]init];
    regist.isEmail = _isEmail;
    regist.isFoget = YES;
    [self.navigationController pushViewController:regist animated:YES];
}

- (BOOL)isEmailAddress:(NSString *)email{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [predicate evaluateWithObject:email];
    return isValid;
}


@end
