//
//  EditNiceName.m
//  yunbaolive
//
//  Created by cat on 16/3/13.
//  Copyright © 2016年 cat. All rights reserved.
//
#import "nickNameEdie.h"
@interface nickNameEdie ()<UITextFieldDelegate>
{
    UITextField *input;
    float NavHeight;
    int setvisaaaa;
    UIActivityIndicatorView *testActivityIndicator;//菊花

}
@end
@implementation nickNameEdie
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    setvisaaaa = 1;
    self.navigationController.navigationBarHidden = YES;

    [self navtion];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvisaaaa = 0;
}
-(void)navtion{
    
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor = navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = YZMsg(@"修改昵称");
    [label setFont:navtionTitleFont];
    
    label.textColor = navtionTitleColor;
    label.frame = CGRectMake(0, statusbarHeight,_window_width,84);
    // label.center = navtion.center;
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor whiteColor];
    
    returnBtn.frame = CGRectMake(10,30 + statusbarHeight,30,20);[returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
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
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    input = [[UITextField alloc] init];
    input.delegate = self;
    NavHeight = 54 + statusbarHeight;//包涵通知栏的20px
    input.frame = CGRectMake(20,NavHeight+20 , [UIScreen mainScreen].bounds.size.width  - 60, 40);
    input.layer.cornerRadius = 3;
    input.layer.masksToBounds = YES;
    input.font = fontThin(15);
    input.text = [Config getOwnNicename];
    [input setBackgroundColor:[UIColor whiteColor]];
    input.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:input];
    UILabel *lab = [[UILabel alloc] init];
    lab.text = YZMsg(@"昵称最多8个字");
    lab.font = fontThin(13);
    [lab setTextColor:[UIColor colorWithRed:45.0/255 green:45.0/255 blue:45.0/255 alpha:1]];
    lab.textColor = [UIColor lightGrayColor];
    lab.frame = CGRectMake(23, NavHeight+65, 200, 25);
    [self.view addSubview:lab];
    [input becomeFirstResponder];
}
-(void)nicknameSave
{
    
    
    if (input.text.length > 8) {
        [MBProgressHUD showError:YZMsg(@"字数超出限制")];
        return ;
    }
    
    
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = self.view.center;
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
    

    
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[input.text] forKeys:@[@"user_nicename"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.updateFields&uid=%@&token=%@&fields=%@",[Config getOwnID],[Config getOwnToken],jsonStr];
    
    url= [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                LiveUser *user = [[LiveUser alloc] init];
              
                
                user.user_nicename = input.text;
                [Config updateProfile:user];
                [self.navigationController popViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
                
                
            
            }
            else
            {
                 [MBProgressHUD showError:[data valueForKey:@"msg"]];
                    NSLog(@"%@",[responseObject valueForKey:@"msg"]);
            }
        }
        else
        {
             [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
            NSLog(@"操作失败！");
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

@end
