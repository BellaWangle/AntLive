#import "hahazhucedeview.h"
@interface hahazhucedeview ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSTimer *messsageTimer;
    int messageIssssss;//短信倒计时  60s
    UIView *bottomView;
    NSMutableArray *countryArray;//国家区号
    NSInteger selectIndex;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VIewH;
@property (weak, nonatomic) IBOutlet UILabel *regTitLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *regBtn;
@property (weak, nonatomic) IBOutlet UIImageView *selectPhoneStateImageView;

@end
@implementation hahazhucedeview
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.VIewH.constant<80) {
        self.VIewH.constant+=statusbarHeight;
    }
    _regTitLabel.text = YZMsg(@"注册");
    _nameLabel.text = YZMsg(@"账号");
    [_yanzhengmaBtn setTitle:YZMsg(@"获取验证码") forState:0];
    _phoneT.placeholder = YZMsg(@"请填写手机号");
    _yanzhengmaT.placeholder = YZMsg(@"请输入验证码");
    _passWordT.placeholder = YZMsg(@"请填写密码");
    _password2.placeholder = YZMsg(@"请确认密码");
    [_regBtn setTitle:YZMsg(@"立即注册") forState:0];
    
    if (_isEmail) {
        _selectPhoneStateImageView.hidden = YES;
        [_selectPhoneStateImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        _nameLabel.text = YZMsg(@"邮箱");
        _phoneT.placeholder = YZMsg(@"请填写邮箱账号");
        _nameLabel.userInteractionEnabled = NO;
        _phoneT.keyboardType = UIKeyboardTypeEmailAddress;

    }else{
        _phoneT.placeholder = YZMsg(@"请填写手机号");
        _nameLabel.text = @"+855";
        _nameLabel.userInteractionEnabled = YES;
        _phoneT.keyboardType = UIKeyboardTypeNumberPad;

    }
    [self creatCountry];
    [_phoneT becomeFirstResponder];
    messageIssssss = 60;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeBtnBackground) name:UITextFieldTextDidChangeNotification object:nil];
}
//MARK:-ChangeBtnBackground
-(void)ChangeBtnBackground
{
    if (_phoneT.text.length > 0) {
        _yanzhengmaBtn.enabled = YES;
    }else{
        _yanzhengmaBtn.enabled = NO;
    }
    if (_phoneT.text.length > 0 && _yanzhengmaT.text.length == 6 && _passWordT.text.length > 0 && _password2.text.length >0)
    {
        [_registBTn setBackgroundColor:normalColors];
        _registBTn.enabled = YES;
    }
    else
    {
        [_registBTn setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0]];
        _registBTn.enabled = NO;
    }
}
//获取验证码倒计时
-(void)daojishi{
    [_yanzhengmaBtn setTitle:[NSString stringWithFormat:@"%ds",messageIssssss] forState:UIControlStateNormal];
    _yanzhengmaBtn.userInteractionEnabled = NO;
    if (messageIssssss<=0) {
        [_yanzhengmaBtn setTitle:YZMsg(@"获取验证码") forState:UIControlStateNormal];
        _yanzhengmaBtn.userInteractionEnabled = YES;
        [messsageTimer invalidate];
        messsageTimer = nil;
        messageIssssss = 60;
    }
    messageIssssss-=1;
}
//键盘的隐藏
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doRegist:(id)sender {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *userBaseUrl;
    NSDictionary *Reg;
    if (!_isEmail) {
        userBaseUrl = [purl stringByAppendingFormat:@"service=Login.userReg"];
        Reg = @{
                @"user_login":_phoneT.text,
                @"user_pass":_passWordT.text,
                @"user_pass2":_password2.text,
                @"code":_yanzhengmaT.text
                };
        
    }else{
        userBaseUrl = [purl stringByAppendingFormat:@"service=Login.userEmailReg"];
        Reg = @{
                @"email":_phoneT.text,
                @"user_pass":_passWordT.text,
                @"user_pass2":_password2.text,
                @"code":_yanzhengmaT.text
                };
        
    }
//    NSString *userBaseUrl = [purl stringByAppendingFormat:@"service=Login.userReg"];
//    NSDictionary *Reg = @{
//                          @"user_login":_phoneT.text,
//                          @"user_pass":_passWordT.text,
//                          @"user_pass2":_password2.text,
//                          @"code":_yanzhengmaT.text
//                          };
    [session POST:userBaseUrl parameters:Reg progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            NSString *msg = [data valueForKey:@"msg"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                [MBProgressHUD showSuccess:@"注册成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            else{
                [MBProgressHUD showError:msg];
            }
        }
        else{
            [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:YZMsg(@"无网络")];
    }];

}
- (IBAction)getYanZheng:(id)sender {
    NSString *url;
    NSDictionary *getcode;
    if (!_isEmail) {
        
        //        if (_phoneT.text.length!=11){
        //            [MBProgressHUD showError:YZMsg(@"regist_phone_wrong")];
        //            return;
        //        }
        if (_phoneT.text.length == 0){
            [MBProgressHUD showError:YZMsg(@"请输入手机号")];
            return;
        }
        url = [purl stringByAppendingFormat:@"service=Login.getCode"];
        getcode = @{
                    @"mobile":_phoneT.text,
                    @"country_code":[[countryArray objectAtIndex:selectIndex] valueForKey:@"country_code"]
                    };
        
    }else{
        if (![self isEmailAddress:_phoneT.text]) {
            [MBProgressHUD showError:YZMsg(@"请输入正确的邮箱")];
            return;
        }
        url = [purl stringByAppendingFormat:@"service=Login.getEmailCode"];
        getcode = @{
                    @"email":_phoneT.text,
                    };
        
    }
    messageIssssss = 60;

        _yanzhengmaBtn.userInteractionEnabled = NO;
//        NSString *url = [purl stringByAppendingFormat:@"?service=Login.getCode"];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//        NSDictionary *getcode = @{
//                                  @"mobile":_phoneT.text
//                                  };
        [session POST:url parameters:getcode progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSNumber *number = [responseObject valueForKey:@"ret"] ;
            if([number isEqualToNumber:[NSNumber numberWithInt:200]])
            {
                NSArray *data = [responseObject valueForKey:@"data"];
                NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
                NSString *msg = [data valueForKey:@"msg"];
                if([code isEqual:@"0"])
                {
                    _yanzhengmaBtn.userInteractionEnabled = YES;
                    if (messsageTimer == nil) {
                        messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
                    }
                    [MBProgressHUD showSuccess:YZMsg(@"发送成功")];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [_yanzhengmaT becomeFirstResponder];
                        [MBProgressHUD hideHUD];
                    });
                }
                else {
                    _yanzhengmaBtn.userInteractionEnabled = YES;
                    [MBProgressHUD showError:msg];
                }
            }
            else{
                _yanzhengmaBtn.userInteractionEnabled = YES;
            }
        }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   _yanzhengmaBtn.userInteractionEnabled = YES;
                  [MBProgressHUD showError:YZMsg(@"无网络")];
              }];
    

}

#pragma mark ================ 国家编号 ===============
- (IBAction)selectAreaCode:(id)sender {
    if (_isEmail) {
        return;
    }
    [_phoneT resignFirstResponder];
    [_yanzhengmaT resignFirstResponder];
    [_passWordT resignFirstResponder];
    [_password2 resignFirstResponder];
    _selectPhoneStateImageView.image = [UIImage imageNamed:@"ic_up"];
    
    if (!bottomView) {
        bottomView = [[UIView alloc]init];
        bottomView.frame = self.view.bounds;
        bottomView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        [self.view addSubview:bottomView];
        
        
        
        UIView * pickerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height-200, _window_width, 200)];
        pickerBgView.backgroundColor = [UIColor whiteColor];
        [bottomView addSubview:pickerBgView];
        
        UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 40)];
        titleView.backgroundColor = HexColor(@"FAFAFA");
        [pickerBgView addSubview:titleView];
        
        UIButton *cancleBtn = [UIButton buttonWithType:0];
        cancleBtn.frame = CGRectMake(20, 0, 40, 40);
        cancleBtn.tag = 100;
        [cancleBtn setTitle:YZMsg(@"取消") forState:0];
        [cancleBtn setTitleColor:[UIColor grayColor] forState:0];
        [cancleBtn addTarget:self action:@selector(cancleOrSure:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:cancleBtn];
        
        UIButton *sureBtn = [UIButton buttonWithType:0];
        sureBtn.frame = CGRectMake(_window_width-60, 0, 40, 40);
        sureBtn.tag = 101;
        [sureBtn setTitle:YZMsg(@"确认") forState:0];
        [sureBtn setTitleColor:[UIColor orangeColor] forState:0];
        [sureBtn addTarget:self action:@selector(cancleOrSure:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:sureBtn];
        
        UIPickerView *pick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, _window_width, 160)];
        pick.delegate = self;
        pick.dataSource = self;
        [pickerBgView addSubview:pick];
        
        
    }else {
       
        bottomView.hidden = NO;
    }
    
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
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
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
        //        return;
    }else{
        //        [_numBtn setTitle:[NSString stringWithFormat:@"+%@",[[countryArray objectAtIndex:selectIndex] valueForKey:@"country_code"]] forState:0];
        _nameLabel.text = [NSString stringWithFormat:@"+%@",[[countryArray objectAtIndex:selectIndex] valueForKey:@"country_code"]];
        
    }
    _selectPhoneStateImageView.image = [UIImage imageNamed:@"ic_down"];
    bottomView.hidden = YES;
}
- (BOOL)isEmailAddress:(NSString *)email{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [predicate evaluateWithObject:email];
    return isValid;
}
@end
