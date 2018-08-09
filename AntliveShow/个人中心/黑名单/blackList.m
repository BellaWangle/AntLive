#import "blackList.h"
#import "blackListCell.h"
#import "fansModel.h"
#import "ZFModalTransitionAnimator.h"
@interface blackList ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    int setvisblack;
}
@property(nonatomic,strong)NSArray *fansmodels;
@property(nonatomic,strong)NSArray *allArray;
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property(nonatomic,strong)NSString *laheiID;
@end
@implementation blackList
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    setvisblack = 1;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvisblack = 0;
}
-(NSArray *)fansmodels{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.allArray) {
        fansModel *model = [fansModel modelWithDic:dic];
        [array addObject:model];
    }
    _fansmodels = array;
    return _fansmodels;
}
-(void)listMessage{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.getBlackList"];
    
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"touid":[Config getOwnID],
                             @"token":[Config getOwnToken]
                             };
    
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
                    [self.tableView removeFromSuperview];
                    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, _window_width, 300)];
                    lab.text = @"这里什么也没有";
                    lab.textAlignment = NSTextAlignmentCenter;
                    lab.textColor =  [UIColor colorWithRed:128/255.0 green:128/255.0 blue:105/255.0 alpha:1];
                    lab.font = [UIFont fontWithName:@"Heiti SC" size:22.f];
                    [self.view addSubview:lab];
                }
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}

- (void)viewDidLoad {
   [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64)];
    navtion.backgroundColor = [UIColor whiteColor];
    UILabel *labels = [[UILabel alloc]init];
    labels.text = @"黑名单";
    //label.font = FNOT;
    [labels setFont:[UIFont fontWithName:@"Heiti SC" size:20]];
    
    labels.textColor = [UIColor blackColor];
    labels.frame = CGRectMake(0, 0,_window_width,84);
    // label.center = navtion.center;
    labels.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:labels];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor whiteColor];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _window_width/2, 64)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(10,30,30,20);[returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
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
    
    [self listMessage];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, _window_width, _window_height) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = YES;
    self.tableView = tableView;
    [self.view addSubview:tableView];
}
-(void)doReturn{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fansmodels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    blackListCell *cell = [blackListCell cellWithTableView:tableView];
    fansModel *model = self.fansmodels[indexPath.row];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    fansModel *model = self.fansmodels[indexPath.row];
    self.laheiID = model.uid;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"取消拉黑" message:@"对方将移除你的黑名单" delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确认"), nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }else{
        
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSString *url = [purl stringByAppendingFormat:@"service=User.setBlack"];
        NSDictionary *subdic = @{
                                 @"uid":[Config getOwnID],
                                 @"touid":self.laheiID
                                 };
        
        [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSNumber *number = [responseObject valueForKey:@"ret"] ;
            if([number isEqualToNumber:[NSNumber numberWithInt:200]])
            {
                NSArray *data = [responseObject valueForKey:@"data"];
                NSNumber *code = [data valueForKey:@"code"];
                if([code isEqualToNumber:[NSNumber numberWithInt:0]])
                {
                    [self listMessage];
                    /*
                    EMError *error = [[EMClient sharedClient].contactManager removeUserFromBlackList:self.laheiID];
                    if (!error) {
                        NSLog(@"取消拉黑成功%@",self.laheiID);
                    }
                    else
                    {
                        NSLog(@"取消拉黑失败%@",self.laheiID);
                    }
                    */
                    [MBProgressHUD showSuccess:@"操作成功"];
                }
            }
            else{
                [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
@end
