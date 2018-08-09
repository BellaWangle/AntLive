//
//  EditNiceName.m
//  AntliveShow
//
//  Created by cat on 16/3/13.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "EditSignature.h"
#import "UIColor+Util.h"
@interface EditSignature ()<UITextFieldDelegate>
{
    UITextField *input;
    int setvisname;
    UIActivityIndicatorView *testActivityIndicator;//菊花
}
@end

@implementation EditSignature
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    setvisname = 1;
    self.navigationController.navigationBarHidden = YES;
    

    [self navtion];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvisname = 0;

}
-(void)navtion{
    
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64+statusbarHeight)];
    navtion.backgroundColor = RGB(246,246,246);
    UILabel *label = [[UILabel alloc]init];
    label.text = YZMsg(@"修改签名");
    //label.font = FNOT;
    [label setFont:[UIFont fontWithName:@"Heiti SC" size:14]];
    
    label.textColor = [UIColor blackColor];
    label.frame = CGRectMake(0, statusbarHeight,_window_width,84);
    // label.center = navtion.center;
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor whiteColor];
    
    returnBtn.frame = CGRectMake(10,30+statusbarHeight,30,20);[returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    returnBtn.tintColor = [UIColor blackColor];
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,64);
    [navtion addSubview:btnttttt];
    
    [self.view addSubview:navtion];
    
    
    UIButton *BtnSave = [[UIButton alloc] initWithFrame:CGRectMake(_window_width*0.1,160+statusbarHeight,_window_width*0.8,50)];
    
    [BtnSave setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [BtnSave setBackgroundColor:normalColors];
    [BtnSave setTitle:YZMsg(@"保存") forState:UIControlStateNormal];
    BtnSave.titleLabel.font = [UIFont systemFontOfSize:17];
    BtnSave.layer.masksToBounds = YES;
    BtnSave.layer.cornerRadius = 25;
    [BtnSave addTarget:self action:@selector(nicknameSave) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:BtnSave];
    
}
-(void)doReturn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;

             self.view.backgroundColor = [UIColor whiteColor];
    input = [[UITextField alloc] init];
    float NavHeight = 54 + statusbarHeight;//包涵通知栏的20px
    input.frame = CGRectMake(20,NavHeight+20,_window_width-60, 40);
    input.layer.cornerRadius = 3;
    input.font = fontThin(15);

    input.delegate =self;
    input.layer.masksToBounds = YES;
    input.text = [Config getOwnSignature];
    [input setBackgroundColor:[UIColor whiteColor]];
    input.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:input];
    UILabel *lab = [[UILabel alloc] init];
    lab.text = YZMsg(@"最多输入20个字");
    lab.font = fontThin(13);

    [lab setTextColor:[UIColor colorWithRed:45.0/255 green:45.0/255 blue:45.0/255 alpha:1]];
    lab.frame = CGRectMake(23, NavHeight+75, 200, 25);
    [self.view addSubview:lab];
    
   
    [input becomeFirstResponder];
}

-(void)nicknameSave
{
    
    if (input.text.length >20) {
        
        [MBProgressHUD showError:YZMsg(@"字数超出限制")];
        
        return;
    }
    
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = self.view.center;
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[input.text] forKeys:@[@"signature"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.updateFields&uid=%@&token=%@&fields=%@",[Config getOwnID],[Config getOwnToken],jsonStr];    url= [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSLog(@"修改成功");
                LiveUser *user = [[LiveUser alloc] init];
                
           
                user.signature = input.text;

                [Config updateProfile:user];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                
             }
            
            else
            {
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
               
            }
            
        }
        else
        {
            [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
            
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



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
    if (textField == input) {
        
        if (input.text.length > 20)
        {
            
            [MBProgressHUD showError:@"字太多啦~"];

            return NO;
        }
    }
    */
    return YES;
}




@end
