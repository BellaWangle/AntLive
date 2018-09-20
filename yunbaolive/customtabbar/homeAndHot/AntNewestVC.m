#import "AntNewestVC.h"
#import "UIImageView+WebCache.h"
#import "antNewCell.h"
#import "SpectatorRoomVC.h"
#import "AntAppDelegate.h"
#import "tuijianwindow.h"
#import "NetWork.h"
#import "UIImageView+WebCache.h"
@import CoreLocation;
@interface AntNewestVC ()<UICollectionViewDataSource,UICollectionViewDelegate,CLLocationManagerDelegate,UICollectionViewDelegateFlowLayout,tuijian>
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
    tuijianwindow *tuijianw;
    UIAlertController *alertController;//邀请码填写
    UITextField *codetextfield;

}
@property(nonatomic,strong)NSArray *allArray;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSString *MD5;
@end
@implementation AntNewestVC
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    type_val = @"0";
    livetype = @"0";
    
    self.allArray = [NSArray array];
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.itemSize = CGSizeMake(_window_width/2, _window_width/2);
    flow.minimumLineSpacing = 3;
    flow.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height - 114 -statusbarHeight-iPhoneX_Bottom) collectionViewLayout:flow];
    
//    [self.collectionView registerNib:[UINib nibWithNibName:@"antNewCell" bundle:nil] forCellWithReuseIdentifier:@"antNewCell"];
    [self.collectionView registerClass:[antNewCell class] forCellWithReuseIdentifier:@"antNewCell"];
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    self.collectionView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    [self.view addSubview:self.collectionView];
    [self createView];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    if ([_url isEqual:@"Home.getHot"]) {
        [self yaoqingma];
    }
    
    [self.collectionView.mj_header beginRefreshing];
}

-(void)createView{
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

-(void)loadData{
    if (!_isHot) {
        [self pullInternetforNew];
    }else{
        [self pullInternetForHot];
    }
}
-(void)pullInternetforNew{
    _url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [NetWork POSTWithURLString:_url Parameters:nil HUD:NO successBlock:^(NSDictionary *responseDic, NSError *error) {
        NSArray *info = [responseDic valueForKey:@"info"];
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
        NoInternetImageV.hidden = YES;
    } failure:^BOOL(NSString *code, NSString *msg) {
        NoInternetImageV.hidden = YES;
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        _nothingView.hidden = YES;
        if (self.allArray.count == 0) {
            [self.collectionView reloadData];
            NoInternetImageV.hidden = NO;
        }
        return YES;
    }];
}

//获取网络数据
-(void)pullInternetForHot{
    NSDictionary *follow = @{
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken]
                             };
    NSString *newUrlStr = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [NetWork POSTWithURLString:newUrlStr Parameters:follow HUD:NO successBlock:^(NSDictionary *responseDic, NSError *error) {
        //热门
        [self.collectionView.mj_header endRefreshing];
        NSArray *info = [[responseDic valueForKey:@"info"] objectAtIndex:0];
        NSArray *list = [info valueForKey:@"list"];
        self.allArray = list;
        if (_allArray.count == 0) {
            _nothingView.hidden = NO;
        }
        else{
            _nothingView.hidden = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView reloadData];
        });
        NoInternetImageV.hidden = YES;
    } failure:^BOOL(NSString *code, NSString *msg) {
        NoInternetImageV.hidden = YES;
        [self.collectionView.mj_header endRefreshing];
        _nothingView.hidden = YES;
        if (self.allArray.count == 0) {
            [self.collectionView reloadData];
            NoInternetImageV.hidden = NO;
        }
        return YES;
    }];
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



#pragma mark - Table view data source




-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    antNewCell *cell = (antNewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"antNewCell" forIndexPath:indexPath];
    NSDictionary *subdic = self.allArray[indexPath.row];
    cell.titleLabel.text = [subdic valueForKey:@"user_nicename"];
    NSString *path = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"thumb"]];
    if (path) {
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"default_head"] options:SDWebImageRefreshCached];
    }
    else{
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[subdic valueForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"default_head"] options:SDWebImageRefreshCached];
    }
    NSInteger type = [[subdic valueForKey:@"type"] integerValue];
    cell.typeView.liveType = type;
    cell.statusView.titleLabel.text = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"nums"]];

    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((_window_width-15)/2,(_window_width-15)/2);
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
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
        [self.collectionView.mj_header endRefreshing];
    }];
}
@end

