#import "messageC.h"
#import "chatController.h"
#import "messageModel.h"
#import "messageCellcell.h"
#import "ZFModalTransitionAnimator.h"
#import "personMessage.h"
@interface messageC ()<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    UISegmentedControl *segmentC;
    UILabel *xianLabel;//下划线
    UILabel *xianLabel2;
    CGFloat w;//segment一个item的宽
    NSString *lastMessage;//获取最后一条消息
    UILabel *label1;//获取会话所有的未读消息数 关注
    UILabel *label2;//未关注
    NSTimer *chattimer;
    UILabel *line1;
    UILabel *line2;
    NSString *idStrings;//获取用户列表所有人的id
}
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property(nonatomic,strong)NSArray *models;
@property(nonatomic,strong)NSMutableArray *UNfollowArray;//未关注好友
@property(nonatomic,strong)NSMutableArray *followArray;//关注好友
@property(nonatomic,strong)NSMutableArray *JIMallArray;//所有
@property(nonatomic,strong)UITableView *tableView;
@end
@implementation messageC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self forMessage];
}
-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    [self forMessage];
}
-(void)onConversationChanged:(JMSGConversation *)conversation{
     [self forMessage];
}
#pragma mark --排序conversation
- (NSMutableArray *)sortConversation:(NSMutableArray *)conversationArr {
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"latestMessage.timestamp" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *sortedArray = [conversationArr sortedArrayUsingDescriptors:sortDescriptors];
    return [NSMutableArray arrayWithArray:sortedArray];
}
-(void)forMessage{
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        if (error == nil) {
        self.JIMallArray = nil;
        self.JIMallArray = [NSMutableArray array];
        self.followArray = nil;
        self.followArray = [NSMutableArray array];
        self.UNfollowArray = nil;
        self.UNfollowArray = [NSMutableArray array];
        self.JIMallArray = [self sortConversation:resultObject];
        [self.tableView reloadData];
        idStrings = nil;
        idStrings = [NSString string];
        for (int i=0; i < [self.JIMallArray count]; i++) {
            JMSGConversation *conversation = [resultObject objectAtIndex:i];
            NSString *name = [NSString stringWithFormat:@"%@",[conversation.target valueForKey:@"username"]];
            name = [name stringByReplacingOccurrencesOfString:JmessageName withString:@""];
            idStrings = [idStrings stringByAppendingFormat:@"%@,",name];
         }
        if (idStrings.length > 1) {
            //获取列表所有人的id
           idStrings = [idStrings substringToIndex:[idStrings length] - 1];
         }
            [self getUserList:idStrings];
       }
        else{
            self.followArray  = nil;
            self.UNfollowArray = nil;
            [self.tableView reloadData];
        }
    }];
}
-(void)getUserList:(NSString *)touid{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];// User.getMultiInfo
    NSString *url = [purl stringByAppendingFormat:@"service=User.getUidsInfo&uid=%@&uids=%@",[Config getOwnID],touid];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *number = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"ret"] ];
        if([number isEqual:@"200"])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"])
            {
                NSArray *info = [data valueForKey:@"info"];
                for (int i=0; i<info.count; i++) {
                    NSMutableDictionary *subdic = [NSMutableDictionary dictionaryWithDictionary:info[i]];
                    NSString *utot = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"utot"]];
                    if ([utot isEqual:@"1"]) {
                        [self.followArray addObject:subdic];
                    }else{
                        [self.UNfollowArray addObject:subdic];
                    }
                    for (JMSGConversation *conversation in self.JIMallArray) {
                        NSString *conversationid = [NSString stringWithFormat:@"%@",[conversation.target valueForKey:@"username"]];
                        conversationid = [conversationid stringByReplacingOccurrencesOfString:JmessageName withString:@""];
                        NSString *touid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
                        if ([conversationid isEqual:touid]) {
                            [subdic setObject:conversation forKey:@"conversation"];
                        }
                    }
                }
            }
        }
         [self.tableView reloadData];
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
     }];
}
-(NSArray *)models{
    NSMutableArray *array = [NSMutableArray array];
    if (segmentC.selectedSegmentIndex == 0 || segmentC.selectedSegmentIndex == 1) {
        for (int i=0;i<self.followArray.count;i++) {
            NSDictionary *dic = self.followArray[i];
            messageModel *model = [messageModel modelWithDic:dic];
            [array addObject:model];
        }
    }
    else
    {
        for (int i=0;i<self.UNfollowArray.count;i++) {
            NSDictionary *dic = self.UNfollowArray[i];
            messageModel *model = [messageModel modelWithDic:dic];
            [array addObject:model];
        }
    }
    
//计算未读消息
    int unread1 = 0;
    for (int i=0; i<self.UNfollowArray.count; i++) {
        NSDictionary *subdic = self.UNfollowArray[i];
        JMSGConversation *conversation = [subdic valueForKey:@"conversation"];
        unread1 += [conversation.unreadCount intValue];
    }
    if (unread1 >0) {
        label2.hidden = NO;
        label2.text = [NSString stringWithFormat:@"%d",unread1];
    }else{
        label2.hidden = YES;
        label2.text = @"";
    }
    int unread2 = 0;
    for (int i=0; i<self.followArray.count; i++) {
        NSDictionary *subdic = self.followArray[i];
        JMSGConversation *conversation = [subdic valueForKey:@"conversation"];
        unread2 += [conversation.unreadCount intValue];
    }
    if (unread2 >0) {
        label1.hidden = NO;
        label1.text = [NSString stringWithFormat:@"%d",unread2];
    }else{
        label1.hidden = YES;
        label1.text = @"";
    }
    
    if (self.followArray.count == 0) {
        label1.hidden = YES;
    }
    if (self.UNfollowArray.count == 0) {
        label2.hidden = YES;
    }
    _models = array;
    return _models;
}
//返回
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//忽略未读
-(void)weidu:(UIButton *)sender{
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    int unreadCount = 0;
    for (JMSGConversation *Conversation in self.JIMallArray) {
        unreadCount += [Conversation.unreadCount intValue];
        [Conversation clearUnreadCount];
    }
    if (unreadCount>0) {
        UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:YZMsg(@"已经忽略未读消息") message:nil delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
        [alerts show];
        [self forMessage];
    }
    else{
        UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:YZMsg(@"暂无未读消息") message:nil delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
        [alerts show];
    }
}
-(void)getview{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationItem.leftBarButtonItem = nil;
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor = RGB(256, 256, 256);
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor blackColor];
    returnBtn.frame = CGRectMake(10,30 + statusbarHeight,30,20);[returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    returnBtn.tintColor = [UIColor blackColor];
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightBTN = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBTN setTitle:YZMsg(@"忽略") forState:UIControlStateNormal];
    rightBTN.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightBTN addTarget:self action:@selector(weidu:) forControlEvents:UIControlEventTouchUpInside];
    [rightBTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBTN.frame = CGRectMake(_window_width - 80,34 + statusbarHeight, 80, 20);
    rightBTN.titleLabel.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:rightBTN];
    [navtion addSubview:returnBtn];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,64+ statusbarHeight);
    [navtion addSubview:btnttttt];
    [self.view addSubview:navtion];
    
    NSString *space = @" ";
    NSArray *array = @[YZMsg(@"已关注"),space,YZMsg(@"未关注")];
    segmentC = [[UISegmentedControl alloc]initWithItems:array];
    [segmentC addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    segmentC.tintColor = [UIColor clearColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:fontMT(15),NSFontAttributeName,[UIColor grayColor], NSForegroundColorAttributeName, nil];
    [segmentC setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:fontMT(16),NSFontAttributeName,[UIColor blackColor], NSForegroundColorAttributeName, nil];
    [segmentC setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    segmentC.selectedSegmentIndex = 0;
    [navtion addSubview:segmentC];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,70+ statusbarHeight, _window_width, _window_height-44 - statusbarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor  = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    
    
    segmentC.frame = CGRectMake(_window_width/6.5/2,statusbarHeight + 20,130,20);
    segmentC.center = CGPointMake(navtion.center.x, statusbarHeight + 34);
    [segmentC setWidth:55 forSegmentAtIndex:0];
    [segmentC setWidth:20 forSegmentAtIndex:1];
    [segmentC setWidth:55 forSegmentAtIndex:2];
    //标记未读消息
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(54,0,18,18)];
    label1.backgroundColor = [UIColor redColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.layer.masksToBounds = YES;
    label1.layer.cornerRadius = 9;
    label1.font = fontMT(10);
    label1.textColor = [UIColor whiteColor];
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(129,0,18,18)];
    label2.backgroundColor = [UIColor redColor];
    label2.layer.masksToBounds = YES;
    label2.layer.cornerRadius = 9;
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = fontMT(10);
    label2.hidden = YES;
    label1.hidden = YES;
    [segmentC addSubview:label2];
    [segmentC addSubview:label1];
    
    
    line1 = [[UILabel alloc]initWithFrame:CGRectMake(8,31,40,3)];
    line1.backgroundColor = [UIColor blackColor];
    line2 = [[UILabel alloc]initWithFrame:CGRectMake(84,31,41,3)];
    line2.backgroundColor = [UIColor blackColor];
    line2.hidden = YES;
    line1.hidden = NO;
    [segmentC addSubview:line2];
    [segmentC addSubview:line1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    idStrings = [NSString string];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.view.backgroundColor =  [UIColor groupTableViewBackgroundColor];
    _followArray = [NSMutableArray array];
    _UNfollowArray = [NSMutableArray array];
    _JIMallArray = [NSMutableArray array];
    [self getview];//初始化界面
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    messageModel *model = self.models[indexPath.row];
    if (segmentC.selectedSegmentIndex == 0) {
        NSDictionary *subdic = self.followArray[indexPath.row];
        JMSGConversation *conversation =subdic[@"conversation"];
        [conversation clearUnreadCount];
    }
    if (segmentC.selectedSegmentIndex == 2) {
        NSDictionary *subdic = self.UNfollowArray[indexPath.row];
        JMSGConversation *conversation =subdic[@"conversation"];
        [conversation clearUnreadCount];
    }
    [JMSGConversation deleteSingleConversationWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,model.uid]];
    [self forMessage];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return self.models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    messageCellcell *cell = [messageCellcell cellWithTableView:tableView];
    messageModel *model = self.models[indexPath.row];
    cell.model = model;
    return cell;
}
-(void)edit{    
    self.tableView.editing = YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (segmentC.selectedSegmentIndex == 0) {
        if (self.followArray.count == 0) {
            return;
        }
    }
    if (segmentC.selectedSegmentIndex == 2) {
        if (self.UNfollowArray.count  == 0) {
            return;
        }
    }
    chatController *chat = [[chatController alloc]init];
    messageModel *model = self.models[indexPath.row];
    
    
    [JMSGConversation createSingleConversationWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,model.uid] completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            chat.msgConversation = resultObject;
            chat.chatID = model.uid;
            chat.avatar = model.imageIcon;
            chat.chatname = model.userName;
            [chat.msgConversation clearUnreadCount];
            [[MXBADelegate sharedAppDelegate] pushViewController:chat animated:YES];
        }else{
           [MBProgressHUD showError:error.localizedDescription];
        }
    }];
}
//segment事件
-(void)change:(UISegmentedControl *)segment{
    if (segment.selectedSegmentIndex == 0) {
        line1.hidden = NO;
        line2.hidden = YES;
         [self forMessage];
    }else if (segmentC.selectedSegmentIndex == 1){
      
        
    }
    else if (segment.selectedSegmentIndex == 2){
        line1.hidden = YES;
        line2.hidden = NO;
         [self forMessage];
    }
}
@end
