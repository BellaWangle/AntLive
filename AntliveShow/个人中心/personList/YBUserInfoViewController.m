#import "YBUserInfoViewController.h"
#import "YBUserInfoListTableViewCell.h"
#import "YBPersonTableViewCell.h"
#import "YBPersonTableViewModel.h"
#import "LiveNodeViewController.h"
#import "fansViewController.h"
#import "attrViewController.h"
#import "myInfoEdit.h"
#import "setView.h"
#import "ProfitViewC.h"
#import "CoinVeiw.h"
#import "webH5.h"
#import "market.h"
#import "equipment.h"
#import "AppDelegate.h"
#import "UserLoginVC.h"
#import "MyVideoListVC.h"
@interface YBUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,personInfoCellDelegate,UIAlertViewDelegate>
{
    NSArray *_listArr;
    NSDictionary *_selectDic;
}
@property (nonatomic, assign, getter=isOpenPay) BOOL openPay;
@property (nonatomic,strong)NSDictionary *infoArray;//个人信息
@property (nonatomic, strong) YBPersonTableViewModel *model;
@property (nonatomic, strong) UITableView *tableView;
@end
@implementation YBUserInfoViewController
-(void)getPersonInfo{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSNumber *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];//本地 build
    //NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];version
    //NSLog(@"当前应用软件版本:%@",appCurVersion);
    NSString *build = [NSString stringWithFormat:@"%@",app_build];
    //这个地方传版本号，做上架隐藏，只有版本号跟后台一致，才会隐藏部分上架限制功能，不会影响其他正常使用客户(后台位置：私密设置-基本设置 -IOS上架版本号)
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *userBaseUrl = [purl stringByAppendingFormat:@"service=User.getBaseInfo&uid=%@&token=%@&version_ios=%@",[Config getOwnID],[Config getOwnToken],build];
    [session GET:userBaseUrl parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"])
            {
                
                LiveUser *user = [Config myProfile];
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                self.infoArray = info;
                user.user_nicename = minstr([info valueForKey:@"user_nicename"]);
                user.sex = minstr([info valueForKey:@"sex"]);
                user.level =minstr([info valueForKey:@"level"]);
                user.avatar = minstr([info valueForKey:@"avatar"]);
                user.city = minstr([info valueForKey:@"city"]);
                user.level_anchor = minstr([info valueForKey:@"level_anchor"]);
                [Config updateProfile:user];
                //保存靓号和vip信息
                NSDictionary *liang = [info valueForKey:@"liang"];
                NSString *liangnum = minstr([liang valueForKey:@"name"]);
                NSDictionary *vip = [info valueForKey:@"vip"];
                NSString *type = minstr([vip valueForKey:@"type"]);
                NSDictionary *subdic = [NSDictionary dictionaryWithObjects:@[type,liangnum] forKeys:@[@"vip_type",@"liang"]];
                [Config saveVipandliang:subdic];
                _model = [YBPersonTableViewModel modelWithDic:info];
                NSArray *list = [info valueForKey:@"list"];
                _listArr = list;
                [self restListArr];
                [common savepersoncontroller:_listArr];//保存在本地，防止没网的时候不显示
            }
            if ([code isEqual:@"700"]) {
                [self quitLogin];
            }
            else{
                _listArr = [NSArray arrayWithArray:[common getpersonc]];
                [self restListArr];
            }
        }
        else{
            _listArr = [NSArray arrayWithArray:[common getpersonc]];
            [self restListArr];
        }
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         _listArr = [NSArray arrayWithArray:[common getpersonc]];
         [self restListArr];
     }];
}

-(void)restListArr{
    NSMutableArray * list = [[NSMutableArray alloc]init];
    for (NSDictionary * dic in _listArr) {
        int selectedid = [dic[@"id"] intValue];//选项ID
        if (selectedid == 15 || selectedid == 13 || selectedid == 12 || selectedid == 14 || selectedid == 3) {
            [list addObject:dic];
        }
    }
    _listArr = list;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getPersonInfo];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    [self creatNavi];
    _listArr = [NSArray arrayWithArray:[common getpersonc]];
    [self restListArr];
    [self setUI];
    
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
//MARK:-设置tableView
-(void)setUI
{
    [self.tableView registerClass:[YBPersonTableViewCell class] forCellReuseIdentifier:@"YBPersonTableViewCell"];
    [self.tableView registerClass:[YBUserInfoListTableViewCell class] forCellReuseIdentifier:@"YBUserInfoListTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.tableView.tableHeaderView = [[UIView alloc]init];
    self.tableView.bounces = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.view.backgroundColor = RGB(248, 248, 248);
}
//MARK:-tableviewDateSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)//102
    {
        YBPersonTableViewCell *cell = [YBPersonTableViewCell cellWithTabelView:tableView];
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[Config getavatar]]];
        cell.nameLabel.text = [Config getOwnNicename];
        if ([[Config getSex] isEqual:@"0"]) {
            [cell.sexView setImage:[UIImage imageNamed:@"sex_man"]];
        }
        else{
            [cell.sexView setImage:[UIImage imageNamed:@"sex_woman"]];
        }
        [cell.levelView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"leve%@",[Config getLevel]]]];
        [cell.level_anchorView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"host_%@",[Config level_anchor]]]];
        cell.personCellDelegate = self;
        if (self.infoArray) {
            cell.model = _model;
        }
        return cell;
    }
    else  {
        YBUserInfoListTableViewCell *cell = [YBUserInfoListTableViewCell cellWithTabelView:tableView];
        NSDictionary *subdic = _listArr[indexPath.row];
        cell.nameL.text = minstr([subdic valueForKey:@"name"]);
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:minstr([subdic valueForKey:@"thumb"])]];
        return cell;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return _listArr.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return PXRate(254)+iPhoneX_Top;
    }
        return 50;
}
-(void)pushH5Webviewinfo:(NSDictionary *)subdic{
    NSString *url = minstr([subdic valueForKey:@"href"]);
    if (url.length >9) {
    webH5 *VC = [[webH5 alloc]init];
    VC.titles = minstr([subdic valueForKey:@"name"]);
    VC.urls = [self addurl:url];
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
     }
}
//所有h5需要拼接uid和token
-(NSString *)addurl:(NSString *)url{
    return [url stringByAppendingFormat:@"&uid=%@&token=%@&language=%@",[Config getOwnID],[Config getOwnToken],[Config canshu]];
}
//我的收益
-(void)Myearnings{
    ProfitViewC *VC = [[ProfitViewC alloc]init];
    VC.titleStr = minstr([_selectDic valueForKey:@"name"]);
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//我的钻石
-(void)MyDiamonds{
    CoinVeiw *VC = [[CoinVeiw alloc]init];
    VC.titleStr = minstr([_selectDic valueForKey:@"name"]);
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//商城
-(void)ShoppingMall{
    market *VC = [[market alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//装备中心
-(void)Myequipment{
    equipment *VC = [[equipment alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//设置
-(void)SetUp{
    setView *VC = [[setView alloc]init];
    VC.titleStr = minstr([_selectDic valueForKey:@"name"]);
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//我的视频
-(void)myVideo{
    NSString *url = [purl stringByAppendingFormat:@"service=Video.getMyVideo&uid=%@&token=%@",[Config getOwnID],[Config getOwnToken]];
    MyVideoListVC *VC = [[MyVideoListVC alloc]init];
    VC.url = url;
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    #warning 根据ID判断 进入 哪个页面（ID 不可随意更改（服务端，客户端））
    if (indexPath.section == 1) {
        _selectDic = _listArr[indexPath.row];
        int selectedid = [_selectDic[@"id"] intValue];//选项ID
        NSString *url = [NSString stringWithFormat:@"%@",[_selectDic valueForKey:@"href"]];
        if (url.length >9) {
            [self pushH5Webviewinfo:_selectDic];
        }else{
            /*
             1我的收益  2 我的钻石  4 在线商城 5 装备中心 13 个性设置
             其他页面 都是H5
             */
            switch (selectedid) {
                    //原生页面无法动态添加
                case 1:
                    [self Myearnings];//我的收益
                    break;
                case 2:
                    [self MyDiamonds];//我的钻石
                    break;
                case 4:
                    [self ShoppingMall];//在线商城
                    break;
                case 5:
                    [self Myequipment];//装备中心
                    break;
                case 13:
                    [self SetUp];//设置
                    break;
                case 15:
                    [self myVideo];//我的视频
                    break;
                default:
                    break;
            }
        }
        
    }
    else if (indexPath.section == 2){
        
    }
}//MARK:-懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,_window_width,_window_height + statusbarHeight-ShowDiff-49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(-(ShowDiff+49));
        }];
        
    }
    return _tableView;
}
-(void)pushLiveNodeList{
    LiveNodeViewController *list = [[LiveNodeViewController alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:list animated:YES];
}
-(void)pushFansList{
    fansViewController *fans = [[fansViewController alloc]init];
    fans.fensiUid = [Config getOwnID];
    [[MXBADelegate sharedAppDelegate] pushViewController:fans animated:YES];
}
-(void)pushAttentionList{
    attrViewController *attention = [[attrViewController alloc]init];
    attention.guanzhuUID = [Config getOwnID];
    [[MXBADelegate sharedAppDelegate] pushViewController:attention animated:YES];
}
-(void)pushEditView{
    myInfoEdit *info = [[myInfoEdit alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:info animated:YES];
}
//退出登录函数
-(void)quitLogin
{
    NSString *aliasStr = [NSString stringWithFormat:@"youke"];
    [JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
    [Config clearProfile];
    [JMSGUser logout:^(id resultObject, NSError *error) {
        if (!error) {
            //退出登录成功
        } else {
            //退出登录失败
        }
    }];
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = (AppDelegate *)app.delegate;
    UserLoginVC *login = [[UserLoginVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    app2.window.rootViewController = nav;
}
#pragma mark -
#pragma mark - navi
-(void)creatNavi {
    UIView *navi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64+statusbarHeight)];
    navi.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navi];
    
    //标题
    UILabel *midLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 20+statusbarHeight, _window_width-120, 44)];
    midLabel.backgroundColor = [UIColor clearColor];
    midLabel.font = fontMT(16);
    midLabel.text = YZMsg(@"个人中心");
    midLabel.textAlignment = NSTextAlignmentCenter;
    [navi addSubview:midLabel];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 63.5+statusbarHeight, _window_width, 0.5)];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [navi addSubview:line];
}
@end
