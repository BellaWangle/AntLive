#import "Livebroadcast.h"
#import "toutiaoAnimation.h"
#define upViewW  _window_width*0.8
@import CoreTelephony;
@interface Livebroadcast ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,catSwitchDelegate,haohuadelegate,socketLiveDelegate,listDelegate,upmessageKickAndShutUp,listDelegate,gameDelegate,WPFRotateViewDelegate,shangzhuangdelegate,gameselected,toutiaoDelegate>
@end
@implementation Livebroadcast
{
    NSMutableArray *msgList;
    CGSize roomsize;
    UILabel *roomID;
    toutiaoAnimation *toutiaoView;
    int sssss;

}
-(void)sendBarrage:(NSDictionary *)msg{
    NSString *text = [NSString stringWithFormat:@"%@",[[msg valueForKey:@"ct"] valueForKey:@"content"]];
    NSString *name = [msg valueForKey:@"uname"];
    NSString *icon = [msg valueForKey:@"uhead"];
    NSDictionary *userinfo = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"title",name,@"name",icon,@"icon",nil];
    [danmuview setModel:userinfo];
}
-(void)sendMessage:(NSDictionary *)dic{
    [msgList addObject:dic];
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast:self.tableView];
}
-(void)sendDanMu:(NSDictionary *)dic{
    NSString *text = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"content"]];
    NSString *name = [dic valueForKey:@"uname"];
    NSString *icon = [dic valueForKey:@"uhead"];
    NSDictionary *userinfo = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"title",name,@"name",icon,@"icon",nil];
    [danmuview setModel:userinfo];
    long totalcoin = [self.danmuPrice intValue];//
    [self addCoin:totalcoin];
}
-(void)getZombieList:(NSArray *)list{
    NSArray *arrays =[list firstObject];
    userCount += arrays.count;
    onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
    if (!listView) {
        listView = [[ListCollection alloc]initWithListArray:list andID:[Config getOwnID] andStream:[NSString stringWithFormat:@"%@",[self.roomDic valueForKey:@"stream"]]];
        listView.delegate = self;
        listView.frame = CGRectMake(110, 20+sssss, _window_width-130, 40);
        [frontView addSubview:listView];
    }
      [listView listarrayAddArray:[list firstObject]];
}
-(void)jumpLast:(UITableView *)tableView
{
    if (_canScrollToBottom) {
    NSUInteger sectionCount = [tableView numberOfSections];
    if (sectionCount) {
        
        NSUInteger rowCount = [tableView numberOfRowsInSection:0];
        if (rowCount) {
            
            NSUInteger ii[2] = {0, rowCount - 1};
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
            [tableView scrollToRowAtIndexPath:indexPath
                             atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
    }
}
-(void)quickSort1:(NSMutableArray *)userlist
{
    for (int i = 0; i<userlist.count; i++)
    {
        for (int j=i+1; j<[userlist count]; j++)
        {
            int aac = [[[userlist objectAtIndex:i] valueForKey:@"level"] intValue];
            int bbc = [[[userlist objectAtIndex:j] valueForKey:@"level"] intValue];
            NSDictionary *da = [NSDictionary dictionaryWithDictionary:[userlist objectAtIndex:i]];
            NSDictionary *db = [NSDictionary dictionaryWithDictionary:[userlist objectAtIndex:j]];
            if (aac >= bbc)
            {
                [userlist replaceObjectAtIndex:i withObject:da];
                [userlist replaceObjectAtIndex:j withObject:db];
            }else{
                [userlist replaceObjectAtIndex:j withObject:da];
                [userlist replaceObjectAtIndex:i withObject:db];
            }
        }
    }
}
-(void)socketUserLive:(NSString *)ID and:(NSDictionary *)msg{
    userCount -= 1;
    onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
    if (listView) {
        [listView userLive:msg];
    }
}
-(void)socketUserLogin:(NSString *)ID andDic:(NSDictionary *)dic{
    userCount += 1;
    if (listView) {
        [listView userAccess:dic];
    }
    onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
    if (isjingpaiwriting == YES) {
        
        return;
    }
    //进场动画级别限制
    NSString *levelLimit = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"level"]];
    int levelLimits = [levelLimit intValue];
    int levelLimitsLocal = [[common enter_tip_level] intValue];
    if (levelLimitsLocal >levelLimits) {
    }
    else{
        [useraimation addUserMove:dic];
        useraimation.frame = CGRectMake(10,self.tableView.top - 40,_window_width,20);
    }
    NSString *car_id = minstr([[dic valueForKey:@"ct"] valueForKey:@"car_id"]);
    if (![car_id isEqual:@"0"]) {
        if (!vipanimation) {
            vipanimation = [[viplogin alloc]initWithFrame:CGRectMake(0,_window_height*0.3,_window_width,_window_width*0.4) andBlock:^(id arrays) {
                [vipanimation removeFromSuperview];
                vipanimation = nil;
            }];
            vipanimation.frame =CGRectMake(0,_window_height*0.3,_window_width,_window_width*0.4);
            [self.view insertSubview:vipanimation atIndex:10];
            [self.view bringSubviewToFront:vipanimation];
        }
        [vipanimation addUserMove:dic];
    }
    
    [self userLoginSendMSG:dic];
    
}
//用户进入直播间发送XXX进入了直播间
-(void)userLoginSendMSG:(NSDictionary *)dic {
    titleColor = @"userLogin";
    NSString *uname = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"user_nicename"]];
    NSString *levell = @" ";
    NSString *ID = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"id"]];
    NSString *vip_type = @"0";
    NSString *liangname = @"0";
    NSString *conttt = YZMsg(@" 进入了直播间");
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",conttt,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",vip_type,@"vip_type",liangname,@"liangname",nil];
    [msgList addObject:chat];
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast:self.tableView];
}
-(void)socketSystem:(NSString *)ct{
    titleColor = @"firstlogin";
    NSString *uname = @"直播间消息";
    NSString *levell = @" ";
    NSString *ID = @" ";
    NSString *vip_type = @"0";
    NSString *liangname = @"0";
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:YZMsg(uname),@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",vip_type,@"vip_type",liangname,@"liangname",nil];
    [msgList addObject:chat];
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast:self.tableView];
}
-(void)socketLight{
    starX = moreBTN.frame.origin.x ;
    starY = moreBTN.frame.origin.y - 30;
    starImage = [[UIImageView alloc]initWithFrame:CGRectMake(starX, starY, 30, 30)];
    starImage.contentMode = UIViewContentModeScaleAspectFit;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"plane_heart_cyan.png",@"plane_heart_pink.png",@"plane_heart_red.png",@"plane_heart_yellow.png",@"plane_heart_heart.png", nil];
    NSInteger random = arc4random()%array.count;
    starImage.image = [UIImage imageNamed:[array objectAtIndex:random]];
    [UIView animateWithDuration:0.2 animations:^{
        starImage.alpha = 1.0;
        starImage.frame = CGRectMake(starX+random - 10, starY-random - 30, 30, 30);
        CGAffineTransform transfrom = CGAffineTransformMakeScale(1.3, 1.3);
        starImage.transform = CGAffineTransformScale(transfrom, 1, 1);
    }];
    [self.view insertSubview:starImage atIndex:10];
    CGFloat finishX = _window_width - round(arc4random() % 200);
    //  动画结束点的Y值
    CGFloat finishY = 200;
    //  imageView在运动过程中的缩放比例
    CGFloat scale = round(arc4random() % 2) + 0.7;
    // 生成一个作为速度参数的随机数
    CGFloat speed = 1 / round(arc4random() % 900) + 0.6;
    //  动画执行时间
    NSTimeInterval duration = 4 * speed;
    //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
    if (duration == INFINITY) duration = 2.412346;
    //  开始动画
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(starImage)];
    //  设置动画时间
    [UIView setAnimationDuration:duration];
    
    
    //  设置imageView的结束frame
    starImage.frame = CGRectMake( finishX, finishY, 30 * scale, 30 * scale);
    
    //  设置渐渐消失的效果，这里的时间最好和动画时间一致
    [UIView animateWithDuration:duration animations:^{
        starImage.alpha = 0;
    }];
    
    //  结束动画，调用onAnimationComplete:finished:context:函数
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    //  设置动画代理
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}
-(void)sendGift:(NSDictionary *)msg{
    titleColor = @"2";
    NSString *haohualiwuss =  [NSString stringWithFormat:@"%@",[msg valueForKey:@"evensend"]];
    NSDictionary *ct = [msg valueForKey:@"ct"];
    NSString *giftName = @"";
    if ([lagType isEqual:EN]) {
        giftName = minstr([ct valueForKey:@"giftname_en"]);
    }else if ([lagType isEqual:KH]){
        giftName = minstr([ct valueForKey:@"giftname_kh"]);
    }else{
        giftName = minstr([ct valueForKey:@"giftname"]);
    }

    NSDictionary *GiftInfo = @{@"uid":[msg valueForKey:@"uid"],
                               @"nicename":[msg valueForKey:@"uname"],
                               @"giftname":giftName,
                               @"gifticon":[ct valueForKey:@"gifticon"],
                               @"giftcount":[ct valueForKey:@"giftcount"],
                               @"giftid":[ct valueForKey:@"giftid"],
                               @"level":[msg valueForKey:@"level"],
                               @"avatar":[msg valueForKey:@"uhead"]
                               };
    NSString *ctt = [NSString stringWithFormat:@"%@%@",YZMsg(@"送了一个"),giftName];
    NSString* uname = [msg valueForKey:@"uname"];
    NSString *levell = [msg valueForKey:@"level"];
    NSString *ID = [msg valueForKey:@"uid"];
    NSString *avatar = [msg valueForKey:@"uhead"];
    NSString *vip_type =minstr([msg valueForKey:@"vip_type"]);
    NSString *liangname =minstr([msg valueForKey:@"liangname"]);
    
    NSDictionary *chat6 = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ctt,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",avatar,@"avatar",vip_type,@"vip_type",liangname,@"liangname",nil];
    long totalcoin = [[ct valueForKey:@"totalcoin"] intValue];//记录礼物价值
    allCoin += totalcoin;
    [self addCoin:totalcoin];
    [msgList addObject:chat6];
    NSNumber *number = [ct valueForKey:@"giftid"];
    NSString *giftid = [NSString stringWithFormat:@"%@",number];
    if (  [giftid isEqual:@"22"] || [giftid isEqual:@"21"] ||  [giftid isEqual:@"9"] ||  [giftid isEqual:@"19"]) {
        [self expensiveGift:GiftInfo];
    }
    else{
        if (!continueGifts) {
            continueGifts = [[continueGift alloc]init];
            [liansongliwubottomview addSubview:continueGifts];
            //初始化礼物空位
            [continueGifts initGift];
        }
        [continueGifts GiftPopView:GiftInfo andLianSong:haohualiwuss];
    }
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast:self.tableView];
    
}
//懒加载
-(NSArray *)chatModels{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in msgList) {
        chatModel *model = [chatModel modelWithDic:dic];
        [model setChatFrame:[_chatModels lastObject]];
        [array addObject:model];
    }
    _chatModels = array;
    return _chatModels;
}
-(void)socketShutUp:(NSString *)name andID:(NSString *)ID{
    [socketL shutUp:ID andName:name];
}
-(void)socketkickuser:(NSString *)name andID:(NSString *)ID{
    [socketL kickuser:ID andName:name];
}
static int startKeyboard = 0;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _canScrollToBottom = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _canScrollToBottom = YES;
}
-(void)chushihua{
    backTime = 0;
    _joined = NO;
    lianmaitime = 10;//连麦申请超时时间
    haslianmai = NO;//主播有没有连麦
    [gameState saveProfile:@"0"];//重置游戏状态
    _canScrollToBottom = YES;
    _voteNums = @"0";//主播一开始的收获数
    allCoin = 0;//计算主播的收获
    userCount = 0;//用户人数计算
    haohualiwuV.expensiveGiftCount = [NSMutableArray array];//豪华礼物数组
    titleColor = @"0";//用此字段来判别文字颜色
    msgList = [[NSMutableArray alloc] init];//聊天数组
    _chatModels = [NSArray array];//聊天模型
    isjingpaiwriting = NO;
    ismessgaeshow = NO;

}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate =nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.unRead = [[JMSGConversation getAllUnreadCount] intValue];
        [self labeiHid];
    });
    if (huanxinviews != nil && chatsmall != nil) {
        huanxinviews.view.frame = CGRectMake(0, _window_height*5, _window_width, _window_height*0.4);
        chatsmall.view.frame = CGRectMake(0, _window_height*5, _window_width, _window_height*0.4);
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES ] ;
}
//时间
- (void)viewDidLoad {
    [super viewDidLoad];
    isclosenetwork = NO;
    if (iPhoneX) {
        sssss = 24;
    }else{
        sssss = 0;
    }
    //顶部弹窗

    _notification = [CWStatusBarNotification new];
    _notification.notificationLabelBackgroundColor = [UIColor redColor];
    _notification.notificationLabelTextColor = [UIColor whiteColor];
    [self chushihua];
    [self nsnotifition];
    [self initPushStreamer];//创建推流器
     __block CWStatusBarNotification *notifications = _notification;
    __block Livebroadcast *weakself = self;
    managerAFH = [AFNetworkReachabilityManager sharedManager];
    [managerAFH setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未识别的网络");
                isclosenetwork = YES;
                [weakself backGround];
                [notifications displayNotificationWithMessage:YZMsg(@"无网络") forDuration:8];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                isclosenetwork = YES;
                [weakself backGround];
                [notifications displayNotificationWithMessage:YZMsg(@"无网络") forDuration:8];
                break;
            case  AFNetworkReachabilityStatusReachableViaWWAN:
                isclosenetwork = NO;
                [weakself forwardGround];
                [notifications dismissNotification];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                isclosenetwork = NO;
                [weakself forwardGround];
                [notifications dismissNotification];
                break;
            default:
                break;
        }
    }];
    [managerAFH startMonitoring];
#pragma mark 回到后台+来电话
    //注册进入后台的处理
    NSNotificationCenter* dc = [NSNotificationCenter defaultCenter];
    [dc addObserver:self
           selector:@selector(appactive)
               name:UIApplicationDidBecomeActiveNotification
             object:nil];
    [dc addObserver:self
           selector:@selector(appnoactive)
               name:UIApplicationWillResignActiveNotification
             object:nil];
    [MBProgressHUD hideHUD];
    [self startUI];//初始化UI
}
//杀进程
-(void)shajincheng{
    [self getCloseShow];
    [socketL closeRoom];
    [socketL colseSocket];
}
-(void)backgroundselector{
    backTime +=1;
    NSLog(@"返回后台时间%d",backTime);
    if (backTime > 60) {
        [self hostStopRoom];
    }
}
-(void)backGround{
        //进入后台
        [self sendEmccBack];
        if (!backGroundTimer) {
            backGroundTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(backgroundselector) userInfo:nil repeats:YES];
        }
}
-(void)forwardGround{
    [socketL phoneCall:@"主播回来了"];
    //进入前台
    if (backTime > 60) {
        [self hostStopRoom];
    }
    if (isclosenetwork == NO) {
        [backGroundTimer invalidate];
        backGroundTimer  = nil;
        backTime = 0;
    }
}
-(void)appactive{
    NSLog(@"哈哈哈哈哈哈哈哈哈哈哈哈 app回到前台");
    [self forwardGround];
}
-(void)appnoactive{
    [self backGround];
    NSLog(@"0000000000000000000 app进入后台");
}
//来电话
-(void)sendEmccBack
{
    [socketL phoneCall:@"主播离开一下，精彩不中断，不要走开哦"];
}
-(void)startUI{
    frontView = [[UIView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height)];
    frontView.clipsToBounds = YES;
    [self.view addSubview:frontView];
    
    listView = [[ListCollection alloc]initWithListArray:nil andID:[Config getOwnID] andStream:[NSString stringWithFormat:@"%@",[_roomDic valueForKey:@"stream"]]];
    listView.frame = CGRectMake(110,20+sssss,_window_width-130,40);
    listView.delegate = self;
    [frontView addSubview:listView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setView];//加载信息页面
    });
    //倒计时动画
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    backView.opaque = YES;
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2 -100, _window_height/2-200, 100, 100)];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:90];
    label1.text = @"3";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.center = backView.center;
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2 -100, _window_height/2-200, 100, 100)];
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:90];
    label2.text = @"2";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.center = backView.center;
    label3 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2 -100, _window_height/2-200, 100, 100)];
    label3.textColor = [UIColor whiteColor];
    label3.font = [UIFont systemFontOfSize:90];
    label3.text = @"1";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.center = backView.center;
    label1.hidden = YES;
    label2.hidden = YES;
    label3.hidden = YES;
    [backView addSubview:label3];
    [backView addSubview:label1];
    [backView addSubview:label2];
    [frontView addSubview:backView];
    [self kaishidonghua];
    self.view.backgroundColor = [UIColor clearColor];
}
//开始321
-(void)kaishidonghua{
    [self hideBTN];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label1.hidden = NO;
        [self donghua:label1];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label1.hidden = YES;
        label2.hidden = NO;
        [self donghua:label2];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label2.hidden = YES;
        label3.hidden = NO;
        [self donghua:label3];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label3.hidden = YES;
        backView.hidden = YES;
        [backView removeFromSuperview];
        [self showBTN];
        [self getStartShow];//请求直播
    });
}
//设置美颜
-(void)setMeiYanData:(int)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            _filter = [[KSYGPUBeautifyExtFilter alloc] init];
        }
            break;
        case 1:
        {
            _filter = [[KSYGPUBeautifyFilter alloc] init];
        }
            break;
        case 2:
        {
            _filter = [[KSYGPUDnoiseFilter alloc] init];
        }
            break;
        case 3:
        {
            _filter = [[KSYGPUBeautifyPlusFilter alloc] init];
        }
            break;
        default:
            _filter = nil;
            _filter = [[KSYGPUFilter alloc] init];
            break;
    }
    
    [_gpuStreamer setupFilter:_filter];
    
}
-(void)sliderValueChanged:(float)slider
{
    [(KSYGPUBeautifyExtFilter *)_filter setBeautylevel: slider];
}
-(void)hidebeautifulgirl
{
    beautifulgirl.hidden = YES;
}
- (void) addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStreamStateChange:)
                                                 name:KSYStreamStateDidChangeNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNetStateEvent:)
                                                 name:KSYNetStateEventNotification
                                               object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [backGroundTimer invalidate];
    backGroundTimer  = nil;
}
//释放通知
- (void) rmObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KSYStreamStateDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KSYNetStateEventNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:@"wangminxindemusicplay"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changemusicaaaaa" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shajincheng" object:nil];
    //shajincheng
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sixinok" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"fenxiang" object:nil];
}
//手指拖拽弹窗移动
-(void)message:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:sender.view];
    CGPoint center = sender.view.center;
    center.x += point.x;
    center.y += point.y;
    userView.center = center;
    //清空
    [sender setTranslation:CGPointZero inView:sender.view];
}
#pragma mark - UI responde
- (void)onQuit:(id)sender {
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
    if (_filter) {
        _filter = nil;
    }
    [_gpuStreamer stopPreview];
    _gpuStreamer = nil;
}
//美颜按钮点击事件
-(void)OnChoseFilter:(id)sender {

    if (!beautifulgirl) {
        __weak Livebroadcast *weakself = self;
           beautifulgirl = [[beautifulview alloc]initWithFrame:self.view.bounds andhide:^(NSString *type) {
               [weakself hidebeautifulgirl];
          } andslider:^(NSString *type) {
               [weakself sliderValueChanged:[type floatValue]];
          } andtype:^(NSString *type) {
              [weakself setMeiYanData:[type intValue]];
        }];
        [self.view addSubview:beautifulgirl];
    }
    beautifulgirl.hidden = NO;
}
- (void)onStream:(id)sender {
    if (_gpuStreamer.streamerBase.streamState != KSYStreamStateConnected) {
        [_gpuStreamer.streamerBase startStream: _hostURL];
        
    }
    else {
        [_gpuStreamer.streamerBase stopStream];
    }
    return;
}
//推流成功后更新直播状态 1开播
-(void)changePlayState:(int)status{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Live.changeLive"];
    NSDictionary *changelive = @{
                                 @"uid":[Config getOwnID],
                                 @"token":[Config getOwnToken],
                                 @"stream":urlStrtimestring,
                                 @"status":[NSString stringWithFormat:@"%d",status]
                                 };
    [session POST:url parameters:changelive progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma mark - state handle
- (void) onStreamError {
    if (1 ) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_gpuStreamer.streamerBase stopStream];
            [_gpuStreamer.streamerBase startStream:_hostURL];
        });
    }
}
- (void) onNetStateEvent:(NSNotification *)notification {
    KSYNetStateCode netEvent = _gpuStreamer.streamerBase.netStateCode;
    //NSLog(@"net event : %ld", (unsigned long)netEvent );
    if ( netEvent == KSYNetStateCode_SEND_PACKET_SLOW ) {
      
        NSLog(@"发送包时间过长，( 单次发送超过 500毫秒 ）");
    }
    else if ( netEvent == KSYNetStateCode_EST_BW_RAISE ) {
  
        NSLog(@"估计带宽调整，上调" );
    }
    else if ( netEvent == KSYNetStateCode_EST_BW_DROP ) {

        
        NSLog(@"估计带宽调整，下调" );
    }
    else if ( netEvent == KSYNetStateCode_KSYAUTHFAILED ) {
        
        NSLog(@"SDK 鉴权失败 (暂时正常推流5~8分钟后终止推流)" );
    }
}
- (void) onStreamStateChange:(NSNotification *)notification {
    if ( _gpuStreamer.streamerBase.streamState == KSYStreamStateIdle) {
        NSLog(@"推流状态:初始化时状态为空闲");
    }
    else if ( _gpuStreamer.streamerBase.streamState == KSYStreamStateConnected){
        NSLog(@"推流状态:已连接");
        [self changePlayState:1];//推流成功后改变直播状态
        if (_gpuStreamer.streamerBase.streamErrorCode == KSYStreamErrorCode_KSYAUTHFAILED ) {
            //(obsolete)
            NSLog(@"推流错误:(obsolete)");
        }
    }
    else if (_gpuStreamer.streamerBase.streamState == KSYStreamStateConnecting ) {
        NSLog(@"推流状态:连接中");
    }
    else if (_gpuStreamer.streamerBase.streamState == KSYStreamStateDisconnecting ) {
        NSLog(@"推流状态:断开连接中");
        [self onStreamError];
    }
    else if (_gpuStreamer.streamerBase.streamState == KSYStreamStateError ) {
        NSLog(@"推流状态:推流出错");
        [self onStreamError];
        return;
    }
}
//直播结束选择 alertview
- (void)onQuit {
    
    
    UIAlertController  *alertlianmaiVCtc = [UIAlertController alertControllerWithTitle:YZMsg(@"确定退出直播吗?") message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
    UIAlertAction *defaultActionss = [UIAlertAction actionWithTitle:YZMsg(@"确认") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self hostStopRoom];
    }];

    UIAlertAction *cancelActionss = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    
    NSString *version = [UIDevice currentDevice].systemVersion;
    
    
    if (version.doubleValue < 9.0) {
        
    }
    else{
        [defaultActionss setValue:normalColors forKey:@"_titleTextColor"];
        [cancelActionss setValue:normalColors forKey:@"_titleTextColor"];
    }
    
    [alertlianmaiVCtc addAction:defaultActionss];
    [alertlianmaiVCtc addAction:cancelActionss];
    [self presentViewController:alertlianmaiVCtc animated:YES completion:nil];

    
}
//警告框  //直播关闭
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
       if (buttonIndex == 0) {
           return;
       }else{
           [self hostStopRoom];
       }
 }
//关闭直播做的操作
-(void)hostStopRoom{
    [self getCloseShow];//请求关闭直播接口
}
//直播结束时 停止所有计时器
-(void)liveOver{
    if (lrcTimer) {
        [lrcTimer invalidate];
        lrcTimer = nil;
    }
    if (backGroundTimer) {
        [backGroundTimer invalidate];
        backGroundTimer  = nil;
    }
    [listTimer invalidate];
    listTimer = nil;
}
//直播结束时退出房间
-(void)dismissVC{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
     [managerAFH stopMonitoring];
    if (toutiaoView) {
        toutiaoView.isDelloc = YES;
        [toutiaoView removeFromSuperview];
        toutiaoView = nil;
    }
    if (bottombtnV) {
        [bottombtnV removeFromSuperview];
        bottombtnV = nil;
    }
    [userView removeFromSuperview];
    userView = nil;
    [gameState saveProfile:@"0"];//清除游戏状态
    [managerAFH stopMonitoring];
    managerAFH = nil;
    if (continueGifts) {
        [continueGifts stopTimerAndArray];
        [continueGifts initGift];
        [continueGifts removeFromSuperview];
        continueGifts = nil;
    }
    if (haohualiwuV) {
        [haohualiwuV stopHaoHUaLiwu];
        [haohualiwuV removeFromSuperview];
        haohualiwuV.expensiveGiftCount = nil;
    }
    if (zhuangVC) {
        [zhuangVC dismissroom];
        [zhuangVC removeall];
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (shell) {
        [shell stopGame];
        [shell releaseAll];
        [shell removeFromSuperview];
        shell = nil;
    }
    if (gameVC) {
        [gameVC stopGame];
        [gameVC releaseAll];
        [gameVC removeFromSuperview];
        gameVC = nil;
    }
    if (rotationV) {
        [rotationV stopRotatipnGameInt];
        [rotationV stoplasttimer];
        [socketL stopRotationGame];//关闭游戏socket
        [rotationV removeFromSuperview];
        [rotationV removeall];
        rotationV = nil;        
    }
    if (hostjingpai) {
        [hostjingpai removeall];
        [hostjingpai removeFromSuperview];
        hostjingpai = nil;
    }

    NSDictionary *subdic = [NSDictionary dictionaryWithObjects:@[urlStrtimestring] forKeys:@[@"stream"]];
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"coin" object:nil userInfo:subdic];
}
/***********  以上推流  *************/
/***************     以下是信息页面          **************/
//加载信息页面
-(void)zhuboMessage{
    CGFloat userviewW;
    if (IS_IPHONE_5) {
        userviewW = _window_width + 50;
    }else if(IS_IPHONE_6){
        userviewW = _window_width;
    }else if (IS_IPHONE_6P){
        userviewW = _window_width *0.9;
    }
    else{
        userviewW = _window_width *0.9 + sssss;
    }
    if (!userView) {

        
        //添加用户列表弹窗
        userView = [[upmessageInfo alloc]initWithFrame:CGRectMake(_window_width*0.1,_window_height*2, _window_width*0.8, userviewW) andPlayer:@"Livebroadcast"];
        userView.upmessageDelegate = self;
        userView.backgroundColor = [UIColor whiteColor];
        userView.layer.cornerRadius = 10;
        
        
        UIWindow *mainwindows = [UIApplication sharedApplication].keyWindow;
        [mainwindows addSubview:userView];
        
    }
    self.tanChuangID = [Config getOwnID];
    self.tanchuangName = [Config getOwnNicename];
    NSDictionary *subdic = @{@"id":[Config getOwnID]};
    [self GetInformessage:subdic];
    [UIView animateWithDuration:0.2 animations:^{
        userView.frame = CGRectMake(_window_width*0.1,_window_height*0.2,upViewW,userviewW);
    }];
}
-(void)GetInformessage:(NSDictionary *)subdic{
    CGFloat userviewW;
    if (IS_IPHONE_5) {
        userviewW = _window_width + 50;
    }else if(IS_IPHONE_6){
        userviewW = _window_width;
    }else if (IS_IPHONE_6P){
        userviewW = _window_width *0.9;
    }    else{
        userviewW = _window_width *0.9 + sssss;
    }
    NSDictionary *subdics = @{@"uid":[Config getOwnID],
                             @"avatar":[Config getavatar]
                            };
        if (!userView) {
            //添加用户列表弹窗
            userView = [[upmessageInfo alloc]initWithFrame:CGRectMake(_window_width*0.1,_window_height*2, _window_width*0.8, userviewW) andPlayer:@"Livebroadcast"];
            userView.upmessageDelegate = self;
            userView.backgroundColor = [UIColor whiteColor];
            userView.layer.cornerRadius = 10;
            UIWindow *mainwindows = [UIApplication sharedApplication].keyWindow;
            [mainwindows addSubview:userView];
        }
        //用户弹窗
        self.tanChuangID = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
        self.tanchuangName = [subdic valueForKey:@"name"];
        [userView getUpmessgeinfo:subdic andzhuboDic:subdics];
        [UIView animateWithDuration:0.2 animations:^{
            userView.frame = CGRectMake(_window_width*0.1,_window_height*0.2,upViewW,userviewW);
        }];
}
/// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIImageView *imageViewsss = (__bridge UIImageView *)(context);
    [imageViewsss removeFromSuperview];
    imageViewsss = nil;
}
-(void)setView{
  
    //左上角 直播live
    leftView = [[UIView alloc]initWithFrame:CGRectMake(10,20+sssss,90,leftW)];
    leftView.layer.cornerRadius = leftW/2;
    leftView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    //主播头像button
    UIButton *IconBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [IconBTN addTarget:self action:@selector(zhuboMessage) forControlEvents:UIControlEventTouchUpInside];
    IconBTN.frame = CGRectMake(0, 0, leftW, leftW);
    IconBTN.layer.masksToBounds = YES;
    IconBTN.layer.borderWidth = 1;
    IconBTN.layer.borderColor = normalColors.CGColor;
    IconBTN.layer.cornerRadius = leftW/2;
    UITapGestureRecognizer *tapleft = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhuboMessage)];
    tapleft.numberOfTapsRequired = 1;
    tapleft.numberOfTouchesRequired = 1;
    [leftView addGestureRecognizer:tapleft];
    LiveUser *user = [[LiveUser alloc]init];
    user = [Config myProfile];
    NSString *path = user.avatar;
    NSURL *url = [NSURL URLWithString:path];
    [IconBTN sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    
    
    levelimage = [[UIImageView alloc]initWithFrame:CGRectMake(IconBTN.right - 15,IconBTN.bottom - 15,15,15)];
    levelimage.layer.masksToBounds = YES;
    levelimage.layer.cornerRadius = 7.5;
    [levelimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"host_%@",minstr([Config level_anchor])]]];
    
    
    //直播live
    UILabel *liveLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftW+7,2,70,20)];
    liveLabel.textAlignment = NSTextAlignmentLeft;
    liveLabel.text = YZMsg(@"直播Live");
    liveLabel.textColor = [UIColor whiteColor];
    //liveLabel.shadowColor = [UIColor lightGrayColor];
    liveLabel.shadowOffset = CGSizeMake(1,1);//设置阴影
    liveLabel.font = fontMT(10);
    //在线人数
    onlineLabel = [[UILabel alloc]init];
    onlineLabel.frame = CGRectMake(leftW+10,17,70,20);
    onlineLabel.textAlignment = NSTextAlignmentLeft;
    onlineLabel.textColor = [UIColor whiteColor];
    onlineLabel.font = fontMT(10);
    onlineLabel.text = @"0";
    //聊天
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _window_height - _window_height*0.2 - 50,tableWidth,_window_height*0.2) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.clipsToBounds = YES;
    //输入框
    keyField = [[UITextField alloc]initWithFrame:CGRectMake(70,7,_window_width-90 - 50, 30)];
    keyField.returnKeyType = UIReturnKeySend;
    keyField.delegate  = self;
    keyField.borderStyle = UITextBorderStyleNone;
    keyField.placeholder = YZMsg(@"和大家说些什么");
    www = 30;
    //键盘出现
    keyBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    keyBTN.tintColor = [UIColor whiteColor];
    keyBTN.userInteractionEnabled = YES;
    [keyBTN setBackgroundImage:[UIImage imageNamed:@"聊天"] forState:UIControlStateNormal];
    [keyBTN addTarget:self action:@selector(showkeyboard:) forControlEvents:UIControlEventTouchUpInside];
    keyBTN.layer.masksToBounds = YES;
    keyBTN.layer.shadowColor = [UIColor blackColor].CGColor;
    keyBTN.layer.shadowOffset = CGSizeMake(1, 1);
    //发送按钮
    pushBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushBTN setTitle:YZMsg(@"发送") forState:UIControlStateNormal];
    [pushBTN setTitleColor:RGB(255, 204, 0) forState:0];
//    pushBTN.backgroundColor = normalColors;
    pushBTN.layer.masksToBounds = YES;
    pushBTN.layer.cornerRadius = 5;
    [pushBTN addTarget:self action:@selector(pushMessage:) forControlEvents:UIControlEventTouchUpInside];
    pushBTN.frame = CGRectMake(_window_width-55,7,50,30);
    cs = [[catSwitch alloc] initWithFrame:CGRectMake(6,11,44,22)];
    cs.delegate = self;
    //退出页面按钮
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tintColor = [UIColor whiteColor];
    [btn setImage:[UIImage imageNamed:@"cancleliveshow"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onQuit) forControlEvents:UIControlEventTouchUpInside];
    //消息按钮
    messageBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBTN setImage:[UIImage imageNamed:@"私信"] forState:UIControlStateNormal];
    [messageBTN addTarget:self action:@selector(doMessage) forControlEvents:UIControlEventTouchUpInside];
    self.unReadLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, -5, 16, 16)];
    self.unReadLabel.textAlignment = NSTextAlignmentCenter;
    self.unReadLabel.textColor = [UIColor whiteColor];
    self.unReadLabel.layer.masksToBounds = YES;
    self.unReadLabel.layer.cornerRadius = 8;
    self.unReadLabel.font = [UIFont systemFontOfSize:9];
    self.unReadLabel.backgroundColor = [UIColor redColor];
    self.unReadLabel.hidden = YES;
    [messageBTN addSubview:self.unReadLabel];
    //camera按钮
    moreBTN = [UIButton buttonWithType:UIButtonTypeSystem];
    moreBTN.tintColor = [UIColor whiteColor];
    [moreBTN setBackgroundImage:[UIImage imageNamed:getImagename(@"功能")] forState:UIControlStateNormal];
    [moreBTN addTarget:self action:@selector(showmoreview) forControlEvents:UIControlEventTouchUpInside];
    /*==================  连麦  ================*/
    //tool绑定键盘
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0,_window_height+10, _window_width, 44)];
    toolBar.backgroundColor = [UIColor clearColor];
    UIView *tooBgv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 44)];
    tooBgv.backgroundColor = [UIColor whiteColor];
    tooBgv.alpha = 0.7;
    [toolBar addSubview:tooBgv];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toolbarClick:)];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(cs.right+9, cs.top, 1, 20)];
    line1.backgroundColor = RGB(176, 176, 176);
    line1.alpha = 0.5;
    [toolBar addSubview:line1];
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(keyField.right+7, line1.top, 1, 20)];
    line2.backgroundColor = line1.backgroundColor;
    line2.alpha = line1.alpha;
    [toolBar addSubview:line2];
    [toolBar addGestureRecognizer:tapGesture];
    [toolBar addSubview:pushBTN];
    [toolBar addSubview:keyField];
    [toolBar addSubview:cs];
    [frontView addSubview:keyBTN];
    //关闭连麦按钮
    btnUserViewClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnUserViewClose setImage:[UIImage imageNamed:@"断"] forState:UIControlStateNormal];
    [btnUserViewClose addTarget:self action:@selector(closeVideo) forControlEvents:UIControlEventTouchUpInside];
    btnUserViewClose.hidden = YES;
    //直播间按钮（竞拍，游戏，扣费，后台控制隐藏,createroom接口传进来）
    [self changeBtnFrame:_window_height - 45];
    [leftView addSubview:onlineLabel];
    [leftView addSubview:liveLabel];
    [leftView addSubview:IconBTN];
    [leftView addSubview:levelimage];
    [frontView addSubview:leftView];
    [frontView addSubview:moreBTN];
    [frontView addSubview:messageBTN];
    [frontView addSubview:btn];
    [self.view addSubview:btnUserViewClose];
    [self hideBTN];
    /*==================  连麦  ================*/
    [self.view addSubview:toolBar];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self.view insertSubview:self.tableView atIndex:4];
    useraimation = [[userLoginAnimation alloc]init];
    useraimation.frame = CGRectMake(10,self.tableView.top - 40,_window_width,20);
    [self.view insertSubview:useraimation atIndex:4];
    danmuview = [[GrounderSuperView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 140)];
    [frontView insertSubview:danmuview atIndex:5];
    liansongliwubottomview = [[UIView alloc]init];
    [self.view insertSubview:liansongliwubottomview atIndex:8];
    liansongliwubottomview.frame = CGRectMake(0, self.tableView.top - 100, _window_width/2, 100);
}
-(void)hidecoastview{
    [UIView animateWithDuration:0.3 animations:^{
        coastview.frame = CGRectMake(0, -_window_height, _window_width, _window_height);
    }];
}
//弹出收费弹窗
-(void)doupcoast{
    if (!coastview) {
        coastview = [[coastselectview alloc]initWithFrame:CGRectMake(0, -_window_height, _window_width, _window_height) andsureblock:^(NSString *type) {
            coastmoney = type;
            [MBProgressHUD showMessage:@""];
            //Live.changeLiveType
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            NSString *url = [purl stringByAppendingFormat:@"service=Live.changeLiveType"];
            NSDictionary *subdic = @{
                                     @"uid":[Config getOwnID],
                                     @"token":[Config getOwnToken],
                                     @"stream":urlStrtimestring,
                                     @"type":@"3",
                                     @"type_val":coastmoney
                                     };
            [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSString *number = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"ret"]];
                if([number isEqual:@"200"])
                {
                    NSArray *data = [responseObject valueForKey:@"data"];
                    NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
                    if([code isEqual:@"0"])
                    {
                        NSString *info = [[[data valueForKey:@"info"] firstObject] valueForKey:@"msg"];
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showSuccess:info];
                        [socketL changeLiveType:coastmoney];
                        //收费金额
                        [self hidecoastview];
                    }
                    else
                    {
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:[data valueForKey:@"msg"]];
                    }
                }
                else{
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
                    
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:YZMsg(@"无网络")];
            }];
        } andcancleblock:^(NSString *type) {
            //取消
            [self hidecoastview];
        }];
        [self.view addSubview:coastview];
    }
    [UIView animateWithDuration:0.3 animations:^{
        coastview.frame = CGRectMake(0,0, _window_width, _window_height);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            coastview.frame = CGRectMake(0,20,_window_width, _window_height);
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            coastview.frame = CGRectMake(0, 0, _window_width, _window_height);
        }];
    });
    coastview.userInteractionEnabled = YES;
}
-(void)toolbarHidden
{
    [self showBTN];
    toolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
    [UIView animateWithDuration:0.5 animations:^{
        chatsmall.view.frame = CGRectMake(0, _window_height*3, _window_width, _window_height*0.4);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (chatsmall) {
            [chatsmall.view removeFromSuperview];
            chatsmall.view = nil;
            chatsmall = nil;
        }
    });
}
-(void)toolbarClick:(id)sender
{
    [keyField resignFirstResponder];
    toolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
}

-(void)changeState{
    if (!imagebackImage) {
        //魅力值//魅力值
        //修改 魅力值 适应字体 欣
        UIFont *font1 = fontMT(13);
        yingpiaoLabel  = [[UILabel alloc]init];
        yingpiaoLabel.backgroundColor = [UIColor clearColor];
        yingpiaoLabel.text = @"  ";
        yingpiaoSize= [yingpiaoLabel.text boundingRectWithSize:CGSizeMake(300, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font1} context:nil].size;
        yingpiaoLabel.frame = CGRectMake(75,0, yingpiaoSize.width,15);
        yingpiaoLabel.textAlignment = NSTextAlignmentCenter;
        yingpiaoLabel.textColor = [UIColor whiteColor];
        
        imagebackImage = [[UIView alloc]init];
        UITapGestureRecognizer *yingpiaoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yingpiao)];
        imagebackImage.userInteractionEnabled = YES;
        [imagebackImage addGestureRecognizer:yingpiaoTap];
        imagebackImage.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        //魅力值文字
        labell = [[UILabel alloc]init];//WithFrame:CGRectMake(30,0,45,20)
        labell.textAlignment =NSTextAlignmentCenter;
        labell.text = [NSString stringWithFormat:@"%@:",[common name_votes]];
        labell.textColor = [UIColor whiteColor];
        labell.font = fontMT(13);
        CGSize voteSize = [labell.text boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontMT(13)} context:nil].size;
        labell.frame = CGRectMake(30, 0, voteSize.width, 20);
        UIImageView *zuanshiImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2.5, 15, 15)];;
        zuanshiImage.image = [UIImage imageNamed:@"zuanshi"];
        zuanshiImage.backgroundColor = [UIColor clearColor];
        [imagebackImage addSubview:zuanshiImage];
        roomID = [[UILabel alloc] init];
        [roomID setTextColor:[UIColor whiteColor]];
        roomID.font = fontMT(13);
        NSString *laingname = minstr([Config getliang]);
        if ([laingname isEqual:@"0"]) {
           roomID.text = [NSString stringWithFormat:@"%@%@",YZMsg(@"房间:"),[Config getOwnID]];
        }
        else{
            roomID.text = [NSString stringWithFormat:@"%@%@%@",YZMsg(@"房间:"),YZMsg(@"靓"),[Config getliang]];
        }
        roomsize = [roomID.text boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontMT(13)} context:nil].size;
        roomID.frame = CGRectMake(yingpiaoLabel.frame.origin.x + yingpiaoLabel.frame.size.width + 5, 0, roomsize.width, 20);
        [imagebackImage addSubview:roomID];
        //魅力值图标
        imageVh = [[UIImageView alloc]initWithFrame:CGRectMake(yingpiaoSize.width+10,0,8,8)];
        imageVh.image = [UIImage imageNamed:@"room_yingpiao_check.png"];
        yingpiao.rightViewMode = UITextFieldViewModeAlways;
        yingpiao.leftViewMode = UITextFieldViewModeAlways;
        yingpiaoLabel.frame = CGRectMake(75,0,yingpiaoSize.width,20);
        yingpiaoLabel.font = fontMT(13);
        imagebackImage.frame = CGRectMake(10,30+leftView.frame.size.height +sssss,yingpiaoSize.width+105 + roomID.frame.size.width,20);
        imagebackImage.layer.cornerRadius = 10;
        imageVh.frame = CGRectMake(imagebackImage.frame.size.width -25 ,3,15,15);
        [imagebackImage addSubview:imageVh];
        [imagebackImage addSubview:yingpiaoLabel];
        [imagebackImage addSubview:labell];
        [frontView addSubview:imagebackImage];
        yingpiaoLabel.text = _voteNums;
    }
    yingpiaoSize= [yingpiaoLabel.text boundingRectWithSize:CGSizeMake(300, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontMT(13)} context:nil].size;
    yingpiaoLabel.frame = CGRectMake(labell.right,0,yingpiaoSize.width,20);
    imagebackImage.frame = CGRectMake(10,30+leftView.frame.size.height + sssss,yingpiaoSize.width+105 + roomID.frame.size.width,20);
    imageVh.frame = CGRectMake(imagebackImage.frame.size.width-20,3,15,15);
    roomID.frame = CGRectMake(yingpiaoLabel.frame.origin.x + yingpiaoLabel.frame.size.width + 5, 0, roomsize.width, 20);
}
//跳往魅力值界面
-(void)yingpiao{
    personList *jumpC = [[personList alloc] init];
    jumpC.userID = [Config getOwnID];
    [self presentViewController:jumpC animated:YES completion:nil];
}
-(void)changeMusic:(NSNotification *)notifition{
    
    _count = 0;
    [musicV removeFromSuperview];
    [self.player stop];
    self.player = nil;
    _isPlayLrcing = NO;
    if (lrcTimer) {
        [lrcTimer invalidate];
        lrcTimer =nil;
    }
    NSDictionary *dic = [notifition userInfo];
    muaicPath = [dic valueForKey:@"music"];
    NSString *lrcId = [dic valueForKey:@"lrc"];
    NSFileManager *managers=[NSFileManager defaultManager];
    if ([managers fileExistsAtPath:muaicPath]) {
        //创建一个播放器  音量为0
        NSURL *url = [[NSURL alloc]initFileURLWithPath:muaicPath];
        if (!self.player) {
            self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            self.player.volume = 0.8;
            [self.player prepareToPlay];
            [self.player play];
            musicV = [[UIView alloc]initWithFrame:CGRectMake(50, _window_height*0.3, _window_width-50, 100)];
            musicV.backgroundColor = [UIColor clearColor];
            [self.view addSubview:musicV];
            UIPanGestureRecognizer *aPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(musicPan:)];
            aPan.minimumNumberOfTouches = 1;
            aPan.maximumNumberOfTouches = 1;
            [musicV addGestureRecognizer:aPan];
        }
    }
    else{
        NSLog(@"歌曲不存在");
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    lrcPath = [docDir stringByAppendingFormat:@"/%@.lrc",lrcId];
    
    if ([managers fileExistsAtPath:lrcPath]) {
        lrcView = [[YLYOKLRCView alloc]initWithFrame:CGRectMake(0,40,_window_width-50, 30)];
        lrcView.lrcLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];//OKlrcLabel
        lrcView.OKlrcLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        lrcView.backgroundColor = [UIColor clearColor];
        [musicV addSubview:lrcView];
        YLYMusicLRC *lrc = [[YLYMusicLRC alloc]initWithLRCFile:lrcPath];
        if(lrc.lrcList.count == 0 || !lrc.lrcList)
        {
            [MBProgressHUD showError:YZMsg(@"暂无歌词")];
            buttonmusic = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonmusic.frame = CGRectMake(80,0,50,30);
            [buttonmusic addTarget:self action:@selector(musicPlay) forControlEvents:UIControlEventTouchUpInside];
            [buttonmusic setTitle:YZMsg(@"结束") forState:UIControlStateNormal];
            buttonmusic.backgroundColor = [UIColor clearColor];
            [buttonmusic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            buttonmusic.layer.masksToBounds = YES;
            buttonmusic.layer.cornerRadius = 10;
            buttonmusic.layer.borderWidth = 1;
            buttonmusic.layer.borderColor = [UIColor whiteColor].CGColor;
            [musicV addSubview:buttonmusic];
            return;
        }
        self.lrcList = lrc.lrcList;
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(140,0,50,30)];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.layer.cornerRadius = 10;
        self.timeLabel.layer.borderWidth = 1;
        self.timeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        self.timeLabel.text = [NSString stringWithFormat:@"%d:0%d",0,0];
        [musicV addSubview:self.timeLabel];
        if (!lrcTimer) {
            lrcTimer= [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateMusicTimeLabel) userInfo:self repeats:YES];
        }
    }
    else{
        NSLog(@"歌词不存在");
    }
    buttonmusic = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonmusic.frame = CGRectMake(80,0,50,30);
    [buttonmusic addTarget:self action:@selector(musicPlay) forControlEvents:UIControlEventTouchUpInside];
    [buttonmusic setTitle:YZMsg(@"结束") forState:UIControlStateNormal];
    buttonmusic.backgroundColor = [UIColor clearColor];
    [buttonmusic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonmusic.layer.masksToBounds = YES;
    buttonmusic.layer.cornerRadius = 10;
    buttonmusic.layer.borderWidth = 1;
    buttonmusic.layer.borderColor = [UIColor whiteColor].CGColor;
    [musicV addSubview:buttonmusic];
}
//手指拖拽音乐移动
-(void)musicPan:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:sender.view];
    CGPoint center = sender.view.center;
    center.x += point.x;
    center.y += point.y;
    musicV.center = center;
    //清空
    [sender setTranslation:CGPointZero inView:sender.view];
}
//TODO:更新ing歌曲播放时间
-(void)updateMusicTimeLabel{
    
    if ((int)self.player.currentTime % 60 < 10) {
        self.timeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)self.player.currentTime / 60, (int)self.player.currentTime % 60];
    }
    else {
        self.timeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)self.player.currentTime / 60, (int)self.player.currentTime % 60];
    }
    NSDictionary *dic = self.lrcList[_count];    
    NSArray *array = [dic[@"lrctime"] componentsSeparatedByString:@":"];//把时间转换成秒
    NSUInteger currentTime = [array[0] intValue] * 60 + [array[1] intValue];
    //判断是否播放歌词
    if (self.player.currentTime >= currentTime && _isPlayLrcing == NO) {
        [lrcView beganLrc:self.lrcList];
        _isPlayLrcing = YES;
    }
    if (![self.player isPlaying]) {
        [self musicPlay];
    }
}
//关闭音乐
-(void)musicPlay{
    if (lrcView.timelrc) {
        [lrcView.timelrc invalidate];
        lrcView.timelrc = nil;
    }
    if (lrcView) {
        [lrcView removeFromSuperview];
        lrcView = nil;
    }
    _count = 0;
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
    [musicV removeFromSuperview];
//    [lrcTimer invalidate];
//    lrcTimer = nil;
}

-(void)showmoreviews{
    //添加的镜像，闪光灯。。。
    __weak Livebroadcast *weakself = self;
    if (!bottombtnV) {
        bottombtnV = [[bottombuttonv alloc]initWithFrame:CGRectMake(0,_window_height*2, _window_width, _window_width/2) music:^(NSString *type) {
            [weakself justplaymusic];//播放音乐
        } meiyan:^(NSString *type) {
             [weakself OnChoseFilter:nil];//美颜
        } coast:^(NSString *type) {
            [weakself doupcoast];//切换技术扣费
        } light:^(NSString *type) {
            [weakself toggleTorch];//闪光灯
        } camera:^(NSString *type) {
            [weakself rotateCamera];//切换摄像头
        } game:^(NSString *type) {
            [weakself startgamepagev];//选择游戏
        } jingpai:^(NSString *type) {
            [weakself dojingpai];//开始竞拍
            
        } showjingpai:_auction_switch showgame:_game_switch showcoase:_type hideself:^(NSString *type) {
            [UIView animateWithDuration:0.4 animations:^{
                bottombtnV.frame = CGRectMake(0, _window_height*2, _window_width, _window_height);
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                bottombtnV.hidden = YES;
            });
        } and:_canFee];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:bottombtnV];
        bottombtnV.hidden = YES;
        
}
}
-(void)toggleTorch{
    if ([_gpuStreamer.vCapDev isTorchSupported]) {
        [_gpuStreamer toggleTorch];
    }
}
-(void)rotateCamera{
     [_gpuStreamer.vCapDev rotateCamera];
}
-(void)justplaymusic{
    musicView *music = [[musicView alloc]init];
    music.modalPresentationStyle = UIModalPresentationFullScreen;
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:music];
    self.animator.bounces = NO;
    self.animator.behindViewAlpha = 1;
    self.animator.behindViewScale = 0.5f;
    self.animator.transitionDuration = 0.4f;
    music.transitioningDelegate = self.animator;
    self.animator.dragable = YES;
    self.animator.direction = ZFModalTransitonDirectionRight;
    [self presentViewController:music animated:YES completion:nil];
}
-(void)showmoreview{
    
    if (!bottombtnV) {
        [self showmoreviews];
    }
    
    if (bottombtnV.hidden == YES) {
        bottombtnV.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            bottombtnV.frame = CGRectMake(0,0, _window_width, _window_height);
        }];
        
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            bottombtnV.frame = CGRectMake(0, _window_height*2, _window_width, _window_height);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            bottombtnV.hidden = YES;
        });
    }
}
-(void)donghua:(UILabel *)labels{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.8;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(4.0, 4.0, 4.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(3.0, 3.0, 3.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 2.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)]];
    animation.values = values;
    animation.removedOnCompletion = NO;//是不是移除动画的效果
    animation.fillMode = kCAFillModeForwards;//保持最新状态
    [labels.layer addAnimation:animation forKey:nil];
}
#pragma mark ---- 私信方法
-(void)nsnotifition{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeMusic:) name:@"changemusicaaaaa" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shajincheng) name:@"shajincheng" object:nil];
    //@"shajincheng"
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forsixin:) name:@"sixinok" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getweidulabel) name:@"gengxinweidu" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(toolbarHidden) name:@"toolbarHidden" object:nil];

}
//更新未读消息
-(void)getweidulabel{
    [self labeiHid];
}

-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    [self labeiHid];
}
-(void)labeiHid{
    self.unRead = [[JMSGConversation getAllUnreadCount] intValue];
    self.unReadLabel.text = [NSString stringWithFormat:@"%d",self.unRead];
    if ([self.unReadLabel.text isEqual:@"0"] || self.unRead == 0) {
        self.unReadLabel.hidden =YES;
    }
    else
    {
        self.unReadLabel.hidden = NO;
    }
}
//跳往消息列表
-(void)doMessage{
    [self hideBTN];
    [chatsmall.view removeFromSuperview];
    chatsmall = nil;
    chatsmall.view = nil;
    [huanxinviews.view removeFromSuperview];
    huanxinviews = nil;
    huanxinviews.view = nil;
    if (!huanxinviews) {
        huanxinviews = [[huanxinsixinview alloc]init];
        huanxinviews.view.frame = CGRectMake(0, _window_height*3, _window_width, _window_height*0.4);
        [self.view insertSubview:huanxinviews.view atIndex:9];
        if (liansongliwubottomview) {
            [self.view insertSubview:liansongliwubottomview atIndex:8];
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        huanxinviews.view.frame = CGRectMake(0, _window_height - _window_height*0.4,_window_width, _window_height*0.4);
    }];
}
//点击用户聊天
-(void)forsixin:(NSNotification *)ns{
    [chatsmall.view removeFromSuperview];
    chatsmall = nil;
    chatsmall.view = nil;
    if (!chatsmall) {
        chatsmall = [[chatsmallview alloc]init];
        chatsmall.view.frame = CGRectMake(0, _window_height*3, _window_width, _window_height*0.4);
        [self.view insertSubview:chatsmall.view atIndex:10];
        if (liansongliwubottomview) {
            [self.view insertSubview:liansongliwubottomview atIndex:8];
        }
    }
    chatsmall.view.hidden = NO;
    NSDictionary *dic = [ns userInfo];
    [UIView animateWithDuration:0.5 animations:^{
        chatsmall.view.frame = CGRectMake(0, _window_height-_window_height*0.4, _window_width, _window_height*0.4);
    }];
    chatsmall.icon = [dic valueForKey:@"avatar"];
    chatsmall.chatID = [dic valueForKey:@"id"];
    chatsmall.chatname = [dic valueForKey:@"name"];
    chatsmall.msgConversation = [dic valueForKey:@"Conversation"];
    [chatsmall changename];
    [chatsmall formessage];
}
-(void)siXin:(NSString *)icon andName:(NSString *)name andID:(NSString *)ID{
    [chatsmall.view removeFromSuperview];
    chatsmall = nil;
    chatsmall.view = nil;
    [huanxinviews.view removeFromSuperview];
    huanxinviews = nil;
    huanxinviews.view = nil;
    [JMSGConversation createSingleConversationWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,ID] completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            [self doCancle];
            if (!chatsmall) {
                chatsmall = [[chatsmallview alloc]init];
                chatsmall.view.frame = CGRectMake(0, _window_height*3, _window_width, _window_height*0.4);
                [self.view insertSubview:chatsmall.view atIndex:10];
                chatsmall.view.hidden =YES;
            }
            chatsmall.view.hidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                chatsmall.view.frame = CGRectMake(0, _window_height-_window_height*0.4, _window_width, _window_height*0.4);
            }];
            chatsmall.msgConversation = resultObject;
            chatsmall.chatID = ID;
            chatsmall.icon = icon;
            chatsmall.chatname = name;
             [chatsmall changename];
            [chatsmall formessage];
        }
        else{
           [MBProgressHUD showError:error.localizedDescription];
        }
    }];
}
-(void)doUpMessageGuanZhu{
    if ([userView.forceBtn.titleLabel.text isEqual:YZMsg(@"已关注")]) {
        [userView.forceBtn setTitle:YZMsg(@"关注") forState:UIControlStateNormal];
        [userView.forceBtn setTitleColor:UIColorFromRGB(0xff9216) forState:UIControlStateNormal];
    }
    else{
        [userView.forceBtn setTitle:YZMsg(@"已关注") forState:UIControlStateNormal];
        [userView.forceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        userView.forceBtn.enabled = NO;
    }
}
-(void)pushZhuYe:(NSString *)IDS{
    [self doCancle];
    personMessage  *person = [[personMessage alloc]initWithNibName:@"personMessage" bundle:nil];
    person.userID = IDS;
    person.isLIve = 1;
    [self.navigationController pushViewController:person animated:YES];
}
-(void)doupCancle{
   [self doCancle];
}
//键盘弹出隐藏下面四个按钮
-(void)hideBTN{
    btn.hidden = YES;
    keyBTN.hidden = YES;
    messageBTN.hidden = YES;
    moreBTN.hidden = YES;
    bottombtnV.hidden = YES;
    btnUserViewClose.hidden = YES;
}
-(void)showBTN{
    btn.hidden = NO;
    keyBTN.hidden = NO;
    messageBTN.hidden = NO;
    moreBTN.hidden = NO;
    if (haslianmai) {
        btnUserViewClose.hidden = NO;
    }
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //防止填写竞拍信息的时候弹出私信
    if (isjingpaiwriting == YES) {
        chatsmall.view.hidden = YES;
    }
    if (!ismessgaeshow) {
        
        return;
    }
    if (startKeyboard == 1) {
        return;
    }
    if (gameVC) {
        gameVC.hidden = YES;
    }
    if (shell) {
        shell.hidden = YES;
    }
    if (rotationV) {
        rotationV.hidden = YES;
    }
    [self hideBTN];
    [self doCancle];
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.origin.y;
    [UIView animateWithDuration:0.3 animations:^{
        toolBar.frame = CGRectMake(0,height-44,_window_width,44);
        frontView.frame = CGRectMake(0,-height, _window_width, _window_height);
        [self tableviewheight:_window_height - _window_height*0.2 - keyboardRect.size.height - 40];
        [self changecontinuegiftframe];
        if (zhuangVC) {
            zhuangVC.frame =  CGRectMake(10,20, _window_width/4, _window_width/4 + 20 + _window_width/8);
        }
    }];
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    ismessgaeshow = NO;
    if (isjingpaiwriting == NO) {
        if (gameVC) {
            gameVC.hidden = NO;
        }
        if (shell) {
            shell.hidden = NO;
        }
        if (rotationV) {
            rotationV.hidden = NO;
        }
    }
    [self showBTN];
    [UIView animateWithDuration:0.1 animations:^{
        toolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
        if (gameVC || shell) {
            [self tableviewheight:_window_height - _window_height*0.2 - 240];

        }else if (rotationV){
            [self tableviewheight:_window_height - _window_height*0.2 - _window_width/1.8 - www];
        }
        else{
            [self tableviewheight:_window_height - _window_height*0.2 - 50];
        }
        
        frontView.frame = CGRectMake(0, 0, _window_width, _window_height);
        [self changecontinuegiftframe];
        if (zhuangVC) {
            zhuangVC.frame =  CGRectMake(10,90, _window_width/4, _window_width/4 + 20 + _window_width/8);
        }
    }];
    if (isjingpaiwriting == YES) {
        [self hideBTN];
    }
}
-(void)adminZhezhao{
    zhezhaoList.view.hidden = YES;
    self.tableView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        adminlist.view.frame = CGRectMake(0,_window_height*2, _window_width, _window_height*0.3);
    }];
}
//管理员列表
-(void)adminList{
    if (!adminlist) {
        //管理员列表
        zhezhaoList  = [[UIViewController alloc]init];
        zhezhaoList.view.frame = CGRectMake(0, 0, _window_width, _window_height);
        [self.view addSubview:zhezhaoList.view];
        zhezhaoList.view.hidden = YES;
        adminlist = [[adminLists alloc]init];
        adminlist.view.frame = CGRectMake(0, _window_height*2, _window_width, _window_height*0.3);
        [self.view addSubview:adminlist.view];
        UITapGestureRecognizer *tapAdmin = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adminZhezhao)];
        [zhezhaoList.view addGestureRecognizer:tapAdmin];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"adminlist" object:nil];
    [self doCancle];
    self.tableView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        zhezhaoList.view.hidden = NO;
        adminlist.view.frame = CGRectMake(0,_window_height*0.7, _window_width, _window_height*0.3);
    }];
}
-(void)setAdminSuccess:(NSString *)isadmin{
    NSString *cts;
    if ([isadmin isEqual:@"0"]) {
        //不是管理员
         cts = @"被取消管理员";
        [MBProgressHUD showSuccess:YZMsg(@"取消管理员成功")];
    }else{
        //是管理员
          cts = @"被设为管理员";
        [MBProgressHUD showSuccess:YZMsg(@"设置管理员成功")];
    }
     [socketL setAdminID:self.tanChuangID andName:self.tanchuangName andCt:cts];
}
//弹窗退出
-(void)doCancle{
    userView.forceBtn.enabled = YES;
    [UIView animateWithDuration:0.2 animations:^{
        userView.frame = CGRectMake(_window_width*0.1,_window_height*2,upViewW, upViewW);
    }];
    self.tableView.userInteractionEnabled = YES;
}
-(void)superStopRoom:(NSString *)state{
    [self hostStopRoom];
}
//发送消息
-(void)sendBarrage
{
    /*******发送弹幕开始 **********/
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Live.sendBarrage"];
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken],
                             @"liveuid":[Config getOwnID],
                             @"stream":urlStrtimestring,
                             @"giftid":@"1",
                             @"giftcount":@"1",
                             @"content":keyField.text
                             };
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSString *info = [[[data valueForKey:@"info"] firstObject] valueForKey:@"barragetoken"];
                //刷新本地魅力值
                LiveUser *liveUser = [Config myProfile];
                liveUser.coin = [NSString stringWithFormat:@"%@",[[[data valueForKey:@"info"] firstObject] valueForKey:@"coin"]];
                [Config updateProfile:liveUser];
                [socketL sendBarrage:info];
                if (gameVC) {
                    [gameVC reloadcoins];
                }
                if (shell) {
                    [shell reloadcoins];
                }
                if (rotationV) {
                    [rotationV reloadcoins];
                }
            }
            else
            {
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    /*********************发送礼物结束 ************************/
}
-(void)pushMessage:(UITextField *)sender{
//    if (keyField.text.length >50) {
//        [MBProgressHUD showError:YZMsg(@"字数最多50字")];
//        return;
//    }
    pushBTN.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        pushBTN.enabled = YES;
    });
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [keyField.text stringByTrimmingCharactersInSet:set];
    if ([trimedString length] == 0) {
        
        return ;
    }
    if(cs.state == YES)//发送弹幕
    {
        
        if (keyField.text.length <=0) {
            return;
        }
        [self sendBarrage];
        keyField.text = @"";
        return;
    }
    [socketL sendMessage:keyField.text];
    keyField.text =nil;
}
//聊天输入框
-(void)showkeyboard:(UIButton *)sender{
    
    if (chatsmall) {
        chatsmall.view.hidden = YES;
        [chatsmall.view removeFromSuperview];
        chatsmall.view = nil;
        chatsmall = nil;
    }
    ismessgaeshow = YES;
    [keyField becomeFirstResponder];
    
}
// 以下是 tableview的方法
/*******    连麦 注意下面的tableview方法    *******/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView)
    {
        chatModel *model = _chatModels[indexPath.row];
        return model.rowHH + 6;
    }
    else
    {
        return 60;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModels.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        static NSString *SimpleTableIdentifier = @"tableviewchat";
        chatcell *cell = [tableView dequeueReusableCellWithIdentifier: SimpleTableIdentifier];
        if(cell == nil)
        {
            cell = [[chatcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.chatModels[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    chatcell *cell = [tableView cellForRowAtIndexPath:indexPath];
    chatModel *model = self.chatModels[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [keyField resignFirstResponder];
    if ([model.userName isEqual:@"直播间消息"]) {
        
        return;
    }
    NSString *IsUser = [NSString stringWithFormat:@"%@",model.userID];
    if (IsUser.length >0) {
        NSDictionary *subdic = @{@"id":model.userID,
                                 @"name":model.userName
                                 };
            [self GetInformessage:subdic];
    }
}
//请求直播
-(void)getStartShow
{
    _hostURL = [[NSURL alloc] initWithString:[_roomDic valueForKey:@"push"]];
    urlStrtimestring = [_roomDic valueForKey:@"stream"];
    _socketUrl = [_roomDic valueForKey:@"chatserver"];
    _danmuPrice = [_roomDic valueForKey:@"barrage_fee"];
    [self onStream:nil];
    _voteNums = [NSString stringWithFormat:@"%@",[_roomDic valueForKey:@"votestotal"]];
    [self changeState];    
    socketL = [[socketLive alloc]init];
    socketL.delegate = self;
    [socketL getshut_time:_shut_time];//获取禁言时间
    [socketL addNodeListen:_socketUrl andTimeString:urlStrtimestring];
    userlist_time = [[_roomDic valueForKey:@"userlist_time"] intValue];
    if (!listTimer) {
        listTimer = [NSTimer scheduledTimerWithTimeInterval:userlist_time target:self selector:@selector(reloadUserList) userInfo:nil repeats:YES];
    }
}
//********************************炸金花*******************************************************************//
-(void)startgamepagev{
    [UIView animateWithDuration:0.4 animations:^{
        bottombtnV.frame = CGRectMake(0, _window_height*2, _window_width, _window_height);
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        bottombtnV.hidden = YES;
    });
    self.tableView.hidden = YES;
    if (!gameselectedVC) {
        gameselectedVC = [[gameselected alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height) andArray:_game_switch];
        gameselectedVC.delegate = self;
        [self.view insertSubview:gameselectedVC atIndex:10];
    }
    gameselectedVC.hidden = NO;
    
}
-(void)reloadcoinsdelegate{
    if (gameVC) {
        [gameVC reloadcoins];
    }
}
//更换庄家信息
-(void)changebank:(NSDictionary *)subdic{
    [zhuangVC getNewZhuang:subdic];
}
-(void)changebankall:(NSDictionary *)subdic{
      [socketL getzhuangjianewmessagem:subdic];
      [zhuangVC getNewZhuang:subdic];
}
-(void)getzhuangjianewmessagedelegate:(NSDictionary *)subdic{
    [zhuangVC getNewZhuang:subdic];
}
-(void)gameselect:(int)action{
    //1炸金花  2海盗  3转盘  4牛牛  5二八贝
    self.tableView.hidden = NO;
    switch (action) {
        case 1:
            _method = @"startGame";
            _msgtype = @"15";
            [self startGame];
            break;
        case 2:
            _method = @"startLodumaniGame";
            _msgtype = @"18";
            [self startGame];
            break;
        case 3:
             [self getRotation];
            break;
        case 4:
            _method = @"startCattleGame";
            _msgtype = @"17";
            [self startGame];
            break;
        case 5:
            _method = @"startShellGame";
            _msgtype = @"19";
            [self startsheelGame];
            break;
            
        default:
            break;
    }
    gameselectedVC.hidden = YES;
}
-(void)hideself{

    self.tableView.hidden = NO;
    gameselectedVC.hidden = YES;
}
//********************************转盘*******************************************************************//
-(void)stopRotationgameBySelf{
    [rotationV stopRotatipnGameInt];
     [rotationV stoplasttimer];
    [socketL stopRotationGame];//关闭游戏socket
    [rotationV removeFromSuperview];
    [rotationV removeall];
    rotationV = nil;
    [gameState saveProfile:@"0"];
    [self changeBtnFrame:_window_height - 45];
    [self tableviewheight: _window_height - _window_height*0.2 - 50];
}
-(void)getRotation{
  
    NSString *games = [NSString stringWithFormat:@"%@",[gameState getGameState]];
    if ([games isEqual:@"1"] ) {
        [MBProgressHUD showError:YZMsg(@"请等待游戏结束")];
        return;
    }
    if (zhuangVC) {
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (zhuangVC) {
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (shell) {
        [shell stopGame];
        [shell releaseAll];
        [shell removeFromSuperview];
        shell = nil;
        [gameState saveProfile:@"0"];//保存游戏开始状态
    }
    if (gameVC) {
        [gameVC stopGame];
        [gameVC releaseAll];
        [gameVC removeFromSuperview];
        gameVC = nil;
        [gameState saveProfile:@"0"];//保存游戏开始状态
    }
    if (rotationV) {
        [rotationV stopRotatipnGameInt];
         [rotationV stoplasttimer];
        [socketL stopRotationGame];//关闭游戏socket
        [rotationV removeFromSuperview];
        [rotationV removeall];
        rotationV = nil;
        [gameState saveProfile:@"0"];
    }
    rotationV = [WPFRotateView rotateView];
    [rotationV setlayoutview];
    [rotationV isHost:YES andHostDic:[_roomDic valueForKey:@"stream"]];
    [rotationV hostgetstart];
    rotationV.delegate = self;
    rotationV.frame = CGRectMake(0, _window_height - _window_width/1.8, _window_width, _window_width);
    [self.view insertSubview:rotationV atIndex:6];
    [self changeBtnFrame:_window_height - _window_width/1.8 - www];
    [self tableviewheight: _window_height - _window_height*0.2 - _window_width/1.8 - www];
    [socketL prepRotationGame];
    [self changecontinuegiftframe];
    //防止 竞拍的时候 出现游戏
    if (isjingpaiwriting == YES) {
        rotationV.hidden = YES;
    }
}
//改变tableview高度
-(void)tableviewheight:(CGFloat)h{
    self.tableView.frame = CGRectMake(10,h,tableWidth,_window_height*0.2);
    useraimation.frame = CGRectMake(10,self.tableView.top - 40,_window_width,20);
}
//改变连送礼物的frame
-(void)changecontinuegiftframe{
    liansongliwubottomview.frame = CGRectMake(0, self.tableView.top - 150,_window_width/2,100);
    if (zhuangVC) {
        liansongliwubottomview.frame = CGRectMake(0,self.tableView.top,_window_width/2,100);
    }
}
//更新押注数量
-(void)getRotationCoin:(NSString *)type andMoney:(NSString *)money{
    [rotationV getRotationCoinType:type andMoney:money];
}
-(void)getRotationResult:(NSArray *)array{
    [rotationV getRotationResult:array];
}
//开始倒计时
-(void)startRotationGameSocketToken:(NSString *)token andGameID:(NSString *)ID andTime:(NSString *)time{
    [socketL RotatuonGame:ID andTime:time androtationtoken:token];
}
-(void)changeBtnFrame:(CGFloat)bottombtnH{
    
    keyBTN.frame = CGRectMake(10, bottombtnH, www, www);
    btn.frame = CGRectMake(_window_width - www- 10,bottombtnH, www, www);
    moreBTN.frame = CGRectMake(_window_width - www*3-60,bottombtnH, 60, www);
    messageBTN.frame = CGRectMake(_window_width - www*2 - 20,bottombtnH, www, www);
    btnUserViewClose.frame = CGRectMake(moreBTN.left - 40,bottombtnH, www, www);

    [self.view insertSubview:keyBTN atIndex:6];
    [self.view insertSubview:btn atIndex:6];
    [self.view insertSubview:messageBTN atIndex:6];
    [self.view insertSubview:moreBTN atIndex:6];
    [self showBTN];
    
}
//二八贝游戏********************************************************************************************
-(void)startsheelGame{

    NSString *games = [NSString stringWithFormat:@"%@",[gameState getGameState]];
    if ([games isEqual:@"1"] ) {
        [MBProgressHUD showError:YZMsg(@"请等待游戏结束")];
        return;
    }
    if (zhuangVC) {
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (rotationV) {
        [rotationV stopRotatipnGameInt];
         [rotationV stoplasttimer];
        [socketL stopRotationGame];//关闭游戏socket
        [rotationV removeFromSuperview];
        [rotationV removeall];
        rotationV = nil;
        [gameState saveProfile:@"0"];
    }
    if (shell) {
        [shell stopGame];
        [shell releaseAll];
        [shell gameOver];
        [shell removeFromSuperview];
        shell = nil;
        [gameState saveProfile:@"0"];//保存游戏开始状态
    }
    if (gameVC) {
        [gameVC stopGame];
        [gameVC releaseAll];
        [gameVC removeFromSuperview];
        gameVC = nil;
        [gameState saveProfile:@"0"];//保存游戏开始状态
    }

    if (!shell) {
        shell = [[shellGame alloc]initWIthDic:_roomDic andIsHost:YES andMethod:@"startShellGame" andMsgtype:@"19" andandBanklist:nil];
        shell.delagate = self;
        [self.view insertSubview:shell atIndex:5];
        [socketL prepGameandMethod:_method andMsgtype:_msgtype];
        shell.frame = CGRectMake(0, _window_height - 260, _window_width,260);
        [self changeBtnFrame:_window_height - 230];
        [self tableviewheight:_window_height - _window_height*0.2 - 230];
        [self changecontinuegiftframe];
    }
    //防止 竞拍的时候 出现游戏
    if (isjingpaiwriting == YES) {
        shell.hidden = YES;
    }
}
//二八贝更新押注数量
-(void)getShellCoin:(NSString *)type andMoney:(NSString *)money{
    [shell getShellCoin:type andMoney:money];
}
-(void)getShellResult:(NSArray *)array{
    [shell getShellResult:array];
}
//二八贝游戏********************************************************************************************
//********************************转盘*******************************************************************//
//********************************炸金花   牛仔*******************************************************************//
-(void)startGame{
 
    NSString *games = [NSString stringWithFormat:@"%@",[gameState getGameState]];
    if ([games isEqual:@"1"] ) {
        [MBProgressHUD showError:YZMsg(@"请等待游戏结束")];
        return;
    }
    if (zhuangVC) {
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (rotationV) {
        [rotationV stopRotatipnGameInt];
         [rotationV stoplasttimer];
        [socketL stopRotationGame];//关闭游戏socket
        [rotationV removeFromSuperview];
        [rotationV removeall];
        rotationV = nil;
    }
    if (shell) {
        [shell stopGame];
        [shell releaseAll];
        [shell gameOver];
        [shell removeFromSuperview];
        shell = nil;
    }
    if (gameVC) {
        [gameVC stopGame];
        [gameVC releaseAll];
        [gameVC removeFromSuperview];
        gameVC = nil;
    }
    
    
    [gameState saveProfile:@"0"];//保存游戏开始状态
    
    
    //出现游戏界面
    gameVC = [[gameBottomVC alloc]initWIthDic:_roomDic andIsHost:YES andMethod:_method andMsgtype:_msgtype];
    [socketL prepGameandMethod:_method andMsgtype:_msgtype];
    //判断开始哪个游戏
    gameVC.delagate = self;
    gameVC.frame = CGRectMake(0, _window_height - 230, _window_width,230);
    [self.view insertSubview:gameVC atIndex:5];
    [self changeBtnFrame:_window_height - 230];
    [self tableviewheight:_window_height - _window_height*0.2 -230];
    [self changecontinuegiftframe];
    if ([_method isEqual:@"startCattleGame"]) {
        //上庄玩法
        zhuangVC = [[shangzhuang alloc]initWithFrame:CGRectMake(10,90, _window_width/4, _window_width/4 + 20 + _window_width/8) ishost:YES withstreame:[_roomDic valueForKey:@"stream"]];
        zhuangVC.deleagte = self;
        [self.view insertSubview:zhuangVC atIndex:6];
        [zhuangVC addPoker];
        [zhuangVC addtableview];
        [zhuangVC getbanksCoin:_zhuangDic];
        [self changecontinuegiftframe];
    }
    //防止 竞拍的时候 出现游戏
    if (isjingpaiwriting == YES) {
        gameVC.hidden = YES;
        zhuangVC.hidden = YES;
    }
}
//主播广播准备开始游戏
-(void)prepGame:(NSString *)gameid ndMethod:(NSString *)method andMsgtype:(NSString *)msgtype andBanklist:(NSDictionary *)banklist{
    [socketL takePoker:gameid ndMethod:method andMsgtype:msgtype andBanklist:banklist];
}
//游戏开始，开始倒数计时
-(void)startGameSocketToken:(NSString *)token andGameID:(NSString *)ID andTime:(NSString *)time ndMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    [socketL zhaJinHua:ID andTime:time andJinhuatoken:token ndMethod:method andMsgtype:msgtype];
}
-(void)skate:(NSString *)type andMoney:(NSString *)money andMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    [socketL stakePoke:type andMoney:money andMethod:method andMsgtype:msgtype];
}
-(void)getCoin:(NSString *)type andMoney:(NSString *)money{
    [gameVC getCoinType:type andMoney:money];
}
//得到游戏结果
-(void)getResult:(NSArray *)array{
    [gameVC getResult:array];
    if (zhuangVC) {
        [zhuangVC getresult:array];
    }
}
-(void)stopGamendMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    [socketL stopGamendMethod:method andMsgtype:msgtype];
 
    if (zhuangVC) {
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (gameVC) {
        [gameVC releaseAll];
        [gameVC removeFromSuperview];
        gameVC = nil;
    }
    if (shell) {
        [shell releaseAll];
        [shell removeFromSuperview];
        shell = nil;
    }
    [self changeBtnFrame:_window_height - 45];
    [self tableviewheight:_window_height - _window_height*0.2 - 50];
    [self changecontinuegiftframe];
}
-(void)pushCoinV{
    CoinVeiw *coin = [[CoinVeiw alloc] init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:coin];
    [self presentViewController:navi animated:YES completion:nil];
}
//********************************转盘*******************************************************************//
-(void)reloadUserList{
    if (listView) {
    [listView listReloadNoew];
    }
}
- (void)loginOnOtherDevice{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:YZMsg(@"当前账号已在其他设备登录") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:YZMsg(@"确认") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self hostStopRoom];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

//请求关闭直播
-(void)getCloseShow
{
    [self musicPlay];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Live.stopRoom&uid=%@&token=%@&stream=%@",[Config getOwnID],[Config getOwnToken],urlStrtimestring];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            [self dismissVC];
            [self liveOver];//停止计时器
            [socketL closeRoom];//发送关闭直播的socket
            [socketL colseSocket];//注销socket
            socketL = nil;//注销socket
            //直播结束
            [self onQuit:nil];//停止音乐、停止推流
            [self rmObservers];//释放通知
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [self dismissVC];
        [self liveOver];//停止计时器
        [socketL closeRoom];//发送关闭直播的socket
        [socketL colseSocket];//注销socket
        socketL = nil;//注销socket
        //直播结束
        [self onQuit:nil];//停止音乐、停止推流
        [self rmObservers];//释放通知
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
//礼物效果
/************ 礼物弹出及队列显示开始 *************/
//红包
-(void)redbag{
    
}
-(void)expensiveGiftdelegate:(NSDictionary *)giftData{
    if (!haohualiwuV) {
        haohualiwuV = [[expensiveGiftV alloc]init];
        haohualiwuV.delegate = self;
        [self.view insertSubview:haohualiwuV atIndex:8];
    }
    if (giftData == nil) {
        
        
        
    }
    else
    {
        [haohualiwuV addArrayCount:giftData];
    }
    if(haohualiwuV.haohuaCount == 0){
        [haohualiwuV enGiftEspensive];
    }
}
-(void)expensiveGift:(NSDictionary *)giftData{
    
    if (isjingpaiwriting == YES) {
        
        
        return;
    }
    
    if (!haohualiwuV) {
        haohualiwuV = [[expensiveGiftV alloc]init];
        haohualiwuV.delegate = self;
        [self.view insertSubview:haohualiwuV atIndex:8];
    }
    if (giftData == nil) {
    }
    else
    {
        [haohualiwuV addArrayCount:giftData];
    }
    if(haohualiwuV.haohuaCount == 0){
        [haohualiwuV enGiftEspensive];
    }
}
/*
 *添加魅力值数
 */
-(void)addCoin:(long)coin
{
    long long ordDate = [yingpiaoLabel.text longLongValue];
    long long newDate = ordDate + coin;
    yingpiaoLabel.text = [NSString stringWithFormat:@"%lld",newDate];
    UIFont *font1 = fontMT(13);
    yingpiaoSize= [yingpiaoLabel.text boundingRectWithSize:CGSizeMake(300, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font1} context:nil].size;
    [self changeState];
}
-(void)addvotesdelegate:(NSString *)votes{
    [self addCoin:[votes longLongValue]];
    
}
-(void)switchState:(BOOL)state
{
    NSLog(@"%d",state);
    if(!state)
    {
        keyField.placeholder = YZMsg(@"和大家说些什么");
    }
    else
    {
        keyField.placeholder = [NSString stringWithFormat:@"%@%@ %@",_danmuPrice,[common name_coin],YZMsg(@"开启大喇叭")];
    }
}
- (BOOL)shouldAutorotate {
    return YES;
}
/*************** 以上视频播放 ***************/
/*==================  连麦  ================*/
-(void)initPushStreamer
{
    jingpaiweb = [[jingpaiwebview alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height) andblock:^(NSString *type) {
        //发送竞拍消息
        [socketL sendjiangpaimessage:type];
        [self videotap];
        
        
    } andcancle:^(NSString *type) {
        [self videotap];
    }];
    [self.view addSubview:jingpaiweb];
    jingpaiweb.hidden = YES;
    pushbottomV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    pushbottomV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pushbottomV];

    videobottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    videobottom.backgroundColor = [UIColor clearColor];
    [pushbottomV addSubview:videobottom];
    _gpuStreamer = [[KSYGPUStreamerKit alloc]initWithDefaultCfg];
    
    [_gpuStreamer.preview setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
    _gpuStreamer.aCapDev.micVolume = 1.0;
    
    [_gpuStreamer startPreview:videobottom];
    _filter = [[KSYGPUBeautifyExtFilter alloc] init];
    [_gpuStreamer setupFilter: _filter];
    [(KSYGPUBeautifyExtFilter *)_filter setBeautylevel:4];//level 1.0 ~ 5.0
    
    //采集相关设置初始化
    [self setCaptureCfg];
    NSLog(@"ksy版本号---------%@",[_gpuStreamer getKSYVersion]);
    [self addObservers];
}
-(void)getjingpaimessagedelegate:(NSDictionary *)dic{
    if (hostjingpai) {
        [hostjingpai removeall];
        [hostjingpai removeFromSuperview];
        hostjingpai = nil;
    }
    if (!hostjingpai) {
        NSString *ID = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
        hostjingpai = [[hostjingpaiVC alloc]initWithFrame:CGRectMake(_window_width - _window_width*0.4, 90, _window_width*0.4, 50) andblock:^(NSDictionary *dic) {
            isjingpaiwriting = NO;
            [self getjingpaidic:dic];
        //竞拍结束
        } andjingpaiid:ID];
        [hostjingpai getjingpaimessage:dic];
        [self.view addSubview:hostjingpai];
        [hostjingpai addnowfirstpersonmessahevc];
    }
}
//竞拍结果
-(void)getjingpaidic:(NSDictionary *)dic{
    //竞拍获胜者用户ID，如果为0，说明竞拍失败
    NSString *bid_uid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"bid_uid"]];
    if ([bid_uid isEqual:@"0"]) {
        [socketL jingpaiovermessage:dic andaction:@"3"];
        [hostjingpai addjingpairesultview:3 anddic:dic];
    }
    else{
        [socketL jingpaiovermessage:dic andaction:@"4"];
        [hostjingpai addjingpairesultview:4 anddic:dic];
    }
}
-(void)getnewmessage:(NSDictionary *)dic{
    [hostjingpai getjingpaimessage:dic];
    [hostjingpai getnewmessage:dic];
}
-(void)dojingpai{
    
    useraimation.hidden = YES;
    vipanimation.hidden = YES;
    isjingpaiwriting = YES;
    [keyField resignFirstResponder];
    jingpaiweb.hidden = NO;
    [jingpaiweb loadrequest:urlStrtimestring];
    if (gameVC) {
        gameVC.hidden = YES;
    }
    if (shell) {
        shell.hidden = YES;
    }
    if (rotationV) {
        rotationV.hidden = YES;
    }
    if (zhuangVC) {
        zhuangVC.hidden = YES;
    }
    liansongliwubottomview.hidden = YES;
    haohualiwuV.hidden = YES;
    [self addvideoswipe];
    listView.hidden       = YES;
    frontView.hidden      = YES;
    danmuview.hidden      = YES;
    self.tableView.hidden = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    pushbottomV.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.3f, 0.3f);
    [UIView commitAnimations];
    
    pushbottomV.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.2 animations:^{
        pushbottomV.frame = CGRectMake(_window_width-_window_width*0.3,0,_window_width*0.3,_window_height*0.3);
    }];
    [self hideBTN];
}
//设置videoview拖拽点击
-(void)addvideoswipe{
    [self showBTN];
    if (!videopan) {
        videopan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlepanss:)];
        [pushbottomV addGestureRecognizer:videopan];
    }
    if (!videotap) {
        videotap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videotap)];
    }
    
}
-(void)videotap{
    isjingpaiwriting = NO;
    useraimation.hidden = NO;
    vipanimation.hidden = NO;
    jingpaiweb.hidden = YES;
    [pushbottomV removeGestureRecognizer:videopan];
    videopan = nil;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    pushbottomV.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
    [UIView commitAnimations];
    pushbottomV.frame = CGRectMake(0,0,_window_width,_window_height);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.hidden = NO;
        listView.hidden       = NO;
        frontView.hidden      = NO;
        danmuview.hidden      = NO;
        if (gameVC) {
            gameVC.hidden = NO;
        }
        if (shell) {
            shell.hidden = NO;
        }
        if (rotationV) {
            rotationV.hidden = NO;
        }
        if (zhuangVC) {
            zhuangVC.hidden = NO;
        }
        liansongliwubottomview.hidden = NO;
        haohualiwuV.hidden = NO;
        [self showBTN];
    });
}
- (void) handlepanss: (UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:sender.view];
    CGPoint center = sender.view.center;
    center.x += point.x/3;
    center.y += point.y/3;
    if (center.x <0 ) {
        center.x = 0;
    }
    if (center.x >_window_width) {
        center.x = _window_width - _window_width*0.3;
    }
    if (center.y <0) {
        center.y = 0;
    }
    if ( center.y > _window_height ) {
        center.y = _window_height - _window_height*0.3;
    }
    pushbottomV.center = center;
    //清空
    [sender setTranslation:CGPointZero inView:sender.view];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    CGPoint origin = [[touches anyObject] locationInView:self.view];
    CGPoint location;
    location.x = origin.x/self.view.frame.size.width;
    location.y = origin.y/self.view.frame.size.height;
    [self onSwitchRtcView:location];
}

-(void)callstart{
    [self musicPlay];
    btnUserViewClose.hidden = NO;
    haslianmai = YES;
    _joined = YES;
}
-(void)callstop{
    btnUserViewClose.hidden = YES;
    haslianmai = NO;
    _joined = NO;
}
// 采集相关设置初始化
- (void) setCaptureCfg {
    
    _gpuStreamer.capPreset =  AVCaptureSessionPreset640x480;
    _gpuStreamer.previewDimension = CGSizeMake(640, 360);
    _gpuStreamer.streamDimension = CGSizeMake(640, 360);
    _gpuStreamer.videoFPS = 15;
    _gpuStreamer.cameraPosition = AVCaptureDevicePositionFront;
    _gpuStreamer.streamerBase.videoCodec = KSYVideoCodec_VT264;
    _gpuStreamer.streamerBase.videoInitBitrate = 480;
    _gpuStreamer.streamerBase.videoMaxBitrate  = 800;
    _gpuStreamer.streamerBase.videoMinBitrate  =   0;
    _gpuStreamer.streamerBase.audiokBPS        =  48;
    _gpuStreamer.streamerBase.videoFPS         =  15;
        
}
//收到连麦请求倒计时10s，未接受则主动发消息，未响应
-(void)lianmaidaojishi{
    lianmaitime -= 1;
    if (lianmaitime == 0) {
        lianmaitime = 10;
        [lianmaitimer invalidate];
        lianmaitimer = nil;
        [alertlianmaiVC dismissViewControllerAnimated:YES completion:nil];
        [socketL hostout:lianmaiID];
    }
}
//主播收到连麦请求
-(void)getConnectvideo:(NSString *)AudienceName andAudienceID:(NSString *)Audience{
    //如果不等于10，说明计时器在计时，有人在请求连麦s
    if (lianmaitime != 10 || haslianmai == YES) {
        //主播正忙碌
        [socketL hostisbusy:Audience];
        return;
    }
    lianmaiID = Audience;
    
    lianmaitime -= 1;
    //这里直接减1，防止两个人同时发来消息连麦，一个人收不到回复
    if (lianmaitimer) {
        [lianmaitimer invalidate];
        lianmaitimer = nil;
    }
    if (!lianmaitimer) {
        lianmaitimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(lianmaidaojishi) userInfo:nil repeats:YES];
    }
    
    alertlianmaiVC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"用户%@对您发起连麦申请",AudienceName] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
    UIAlertAction *defaultActionss = [UIAlertAction actionWithTitle:@"接受" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        haslianmaiID = Audience;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_joined ==NO) {
              //   [_gpuStreamer joinChannel:[Config getOwnID]];
            }
            //[socketL replyConnectvideo:@"2" andAudienceID:Audience];
            [lianmaitimer invalidate];
            lianmaitimer = nil;
            lianmaitime = 10;
            
            if (self.player) {
                [self.player stop];
                self.player = nil;
            }
            
            btnUserViewClose.hidden = NO;
            
        });
    }];
    UIAlertAction *cancelActionss = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        haslianmaiID = @"";
        [socketL replyConnectvideo:@"3" andAudienceID:Audience];
        [lianmaitimer invalidate];
        lianmaitimer = nil;
        lianmaitime = 10;
    }];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 9.0) {
        
    }
    else{
        [defaultActionss setValue:normalColors forKey:@"_titleTextColor"];
        [cancelActionss setValue:normalColors forKey:@"_titleTextColor"];
    }
    [alertlianmaiVC addAction:defaultActionss];
    [alertlianmaiVC addAction:cancelActionss];
    [self presentViewController:alertlianmaiVC animated:YES completion:nil];
    //3同意。2 拒绝
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField == keyField) {
        [self pushMessage:nil];
    }
    return YES;
}
-(void) onSwitchRtcView:(CGPoint)location
{
    
}


//关闭连麦
-(void)closeVideo{
    UIAlertController  *alertlianmaiVCtc = [UIAlertController alertControllerWithTitle:@"是否断开连麦" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
    UIAlertAction *defaultActionss = [UIAlertAction actionWithTitle:YZMsg(@"确认") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [socketL closevideo:@""];
        [self xiamai];
    }];
    UIAlertAction *cancelActionss = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    NSString *version = [UIDevice currentDevice].systemVersion;
    
    
    if (version.doubleValue < 9.0) {
        
    }
    else{
        [defaultActionss setValue:normalColors forKey:@"_titleTextColor"];
        [cancelActionss setValue:normalColors forKey:@"_titleTextColor"];
    }
    [alertlianmaiVCtc addAction:defaultActionss];
    [alertlianmaiVCtc addAction:cancelActionss];
    [self presentViewController:alertlianmaiVCtc animated:YES completion:nil];
}
-(void)xiamai:(NSString *)uname andID:(NSString *)uid{
    [self xiamai];
    [alertlianmaiVC dismissViewControllerAnimated:YES completion:nil];
    if ([uid isEqual:haslianmaiID]) {
    lianmaiID = @"";
    NSString *path = [NSString stringWithFormat:@"%@已下麦",uname];
    UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:path message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alerts show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alerts dismissWithClickedButtonIndex:0 animated:YES];
    });
    }
}
-(void)xiamai{
     _joined = NO;
  
    btnUserViewClose.hidden = YES;
    haslianmai = NO;
    _gpuStreamer.aCapDev.micVolume = 1.0;    
}
////////////////////////
- (void)sendZhongJiangMsg:(NSDictionary *)dic{
    if (!toutiaoView) {
        toutiaoView = [[toutiaoAnimation alloc]init];
        toutiaoView.frame = CGRectMake(0, 0, _window_width, 30);
        toutiaoView.delegate = self;
        [self.view addSubview:toutiaoView];
    }else{
        toutiaoView.hidden = NO;
    }
    [toutiaoView addUserMove:dic];

}
- (void)bofangjieshu{
    toutiaoView.hidden = YES;
}

@end
