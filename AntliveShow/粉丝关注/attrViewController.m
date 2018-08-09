

#import "attrViewController.h"
#import "fans.h"
#import "fansModel.h"
#import "personMessage.h"
#import "ZFModalTransitionAnimator.h"

@interface attrViewController ()<UITableViewDelegate,UITableViewDataSource,guanzhu>
{
    
    NSInteger a;
    personMessage *person;
    int setvisatten;
    UIActivityIndicatorView *testActivityIndicator;//菊花
    UIImageView *NoInternetImageV;
    UIView *_nothingView;
}
@property(nonatomic,copy)NSString *btnn;

@property(nonatomic,strong)NSArray *fansmodels;

@property(nonatomic,strong)NSArray *allArray;

@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

@end

@implementation attrViewController

-(NSArray *)fansmodels{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dic in self.allArray) {
        
        fansModel *model = [fansModel modelWithDic:dic];
        
        [array addObject:model];
    }
    _fansmodels = array;
    
    return _fansmodels;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    setvisatten = 1;
    [self createView];
    _nothingView.hidden = YES;
    
    [self request];
    

}
-(void)createView{
    
    _nothingView = [[UIView alloc] initWithFrame:CGRectMake(0.3 * _window_width, 0.2 * _window_height, 0.4 * _window_width, 0.4 * _window_width)];
    _nothingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_nothingView];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,_nothingView.frame.size.width, _nothingView.frame.size.height)];
    imageV.image = [UIImage imageNamed:getImagename(@"关注无")];
    [_nothingView addSubview:imageV];
    _nothingView.hidden = YES;
    
    NoInternetImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0.3 * _window_width, 0.3 * _window_height, 0.4 * _window_width, 0.4 * _window_width)];
     NoInternetImageV.contentMode = UIViewContentModeScaleAspectFit;
    NoInternetImageV.image = [UIImage imageNamed:@"shibai"];
    [self.view addSubview:NoInternetImageV];
    NoInternetImageV.hidden = YES;
    
    
}
-(void)request
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.getFollowsList&uid=%@&touid=%@&p=%@",[Config getOwnID],self.guanzhuUID,@"1"];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSArray *info = [data valueForKey:@"info"];
                self.allArray = info;//关注信息复制给数据源
                [self.tableView reloadData];
                //如果数据为空
                if (self.allArray.count == 0) {
                    _nothingView.hidden = NO;
                }
            }
            else{
                _nothingView.hidden = NO;

            }
        }
        else
        {
            _nothingView.hidden = NO;
        }
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        NoInternetImageV.hidden = YES;
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         _nothingView.hidden = YES;
         [testActivityIndicator stopAnimating]; // 结束旋转
         [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
         if (self.allArray.count == 0) {
             NoInternetImageV.hidden = NO;
         }
     }];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvisatten = 0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    
    self.btnn = [[NSString alloc]init];
    self.btnn = [NSString stringWithFormat:@"a"];
    
    self.allArray = [NSArray array];
    
    self.tableView =  [[UITableView alloc] initWithFrame:CGRectMake(0,64 + statusbarHeight, _window_width, _window_height-64 - statusbarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self request];
    [self navtion];
    
    
    
    
    
    
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = self.view.center;
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fansmodels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    fans *cell = [fans cellWithTableView:tableView];
    fansModel *model = self.fansmodels[indexPath.row];
    cell.model = model;
    cell.guanzhuDelegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)navtion{
    
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor = navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = YZMsg(@"关注");
    [label setFont:navtionTitleFont];
    label.textColor = navtionTitleColor;
    label.frame = CGRectMake(0, statusbarHeight,_window_width,84);
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor whiteColor];
    
    returnBtn.frame = CGRectMake(10,30 + statusbarHeight,30,20);[returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    returnBtn.tintColor = [UIColor blackColor];
    
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, statusbarHeight, _window_width/2, 64)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];

    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navtion];
    [navtion addSubview:returnBtn];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,64);
    [navtion addSubview:btnttttt];
}
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    person = [[personMessage alloc]init];
    
    fansModel *model = self.fansmodels[indexPath.row];

    person.userID = model.uid;
    [self.navigationController pushViewController:person animated:YES];
   // [self presentViewController:person animated:YES completion:nil];

}
-(void)doGuanzhu:(NSString *)st{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.setAttent&uid=%@&touid=%@",[Config getOwnID],st];

    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [self request];
        
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
     }];
}

@end
