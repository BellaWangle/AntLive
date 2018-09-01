#import "registerVC.h"
#import "AntButton.h"
#import "TextFieldView.h"
#import "NetWork.h"
@interface registerVC ()<TextFieldViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSTimer *messsageTimer;
    int messageIssssss;//短信倒计时  60s
    NSMutableArray *countryArray;//国家区号
    NSInteger selectIndex;
}

@property (nonatomic, strong) TextFieldView * loginNameTextField;
@property (nonatomic, strong) TextFieldView * smsCodeTextField;
@property (nonatomic, strong) TextFieldView * passwordTextField1;
@property (nonatomic, strong) TextFieldView * passwordTextField2;
@property (nonatomic, strong) AntButton * registerButton;
@property (nonatomic, strong) AntButton * areaCodeButton;
@property (nonatomic, strong) AntButton * smsCodeButton;

@property (nonatomic, strong) UIView * pickBgView;
@property (nonatomic, strong) UIView * pickContentView;

@end
@implementation registerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubviews];
    [self creatCountry];
    messageIssssss = 60;
    
//    _regTitLabel.text = YZMsg(@"注册");
//    _nameLabel.text = YZMsg(@"账号");
//    _yzmLabel.text = YZMsg(@"验证码");
//    _pwdLabel.text = YZMsg(@"密码");
//    _pwdLabel2.text = YZMsg(@"确认密码");
//    [_yanzhengmaBtn setTitle:YZMsg(@"获取验证码") forState:0];
//    _phoneT.placeholder = YZMsg(@"请填写手机号");
//    _yanzhengmaT.placeholder = YZMsg(@"请输入验证码");
//    _passWordT.placeholder = YZMsg(@"请填写密码");
//    _password2.placeholder = YZMsg(@"请确认密码");
//    [_regBtn setTitle:YZMsg(@"立即注册") forState:0];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(aaaaaa)];
//    //    _nameLabel.userInteractionEnabled = YES;
//    [_nameLabel addGestureRecognizer:tap];
    
//    else{
//        _phoneT.placeholder = YZMsg(@"请填写手机号");
//        _nameLabel.text = @"+855";
//        _nameLabel.userInteractionEnabled = YES;
//        _phoneT.keyboardType = UIKeyboardTypeNumberPad;
//
//    }
    
//    [_phoneT becomeFirstResponder];
    
}

-(void)createSubviews{
    self.view.backgroundColor = [UIColor whiteColor];
    
    AntLiveNavigationBar * navigationBar = [self createNavigationBarWithTitle:nil];
    navigationBar.bottomline.hidden = YES;
    
    UILabel * titleLabel = [[UILabel alloc]initWithTextColor:Default_Black font:24 textAliahment:NSTextAlignmentCenter text:YZMsg(@"注册")];
    if (_isFoget) {
        titleLabel.text = YZMsg(@"忘记密码");
    }
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(navigationBar.mas_bottom).offset(15);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    
    UIView * loginNameLeftView = [[UIView alloc]init];
    loginNameLeftView.frame = CGRectMake(0, 0, 63, 35);
    
    _areaCodeButton = [[AntButton alloc]initWithDirectionWithType:DirectionHorizontalImageRight];
    _areaCodeButton.buttonTitleFontSize = 17;
    _areaCodeButton.HorizontalWidth = 4;
    _areaCodeButton.buttonImageWidth = 10;
    [_areaCodeButton setTitle:@"+855" imageName:@"ic_down"];
    [_areaCodeButton setSelectTitle:@"+855" imageName:@"ic_up"];
    [_areaCodeButton addTarget:self action:@selector(aaaaaa) forControlEvents:UIControlEventTouchUpInside];
    [loginNameLeftView  addSubview:_areaCodeButton];
    _areaCodeButton.frame = CGRectMake(0, 0, 55, 35);
    
    UILabel * lineLabel = [[UILabel alloc]initLineColor:nil];
    [loginNameLeftView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.centerY.mas_equalTo(0);
        make.width.mas_equalTo(0.6);
        make.height.mas_equalTo(25);
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
    
    if (_isEmail) {
        _loginNameTextField.placeholder = YZMsg(@"请填写邮箱账号");
        _areaCodeButton.userInteractionEnabled = NO;
        _areaCodeButton.title = YZMsg(@"邮箱");
        _areaCodeButton.mj_w = 41;
        loginNameLeftView.mj_w = 49;
        _loginNameTextField.keyboardType = UIKeyboardTypeEmailAddress;
        
    }
    
    _loginNameTextField.leftView = loginNameLeftView;
    
    _smsCodeButton = [[AntButton alloc]init];
    _smsCodeButton.buttonTitleFontSize = 17;
    _smsCodeButton.buttonTitleColor = [Main_Color colorWithAlphaComponent:0.3];
    _smsCodeButton.title = @"获取验证码";
    _smsCodeButton.frame = CGRectMake(0, 0, _smsCodeButton.buttonWidth, 35);
    
    _smsCodeTextField = [[TextFieldView alloc]initWithTitile:nil placeholder:YZMsg(@"请输入验证码")];
    _smsCodeTextField.delegate = self;
    _smsCodeTextField.textField.font = [UIFont systemFontOfSize:17];
    _smsCodeTextField.textFieldViewType = TextFieldViewType_Login;
    _smsCodeTextField.keyboardType = UIKeyboardTypePhonePad;
    _smsCodeTextField.rightButton = _smsCodeButton;
    [self.view addSubview:_smsCodeTextField];
    [_smsCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_loginNameTextField.mas_bottom).offset(35);
        make.leading.trailing.height.mas_equalTo(_loginNameTextField);
    }];
    
    _passwordTextField1 = [[TextFieldView alloc]initWithTitile:nil placeholder:YZMsg(@"请填写密码")];
    _passwordTextField1.delegate = self;
    _passwordTextField1.textField.font = [UIFont systemFontOfSize:17];
    _passwordTextField1.textFieldViewType = TextFieldViewType_Login;
    _passwordTextField1.secureTextEntry = YES;
    [self.view addSubview:_passwordTextField1];
    [_passwordTextField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_smsCodeTextField.mas_bottom).offset(35);
        make.leading.trailing.height.mas_equalTo(_loginNameTextField);
    }];
    
    _passwordTextField2 = [[TextFieldView alloc]initWithTitile:nil placeholder:YZMsg(@"请确认密码")];
    _passwordTextField2.delegate = self;
    _passwordTextField2.textField.font = [UIFont systemFontOfSize:17];
    _passwordTextField2.textFieldViewType = TextFieldViewType_Login;
    _passwordTextField2.secureTextEntry = YES;
    [self.view addSubview:_passwordTextField2];
    [_passwordTextField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_passwordTextField1.mas_bottom).offset(35);
        make.leading.trailing.height.mas_equalTo(_loginNameTextField);
    }];
    
    _registerButton = [[AntButton alloc]initConfirmButtonWithTitle:YZMsg(@"立即注册") cornerRadius:25];
    [_registerButton addTarget:self action:@selector(doRegist:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(_loginNameTextField);
        make.top.mas_equalTo(_passwordTextField2.mas_bottom).offset(38);
        make.height.mas_equalTo(50);
    }];
    
    if (_isFoget) {
        _registerButton.title = YZMsg(@"立即找回");
    }
}

-(void)textFiledRightButtonOnClick:(TextFieldView *)textFiled{
    if (textFiled == _smsCodeTextField) {
        [self getYanZheng:nil];
        return;
    }
}

-(void)textFiledDidChange:(TextFieldView *)textFiled{
    _registerButton.selected = !IsEmptyStr(_loginNameTextField.text) && !IsEmptyStr(_smsCodeTextField.text) && !IsEmptyStr(_passwordTextField1.text) && !IsEmptyStr(_passwordTextField2.text);
    if (!IsEmptyStr(_loginNameTextField.text)) {
        _smsCodeButton.buttonTitleColor = Main_Color;
    }else{
        _smsCodeButton.buttonTitleColor = [Main_Color colorWithAlphaComponent:0.3];
    }
}


//获取验证码倒计时
-(void)daojishi{
    _smsCodeButton.title = [NSString stringWithFormat:@"%ds",messageIssssss];
    _smsCodeButton.userInteractionEnabled = NO;
    if (messageIssssss<=0) {
        _smsCodeButton.title = YZMsg(@"获取验证码");
        _smsCodeButton.userInteractionEnabled = YES;
        [messsageTimer invalidate];
        messsageTimer = nil;
        messageIssssss = 60;
    }
    messageIssssss-=1;
}

- (void)doRegist:(id)sender {
    if (_isFoget) {
        [self resetPassword];
        return;
    }
    NSString *userBaseUrl;
    NSDictionary *Reg;
    if (!_isEmail) {
        userBaseUrl = [purl stringByAppendingFormat:@"service=Login.userReg"];
        Reg = @{
                @"user_login":_loginNameTextField.text,
                @"user_pass":_passwordTextField1.text,
                @"user_pass2":_passwordTextField2.text,
                @"code":_smsCodeTextField.text
                };
        
    }else{
        userBaseUrl = [purl stringByAppendingFormat:@"service=Login.userEmailReg"];
        Reg = @{
                @"email":_loginNameTextField.text,
                @"user_pass":_passwordTextField1.text,
                @"user_pass2":_passwordTextField2.text,
                @"code":_smsCodeTextField.text
                };
        
    }
    [NetWork POSTWithURLString:userBaseUrl Parameters:Reg HUD:YES successBlock:^(NSDictionary *responseDic, NSError *error) {
        [MBProgressHUD showSuccess:@"注册成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:nil];
}

-(void)resetPassword{
    NSString *userBaseUrl = [purl stringByAppendingFormat:@"service=User.updateMainPass"];
    NSString *type;
    if (!_isEmail) {
        type = @"1";
    }else{
        type = @"2";
    }
    NSDictionary *FindPass = @{ @"user_login":_loginNameTextField.text,
                               @"pass":_passwordTextField1.text,
                               @"pass2":_passwordTextField2.text,
                               @"code":_smsCodeTextField.text,
                               @"type":type};
    [NetWork POSTWithURLString:userBaseUrl Parameters:FindPass HUD:YES successBlock:^(NSDictionary *responseDic, NSError *error) {
        [MBProgressHUD showSuccess:YZMsg(@"密码重置成功")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:nil];
}

- (void)getYanZheng:(id)sender {
    NSString *url;
    NSDictionary *getcode;
    
    if (_isEmail) {
        if (![self isEmailAddress:_loginNameTextField.text]) {
            [MBProgressHUD showError:YZMsg(@"请输入正确的邮箱")];
            return;
        }
    }else if(IsEmptyStr(_loginNameTextField.text)){
        [MBProgressHUD showError:YZMsg(@"请输入手机号")];
    }
    
    if (_isFoget) {
        if (_isEmail) {
            url = [purl stringByAppendingFormat:@"service=User.getupdateEmailCode"];
            getcode = @{@"email":_loginNameTextField.text,};
            
        }else{
            url = [purl stringByAppendingFormat:@"service=Login.getForgetCode"];
            getcode = @{@"mobile":_loginNameTextField.text,
                        @"country_code":[[countryArray objectAtIndex:selectIndex] valueForKey:@"country_code"]};
        }
    }else{
        if (_isEmail) {
            url = @"service=Login.getEmailCode";
            getcode = @{@"email":_loginNameTextField.text,};
        }else{
            url = @"service=Login.getCode";
            getcode = @{@"mobile":_loginNameTextField.text,
                        @"country_code":[[countryArray objectAtIndex:selectIndex] valueForKey:@"country_code"]};
        }
    }
    
    messageIssssss = 60;
    _smsCodeButton.userInteractionEnabled = NO;
    [NetWork POSTWithURLString:url Parameters:getcode HUD:YES successBlock:^(NSDictionary *responseDic, NSError *error) {
        _smsCodeButton.userInteractionEnabled = YES;
        if (messsageTimer == nil) {
            messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
        }
        [MBProgressHUD showSuccess:YZMsg(@"发送成功")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_smsCodeTextField becomeFirstResponder];
            [MBProgressHUD hideHUD];
        });
    } failure:^BOOL(NSString *code, NSString *msg) {
       _smsCodeButton.userInteractionEnabled = YES;
        return NO;
    }];
}
#pragma mark ================ 国家编号 ===============
- (void)aaaaaa {
    [_loginNameTextField resignFirstResponder];
    [_smsCodeTextField resignFirstResponder];
    [_passwordTextField1 resignFirstResponder];
    [_passwordTextField2 resignFirstResponder];
    _areaCodeButton.selected = YES;
    
    if (!_pickBgView) {
        
        
        _pickBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
        _pickBgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        _pickBgView.alpha = 0;
        [self.view addSubview:_pickBgView];
        
        _pickContentView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height, SCREEN_WIDTH, 200)];
        [_pickBgView addSubview:_pickContentView];
        
        UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 40)];
        titleView.backgroundColor = [UIColor whiteColor];
        [_pickContentView addSubview:titleView];
        
        UIButton *cancleBtn = [UIButton buttonWithType:0];
        cancleBtn.frame = CGRectMake(20, 0, 80, 40);
        cancleBtn.tag = 100;
        [cancleBtn setTitle:YZMsg(@"取消") forState:0];
        [cancleBtn setTitleColor:[UIColor grayColor] forState:0];
        [cancleBtn addTarget:self action:@selector(cancleOrSure:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:cancleBtn];
        UIButton *sureBtn = [UIButton buttonWithType:0];
        sureBtn.frame = CGRectMake(_window_width-100, 0, 80, 40);
        sureBtn.tag = 101;
        [sureBtn setTitle:YZMsg(@"确认") forState:0];
        [sureBtn setTitleColor:[UIColor orangeColor] forState:0];
        [sureBtn addTarget:self action:@selector(cancleOrSure:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:sureBtn];
        
        UIPickerView *pick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, _window_width, 160)];
        pick.backgroundColor = [UIColor whiteColor];
        pick.delegate = self;
        pick.dataSource = self;
        [_pickContentView addSubview:pick];
        
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _pickBgView.alpha = 1;
        _pickContentView.mj_y = SCREEN_HEIGHT - _pickContentView.mj_h;
    }];
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return countryArray.count;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回teams中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentLanguage];
    if ([str isEqualToString:ZW]) {
        return [[countryArray objectAtIndex:row] valueForKey:@"country_name_cn"];
    }else if ([str isEqualToString:EN]) {
        return [[countryArray objectAtIndex:row] valueForKey:@"country_name_en"];
    }{
        return [[countryArray objectAtIndex:row] valueForKey:@"country_name_ft"];
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component {
    selectIndex = row;
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30.0;
}

- (void)creatCountry{
    countryArray = [NSMutableArray array];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CountryCode" ofType:@".json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
    NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary *dic in jsonDic) {
        [countryArray addObject:dic];
    }
    for (int i = 0; i<countryArray.count; i++) {
        if ([[countryArray[i] valueForKey:@"country_name_cn"] isEqualToString:@"柬埔寨"]) {
            [countryArray exchangeObjectAtIndex:0 withObjectAtIndex:i];
        }
    }
    NSLog(@"%@",countryArray);
}
- (void)cancleOrSure:(UIButton *)button{
    if (button.tag == 100) {
        
    }else{
        [_areaCodeButton setTitle:[NSString stringWithFormat:@"+%@",[[countryArray objectAtIndex:selectIndex] valueForKey:@"country_code"]] imageName:@"ic_down"];
        [_areaCodeButton setSelectTitle:[NSString stringWithFormat:@"+%@",[[countryArray objectAtIndex:selectIndex] valueForKey:@"country_code"]] imageName:@"ic_up"];
    }
    _areaCodeButton.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _pickBgView.alpha = 0;
        _pickContentView.mj_y = SCREEN_HEIGHT;
    }];
}
- (BOOL)isEmailAddress:(NSString *)email{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [predicate evaluateWithObject:email];
    return isValid;
}
@end
