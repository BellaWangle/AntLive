#import "attentionViewC.h"
#import "hotModel.h"
#import "hotCell.h"
#import "myView.h"
#import "LivePlay.h"
#import "AppDelegate.h"
@interface attentionViewC ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *zanwuguanzhudezhubo;
    long indexpath;//tableviewcell数量
    UIImageView *NoInternetImageV;//无网络的时候显示
    UIImageView *imageV;
    NSDictionary *selectedDic;
    int selected;
    UIAlertView *coastAlert;
    UIAlertView *secretAlert;
    NSString *type_val;//
    NSString *livetype;//
}
@property(nonatomic,strong)NSMutableArray *zhuboModel;//主播模型
@property(nonatomic,strong)NSArray *infoArray;//获取到的主播列表信息
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *MD5;
@end
@implementation attentionViewC
//懒加载
-(NSMutableArray *)zhuboModel{
    NSMutableArray *mutable = [NSMutableArray array];
    for (int i=0; i<self.infoArray.count; i++) {
        NSDictionary *subDic = [self.infoArray objectAtIndex:i];
        hotModel *model = [hotModel modelWithDic:subDic];
        [mutable addObject:model];
    }
    _zhuboModel = mutable;
    return _zhuboModel;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self pullInternet];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    type_val = @"0";
    livetype = @"0";
    self.infoArray = [NSArray array];
    self.zhuboModel = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height - 74 - statusbarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    //下拉刷新
    self.tableView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullInternet)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    [self createView];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(void)createView{
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0.3 * _window_width, 0.2 * _window_height, 0.4 * _window_width, 0.4 * _window_width)];
    imageV.image = [UIImage imageNamed:getImagename(@"关注无") ];
    [self.tableView addSubview:imageV];
    imageV.hidden = YES;
    NoInternetImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0.3 * _window_width, 0.25 * _window_height, 0.4 * _window_width, 0.4 * _window_width)];
    NoInternetImageV.contentMode = UIViewContentModeScaleAspectFit;
    NoInternetImageV.image = [UIImage imageNamed:@"shibai"];
    [self.tableView addSubview:NoInternetImageV];
    NoInternetImageV.hidden = YES;
}
-(void)pullInternet{
    NSString *url = [purl stringByAppendingFormat:@"service=Home.getFollow"];
    NSDictionary *follow = @{
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken]
                             };
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:url parameters:follow progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSArray *info = [data valueForKey:@"info"];
                self.infoArray  = info;
                //加载成功 停止刷新
                if (info.count == 0) {
                    imageV.hidden = NO;
                }else{
                    imageV.hidden = YES;
                }
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            }
            else{
                
                 imageV.hidden = NO;
            }
        }
        else{
             imageV.hidden = NO;
        }
           NoInternetImageV.hidden = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        imageV.hidden = YES;
        [MBProgressHUD showError:YZMsg(@"无网络")];
        if (self.infoArray.count == 0) {
             NoInternetImageV.hidden = NO;
        }
        
        
    }];
}
#pragma mark - Table vie data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    indexpath = self.infoArray.count;
    return self.infoArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    hotCell *cell = [hotCell cellWithTableView:tableView];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[self.infoArray objectAtIndex:indexPath.row]];
    hotModel *model = [hotModel modelWithDic:dic];
    cell.model = model;
    return cell;
}
//表头间距
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _window_width + 60 + 10;
}
//进入房间
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    selected = (int)indexPath.row;
    selectedDic = self.infoArray[indexPath.row];
    [self checklive:[selectedDic valueForKey:@"stream"] andliveuid:[selectedDic valueForKey:@"uid"]];
}
-(void)checklive:(NSString *)stream andliveuid:(NSString *)liveuid{
    
    NSString *url = [purl stringByAppendingFormat:@"service=Live.checkLive"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = 5.0;
    request.HTTPMethod = @"post";
    NSString *param = [NSString stringWithFormat:@"uid=%@&token=%@&liveuid=%@&stream=%@",[Config getOwnID],[Config getOwnToken],liveuid,stream];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response;
    NSError *error;
    NSData *backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
      
    }
    else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:backData options:NSJSONReadingMutableContainers error:nil];
        
        NSNumber *number = [dic valueForKey:@"ret"];
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [dic valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"])
            {
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                NSString *type = [NSString stringWithFormat:@"%@",[info valueForKey:@"type"]];
                
                type_val =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type_val"]];
                 livetype =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type"]];
                
                if ([type isEqual:@"0"]) {
                    [self pushMovieVC];
                }
                else if ([type isEqual:@"1"]){
                    //密码
                    secretAlert = [[UIAlertView alloc]initWithTitle:YZMsg(@"请填写密码") message:nil delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确认"), nil];
                    secretAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    UITextField *field = [secretAlert textFieldAtIndex:0];
                    field.keyboardType = UIKeyboardTypeNumberPad;
                    [secretAlert show];
                    _MD5 = [NSString stringWithFormat:@"%@",[info valueForKey:@"type_msg"]];
                }else if ([type isEqual:@"2"] || [type isEqual:@"3"]){
                    //收费
                    NSString *type_msg = [NSString stringWithFormat:@"%@",[info valueForKey:@"type_msg"]];
                    coastAlert = [[UIAlertView alloc]initWithTitle:type_msg message:nil delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确认"), nil];
                    [coastAlert show];
                }
            }
            else{
                NSString *msg = [NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]];
                [MBProgressHUD showError:msg];
            }
        }
        
        
        
    }
    
}
-(void)pushMovieVC{
    moviePlay *player = [[moviePlay alloc]init];
    player.scrollarray = self.infoArray;
    player.scrollindex = selected;
    player.playDoc = selectedDic;
       player.type_val = type_val;
      player.livetype = livetype;
    [[MXBADelegate sharedAppDelegate] pushViewController:player animated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == coastAlert) {
        if (buttonIndex == 0) {
            return;
        }else if (buttonIndex == 1){
            [self doCoast];
        }
    }else    if (alertView == secretAlert) {
        if (buttonIndex == 0) {
            return;
        }else if (buttonIndex == 1){
            UITextField *field = [alertView textFieldAtIndex:0];
            
            NSString *MD5s = [self stringToMD5:field.text];
            if ([MD5s isEqual:_MD5]) {
                
                [self pushMovieVC];
            }else{
                [MBProgressHUD showError:YZMsg(@"密码错误")];
            }
            
        }
    }
}
- (NSString *)stringToMD5:(NSString *)str
{
    
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}
//执行扣费
-(void)doCoast{
    NSString *url = [purl stringByAppendingFormat:@"service=Live.roomCharge"];
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken],
                             @"liveuid":[selectedDic valueForKey:@"uid"],
                             @"stream":[selectedDic valueForKey:@"stream"]
                             };
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"];
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"])
            {
                [self pushMovieVC];
            }
            else{
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}
@end
