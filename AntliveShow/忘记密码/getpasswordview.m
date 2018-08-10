#import "getpasswordview.h"
@interface getpasswordview ()<UIPickerViewDelegate,UIPickerViewDataSource> {
    NSTimer *messsageTimer;
    int messageIssssss;//短信倒计时  60s
    UIView *bottomView;
    NSMutableArray *countryArray;//国家区号
    NSInteger selectIndex;
    
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VIewH;
@property (weak, nonatomic) IBOutlet UILabel *fogtTitLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectPhoneStateImageView;


@end

@implementation getpasswordview

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.VIewH.constant<80) {
        self.VIewH.constant+=statusbarHeight;
    }
    _fogtTitLabel.text = YZMsg(@"忘记密码");
   
    [_findNowBtn setTitle:YZMsg(@"立即找回") forState:0];
    [_yanzhengmaBtn setTitle:YZMsg(@"获取验证码") forState:0];
    _phoneT.placeholder = YZMsg(@"请填写手机号");
    _yanzhengma.placeholder = YZMsg(@"请输入验证码");
    _secretT.placeholder = YZMsg(@"请填写密码");
    _secretTT2.placeholder = YZMsg(@"请确认密码");
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
-(void)ChangeBtnBackground
{
    if (_phoneT.text.length > 0) {
        _yanzhengmaBtn.enabled = YES;
    }else{
        _yanzhengmaBtn.enabled = NO;
    }
    if (_phoneT.text.length != 0 && _yanzhengma.text.length == 6 && _secretT.text.length > 0 && _secretTT2.text.length >0)
    {
        [_findNowBtn setBackgroundColor:normalColors];
        _findNowBtn.enabled = YES;
    }
    else
    {
        [_findNowBtn setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0]];
        _findNowBtn.enabled = NO;
    }
}
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
- (IBAction)clickYanzhengma:(id)sender {
    
    
    NSString *url;
    NSDictionary *ForgetCode;
    if (!_isEmail) {
        url = [purl stringByAppendingFormat:@"service=Login.getForgetCode"];
        ForgetCode = @{
                       @"mobile":_phoneT.text,
                       @"country_code":[[countryArray objectAtIndex:selectIndex] valueForKey:@"country_code"]
                       };
        
    }else{
        if (![self isEmailAddress:_phoneT.text]) {
            [MBProgressHUD showError:YZMsg(@"请输入正确的邮箱")];
            return;
        }
        url = [purl stringByAppendingFormat:@"service=User.getupdateEmailCode"];
        ForgetCode = @{
                       @"email":_phoneT.text,
                       };
        
    }
    
    _yanzhengmaBtn.userInteractionEnabled = NO;
    messageIssssss = 60;
//    NSString *url = [purl stringByAppendingFormat:@"?service=Login.getForgetCode"];
//    NSDictionary *ForgetCode = @{
//                                 @"mobile":_phoneT.text
//                                 };
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:url parameters:ForgetCode progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            NSString *msg = [data valueForKey:@"msg"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                _yanzhengmaBtn.userInteractionEnabled = YES;
                if (messsageTimer == nil) {
                    messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
                }
                
                [MBProgressHUD showSuccess:YZMsg(@"发送成功")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    [_yanzhengma becomeFirstResponder];
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _yanzhengmaBtn.userInteractionEnabled = YES;
        [MBProgressHUD showError:YZMsg(@"无网络")];
    }];

    
}
//键盘的隐藏
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)doBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickFindBtn:(id)sender {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *userBaseUrl = [purl stringByAppendingFormat:@"service=User.updateMainPass"];
    NSString *type;
    if (!_isEmail) {
        type = @"1";
    }else{
        type = @"2";
    }
    NSDictionary *FindPass = @{
                               @"user_login":_phoneT.text,
                               @"pass":_secretT.text,
                               @"pass2":_secretTT2.text,
                               @"code":_yanzhengma.text,
                               @"type":type
                               };
    [session POST:userBaseUrl parameters:FindPass progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            NSString *msg = [data valueForKey:@"msg"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                [MBProgressHUD showSuccess:YZMsg(@"密码重置成功")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            else{
                [MBProgressHUD showError:msg];
            }
        }
        else{
            NSString *msg = [responseObject valueForKey:@"msg"];
            [MBProgressHUD showError:msg];
        }
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              [MBProgressHUD showError:YZMsg(@"无网络")];
          }];

    
}
#pragma mark ================ 国家编号 ===============
- (IBAction)selectAreaCode:(id)sender {
    if (_isEmail) {
        return;
    }
    [_phoneT resignFirstResponder];
    [_yanzhengma resignFirstResponder];
    [_secretT resignFirstResponder];
    [_secretTT2 resignFirstResponder];
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
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.top.mas_equalTo(0);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_equalTo(40);
        }];
        
        UIButton *sureBtn = [UIButton buttonWithType:0];
        sureBtn.frame = CGRectMake(_window_width-60, 0, 40, 40);
        sureBtn.tag = 101;
        [sureBtn setTitle:YZMsg(@"确认") forState:0];
        [sureBtn setTitleColor:[UIColor orangeColor] forState:0];
        [sureBtn addTarget:self action:@selector(cancleOrSure:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-20);
            make.top.mas_equalTo(0);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_equalTo(40);
        }];
        
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
