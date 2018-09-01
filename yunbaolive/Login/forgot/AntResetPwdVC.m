#import "AntResetPwdVC.h"


@interface AntResetPwdVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VIewH;
@property (weak, nonatomic) IBOutlet UILabel *titLAbel;

@property (weak, nonatomic) IBOutlet UILabel *oldLabel;
@property (weak, nonatomic) IBOutlet UILabel *nnewLabel;
@property (weak, nonatomic) IBOutlet UILabel *nnewLabel2;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@end
@implementation AntResetPwdVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.VIewH.constant<80) {
        self.VIewH.constant+=statusbarHeight;
    }
    _titLAbel.text = YZMsg(@"重置密码");
    _oldLabel.text = YZMsg(@"旧密码");
    _nnewLabel.text = YZMsg(@"新密码");
    _nnewLabel2.text = YZMsg(@"确认密码");
    [_changeBtn setTitle:YZMsg(@"立即修改") forState:0];
    _oldPassWord.placeholder = YZMsg(@"请输入旧密码");
    _futurePassWord.placeholder = YZMsg(@"请填写新密码");
    _futurePassWord2.placeholder = YZMsg(@"确认新密码");
    [_oldPassWord becomeFirstResponder];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeBtnBackground) name:UITextFieldTextDidChangeNotification object:nil];

    
}
-(void)ChangeBtnBackground
{
   
    if (_oldPassWord.text.length >0 && _futurePassWord.text.length >0 && _futurePassWord2.text.length > 0 )
    {
        [_dochange setBackgroundColor:normalColors];
        _dochange.enabled = YES;
    }
    else
    {
        [_dochange setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0]];
        _dochange.enabled = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)doBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doChangePassWord:(id)sender {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSString *url = [purl stringByAppendingFormat:@"service=User.updatePass&uid=%@&token=%@&oldpass=%@&pass=%@&pass2=%@",[Config getOwnID],[Config getOwnToken],_oldPassWord.text,_futurePassWord.text,_futurePassWord2.text];
    
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                
                NSString *msg = [data valueForKey:@"msg"];
                [MBProgressHUD showSuccess:msg];
                
                [self.navigationController popViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
            else{
                NSString *msg = [data valueForKey:@"msg"];
                [MBProgressHUD showError:msg];
                
                
            }
            
        }
        
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [MBProgressHUD showError:YZMsg(@"无网络")];
     }];
    
    

}
@end
