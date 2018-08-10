

#import "setView.h"
#import "InfoEdit2TableViewCell.h"
#import "ZFModalTransitionAnimator.h"
#import "userItemCell5.h"
#import "getpasswangViewController.h"
#import "UserLoginVC.h"
#import "AppDelegate.h"
#import "SwitchLanguage.h"
@interface setView ()<UITableViewDataSource,UITableViewDelegate>
{
    int setvissssaaasas;
    int isNewBuid;//判断是不是最新版本
}
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@end
@implementation setView
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = RGB(246, 246, 246);
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.frame = CGRectMake(0, 64+statusbarHeight, _window_width, _window_height - 64 - statusbarHeight);
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvissssaaasas = 0;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    setvissssaaasas = 1;
    self.navigationController.navigationBarHidden = YES;

    [self navtion];
    [self.tableView reloadData];
}
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0,0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor = [UIColor whiteColor];
    UILabel *labels = [[UILabel alloc]init];
    labels.text = _titleStr;
    [labels setFont:navtionTitleFont];
    labels.textColor = navtionTitleColor;
    labels.frame = CGRectMake(0,statusbarHeight,_window_width,84);
    labels.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:labels];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor whiteColor];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, statusbarHeight, _window_width/2, 64)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
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
}
-(void)doReturn{    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIFont *font = [UIFont fontWithName:@"Heiti SC" size:15];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
                InfoEdit2TableViewCell *cell = [InfoEdit2TableViewCell cellWithTableView:tableView];
                cell.labContrName.text =YZMsg(@"修改密码");
                cell.labContrName.font = font;
                cell.labDetail.text = @"";
                return cell;
        }else if (indexPath.row == 1) {
            InfoEdit2TableViewCell *cell = [InfoEdit2TableViewCell cellWithTableView:tableView];
            cell.labContrName.text =YZMsg(@"切换语言");
            cell.labContrName.font = font;
            cell.labDetail.text = @"";
            return cell;
        }
        else
            {
                InfoEdit2TableViewCell *cell = [InfoEdit2TableViewCell cellWithTableView:tableView];
                cell.labContrName.text =YZMsg(@"检查更新");
                cell.labContrName.font = font;
                NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];//本地的版本号
                NSString *hisBuild = [common ipa_ver];//远程存储的版本号
                NSNumber *local = (NSNumber *)build;
                NSNumber *internet = (NSNumber *)hisBuild;
                NSComparisonResult r = [local compare:internet];
                if (r == NSOrderedAscending || r == NSOrderedDescending) {//可改为if(r == -1L)
                    NSMutableAttributedString *attributeall = [[NSMutableAttributedString alloc]init];
                    NSString *string = [NSString stringWithFormat:@"%.1f",local.floatValue];
                    NSMutableAttributedString *version = [[NSMutableAttributedString alloc]initWithString:string];
                    [attributeall appendAttributedString:version];
                    NSMutableAttributedString *now = [[NSMutableAttributedString alloc]initWithString:YZMsg(@"(当前版本可更新)")];
                    [attributeall appendAttributedString:now];
                    [attributeall addAttribute:NSForegroundColorAttributeName value:normalColors range:NSMakeRange(0, version.length)];
                    cell.labDetail.attributedText = attributeall;
                    isNewBuid = 1;
                }
                else{
                    isNewBuid = 0;
                    //(当前已是最新版本)
                    NSMutableAttributedString *attributeall = [[NSMutableAttributedString alloc]init];
                    NSString *string = [NSString stringWithFormat:@"%.1f",local.floatValue];
                    NSMutableAttributedString *version = [[NSMutableAttributedString alloc]initWithString:string];
                    [attributeall appendAttributedString:version];
                    NSMutableAttributedString *now = [[NSMutableAttributedString alloc]initWithString:YZMsg(@"(当前已是最新版本)")];
                    [attributeall appendAttributedString:now];
                    [attributeall addAttribute:NSForegroundColorAttributeName value:normalColors range:NSMakeRange(0, version.length)];
                    cell.labDetail.attributedText = attributeall;
                }
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                //ios_shelves 为上架版本号，与本地一致则为上架版本,需要隐藏一些东西
                NSNumber *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];//本地 build
                NSString *buildsss = [NSString stringWithFormat:@"%@",app_build];
                if (![[common ios_shelves] isEqual:buildsss]) {
                    cell.hidden = NO;
                    
                }else
                {
                    cell.hidden = YES;
                }
                return cell;
            }
        }
    else
    {
        userItemCell5 *cell = [userItemCell5 cellWithTableView:tableView];
        cell.llllLabel.text = YZMsg(@"退出登录");

        return cell;
    
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //判断当前分区返回分区行数
    if (section == 0 ) {
        return 3;
    }
    else
    {
        return 1;
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
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                //修改密码
                getpasswangViewController *tuisong = [[getpasswangViewController alloc]init];
                [self.navigationController pushViewController:tuisong animated:YES];
            }
                break;
            case 1:
            {
                SwitchLanguage *tuisong = [[SwitchLanguage alloc]init];
                [self.navigationController pushViewController:tuisong animated:YES];

            }
                break;
            case 2:
            {
                //版本更新
                [self getbanben];
            }
                break;
   
        }    }
    else if (indexPath.section == 1){
        [self quitLogin];
    }
    
}
-(void)getbanben{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSNumber *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];//本地
    NSNumber *build = (NSNumber *)[common ipa_ver];//远程
    NSComparisonResult r = [app_build compare:build];
if (r == NSOrderedAscending || r == NSOrderedDescending) {//可改为if(r == -1L)
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[common app_ios]]];
            [MBProgressHUD hideHUD];
    }else if(r == NSOrderedSame) {//可改为if(r == 0L)
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"当前已是最新版本") message:nil delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
                    [alert show];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)clearTmpPics
{
    [[SDImageCache sharedImageCache] clearDisk];
 
}
//MARK:-设置tableivew分割线
-(void)setTableViewSeparator
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPa
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
//退出登录函数
-(void)quitLogin
{
    NSString *aliasStr = [NSString stringWithFormat:@"youke"];
    [JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
    [JMSGUser logout:^(id resultObject, NSError *error) {
        if (!error) {
            NSLog(@"极光IM退出登录成功");
        } else {
            NSLog(@"极光IM退出登录失败");
        }
    }];
    
    [Config clearProfile];
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = (AppDelegate*)app.delegate;
    UserLoginVC *login = [[UserLoginVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    app2.window.rootViewController = nav;
}
@end
