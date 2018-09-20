#import "AntUserInfoViewController.h"
#import "YBUserInfoListTableViewCell.h"
#import "YBPersonTableViewCell.h"
#import "YBPersonTableViewModel.h"
#import "backLiveVC.h"
#import "AntFansVC.h"
#import "AntFollowVC.h"
#import "myInfoEdit.h"
#import "setView.h"
#import "ProfitViewC.h"
#import "AntCoinVeiw.h"
#import "antWebH5.h"
#import "antLiveMarket.h"
#import "equipmentVC.h"
#import "AntAppDelegate.h"
#import "AntLoginTypeVC.h"
#import "MyVideoList.h"
#import "NetWork.h"
#import "UserinfoHeaderView.h"


@interface AntUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UserinfoHeaderViewDelegate,UIAlertViewDelegate>
{
    NSArray *listArr;
    NSMutableArray *_dataSource;
    NSMutableArray *_shadowViewArr;
    NSDictionary *selectDic;
    CGFloat _shadowTop;
}
@property (nonatomic, assign, getter=isOpenPay) BOOL openPay;
@property (nonatomic,strong)NSDictionary *infoArray;//个人信息
@property (nonatomic, strong) YBPersonTableViewModel *model;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UserinfoHeaderView * headerView;
@property (nonatomic, strong) AntLiveNavigationBar * navigationBar;
@property (nonatomic, strong) UIView * shadowView1;
@property (nonatomic, strong) UIView * shadowView2;
@property (nonatomic, strong) UIView * shadowView3;

@end
@implementation AntUserInfoViewController
-(void)getPersonInfo{
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSNumber *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];//本地 build
    //NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];version
    //NSLog(@"当前应用软件版本:%@",appCurVersion);
//    NSString *build = [NSString stringWithFormat:@"%@",app_build];
    //这个地方传版本号，做上架隐藏，只有版本号跟后台一致，才会隐藏部分上架限制功能，不会影响其他正常使用客户(后台位置：私密设置-基本设置 -IOS上架版本号)
    
    NSString *userBaseUrl = [purl stringByAppendingFormat:@"service=User.getBaseInfo&uid=%@&token=%@&version_ios=1000",[Config getOwnID],[Config getOwnToken]];
    [NetWork POSTWithURLString:userBaseUrl Parameters:nil HUD:NO successBlock:^(NSDictionary *responseDic, NSError *error) {
        LiveUser *user = [Config myProfile];
        NSDictionary *info = [[responseDic valueForKey:@"info"] firstObject];
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
        _headerView.model = _model;
        NSArray *list = [info valueForKey:@"list"];
        listArr = list;
        [common savepersoncontroller:listArr];//保存在本地，防止没网的时候不显示
        [self reloadViewsWithData:list];
    } failure:^BOOL(NSString *code, NSString *msg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadViewsWithData:[NSArray arrayWithArray:[common getpersonc]]];
        });
        return YES;
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getPersonInfo];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    listArr = [NSArray arrayWithArray:[common getpersonc]];
    _dataSource = [[NSMutableArray alloc]init];
    _shadowViewArr = [[NSMutableArray alloc]init];
    
    [self setUI];
    [self reloadViewsWithData:[NSArray arrayWithArray:[common getpersonc]]];
}


//MARK:-设置tableView
-(void)setUI
{
    _shadowView1 = [self shadowView];
    _shadowView2 = [self shadowView];
    _shadowView3 = [self shadowView];
    
    _headerView = [[UserinfoHeaderView alloc]init];
    _headerView.delegate = self;
    
    [self.tableView registerClass:[YBPersonTableViewCell class] forCellReuseIdentifier:@"YBPersonTableViewCell"];
    [self.tableView registerClass:[YBUserInfoListTableViewCell class] forCellReuseIdentifier:@"YBUserInfoListTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80+iPhoneX_Bottom)];
    self.tableView.tableHeaderView = _headerView;
    self.tableView.bounces = NO;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.view.backgroundColor = RGB(248, 248, 248);
    
    _navigationBar = [self createNavigationBarWithTitle:YZMsg(@"个人中心") type:NavigationBarTypeGradual];
    _navigationBar.backButton.hidden = YES;
    _navigationBar.alpha = 0;
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
}

-(UIView *)shadowView{
    UIView * shadowView = [[UIView alloc]init];
    shadowView.backgroundColor = [UIColor whiteColor];
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowOpacity = 0.1;
    shadowView.layer.shadowRadius = 10;
    shadowView.layer.cornerRadius = 8;
    shadowView.userInteractionEnabled = NO;
    [self.view addSubview:shadowView];
    [self.view sendSubviewToBack:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0);
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
    }];
    [_shadowViewArr addObject:shadowView];
    return shadowView;
}

-(void)reloadViewsWithData:(NSArray *)data{
    _shadowTop = _headerView.mj_h + 20;
    [_dataSource removeAllObjects];
    
    NSMutableArray * list1 = [[NSMutableArray alloc]initWithCapacity:6];
    NSMutableArray * list2 = [[NSMutableArray alloc]initWithCapacity:2];
    NSMutableArray * list3 = [[NSMutableArray alloc]initWithCapacity:2];
    
    for (int i = 0; i < listArr.count; i++) {
        NSDictionary * dic = listArr[i];
        NSInteger ID = [dic[@"id"] integerValue];
        if (ID == 1 || ID == 2 || ID == 15 || ID == 3 || ID == 14 || ID == 11) {
            [list1 addObject:dic];
            continue;
        }
        if (ID == 4 || ID == 8) {
            [list2 addObject:dic];
            continue;
        }
        if (ID == 12 || ID == 13) {
            [list3 addObject:dic];
            continue;
        }
    }
    
    [_dataSource addObject:list1];
    [_dataSource addObject:list2];
    [_dataSource addObject:list3];
    
   
    
    for (int i = 0; i < _dataSource.count; i++) {
        UIView * shadow = _shadowViewArr[i];
        NSArray * list = _dataSource[i];
        
        shadow.hidden = IsEmptyList(list);
        shadow.mj_h = list.count * 50;
    }
    
    _shadowView1.mj_y = -self.tableView.contentOffset.y + _headerView.mj_h + 20;
    _shadowView2.mj_y = _shadowView1.mj_y + _shadowView1.mj_h+20;
    _shadowView3.mj_y = _shadowView2.mj_y + _shadowView2.mj_h+20;
    
    [_tableView reloadData];
}
//MARK:-tableviewDateSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * list = _dataSource[section];
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBUserInfoListTableViewCell *cell = [YBUserInfoListTableViewCell cellWithTabelView:tableView];
    NSArray * list = _dataSource[indexPath.section];
    NSDictionary *subdic = list[indexPath.row];
    cell.nameL.text = minstr([subdic valueForKey:@"name"]);
    int selectedid = [subdic[@"id"] intValue];//选项ID
    
    switch (selectedid) {
            //原生页面无法动态添加
        case 1:
            cell.iconImage.image = [UIImage imageNamed:@"Collection"];
            break;
        case 2:
            cell.iconImage.image = [UIImage imageNamed:@"Diamonds"];
            break;
        case 3:
            cell.iconImage.image = [UIImage imageNamed:@"Grade"];
            break;
        case 4:
            cell.iconImage.image = [UIImage imageNamed:@"ShoppingMall"];
            break;
        case 8:
            cell.iconImage.image = [UIImage imageNamed:@"distribution"];
            break;
        case 11:
            cell.iconImage.image = [UIImage imageNamed:@"Authentication"];
            break;
        case 12:
            cell.iconImage.image = [UIImage imageNamed:@"us"];
            break;
        case 13:
            cell.iconImage.image = [UIImage imageNamed:@"setting"];
            break;
        case 14:
            cell.iconImage.image = [UIImage imageNamed:@"Detailed"];
            break;
        case 15:
            cell.iconImage.image = [UIImage imageNamed:@"video"];
            break;
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
#warning 根据ID判断 进入 哪个页面（ID 不可随意更改（服务端，客户端））
    NSArray * list = _dataSource[indexPath.section];
    selectDic = list[indexPath.row];
    int selectedid = [selectDic[@"id"] intValue];//选项ID
    NSString *url = [NSString stringWithFormat:@"%@",[selectDic valueForKey:@"href"]];
    if (url.length >9) {
        [self pushH5Webviewinfo:selectDic];
    }
    else{
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

-(void)pushH5Webviewinfo:(NSDictionary *)subdic{
    NSString *url = minstr([subdic valueForKey:@"href"]);
    if (url.length >9) {
    antWebH5 *VC = [[antWebH5 alloc]init];
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
    VC.titleStr = minstr([selectDic valueForKey:@"name"]);
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//我的钻石
-(void)MyDiamonds{
    AntCoinVeiw *VC = [[AntCoinVeiw alloc]init];
    VC.titleStr = minstr([selectDic valueForKey:@"name"]);
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//商城
-(void)ShoppingMall{
    antLiveMarket *VC = [[antLiveMarket alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//装备中心
-(void)Myequipment{
    equipmentVC *VC = [[equipmentVC alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//设置
-(void)SetUp{
    setView *VC = [[setView alloc]init];
    VC.titleStr = minstr([selectDic valueForKey:@"name"]);
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
//我的视频
-(void)myVideo{
    NSString *url = [purl stringByAppendingFormat:@"service=Video.getMyVideo&uid=%@&token=%@",[Config getOwnID],[Config getOwnToken]];
    MyVideoList *VC = [[MyVideoList alloc]init];
    VC.url = url;
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}

//MARK:-懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,_window_width,_window_height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
-(void)pushLiveNodeList{
    backLiveVC *list = [[backLiveVC alloc]init];
    [[MXBADelegate sharedAppDelegate] pushViewController:list animated:YES];
}
-(void)pushFansList{
    AntFansVC *fans = [[AntFansVC alloc]init];
    fans.fensiUid = [Config getOwnID];
    [[MXBADelegate sharedAppDelegate] pushViewController:fans animated:YES];
}
-(void)pushAttentionList{
    AntFollowVC *attention = [[AntFollowVC alloc]init];
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
    AntAppDelegate *app2 = (AntAppDelegate *)app.delegate;
    AntLoginTypeVC *login = [[AntLoginTypeVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    app2.window.rootViewController = nav;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y <=0) {
        _navigationBar.alpha = 0;
    }else if (scrollView.contentOffset.y >=0 && scrollView.contentOffset.y <=100) {
        _navigationBar.alpha = scrollView.contentOffset.y/100;
    }else{
        _navigationBar.alpha = 1;
    }
    
    _shadowView1.mj_y = -scrollView.contentOffset.y + _headerView.mj_h + 20;
    _shadowView2.mj_y = _shadowView1.mj_y + _shadowView1.mj_h+20;
    _shadowView3.mj_y = _shadowView2.mj_y + _shadowView2.mj_h+20;
}

@end
