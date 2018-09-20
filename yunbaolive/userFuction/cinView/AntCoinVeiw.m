#import "AntCoinVeiw.h"
#import "coinCell1.h"
#import "coinCell3.h"
#import "applePay.h"
#define TEST_SANDBOX 1
@interface AntCoinVeiw ()<applePayDelegate,UITableViewDelegate,UITableViewDataSource>
{
    int setvis;
    applePay *applePays;//苹果支付
    NSString *urlStrtimestring;//时间戳
    UIActivityIndicatorView *testActivityIndicator;//菊花
}
//以下是支付用到的
@property(nonatomic,strong)NSArray *coinArrays;
@property(nonatomic,strong)NSDictionary *seleDic;//选中的钻石字典

@property  BOOL Firstcharge;
@end
@implementation AntCoinVeiw
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = RGB(246, 246, 246);
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableV.separatorStyle = NO;
    //创建苹果支付
    applePays = [[applePay alloc]init];
    applePays.delegate = self;
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = CGPointMake((_window_width - 10)/2, (_window_height - 10)/2);
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    self.tableV.frame = CGRectMake(0, 64+statusbarHeight, _window_width, _window_height - statusbarHeight - 64);
}
- (void)onAppWillEnterForeground:(UIApplication*)app {
    [self getMyCoin];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvis = 0;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    setvis = 1;
    [MBProgressHUD hideHUD];
    self.navigationController.navigationBarHidden = YES;
    [self getMyCoin];
    [self navtion];
}
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor =navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = _titleStr;
    [label setFont:navtionTitleFont];
    label.textColor = navtionTitleColor;
    label.frame = CGRectMake(0, statusbarHeight,_window_width,84);
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor whiteColor];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, statusbarHeight, _window_width/2, 64)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(10,30 +statusbarHeight,30,20);[returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
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
}
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableV deselectRowAtIndexPath:indexPath animated:YES];
     //判断返回cell
    if (indexPath.section == 0) {
        coinCell1 *cell = [coinCell1 cellWithTableView:self.tableV];
        cell.labCoin.text = self.coin;
        return cell;
    }
    else
    {
        NSDictionary *subdic = [_coinArrays objectAtIndex:indexPath.row];
        coinCell3 *cell = [coinCell3 cellWithTableView:self.tableV];
        NSString *money = [subdic valueForKey:@"money_ios"];
        NSString *give = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"give"]];
        if ([give isEqual:@"0"]) {
            cell.labRemake.hidden = YES;
        }
        else{
            cell.labRemake.hidden = NO;
            cell.labRemake.text = [NSString stringWithFormat:@"%@%@%@",YZMsg(@"赠送"),give,[common name_coin]];
        }
        cell.btnPrice.layer.masksToBounds = YES;
        cell.btnPrice.layer.borderWidth = 1.0;
        cell.btnPrice.layer.cornerRadius = 15;
        cell.btnPrice.layer.borderColor = RGB(253, 198, 16).CGColor;
        cell.labCoin.text = [subdic valueForKey:@"coin"];
        [cell.btnPrice setTitle:[NSString stringWithFormat:@"$%@",money] forState:UIControlStateNormal];
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //判断当前分区返回分区行数
    if (section == 0 ) {
        return 1;
    }
    else
    {
        return _coinArrays.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回分区数
    return 2;
}
- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section
{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger) section
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableV deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    _seleDic = _coinArrays[indexPath.row];
    [applePays applePay:_seleDic];
}
-(void)getMyCoin
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *userBaseUrl = [purl stringByAppendingFormat:@"service=User.getBalance"];
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken]
                             };
    [session POST:userBaseUrl parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        NSArray *data = [responseObject valueForKey:@"data"];
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqual:@0])
            {
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                _coinArrays = [info valueForKey:@"rules"];
                self.coin = [info valueForKey:@"coin"];
                [self.tableV reloadData];
            }
            else{
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
            }
        }
        else{
            [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
        }
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150;
    }
    else
        return 70;
}
/******************   内购  ********************/
-(void)applePayHUD{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)applePayShowHUD{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//内购成功
-(void)applePaySuccess{
    NSLog(@"苹果支付成功");
    [self getMyCoin];
}
@end
