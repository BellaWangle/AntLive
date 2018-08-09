#import "sexChange.h"
@interface sexChange ()
{
    int setvissex;
    UIActivityIndicatorView *testActivityIndicator;//菊花
}
@property (weak, nonatomic) IBOutlet UIButton *manBTN;
@property (weak, nonatomic) IBOutlet UIButton *womanBTN;
- (IBAction)doman:(id)sender;
- (IBAction)dowoman:(id)sender;
- (IBAction)cancle:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *manlabel;
@property (weak, nonatomic) IBOutlet UILabel *womanlabel;
@property(nonatomic,strong)UILabel *titleLab;
@end
@implementation sexChange
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0,0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor = navigationBGColor;
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.text = YZMsg(@"性别");
    [self.titleLab setFont:navtionTitleFont];
    
    self.titleLab.textColor = navtionTitleColor;
    self.titleLab.frame = CGRectMake(0,statusbarHeight,_window_width,84);
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:self.titleLab];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor whiteColor];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0,statusbarHeight, _window_width/2, 64)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(10,30 + statusbarHeight,30,20);[returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    returnBtn.tintColor = [UIColor blackColor];
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    
    [self.view addSubview:navtion];
}
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    LiveUser *user = [Config myProfile];
    if ([user.sex isEqualToString:@"1"]) {
        [self.manBTN setImage:[UIImage imageNamed:@"choice_sex_nanren"] forState:UIControlStateNormal];
        [self.womanBTN setImage:[UIImage imageNamed:@"choice_sex_un_femal"] forState:UIControlStateNormal];
    }
    else{
        [self.womanBTN setImage:[UIImage imageNamed:@"choice_sex_nvren"] forState:UIControlStateNormal];
        [self.manBTN setImage:[UIImage imageNamed:@"choice_sex_un_male"] forState:UIControlStateNormal];
    }
    [self navtion];
    
}
- (IBAction)doman:(id)sender {
    
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = self.view.center;
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
    
    
    [self.manBTN setImage:[UIImage imageNamed:@"choice_sex_nanren"] forState:UIControlStateNormal];
    [self.womanBTN setImage:[UIImage imageNamed:@"choice_sex_un_femal"] forState:UIControlStateNormal];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[@"1"] forKeys:@[@"sex"]];
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
                NSLog(@"修改成功");
                
                LiveUser *user = [[LiveUser alloc] init];
                user.sex = @"1";
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

                [userDefaults setObject:@"1" forKey:@"sex"];
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    setvissex = 1;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    setvissex = 0;
}
- (IBAction)dowoman:(id)sender {
    
    
    [self.manBTN setImage:[UIImage imageNamed:@"choice_sex_un_male"] forState:UIControlStateNormal];
    [self.womanBTN setImage:[UIImage imageNamed:@"choice_sex_nvren"] forState:UIControlStateNormal];

    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[@"2"] forKeys:@[@"sex"]];
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
                NSLog(@"修改成功");
                LiveUser *user = [[LiveUser alloc] init];
                user.sex = @"2";
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:@"2" forKey:@"sex"];
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            
        }
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
     }];
}
- (IBAction)cancle:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
