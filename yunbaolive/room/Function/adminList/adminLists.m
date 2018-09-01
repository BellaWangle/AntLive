#import "adminLists.h"
#import "adminCELL.h"
#import "AntFansModel.h"
@interface adminLists ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *fansmodels;
@property(nonatomic,strong)NSArray *allArray;
@property(nonatomic,strong)UITableView *tableView;
@end
@implementation adminLists
-(NSArray *)fansmodels{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.allArray) {
        AntFansModel *model = [AntFansModel modelWithDic:dic];
        [array addObject:model];
    }
    _fansmodels = array;
    return _fansmodels;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(adminxin) name:@"adminlist" object:nil];
}
-(void)listMessage{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Live.getAdminList"];
    
    NSDictionary *subdic = @{
                             @"liveuid":[Config getOwnID]
                             };
    
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSArray *info = [data valueForKey:@"info"];
                self.allArray = info;//关注信息复制给数据源
                dispatch_async(dispatch_get_main_queue(), ^{
                     [self.tableView reloadData];
                });
               
            }
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)adminxin{
    self.allArray = [NSArray array];
    self.fansmodels = [NSArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height*0.3) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    [self listMessage];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _window_width, 20)];
    label.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = YZMsg(@"管理员列表");
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    adminCELL *cell = [adminCELL cellWithTableView:tableView];
    AntFansModel *model = self.fansmodels[indexPath.row];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //弹窗
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)doGuanzhu:(NSString *)st{
    //关注
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.setAttention&uid=%@&showid=%@&token=%@",[Config getOwnID],st,[Config getOwnToken]];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                
            }
        }
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
     }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
@end
