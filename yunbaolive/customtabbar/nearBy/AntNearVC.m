//
//  NearVC.m
//  yunbaolive
//
//  Created by YunBao on 2018/2/1.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "AntNearVC.h"

#import "UIImageView+WebCache.h"
#import "SpectatorRoomVC.h"
#import "AntAppDelegate.h"
#import "AntNearbyCell.h"
#import "searchVC.h"

@import CoreLocation;

@interface AntNearVC ()<UICollectionViewDataSource,UICollectionViewDelegate,CLLocationManagerDelegate,UICollectionViewDelegateFlowLayout,JMessageDelegate>
{
    CLLocationManager   *_NearByManager;
    UIView *_nothingView;
    NSDictionary *selectedDic;
    int selected;
    UIAlertView *coastAlert;
    UIAlertView *secretAlert;
    UIImageView *NoInternetImageV;
    NSString *type_val;//
    NSString *livetype;//
}
@property(nonatomic,strong)NSArray *allArray;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSString *MD5;

@end

@implementation AntNearVC

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self pullInternet];
    
    [self getUnreadNums];
}
-(void)getUnreadNums{
    [self labeiHid];
}
-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    //显示消息数量
    [self labeiHid];
}
-(void)onUnreadChanged:(NSUInteger)newCount{
    [self labeiHid];
}
-(void)labeiHid{
    unRead = [[JMSGConversation getAllUnreadCount] intValue];
    label.text = [NSString stringWithFormat:@"%d",unRead];
    if ([label.text isEqual:@"0"]) {
        label.hidden =YES;
    }else{
        label.hidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.navigationController.navigationBarHidden = YES;
    [self creatNavi];
    
    type_val = @"0";
    livetype = @"0";
    self.allArray = [NSArray array];
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.itemSize = CGSizeMake(_window_width/2, _window_width/2);
    flow.minimumLineSpacing = 3;
    flow.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64+statusbarHeight, _window_width, _window_height - 114 -statusbarHeight-ShowDiff) collectionViewLayout:flow];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"AntNearbyCell" bundle:nil] forCellWithReuseIdentifier:@"fujincell"];
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    self.collectionView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullInternet)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    [self.view addSubview:self.collectionView];
    [self createViewNothing];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //获取所有未读消息
    [JMessage addDelegate:self withConversation:nil];
    [self getUnreadNums];
    
}

-(void)createViewNothing{
    _nothingView = [[UIView alloc] initWithFrame:CGRectMake(0.2 * _window_width, 0.2 * _window_height, 0.6 * _window_width, 0.5 * _window_height)];
    _nothingView.backgroundColor = [UIColor clearColor];
    [self.collectionView addSubview:_nothingView];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0.15 * _window_width,0, 0.3 * _window_width, 0.3 * _window_width)];
    imageV.image = [UIImage imageNamed:@"nothing.png"];
    [_nothingView addSubview:imageV];
    _nothingView.hidden = YES;
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = YZMsg(@"现在还没有主播");
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont fontWithName:@"Heiti SC" size:18];
    label1.backgroundColor = [UIColor clearColor];
    label1.textAlignment = NSTextAlignmentCenter;
    [_nothingView addSubview:label1];
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = YZMsg(@"快快开启你的直播吧");
    label2.font = [UIFont fontWithName:@"Heiti SC" size:16];
    label2.textColor = [UIColor grayColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [_nothingView addSubview:label2];
    label1.frame = CGRectMake(0, imageV.bottom, _window_width*0.6, 20);
    label2.frame = CGRectMake(0, imageV.bottom + 30,_window_width*0.6,20);
    
    
    
    NoInternetImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0.3 * _window_width, 0.2 * _window_height, 0.4 * _window_width, 0.4 * _window_width)];
    NoInternetImageV.contentMode = UIViewContentModeScaleAspectFit;
    NoInternetImageV.image = [UIImage imageNamed:@"shibai"];
    [self.collectionView addSubview:NoInternetImageV];
    NoInternetImageV.hidden = YES;
    
}
-(void)pullInternet{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *postUrl = [purl stringByAppendingFormat:@"service=Home.getNearby&lng=%@&lat=%@&city=%@",[locationCache getMylng],[locationCache getMylat],[locationCache getMyCity]];
    postUrl = [postUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [session POST:postUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSArray *info = [data valueForKey:@"info"];
                self.allArray = info;
                if (info.count == 0) {
                    _nothingView.hidden = NO;
                }
                else{
                    _nothingView.hidden = YES;
                }
                //加载成功 停止刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView.mj_header endRefreshing];
                    [self.collectionView reloadData];
                });
                
            }
            else{
                [self.collectionView.mj_header endRefreshing];
            }
        }
        NoInternetImageV.hidden = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        _nothingView.hidden = YES;
        if (self.allArray.count == 0) {
            [self.collectionView reloadData];
            NoInternetImageV.hidden = NO;
        }
    }];
}
#pragma mark - Table view data source
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(_window_width/2-1.5,_window_width/2-1.5 + 20);
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allArray.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    AntNearbyCell *cell = (AntNearbyCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"fujincell" forIndexPath:indexPath];
    NSDictionary *subdic = self.allArray[indexPath.row];
    cell.namel.text = [subdic valueForKey:@"user_nicename"];
    cell.liveImgView.image = [UIImage imageNamed:getImagename(@"直播live")];
    NSString *path = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"thumb"]];
    if (path) {
        [cell.thumbimagev sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"bg1"] options:SDWebImageRefreshCached];
    }
    else{
        [cell.thumbimagev sd_setImageWithURL:[NSURL URLWithString:[subdic valueForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"bg1"] options:SDWebImageRefreshCached];
    }
    cell.cityl.text = minstr([subdic valueForKey:@"city"]);
    cell.distanceL.text = minstr([subdic valueForKey:@"distance"]);
    
    int type = [[subdic valueForKey:@"type"] intValue];
    // 0是一般直播，1是私密直播，2是收费直播，3是计时直播
    switch (type) {
        case 0:
            [cell.typeimagev setImage:[UIImage imageNamed:getImagename(@"icon_live_type_normal")]];
            break;
        case 1:
            [cell.typeimagev setImage:[UIImage imageNamed:getImagename(@"icon_live_type_pwd")]];
            break;
        case 2:
            [cell.typeimagev setImage:[UIImage imageNamed:getImagename(@"icon_live_type_charge")]];
            break;
        case 3:
            [cell.typeimagev setImage:[UIImage imageNamed:getImagename(@"icon_live_type_time_charge")]];
        default:
            break;
    }
    
   
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    selected = (int)indexPath.row;
    selectedDic = self.allArray[indexPath.row];
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
    SpectatorRoomVC *player = [[SpectatorRoomVC alloc]init];
    player.scrollarray = self.allArray;
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
        if([number isEqualToNumber:[NSNumber numberWithInt:200]]) {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"]) {
                [self pushMovieVC];
            }else{
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
    }];
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
    midLabel.text = YZMsg(@"附近");
    midLabel.textAlignment = NSTextAlignmentCenter;
    [navi addSubview:midLabel];
    
    //搜索按钮
    UIButton *searchBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBTN setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    searchBTN.frame = CGRectMake(20,35 +statusbarHeight,15,15);
    searchBTN.contentMode = UIViewContentModeScaleAspectFit;
    [searchBTN addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:searchBTN];
    UIButton *searchBTNs = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBTNs.frame = CGRectMake(0,0,60,60);
    searchBTNs.contentMode = UIViewContentModeScaleAspectFit;
    [searchBTNs addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:searchBTNs];
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    messageBtn.frame = CGRectMake(_window_width-35,35 +statusbarHeight,20,15);
    messageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [messageBtn setImage:[UIImage imageNamed:@"ic_message"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:messageBtn];
    UIButton *messageBtns = [UIButton buttonWithType:UIButtonTypeCustom];
    messageBtns.frame = CGRectMake(_window_width-60,0,60,60);
    messageBtns.contentMode = UIViewContentModeScaleAspectFit;
    [messageBtns addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:messageBtns];
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, -5, 16, 16)];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8;
    label.hidden = YES;
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    label.text = [NSString stringWithFormat:@"%d",unRead];
    label.textAlignment = NSTextAlignmentCenter;
    [messageBtn addSubview:label];
    
}

-(void)messageBtnClick{
    messageC *MC = [[messageC alloc]init];
    [[MXBADelegate sharedAppDelegate]pushViewController:MC animated:YES];
}
-(void)search{
    searchVC *search = [[searchVC alloc]init];
    [[MXBADelegate sharedAppDelegate]pushViewController:search animated:YES];
}
@end
