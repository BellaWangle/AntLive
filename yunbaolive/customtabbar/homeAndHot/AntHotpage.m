#import "AntHotpage.h"
#import "AnthotModel.h"
#import "AntHotCell.h"
#import "myView.h"
#import "SpectatorRoomVC.h"
#import "AntAppDelegate.h"
#import "jumpSlideContent.h"
#import <CommonCrypto/CommonCrypto.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "tuijianwindow.h"
@interface AntHotpage ()<UITableViewDataSource,UITableViewDelegate,slideDelegate,UIAlertViewDelegate,UIAlertViewDelegate,tuijian>
{
    long indexpath;//tableviewcell数量
    myView *myview;
    int selected;//选择的哪一个
    NSDictionary *selectedDic;
    UIAlertView *coastAlert;
    UIAlertView *secretAlert;
    UIImageView *NoInternetImageV;//无网络的时候显示
    UIImageView *imageV;
    UIAlertController *alertController;//邀请码填写
    UITextField *codetextfield;
    NSString *type_val;//
    NSString *livetype;//
    tuijianwindow *tuijianw;
}
@property(nonatomic,strong)NSArray *zhuboModel;//主播模型
@property(nonatomic,strong)NSArray *infoArray;//获取到的主播列表信息
@property(nonatomic,strong)NSArray *CarouselArray;//轮播图
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *MD5;//加密密码
@end
static NSString *CellIdentifier = @"HOTCell";

@implementation AntHotpage
-(void)jump{
    tuijianw.hidden = YES;
    [tuijianw removeFromSuperview];
    tuijianw = nil;
    //邀请码
    NSString *isregs = minstr([locationCache getreg]);
    if ([isregs isEqual:@"1"]) {
        [self showyaoqingma];
    }
}
-(NSArray *)zhuboModel{
    NSMutableArray *mutable = [NSMutableArray array];
    for (int i=0; i<_infoArray.count; i++) {
        NSDictionary *subDic = [_infoArray objectAtIndex:i];
        AnthotModel *model = [AnthotModel modelWithDic:subDic];
        [mutable addObject:model];
    }
    _zhuboModel = mutable;
    return _zhuboModel;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_infoArray.count<=0) {
        [self pullInternet];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    type_val = @"0";
    livetype = @"0";
    _infoArray    =  [NSArray array];
    self.CarouselArray =  [NSArray array];
    self.zhuboModel    =  [NSArray array];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self createtableview];
    [self nothingview];
    if ([_url isEqual:@"Home.getHot"]) {
        [self yaoqingma];
    }
    
}
-(void)createtableview{
    myview = [[myView alloc]init];
    myview.delegate = self;
    myview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    CGFloat Y = 0;
    CGFloat space = 74;
    NSInteger type = 0;
    //热门和关注 显示 类型不一样
    if ([_url isEqual:@"Home.getFollow"]) {
        type = 0;
        space = 114;
    }
    else{
        type = 1;
        space = 74;
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,Y, _window_width, _window_height-space - statusbarHeight) style:type];
    
    if ([[self iphoneType] isEqualToString:@"iPhone X"]) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,Y, _window_width, _window_height-space - statusbarHeight - 34) style:type];
        NSLog(@"iPhone X");
    }
    
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //下拉刷新
    _tableView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}
-(void)nothingview{
    NoInternetImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0.3 * _window_width, 0.2 * _window_height, 0.4 * _window_width, 0.4 * _window_width)];
    NoInternetImageV.contentMode = UIViewContentModeScaleAspectFit;
    NoInternetImageV.image = [UIImage imageNamed:@"shibai"];
    [self.view addSubview:NoInternetImageV];
    NoInternetImageV.hidden = YES;
    
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0.3 * _window_width, 0.2 * _window_height, 0.4 * _window_width, 0.4 * _window_width)];
    imageV.image = [UIImage imageNamed:getImagename(@"关注无")];
    [_tableView addSubview:imageV];
    imageV.hidden = YES;
}
-(void)yaoqingma{
    //主播推荐
    NSString *isregs = minstr([locationCache getreg]);
    if ([isregs isEqual:@"1"]) {
        if (!tuijianw) {
            tuijianw = [[tuijianwindow alloc]initWithFrame:CGRectMake(0,0,_window_width,_window_height)];
            tuijianw.delegate = self;
            [tuijianw makeKeyAndVisible];
        }
    }
}
-(void)showyaoqingma{
    [locationCache saveisreg:@"0"];
    alertController = [UIAlertController alertControllerWithTitle:YZMsg(@"输入邀请码") message:@""preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = YZMsg(@"输入邀请码");
        codetextfield = textField;
    }];
    //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:YZMsg(@"确认")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (codetextfield.text.length == 0) {
            [self presentViewController:alertController animated:YES completion:nil];
            [MBProgressHUD showError:YZMsg(@"邀请码不能为空")];
            return;
        }
        [self uploadInvitationV];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:YZMsg(@"取消")style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    NSString *version = [UIDevice currentDevice].systemVersion;
    
    if (version.doubleValue < 9.0) {
        
    }
    else{
        [defaultAction setValue:normalColors forKey:@"_titleTextColor"];
        [cancelAction setValue:normalColors forKey:@"_titleTextColor"];
    }
    [alertController addAction:defaultAction]; [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
//获取网络数据
-(void)pullInternet{
    
    NSString *url = [purl stringByAppendingFormat:@"service=%@",_url];
    NSDictionary *follow = @{
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken]
                             };
    NSString *newUrlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:newUrlStr parameters:follow progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"];
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"]) {
                //关注
                if ([_url isEqual:@"Home.getFollow"]) {
                    NSArray *info = [data valueForKey:@"info"];
                    _infoArray = info;
                    if (_infoArray.count == 0) {
                        imageV.hidden = NO;
                    }else {
                        imageV.hidden = YES;
                    }
                } else{
                    //热门
                    NSArray *info = [[data valueForKey:@"info"] objectAtIndex:0];
                    NSArray *list = [info valueForKey:@"list"];
                    _infoArray = list;
                    self.CarouselArray = [info valueForKey:@"slide"];
                    [myview reload:self.CarouselArray];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView.mj_header endRefreshing];
                    [_tableView reloadData];
                });
            }
            else{
                [_tableView.mj_header endRefreshing];
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
            }
        }
        NoInternetImageV.hidden = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_tableView.mj_header endRefreshing];
        
        if (_infoArray.count == 0) {
            NoInternetImageV.hidden = NO;
        }
    }];
}
#pragma mark - 刷新
- (void)refresh
{
    [self pullInternet];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    indexpath = self.zhuboModel.count;
    return self.zhuboModel.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
//    hotCell *cell = [hotCell cellWithTableView:tableView];
    
    AntHotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[AntHotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[_infoArray objectAtIndex:indexPath.row]];
    AnthotModel *model = [AnthotModel modelWithDic:dic];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}
//轮播图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([_url isEqual:@"Home.getFollow"]) {
        return nil;
    }
    return myview;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([_url isEqual:@"Home.getFollow"]) {
        return 0;
    }
    return 130;
}
//表头间距
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _window_width + 60;
}
//进入房间
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selected = (int)indexPath.row;
    selectedDic = _infoArray[indexPath.row];
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
        [MBProgressHUD showError:YZMsg(@"无网络")];
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
                }
                else if ([type isEqual:@"2"] || [type isEqual:@"3"]){
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
    
    SpectatorRoomVC *player = [[SpectatorRoomVC alloc]init];
    player.scrollarray = _infoArray;
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
        [_tableView.mj_header endRefreshing];
        [MBProgressHUD showError:YZMsg(@"无网络")];
    }];
}
-(void)jumpWebView:(NSString *)url
{
    jumpSlideContent *jumpC = [[jumpSlideContent alloc] init];
    jumpC.url = url;
    [[MXBADelegate sharedAppDelegate] pushViewController:jumpC animated:YES];
}
-(void)uploadInvitationV{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.setDistribut"];
    NSDictionary *subdic =@{
                            @"uid":[Config getOwnID],
                            @"token":[Config getOwnToken],
                            @"code":minstr(codetextfield.text)
                            };
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSDictionary *subdic = [[data valueForKey:@"info"] firstObject];
                [MBProgressHUD showSuccess:minstr([subdic valueForKey:@"msg"])];
            }
            else{
                [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}
@end
