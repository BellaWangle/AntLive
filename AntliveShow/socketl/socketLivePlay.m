#import "socketLivePlay.h"

@implementation socketMovieplay
//发送弹幕
-(void)sendBarrageID:(NSString *)ID andTEst:(NSString *)content andDic:(NSDictionary *)zhubodic and:(getResults)handler{
    /*******发送弹幕开始 **********/
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Live.sendBarrage"];
    NSDictionary *barrage = @{
                              @"uid":[Config getOwnID],
                              @"token":[Config getOwnToken],
                              @"liveuid":ID,
                              @"stream":[zhubodic valueForKey:@"stream"],
                              @"giftid":@"1",
                              @"giftcount":@"1",
                              @"content":content
                              };
    [session POST:url parameters:barrage progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            handler(responseObject);
        }
        else{
            [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
//建立socket
- (void)setnodejszhuboDic:(NSDictionary *)zhubodic Handler:(getResults)handler andlivetype:(NSString *)livetypes{
    
    _livetype = livetypes;
    __weak socketMovieplay *weakself = self;
    _shut_time = @"0";
    self.playDoc = zhubodic;
     justonce = 0;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Live.enterRoom"];
    NSDictionary *enter = @{
                            @"uid":[Config getOwnID],
                            @"token":[Config getOwnToken],
                            @"liveuid":[zhubodic valueForKey:@"uid"],
                            @"city":[cityDefault getMyCity],
                            @"stream":[zhubodic valueForKey:@"stream"]
                            };
    [session POST:url parameters:enter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                handler(data);
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                _shut_time = [NSString stringWithFormat:@"%@",[info valueForKey:@"shut_time"]];//禁言时间
                _chatserver = [info valueForKey:@"chatserver"];
                [weakself addNodeListen:zhubodic];
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)addNodeListen:(NSDictionary *)dic
{
     __weak socketMovieplay *weakself = self;
    users = [Config myProfile];
    isReConSocket = YES;
    NSURL* url = [[NSURL alloc] initWithString:_chatserver];
   _ChatSocket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @NO,@"forcePolling":@YES}];
    [_ChatSocket connect];
    NSArray *cur = @[@{@"username":[Config getOwnNicename],
                       @"uid":[Config getOwnID],
                       @"token":[Config getOwnToken],
                       @"roomnum":[dic valueForKey:@"uid"],
                       @"stream":[dic valueForKey:@"stream"],
                       @"language":[Config canshu],
                       }];
    [_ChatSocket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
    NSLog(@"socket connected");
        [_ChatSocket emit:@"conn" with:cur];
    }];
    [_ChatSocket on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket.io disconnect---%@",data);
    }];
    [_ChatSocket on:@"error" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket.io error -- %@",data);
    }];
    [_ChatSocket on:@"conn" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"进入房间");
         [weakself getZombie];
        
        //第一次进入 扣费 ，广播其他人增加映票
        if ([_livetype isEqual:@"3"] || [_livetype isEqual:@"2"]) {
            //第一次进入 扣费 ，广播其他人增加映票
            if (justonce == 0) {
                [self addvotes:type_val isfirst:@"1"];
            }
        }
        
    }];
    [_ChatSocket on:@"broadcastingListen" callback:^(NSArray* data, SocketAckEmitter* ack) {
        justonce= 1;
        if ([[data[0] firstObject] isEqual:@"stopplay"]) {
            [weakself.socketDelegate roomCloseByAdmin];
            return ;
        }
        for (NSString *path in data[0]) {
            NSDictionary *jsonArray = [path JSONValue];
            NSDictionary *msg = [[jsonArray valueForKey:@"msg"] firstObject];
            NSString *retcode = [NSString stringWithFormat:@"%@",[jsonArray valueForKey:@"retcode"]];
            NSString *method = [msg valueForKey:@"_method_"];
            if ([retcode isEqual:@"409002"]) {
                [MBProgressHUD showError:YZMsg(@"你已被禁言")];
                return;
            }
            [weakself getmessage:msg andMethod:method];
        }
    }];
}
-(void)getmessage:(NSDictionary *)msg andMethod:(NSString *)method{
    //僵尸粉
    if ([method isEqual:@"requestFans"]) {
        
        NSArray *ct = [msg valueForKey:@"ct"];
        NSArray *data = [ct valueForKey:@"data"];
        if ([[data valueForKey:@"code"]isEqualToNumber:@0]) {
            NSArray *info = [data valueForKey:@"info"];
            NSArray *list = [[info valueForKey:@"list"] firstObject];
            [self.socketDelegate addZombieByArray:list];
        }
    }
    //会话消息
    if ([method isEqual:@"SendMsg"]) {
        //SendMsg   msgtype  26  votes
        NSString *msgtype = [msg valueForKey:@"msgtype"];
        if([msgtype isEqual:@"2"])
        {
            NSString* ct;
            NSDictionary *heartDic = [[NSArray arrayWithObject:msg] firstObject];
            NSArray *sub_heart = [heartDic allKeys];
            //点亮
            if ([sub_heart containsObject:@"heart"]) {
                NSString *lightColor = [heartDic valueForKey:@"heart"];
                NSString *light = @"light";
                NSString *titleColor = [light stringByAppendingFormat:@"%@",lightColor];
//                ct = [NSString stringWithFormat:@"%@", [msg valueForKey:@"ct"]];
                ct = [NSString stringWithFormat:@"%@",YZMsg(@"我点亮了")];
                NSString* uname = minstr([msg valueForKey:@"uname"]);
                NSString *levell = minstr([msg valueForKey:@"level"]);
                NSString *ID = minstr([msg valueForKey:@"uid"]);
                NSString *vip_type =minstr([msg valueForKey:@"vip_type"]);
                NSString *liangname =minstr([msg valueForKey:@"liangname"]);
                NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",vip_type,@"vip_type",liangname,@"liangname",nil];
                [self.socketDelegate light:chat];
            }
            else{
                NSString *titleColor = @"0";
                ct = [NSString stringWithFormat:@"%@", [msg valueForKey:@"ct"]];
                NSString* uname = minstr([msg valueForKey:@"uname"]);
                NSString *levell = minstr([msg valueForKey:@"level"]);
                NSString *ID = minstr([msg valueForKey:@"uid"]);
                NSString *vip_type =minstr([msg valueForKey:@"vip_type"]);
                NSString *liangname =minstr([msg valueForKey:@"liangname"]);
                NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",vip_type,@"vip_type",liangname,@"liangname",nil];
                [self.socketDelegate messageListen:chat];
            }
        }
        //用户离开进入
        if([msgtype isEqual:@"0"])
        {
            NSString *action = [msg valueForKey:@"action"];
            //用户离开
            if ([action isEqual:@"1"]) {
                NSLog(@"用户离开，%@",msg);
                [self.socketDelegate UserLeave:msg];
            }
            //用户进入
            if ([action isEqual:@"0"]) {
                [self.socketDelegate UserAccess:msg];
            }
        }
        //直播关闭
        if ([msgtype isEqual:@"1"]) {
            NSString *action = [msg valueForKey:@"action"];
            if ([action isEqual:@"18"]) {
                NSLog(@"直播关闭");
                [self.socketDelegate LiveOff];
            }
        }
        if ([msgtype isEqual:@"26"]) {
            
            
            
        }
    }
    //增加映票
    else if ([method isEqual:@"updateVotes"]){
        NSString *msgtype = [msg valueForKey:@"msgtype"];
        if ([msgtype isEqual:@"26"])
        {
            //限制进房间的时候自己不增加
            NSString *uid = minstr([msg valueForKey:@"uid"]);
            if (![uid isEqual:[Config getOwnID]]) {
                [self.socketDelegate addvotesdelegate:[msg valueForKey:@"votes"]];
            }
        }
    }
    //房间类型切换
    else if ([method isEqual:@"changeLive"])
    {
        [self.socketDelegate changeLive:[NSString stringWithFormat:@"%@",[msg valueForKey:@"type_val"]]];
    }
    //点亮
    else if ([method isEqual:@"light"]){
        NSString *msgtype = [msg valueForKey:@"msgtype"];
        if([msgtype isEqual:@"0"]){
            NSString *action = [msg valueForKey:@"action"];
            //点亮
            if ([action isEqual:@"2"]) {
                [self.socketDelegate sendLight];
            }
        }
    }else if ([method isEqual:@"ShutUpUser"] ){
        NSString *ct = [NSString stringWithFormat:@"%@%@%@",minstr([msg valueForKey:@"toname"]),YZMsg(@"被禁言"),_shut_time];
        if (ct) {
            [self.socketDelegate setAdmin:ct];
        }
        NSString *touid = [NSString stringWithFormat:@"%@",[msg valueForKey:@"touid"]];

        //禁言
        if ([touid isEqual:[Config getOwnID]]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"提示") message:ct delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
            [alert show];
        }

    }
    //设置管理员
    else if ([method isEqual:@"SystemNot"]){
//        NSString *msgtype = [NSString stringWithFormat:@"%@",[msg valueForKey:@"msgtype"]];
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        NSString *touid = [NSString stringWithFormat:@"%@",[msg valueForKey:@"touid"]];
            //设置取消管理员
        if ([action isEqual:@"13"]) {
//            NSString *ct = [NSString stringWithFormat:@"%@%@",minstr([msg valueForKey:@"toname"]),YZMsg(minstr([msg valueForKey:@"ct"]))];
            NSString *ct;
            NSString *type = minstr([msg valueForKey:@"msgtype"]);
            if ([type isEqual:@"100"]) {
                ct = [NSString stringWithFormat:@"%@%@",minstr([msg valueForKey:@"toname"]),YZMsg(@"关注了主播")];
                
            }else if ([type isEqual:@"101"]) {
                ct = [NSString stringWithFormat:@"%@%@",minstr([msg valueForKey:@"toname"]),YZMsg(@"被设为管理员")];
                
            }else if ([type isEqual:@"102"]) {
                ct = [NSString stringWithFormat:@"%@%@",minstr([msg valueForKey:@"toname"]),YZMsg(@"被取消管理员")];
                
            }else if ([type isEqual:@"103"]) {
                ct = [NSString stringWithFormat:@"%@",YZMsg(@"主播离开一下，精彩不中断，不要走开哦")];
                
            }else if ([type isEqual:@"104"]) {
                ct = [NSString stringWithFormat:@"%@",YZMsg(@"主播回来了")];
            }

            if (ct) {
                [self.socketDelegate setAdmin:ct];
            }
            if ([touid isEqual:[Config getOwnID]]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"提示") message:ct delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
                [alert show];
            }

        }else{
            NSString *ct = [NSString stringWithFormat:@"%@",[msg valueForKey:@"ct"]];
            if (ct) {
                [self.socketDelegate setAdmin:ct];
            }
        }
    }
    //送礼物
    else if([method isEqual:@"SendGift"])
    {
        NSString *titleColor = @"2";
        NSString *haohualiwu =  [NSString stringWithFormat:@"%@",[msg valueForKey:@"evensend"]];
        NSDictionary *ct = [msg valueForKey:@"ct"];
        long totalcoin = [[ct valueForKey:@"totalcoin"] intValue];//记录礼物价值
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
        titleColor = @"2";
        NSString* uname = minstr([msg valueForKey:@"uname"]);
        NSString *levell = minstr([msg valueForKey:@"level"]);
        NSString *ID = minstr([msg valueForKey:@"uid"]);
        NSString *avatar = minstr([msg valueForKey:@"uhead"]);
        NSString *vip_type =minstr([msg valueForKey:@"vip_type"]);
        NSString *liangname =minstr([msg valueForKey:@"liangname"]);
        NSDictionary *chat6 = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ctt,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",avatar,@"avatar",vip_type,@"vip_type",liangname,@"liangname",nil];
        [self.socketDelegate sendGift:chat6 andLiansong:haohualiwu andTotalCoin:totalcoin andGiftInfo:GiftInfo];
        
    }
    //弹幕
    else if([method isEqual:@"SendBarrage"])
    {
        [self.socketDelegate SendBarrage:msg];
        NSLog(@"弹幕接受成功%@",msg);
    }
    //结束直播
    else if([method isEqual:@"StartEndLive"])
    {
        [self.socketDelegate StartEndLive];
    }
    //断开链接
    else if([method isEqual:@"disconnect"])
    {
        [self.socketDelegate UserDisconnect:msg];
    }
    //踢人消息
    else if([method isEqual:@"KickUser"])
    {
        NSString* unamessss = [NSString stringWithFormat:@"%@",[msg valueForKey:@"touid"]];
        if([unamessss isEqual:[Config getOwnID]] ){
            [self.socketDelegate kickOK];
        }
        NSString *titleColor = @"firstlogin";
        NSString *ct = [NSString stringWithFormat:@"%@%@",minstr([msg valueForKey:@"toname"]),YZMsg(@"被踢出房间")];
        NSString *uname = @"直播间消息";
        NSString *levell = @" ";
        NSString *ID = @" ";
        NSString *icon = @" ";
        NSString *vip_type = @"0";
        NSString *liangname = @"0";
        NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:YZMsg(uname),@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",icon,@"avatar",vip_type,@"vip_type",liangname,@"liangname",nil];
        [self.socketDelegate KickUser:chat];
    }
    //发红包
    else if ([method isEqual:@"SendRed"]){
        [self.socketDelegate sendRed:msg];
    }
    //炸金花//收到主播广播准备开始游戏
    ////收到主播广播准备开始游戏
    else if ([method isEqual:@"startGame"] || [method isEqual:@"startLodumaniGame"] || [method isEqual:@"startCattleGame"] ){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        NSString *msgtype = [NSString stringWithFormat:@"%@",[msg valueForKey:@"msgtype"]];
        if ([action isEqual:@"1"]) {
            //出现游戏界面
            [self.socketDelegate prepGameandMethod:method andMsgtype:msgtype];
        }
        else if ([action isEqual:@"2"]){
            if ([method isEqual:@"startCattleGame"]) {
                NSDictionary *bankdic = [msg valueForKey:@"bankerlist"];
                [self.socketDelegate changeBank:bankdic];
            }
            //开始发牌
            [self.socketDelegate takePoker:[msg valueForKey:@"gameid"] Method:method andMsgtype:msgtype];
            
        }
        else if ([action isEqual:@"3"]){
            //主播关闭游戏
            [self.socketDelegate stopGame];
        }
        else if ([action isEqual:@"4"]){
            //游戏开始 倒数计时
            NSString *time = [NSString stringWithFormat:@"%@",[msg valueForKey:@"time"]];//游戏时间
            [self.socketDelegate startGame:time andGameID:[msg valueForKey:@"gameid"]];
        }
        else if ([action isEqual:@"5"]){
            //用户投注
            NSString *money = [NSString stringWithFormat:@"%@",[msg valueForKey:@"money"]];
            NSString *type = [NSString stringWithFormat:@"%@",[msg valueForKey:@"type"]];
            [self.socketDelegate getCoin:type andMoney:money];
        }else if ([action isEqual:@"6"]){
            //开奖
            NSArray *ct = [msg valueForKey:@"ct"];
            [self.socketDelegate getResult:ct];
        }
    }
    else if ([method isEqual:@"startRotationGame"]){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        if ([action isEqual:@"1"]) {
            //出现游戏界面
            [self.socketDelegate prepRotationGame];
        }
        else if ([action isEqual:@"2"]){
            
            
        }
        else if ([action isEqual:@"3"]){
            //主播关闭游戏
            [self.socketDelegate stopRotationGame];
            
        }
        else if ([action isEqual:@"4"]){
            //游戏开始 倒数计时
            NSString *time = [NSString stringWithFormat:@"%@",[msg valueForKey:@"time"]];//游戏时间
            [self.socketDelegate startRotationGame:time andGameID:[msg valueForKey:@"gameid"]];
        }
        else if ([action isEqual:@"5"]){
            //用户投注
            NSString *money = [NSString stringWithFormat:@"%@",[msg valueForKey:@"money"]];
            NSString *type = [NSString stringWithFormat:@"%@",[msg valueForKey:@"type"]];
            [self.socketDelegate getRotationCoin:type andMoney:money];
        }else if ([action isEqual:@"6"]){
            //开奖
            NSArray *ct = [msg valueForKey:@"ct"];
            [self.socketDelegate getRotationResult:ct];
        }
    }
    //二八贝
    else if ([method isEqual:@"startShellGame"]){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        NSString *msgtype = [NSString stringWithFormat:@"%@",[msg valueForKey:@"msgtype"]];
        if ([action isEqual:@"1"]) {
            //出现游戏界面
            [self.socketDelegate shellprepGameandMethod:method andMsgtype:msgtype];
        }
        else if ([action isEqual:@"2"]){
            //开始发牌
            [self.socketDelegate shelltakePoker:[msg valueForKey:@"gameid"] Method:method andMsgtype:msgtype];
        }
        else if ([action isEqual:@"3"]){
            //主播关闭游戏
            [self.socketDelegate shellstopGame];
        }
        else if ([action isEqual:@"4"]){
            //游戏开始 倒数计时
            NSString *time = [NSString stringWithFormat:@"%@",[msg valueForKey:@"time"]];//游戏时间
            [self.socketDelegate shellstartGame:time andGameID:[msg valueForKey:@"gameid"]];
        }
        else if ([action isEqual:@"5"]){
            //用户投注
            NSString *money = [NSString stringWithFormat:@"%@",[msg valueForKey:@"money"]];
            NSString *type = [NSString stringWithFormat:@"%@",[msg valueForKey:@"type"]];
            [self.socketDelegate shellgetCoin:type andMoney:money];
        }else if ([action isEqual:@"6"]){
            //开奖
            NSArray *ct = [msg valueForKey:@"ct"];
            [self.socketDelegate shellgetResult:ct];
        }
    }
    else if ([method isEqual:@"shangzhuang"]){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        //有人上庄
        if ([action isEqual:@"1"]) {
            NSDictionary *subdic = @{
                                     @"uid":[msg valueForKey:@"uid"],
                                     @"uhead":[msg valueForKey:@"uhead"],
                                     @"uname":[msg valueForKey:@"uname"],
                                     @"coin":[msg valueForKey:@"coin"]
                                     };
            [self.socketDelegate getzhuangjianewmessagedelegatem:subdic];
        }
    }
    /*
     竞拍1  主播发送竞拍消息
     2 服务端返回竞拍的信息
     */
    else if ([method isEqual:@"auction"]){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        
        if ([action isEqual:@"1"]) {
            NSDictionary *ct = [msg valueForKey:@"ct"];
            [self.socketDelegate getjingpaimessagedelegate:ct];
        }
        else if ([action isEqual:@"2"]){
            //
            [self.socketDelegate getnewjingpaipersonmessage:msg];
        }
        else if ([action isEqual:@"3"]){
            //竞拍失败，无人竞拍
            [self.socketDelegate jingpaifailed];
        }
        else if ([action isEqual:@"4"]){
            [self.socketDelegate jingpaisuccess:msg];
        }
    }
    
#pragma mark 连麦+声网
    /*
     1 有人发送连麦请求
     2 主播接受连麦
     3 主播拒绝连麦
     4 下麦
     5 主播正忙碌
     6 主播未响应
     */
    else if ([method isEqual:@"ConnectVideo"]){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        if ([action isEqual:@"1"]) {
            return;
        }
        if ([action isEqual:@"4"]){
            [self.socketDelegate xiamai];
        }
        NSString *touid = [NSString stringWithFormat:@"%@",[msg valueForKey:@"touid"]];
        if ([touid isEqual:[Config getOwnID]]) {
            if ([action isEqual:@"2"]) {
                //同意连麦
                [self.socketDelegate startConnectvideo];
            }
            else if ([action isEqual:@"3"]){
                //拒绝连麦
                [MBProgressHUD hideHUD];
                UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:@"主播拒绝了连麦请求" message:nil delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
                [alerts show];
                [self.socketDelegate confuseConnectvideo];
            }
            else  if ([action isEqual:@"5"]){
                
                UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:@"主播正忙碌" message:nil delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
                [alerts show];
                [self.socketDelegate hostisbusy];
                
            }
            else if ([action isEqual:@"6"]){
                //                UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:@"主播未响应" message:nil delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
                //                [alerts show];
                [self.socketDelegate hostout];
            }
        }
    }else if ([method isEqual:@"SendGoldeneggGift"]){
        NSString *msgtype = [NSString stringWithFormat:@"%@",[msg valueForKey:@"msgtype"]];
        if ([msgtype isEqual:@"153"]) {
            NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
            if ([action isEqual:@"153"]) {
                [self.socketDelegate sendZhongJiangMsg:msg];
            }
        }
        
    }
}
//游戏押注
-(void)stakePoke:(NSString *)type andMoney:(NSString *)money andMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": method,
                                        @"action": @"5",
                                        @"msgtype":msgtype,
                                        @"type":type,
                                        @"money":money,
                                        @"uid":[Config getOwnID]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//转盘押注
-(void)stakeRotationPoke:(NSString *)type andMoney:(NSString *)money{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"startRotationGame",
                                        @"action": @"5",
                                        @"msgtype":@"16",
                                        @"type":type,
                                        @"money":money,
                                        @"uid":[Config getOwnID]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//发送竞拍消息
-(void)sendmyjingpaimessage:(NSString *)money{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"auction",
                                        @"action": @"2",
                                        @"msgtype":@"55",
                                        @"money":money,
                                        @"uname":[Config getOwnNicename],
                                        @"uid":[Config getOwnID],
                                        @"uhead":[Config getavatar]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//注销socket
-(void)socketStop{
    [_ChatSocket disconnect];
    [_ChatSocket off:@""];
    [_ChatSocket leaveNamespace];
    _ChatSocket = nil;
}
#pragma mark ----- 发送socket
//红包
-(void)sendRed:(NSString *)money andNodejsInfo:(NSMutableArray *)nodejsInfo{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.sendRed&uid=%@&touid=%@&money=%@&token=%@",[Config getOwnID],[self.playDoc valueForKey:@"uid"],money,[Config getOwnToken]];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            NSString *msg = [data valueForKey:@"msg"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSArray *info = [data valueForKey:@"info"];
                NSString *coin = [info valueForKey:@"coin"];
                NSString *level = [[data valueForKey:@"info"] valueForKey:@"level"];
                //刷新本地魅力值
                users.coin = [NSString stringWithFormat:@"%@",coin];
                [Config updateProfile:users];
                [self.socketDelegate reloadChongzhi:coin];
                NSArray *msgData =@[
                                    @{
                                        @"msg": @[
                                                @{
                                                    @"_method_": @"SendRed",
                                                    @"action": @"0",
                                                    @"ct":[info valueForKey:@"gifttoken"],
                                                    @"msgtype": @"1",
                                                    @"timestamp": @"",
                                                    @"tougood": @"",
                                                    @"touid": @"0",
                                                    @"touname": @"",
                                                    @"ugood":@"",
                                                    @"uid": [Config getOwnID],
                                                    @"uname": [Config getOwnNicename],
                                                    @"equipment": @"app",
                                                    @"roomnum": [self.playDoc valueForKey: @"uid"],
                                                    @"level":level,
                                                    @"city":@"",
                                                    @"evensend":@"n",
                                                    @"usign":@"",
                                                    @"uhead":@"",
                                                    @"sex":@"",
                                                    @"vip_type":[Config getVip_type],
                                                    @"liangname":[Config getliang]
                                                    }
                                                ],
                                        @"retcode": @"000000",
                                        @"retmsg": @"OK"
                                        }
                                    ];
                
                [_ChatSocket emit:@"broadcast" with:msgData];
                
            }
            else{
                [MBProgressHUD showError:msg];
            }
        }
        
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
     }];
}
//点亮
-(void)starlight:(NSString *)level :(NSNumber *)num{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendMsg",
                                        @"action": @"0",
                                        @"ct": @"我点亮了",
                                        @"msgtype": @"2",
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"roomnum": [self.playDoc valueForKey: @"uid"],
                                        @"level":level,
                                        @"heart":num,
                                        @"vip_type":[Config getVip_type],
                                        @"liangname":[Config getliang]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//关注主播
-(void)attentionLive:(NSString *)level{
//    NSString *content = [NSString stringWithFormat:@"%@%@",,YZMsg(@"关注了主播")];
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SystemNot",
                                        @"action": @"13",
                                        @"ct":@"关注了主播",
                                        @"msgtype": @"100",
                                        @"timestamp": @"",
                                        @"tougood": @"",
                                        @"touid": @"0",
                                        @"city":@"",
                                        @"toname": [Config getOwnNicename],
                                        @"ugood": @"",
                                        @"uid": [Config getOwnID],
                                        @"uname": @"直播间消息",
                                        @"equipment": @"app",
                                        @"roomnum": [self.playDoc valueForKey: @"uid"],
                                        @"usign":@"",
                                        @"uhead":@"",
                                        @"level":level,
                                        @"sex":@""
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//房间关闭
-(void)superStopRoom{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"stopLive",
                                        @"action": @"19",
                                        @"ct":@"",
                                        @"msgtype": @"1",
                                        @"timestamp": @"",
                                        @"tougood": @"",
                                        @"touid": @"0",
                                        @"touname": @"",
                                        @"ugood": [Config getOwnID],
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"roomnum":[self.playDoc valueForKey: @"uid"],
                                        @"usign":@"",
                                        @"uhead":users.avatar,
                                        @"level":[Config getLevel],
                                        @"city":@"",
                                        @"sex":@""
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];}
//发送消息
-(void)sendmessage:(NSString *)text andLevel:(NSString *)level{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_":@"SendMsg",
                                        @"action":@"0",
                                        @"ct":text,
                                        @"msgtype":@"2",
                                        @"timestamp":@"",
                                        @"tougood":@"",
                                        @"touid":@"0",
                                        @"city":@"",
                                        @"touname":@"",
                                        @"ugood":@"",
                                        @"uid":[Config getOwnID],
                                        @"uname":[Config getOwnNicename],
                                        @"equipment":@"app",
                                        @"roomnum":[self.playDoc valueForKey: @"uid"],
                                        @"usign":@"",
                                        @"uhead":@"",
                                        @"level":level,
                                        @"sex":@"",
                                        @"vip_type":[Config getVip_type],
                                        @"liangname":[Config getliang]
                                        }
                                    ],
                            @"retcode":@"000000",
                            @"retmsg":@"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//送礼物
-(void)sendGift:(NSString *)level andINfo:(NSString *)info andlianfa:(NSString *)lianfa{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendGift",
                                        @"action": @"0",
                                        @"ct":info ,
                                        @"msgtype": @"1",
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"roomnum": [self.playDoc valueForKey: @"uid"],
                                        @"level":level,
                                        @"evensend":lianfa,
                                        @"uhead":users.avatar,
                                        @"vip_type":[Config getVip_type],
                                        @"liangname":[Config getliang]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//禁言
-(void)shutUp:(NSString *)name andID:(NSString *)ID{
    NSArray* jinyanArray = @[
                             @{
                                 @"msg":
                                     @[@{
                                           @"_method_":@"ShutUpUser",
                                           @"action":@"1",
                                           @"ct":[NSString stringWithFormat:@"%@%@%@",name,YZMsg(@"被禁言"),_shut_time],
                                           @"uid":[Config getOwnID],
                                           @"touid":ID,
                                           @"showid":[Config getOwnID],
                                           @"uname":@"",
                                           @"msgtype":@"4",
                                           @"timestamp":@"",
                                           @"tougood":@"",
                                           @"toname":name,
                                           @"ugood":@""
                                           }],
                                 @"retcode":@"000000",
                                 @"retmsg":@"OK"}];
    
    [MBProgressHUD showSuccess:YZMsg(@"禁言成功")];
    [_ChatSocket emit:@"broadcast" with:jinyanArray];
}
//踢人
-(void)kickuser:(NSString *)name andID:(NSString *)ID{
    NSArray* jinyanArray = @[
                             @{
                                 @"msg":
                                     @[@{
                                           @"_method_":@"KickUser",
                                           @"action":@"2",
                                           @"ct":[NSString stringWithFormat:@"%@%@",name,YZMsg(@"被踢出房间")],
                                           @"uid":[Config getOwnID],
                                           @"touid":ID,
                                           @"showid":[Config getOwnID],
                                           @"uname":@"",
                                           @"msgtype":@"4",
                                           @"timestamp":@"",
                                           @"tougood":@"",
                                           @"toname":name,
                                           @"ugood":@""
                                           }],
                                 @"retcode":@"000000",
                                 @"retmsg":@"OK"}];
    [MBProgressHUD showSuccess:YZMsg(@"踢人成功")];
    [_ChatSocket emit:@"broadcast" with:jinyanArray];
}
//弹幕
-(void)sendBarrage:(NSString *)level andmessage:(NSString *)test{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendBarrage",
                                        @"action": @"7",
                                        @"ct":test ,
                                        @"msgtype": @"1",
                                        @"ugood": [Config getOwnID],
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"roomnum": [self.playDoc valueForKey:@"uid"],
                                        @"level":[Config getLevel],
                                        @"uhead":users.avatar,
                                        @"vip_type":[Config getVip_type],
                                        @"liangname":[Config getliang]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//点亮
-(void)starlight{
    //NSLog(@"发送了点亮消息");
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"light",
                                        @"action": @"2",
                                        @"msgtype": @"0",
                                        @"timestamp": @"",
                                        @"tougood": @"",
                                        @"touname": @"",
                                        @"ugood": @"",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//僵尸粉
-(void)getZombie{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"requestFans",
                                        @"timestamp":@"",
                                        @"msgtype": @"0",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
#pragma mark 连麦+声网
//连麦socket
-(void)sendlianmaicoin{
    NSArray *msgData2 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_":@"ConnectVideo",
                                         @"action": @"5",
                                         @"msgtype": @"10",
                                         @"uid":[Config getOwnID],
                                         @"uname": [Config getOwnNicename],
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [_ChatSocket emit:@"broadcast" with:msgData2];
}
-(void)xiamaisocket{
    NSArray *msgData2 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_":@"ConnectVideo",
                                         @"action": @"4",
                                         @"msgtype": @"10",
                                         @"uid":[Config getOwnID],
                                         @"uname": [Config getOwnNicename],
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [_ChatSocket emit:@"broadcast" with:msgData2];
}
//发送连麦邀请
-(void)connectvideoToHost{
    
    NSArray *msgData2 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_":@"ConnectVideo",
                                         @"action": @"1",
                                         @"msgtype": @"10",
                                         @"uid":[Config getOwnID],
                                         @"uname": [Config getOwnNicename],
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [_ChatSocket emit:@"broadcast" with:msgData2];
}
//上庄
-(void)getzhuangjianewmessagem:(NSDictionary *)subdic{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_":@"shangzhuang",
                                        @"action":@"1",
                                        @"msgtype":@"25",
                                        @"uid":[subdic valueForKey:@"uid"],
                                        @"uhead":[subdic valueForKey:@"uhead"],
                                        @"uname":[subdic valueForKey:@"uname"],
                                        @"coin":[subdic valueForKey:@"coin"]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}

//第一次进入 扣费 ，广播其他人增加映票
-(void)addvotesenterroom:(NSString *)votes{
    type_val = votes;
    
}

//增加映票
-(void)addvotes:(NSString *)votes isfirst:(NSString *)isfirst{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"updateVotes",
                                        @"action":@"1",
                                        @"votes":votes,
                                        @"msgtype": @"26",
                                        @"uid":[Config getOwnID],
                                        @"isfirst":isfirst
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
- (void)zhongjiangSocket:(NSDictionary *)dic{
    NSArray *msgData2 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_":@"SendGoldeneggGift",
                                         @"action": @"153",
                                         @"msgtype": @"153",
                                         @"uid":[Config getOwnID],
                                         @"uname": [dic valueForKey:@"user_nicename"],
                                         @"gifticon":minstr([dic valueForKey:@"gifticon"]),
                                         @"giftname":[dic valueForKey:@"giftname"]
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [_ChatSocket emit:@"broadcast" with:msgData2];
    
}

@end
