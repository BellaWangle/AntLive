#import "LivePlay.h"

/*
tableview->->backscrollview 4
_danmuView->backscrollview 5
gamevc->backscrollview 6
userview->backscroll添加 7
haohualiwuv->backscrollview 8
liansongliwubottomview->backscrollview 8
 
 
 
UI层次（从低到高，防止覆盖问题）
tableview（聊天） 4
弹幕 5
game 5
私信 7
私信聊天 8
礼物（连送、豪华）9
弹窗 window add
*/

#import <ReplayKit/ReplayKit.h>
#import "zajindan.h"
#import "toutiaoAnimation.h"
//新礼物结束
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define upViewW     _window_width*0.8

@interface moviePlay ()
<
UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,dianjishijian,UIScrollViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate ,catSwitchDelegate,UIAlertViewDelegate,socketDelegate,frontviewDelegate,sendGiftDelegate,upmessageKickAndShutUp,haohuadelegate,listDelegate,gameDelegate,WPFRotateViewDelegate,shangzhuangdelegate,zajindanDelegate,toutiaoDelegate
>
@end
int d =1;
@implementation moviePlay
{
    NSMutableArray *msgList;
  
    UIAlertController  *Feedeductionalertc;//扣费alert
    zajindan *goldView;
    toutiaoAnimation *toutiaoView;
    int sssss;
}
#pragma socketDelegate
//准备炸金花游戏
//*********************************************************************** 炸金花********************************//
-(void)stopGamendMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    
    
    
}
-(void)prepGameandMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    if (gameVC) {
        [gameVC releaseAll];
        [gameVC removeFromSuperview];
        gameVC = nil;
    }
    gameVC = [[gameBottomVC alloc]initWIthDic:_playDoc andIsHost:NO andMethod:method andMsgtype:msgtype];
    gameVC.delagate = self;
    gameVC.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
    [self changeBtnFrame:_window_height - 260];
    [backScrollView insertSubview:gameVC atIndex:4];
    [backScrollView insertSubview:_liwuBTN atIndex:5];
    [self tableviewheight:_window_height - _window_height*0.2 -260];
    [self changecontinuegiftframe];
    //上庄
    if ([method isEqual:@"startCattleGame"]) {
        if (!zhuangVC) {
            zhuangVC = [[shangzhuang alloc]initWithFrame:CGRectMake(_window_width + 10,90, _window_width/4, _window_width/4 + 20 + _window_width/8) ishost:NO withstreame:[self.playDoc valueForKey:@"stream"]];
            zhuangVC.deleagte = self;
            [backScrollView insertSubview:zhuangVC atIndex:10];
            [backScrollView bringSubviewToFront:zhuangVC];
            [zhuangVC addtableview];
            [zhuangVC getbanksCoin:zhuangstartdic];
        }
    }
}
//**************************************************上庄操作***********************

-(void)changeBank:(NSDictionary *)bankdic{
       [gameVC changebankid:[bankdic valueForKey:@"id"]];
       [zhuangVC getNewZhuang:bankdic];
}
-(void)getzhuangjianewmessagedelegatem:(NSDictionary *)subdic{
    
    [zhuangVC getNewZhuang:subdic];
    
}
-(void)takePoker:(NSString *)gameid Method:(NSString *)method andMsgtype:(NSString *)msgtype{
    if (!gameVC) {
        gameVC = [[gameBottomVC alloc]initWIthDic:_playDoc andIsHost:NO andMethod:method andMsgtype:msgtype];
        gameVC.delagate = self;
        gameVC.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
        [self changeBtnFrame:_window_height - 260];
        [backScrollView insertSubview:gameVC atIndex:4];
        [backScrollView insertSubview:_liwuBTN atIndex:5];
    }
    //上庄
    if ([method isEqual:@"startCattleGame"]) {
        if (!zhuangVC) {
            zhuangVC = [[shangzhuang alloc]initWithFrame:CGRectMake(_window_width + 10,90, _window_width/4, _window_width/4 + 20 + _window_width/8) ishost:NO withstreame:[self.playDoc valueForKey:@"stream"]];
            zhuangVC.deleagte = self;
            [backScrollView insertSubview:zhuangVC atIndex:10];
            [zhuangVC getbanksCoin:zhuangstartdic];
            [zhuangVC addtableview];
        }
        [zhuangVC addPoker];
    }
    [self tableviewheight:_window_height - _window_height*0.2 -260 - www ];
    //wangminxinliwu
    [self changecontinuegiftframe];
    [gameVC createUI];
}
-(void)startGame:(NSString *)time andGameID:(NSString *)gameid{
    [gameVC movieplayStartCut:time andGameid:gameid];
}
//得到游戏结果
-(void)getResult:(NSArray *)array{
    [gameVC getResult:array];
    if (zhuangVC) {
        [zhuangVC getresult:array];
    }
    
}
-(void)reloadcoinsdelegate{
    if (gameVC) {
        [gameVC reloadcoins];
    }
}
-(void)stopGame{
    if (zhuangVC) {
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    [gameVC removeFromSuperview];
    gameVC = nil;
    [self changeBtnFrame:_window_height - 45];
    [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 50];
    //wangminxinliwu
    [self changecontinuegiftframe];
}
//用户投注
-(void)skate:(NSString *)type andMoney:(NSString *)money andMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    [socketDelegate stakePoke:type andMoney:money andMethod:method andMsgtype:msgtype];
}
-(void)getCoin:(NSString *)type andMoney:(NSString *)money{
    [gameVC getCoinType:type andMoney:money];
}

//*********************************************************************** 炸金花********************************//
//*********************************************************************** 二八贝********************************//
-(void)shellprepGameandMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    if (shell) {
        [shell gameOver];
        [shell removeFromSuperview];
        shell = nil;
    }
    shell = [[shellGame alloc]initWIthDic:_playDoc andIsHost:NO andMethod:@"startShellGame" andMsgtype:@"19" andandBanklist:nil];
    shell.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
    shell.delagate = self;
    [backScrollView insertSubview:shell atIndex:4];
    [backScrollView insertSubview:_liwuBTN atIndex:5];
    [self changeBtnFrame:_window_height - 45 - 215];
     [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2- 265];
    //wangminxinliwu
    [self changecontinuegiftframe];
}
-(void)shelltakePoker:(NSString *)gameid Method:(NSString *)method andMsgtype:(NSString *)msgtype{
    if (!shell) {
        shell = [[shellGame alloc]initWIthDic:_playDoc andIsHost:NO andMethod:@"startShellGame" andMsgtype:@"19" andandBanklist:nil];
        shell.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
        shell.delagate = self;
        [backScrollView insertSubview:shell atIndex:4];
        [backScrollView insertSubview:_liwuBTN atIndex:5];
    }
    [self changeBtnFrame:_window_height - 45 - 215];
    [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2- 265];
    //wangminxinliwu
    [self changecontinuegiftframe];
    [shell createUI];
}
-(void)shellstopGame{
    [shell gameOver];
    [shell removeFromSuperview];
    [self changeBtnFrame:_window_height - 45];
    shell = nil;
    [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 50];
    //wangminxinliwu
    [self changecontinuegiftframe];
}
-(void)shellgetResult:(NSArray *)array{
    [shell getShellResult:array];
}
//开始倒数计时
-(void)shellstartGame:(NSString *)time andGameID:(NSString *)gameid{
    [shell movieplayStartCut:time andGameid:gameid];
}
-(void)shellgetCoin:(NSString *)type andMoney:(NSString *)money{
    [shell getShellCoin:type andMoney:money];
}
-(void)shellstakePoke:(NSString *)type andMoney:(NSString *)money andMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    [socketDelegate stakePoke:type andMoney:money andMethod:method andMsgtype:msgtype];
}
//**********************************************************************转盘游戏
//关闭游戏
-(void)stopRotationGame{
    [self setbtnframe];
     [rotationV stopRotatipnGameInt];
     [rotationV stoplasttimer];
    [rotationV removeFromSuperview];
    [rotationV removeall];
    rotationV = nil;
    [self changeBtnFrame:_window_height - 45];
    [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 50];
    //wangminxinliwu
    [self changecontinuegiftframe];
}
//出现游戏界面
-(void)prepRotationGame{
    [self getRotation];
}
-(void)getRotation{
    if (zhuangVC) {
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (!rotationV) {
        isRotationGame = YES;
        rotationV = [WPFRotateView rotateView];
        [rotationV setlayoutview];
        rotationV.delegate = self;
        [rotationV isHost:NO andHostDic:[_playDoc valueForKey:@"stream"]];
        rotationV.frame = CGRectMake(_window_width, _window_height - _window_width/1.5, _window_width, _window_width);
        [backScrollView insertSubview:rotationV atIndex:6];
        [backScrollView insertSubview:_liwuBTN atIndex:7];
        [rotationV addtableview];
    }
    rotationV.frame = CGRectMake(_window_width, _window_height - _window_width/1.5, _window_width, _window_width);
    [self changeBtnFrame:_window_height - 45 - _window_width/1.5];
    
}
-(void)changeBtnFrame:(CGFloat)hhh{
    
    if (rotationV) {
        [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - _window_width+_window_width/5];
        [self changecontinuegiftframe];
    }
    CGFloat  wwwssss = 30;
    keyBTN.frame = CGRectMake(_window_width + 15,hhh, www, www);
    _returnCancle.frame = CGRectMake(_window_width*2-wwwssss-10,hhh,wwwssss,wwwssss);
    _liwuBTN.frame = CGRectMake(_window_width*2 - wwwssss*2-20,hhh,wwwssss,wwwssss);
    _fenxiangBTN.frame = CGRectMake(_window_width*2 - wwwssss*3-30,hhh, wwwssss, wwwssss);
    _messageBTN.frame = CGRectMake(_window_width*2 - wwwssss*4-40,hhh, wwwssss,wwwssss);
    _connectVideo.frame = CGRectMake(_window_width*2 - wwwssss*5-50,hhh + 2,27,27);
    NSArray *shareplatforms = [common share_type];
    if (shareplatforms.count == 0) {
        _fenxiangBTN.hidden = YES;
        _messageBTN.frame = CGRectMake(_window_width*2 - wwwssss*3 - 30,hhh, wwwssss,wwwssss);
        _connectVideo.frame = CGRectMake(_window_width*2 - wwwssss*4 - 40,hhh + 2,27,27);
    }
}
//开始倒计时
-(void)startRotationGame:(NSString *)time andGameID:(NSString *)gameid{
    [self getRotation];
    [rotationV movieplayStartCut:time andGameid:gameid];
}
//获取游戏结果
-(void)getRotationResult:(NSArray *)array{
    [rotationV getRotationResult:array];
}
//用户押注
-(void)skateRotaton:(NSString *)type andMoney:(NSString *)money{
    [socketDelegate stakeRotationPoke:type andMoney:money];
}
//更新押注数量
-(void)getRotationCoin:(NSString *)type andMoney:(NSString *)money{
    [rotationV getRotationCoinType:type andMoney:money];
}
//*****************************************************************************
-(void)superAdmin:(NSString *)state{
    [socketDelegate superStopRoom];
    haohualiwuV.expensiveGiftCount = nil;
    [self releaseObservers];
    [self lastView];
}
-(void)roomCloseByAdmin{
    [self lastView];
}
-(void)addZombieByArray:(NSArray *)array{
    if (!listView) {
        listView = [[ListCollection alloc]initWithListArray:_listArray andID:[self.playDoc valueForKey:@"uid"]andStream:[NSString stringWithFormat:@"%@",[self.playDoc valueForKey:@"stream"]]];
        listView.delegate = self;
        listView.frame = CGRectMake(_window_width+110, 20 + sssss, _window_width-130, 40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-130, 40);
        [backScrollView addSubview:listView];
    }
    [listView listarrayAddArray:array];
    userCount += array.count;
    setFrontV.onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
}
-(void)light:(NSDictionary *)chats{
    [msgList addObject:chats];
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast];
}
-(void)messageListen:(NSDictionary *)chats{
        [msgList addObject:chats];
        titleColor = @"0";
        if(msgList.count>30)
        {
            [msgList removeObjectAtIndex:0];
        }
        [self.tableView reloadData];
        [self jumpLast];
}
-(void)UserLeave:(NSDictionary *)msg{
    userCount -= 1;
    setFrontV.onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
    if (listView) {
        [listView userLive:msg];
    }
}
//********************************用户进入动画********************************************//
-(void)UserAccess:(NSDictionary *)msg{
    
    //用户进入
    userCount += 1;
    if (listView) {
        [listView userAccess:msg];
    }
    setFrontV.onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
    //进场动画级别限制
    NSString *levelLimit = [NSString stringWithFormat:@"%@",[[msg valueForKey:@"ct"] valueForKey:@"level"]];
    int levelLimits = [levelLimit intValue];
    int levelLimitsLocal = [[common enter_tip_level] intValue];
    if (levelLimitsLocal >levelLimits) {

        
    }else{
        
        [useraimation addUserMove:msg];
        useraimation.frame = CGRectMake(_window_width + 10,self.tableView.top - 40,_window_width,20);
        
    }
    NSString *car_id = minstr([[msg valueForKey:@"ct"] valueForKey:@"car_id"]);
    if (![car_id isEqual:@"0"]) {
        if (!vipanimation) {
            vipanimation = [[viplogin alloc]initWithFrame:CGRectMake(_window_width,_window_height*0.3,_window_width,_window_width*0.4) andBlock:^(id arrays) {
                [vipanimation removeFromSuperview];
                vipanimation = nil;
            }];
            vipanimation.frame =CGRectMake(_window_width,_window_height*0.3,_window_width,_window_width*0.4);
            [backScrollView insertSubview:vipanimation atIndex:10];
            UITapGestureRecognizer  *tapvip = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starok)];
            [vipanimation addGestureRecognizer:tapvip];
      }
        [vipanimation addUserMove:msg];
        
    }
    [self userLoginSendMSG:msg];
}
//用户进入直播间发送XXX进入了直播间
-(void)userLoginSendMSG:(NSDictionary *)dic {
    titleColor = @"userLogin";
    NSString *uname = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"user_nicename"]];
    NSString *levell = @" ";
    NSString *ID = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"id"]];;
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
    [self jumpLast];
}
////////////////////////////////////////////////////
-(void)LiveOff{
    [self lastView];
}
-(void)sendLight{
   [self staredMove];
}
-(void)setAdmin:(NSString *)msg{
    titleColor = @"firstlogin";
    NSString *uname = @"直播间消息";
    NSString *ID = @"";
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:YZMsg(uname),@"userName",msg,@"contentChat",ID,@"id",titleColor,@"titleColor",nil];
    [msgList addObject:chat];
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast];
}
-(void)sendGift:(NSDictionary *)chats andLiansong:(NSString *)liansong andTotalCoin:(long)totalcoin andGiftInfo:(NSDictionary *)giftInfo{
          [msgList addObject:chats];
          [self addCoin:totalcoin];//添加映票
          NSNumber *number = [giftInfo valueForKey:@"giftid"];
          NSString *giftid = [NSString stringWithFormat:@"%@",number];
    if (!continueGifts) {
        continueGifts = [[continueGift alloc]init];
        [liansongliwubottomview addSubview:continueGifts];
        //初始化礼物空位
        [continueGifts initGift];
    }
      if ([giftid isEqual:@"22"] || [giftid isEqual:@"21"] ||  [giftid isEqual:@"9"] ||  [giftid isEqual:@"19"]) {
        [self expensiveGift:giftInfo];
    }
    else{
        [continueGifts GiftPopView:giftInfo andLianSong:haohualiwu];
    }
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast];
}
-(void)SendBarrage:(NSDictionary *)msg{
    NSString *text = [NSString stringWithFormat:@"%@",[[msg valueForKey:@"ct"] valueForKey:@"content"]];
    NSString *name = [msg valueForKey:@"uname"];
    NSString *icon = [msg valueForKey:@"uhead"];
    NSDictionary *userinfo = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"title",name,@"name",icon,@"icon",nil];
    [_danmuView setModel:userinfo];
    long totalcoin = [self.danmuprice intValue];
    [self addCoin:totalcoin];
}
-(void)StartEndLive{
    [self lastView];
}
-(void)UserDisconnect:(NSDictionary *)msg{
    userCount -= 1;
    setFrontV.onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
    if (listView) {
        [listView userLive:msg];
    }
}
-(void)KickUser:(NSDictionary *)chats{
    [msgList addObject:chats];
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast];
}
-(void)kickOK{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"被踢出房间") message:nil delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
    [alert show];
    [self dissmissVC];
}
#pragma frontview 信息页面
-(void)gongxianbang{
    //跳往魅力值界面
    personList *jumpC = [[personList alloc] init];
    jumpC.userID =[self.playDoc valueForKey:@"uid"];
    [self presentViewController:jumpC animated:YES completion:nil];
}
//加载信息页面
-(void)zhubomessage{
    CGFloat userviewW;
    if (IS_IPHONE_5) {
        userviewW = _window_width + 50;
    }
    else if(IS_IPHONE_6){
        userviewW = _window_width;
    }
    else if (IS_IPHONE_6P){
        userviewW = _window_width *0.9;
    }
    else{
        userviewW = _window_width *0.9 + sssss;
    }
    if (!userView) {
         userView = [[upmessageInfo alloc]initWithFrame:CGRectMake(_window_width/2 - 150,_window_height + 20,upViewW,userviewW) andPlayer:@"movieplay"];
        //添加用户列表弹窗
        userView.upmessageDelegate = self;
        userView.backgroundColor = [UIColor whiteColor];
        userView.layer.cornerRadius = 10;
        UIWindow *mainwindows = [UIApplication sharedApplication].keyWindow;
        [mainwindows addSubview:userView];
        
    }
    self.tanChuangID = [self.playDoc valueForKey:@"uid"];
    NSDictionary *subdic = @{@"id":[self.playDoc valueForKey:@"uid"]};
    [self GetInformessage:subdic];
    [UIView animateWithDuration:0.2 animations:^{
        userView.frame = CGRectMake(_window_width*0.1,_window_height*0.2,upViewW,userviewW);
    }];
}
//改变tableview高度
-(void)tableviewheight:(CGFloat)h{
    self.tableView.frame = CGRectMake(_window_width + 10,h,tableWidth,_window_height*0.2);
    useraimation.frame = CGRectMake(_window_width + 10,self.tableView.top - 40,_window_width,20);
}
//点击礼物ye消失
-(void)zhezhaoBTNdelegate{
    giftViewShow = NO;
    if (gameVC || shell || rotationV) {
        [self.liwuBTN setBackgroundImage:[UIImage imageNamed:@"live_礼物"] forState:UIControlStateNormal];//@"花猫直播－游戏图标"
        giftview.push.enabled = NO;
        giftview.push.backgroundColor = [UIColor lightGrayColor];
            if (gameVC) {
                gameVC.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
                 [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 265];
            }
            if (shell) {
                shell.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 265];
            }
            if (rotationV) {
                rotationV.frame = CGRectMake(_window_width, _window_height - _window_width/1.5, _window_width, _window_width);
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - _window_width+_window_width/5];
            }
        setFrontV.ZheZhaoBTN.hidden = YES;
        giftview.continuBTN.hidden = YES;
        fenxiangV.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            [self changeGiftViewFrameY:_window_height *3];
            self.tableView.hidden = NO;
        }];
        //wangminxinliwu
        [self changecontinuegiftframe];
    }
    else{
        giftViewShow = NO;
        giftview.push.enabled = NO;
        giftview.push.backgroundColor = [UIColor lightGrayColor];
        setFrontV.ZheZhaoBTN.hidden = YES;
        giftview.continuBTN.hidden = YES;
        fenxiangV.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
           [self changeGiftViewFrameY:_window_height *3];
            [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 50];
        }];
        keyBTN.hidden = NO;
        //wangminxinliwu
        [self changecontinuegiftframe];
    }
    [self showBTN];
}
//页面退出
-(void)returnCancless{
  [self dissmissVC];
}

-(void)doFenxiang:(UIButton *)sender{
    if (!fenxiangV) {
        //分享弹窗
        fenxiangV = [[fenXiangView alloc]initWithFrame:CGRectMake(0,_window_height - _window_width/6 - 20, _window_width, _window_width/6 + 20)];
        [fenxiangV GetDIc:self.playDoc];
        [self.view addSubview:fenxiangV];
    }
    if (fenxiangV.hidden == YES) {
        setFrontV.ZheZhaoBTN.hidden = NO;
        fenxiangV.hidden = NO;
    }
    else{
        setFrontV.ZheZhaoBTN.hidden = YES;
        fenxiangV.hidden = YES;
    }
}
-(void)changeGiftViewFrameY:(CGFloat)Y{
    giftview.frame = CGRectMake(0,Y, _window_width, _window_height/3+10+40);
    if ([[self iphoneType] isEqualToString:@"iPhone X"]) {
        giftview.frame = CGRectMake(0,Y-10, _window_width, _window_height/3 + 30+40);
        [giftview setBottomAdd];
    }
    
}
//礼物按钮
-(void)doLiwu{
    if (gameVC || rotationV || shell) {
        if (giftViewShow == NO) {
            giftViewShow = YES;
            if (gameVC) {
                [self changeBtnFrame:_window_height - 260];
                [UIView animateWithDuration:0.5 animations:^{
                    gameVC.frame = CGRectMake(_window_width, _window_height+60, _window_width,260);
                }];
            }
            if (rotationV) {
                [self changeBtnFrame:_window_height - 45 - _window_width/1.5];
                [UIView animateWithDuration:0.5 animations:^{
                    rotationV.frame = CGRectMake(_window_width, _window_height+60, _window_width, _window_width);
                }];
            }
            if (shell) {
                  [self changeBtnFrame:_window_height - 45 - 215];
                [UIView animateWithDuration:0.5 animations:^{
                    shell.frame = CGRectMake(_window_width, _window_height +60, _window_width,260);
                }];
            }
            if (!giftview) {
                //礼物弹窗
                giftview = [[liwuview alloc]initWithDic:self.playDoc andMyDic:nil];
                giftview.giftDelegate = self;
                [self changeGiftViewFrameY:_window_height*3];
                [self.view addSubview:giftview];
            }
            backScrollView.userInteractionEnabled = YES;
            setFrontV.ZheZhaoBTN.hidden = NO;
            setFrontV.backgroundColor = [UIColor clearColor];
            LiveUser *user = [Config myProfile];
            [giftview chongzhiV:user.coin];
            [UIView animateWithDuration:0.5 animations:^{
                [self changeGiftViewFrameY:_window_height/3*2 - 10-40];
            }];
            [self.liwuBTN setBackgroundImage:[UIImage imageNamed:@"live_礼物"] forState:UIControlStateNormal];//@"花猫直播－游戏图标"
            [self changecontinuegiftframe];
            [self hideBTN];
        }
        else{
            [self zhezhaoBTNdelegate];
        }
    }
    else{
        if (giftViewShow == NO) {
            giftViewShow = YES;
            if (!giftview) {
                //礼物弹窗
                giftview = [[liwuview alloc]initWithDic:self.playDoc andMyDic:nil];
                giftview.giftDelegate = self;
                 [self changeGiftViewFrameY:_window_height*3];
                [self.view addSubview:giftview];
            }
            
            backScrollView.userInteractionEnabled = YES;
            setFrontV.ZheZhaoBTN.hidden = NO;
            setFrontV.backgroundColor = [UIColor clearColor];
            LiveUser *user = [Config myProfile];
            [giftview chongzhiV:user.coin];
            [UIView animateWithDuration:0.1 animations:^{
                [self changeGiftViewFrameY:_window_height/3*2 - 10-40];
            }];
            [self changecontinuegiftframe];
            [self showBTN];
        }
    }
    [giftview reloadPushState];
}
#pragma gift delegate
//发送礼物
-(void)sendGift:(NSDictionary *)myDic andPlayDic:(NSDictionary *)playDic andData:(NSArray *)datas andLianFa:(NSString *)lianfa{
    haohualiwu = lianfa;
    NSString *info = [[[datas valueForKey:@"info"] firstObject] valueForKey:@"gifttoken"];
    level = [[[datas valueForKey:@"info"] firstObject] valueForKey:@"level"];
    LiveUser *users = [Config myProfile];
    users.level = level;
    [Config updateProfile:users];
    [socketDelegate sendGift:level andINfo:info andlianfa:lianfa];
}
-(NSMutableArray *)chatModels{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in msgList) {
        chatModel *model = [chatModel modelWithDic:dic];
        [model setChatFrame:[_chatModels lastObject]];
        [array addObject:model];
    }
    _chatModels = array;
    return _chatModels;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [backScrollView setContentOffset:CGPointMake(_window_width,0) animated:YES];
    self.unRead = 0;
    [self labeiHid];
}

//手指拖拽弹窗移动
-(void)musicPan:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:sender.view];
    CGPoint center = sender.view.center;
    center.x += point.x;
    center.y += point.y;
    userView.center = center;
    //清空
    [sender setTranslation:CGPointZero inView:sender.view];
}

-(void)shajincheng{
    
    [self xiamai];
  
}
-(void)initArray{
    haslianmai = NO;//本人是否连麦
    lianmaisuccess = NO;
    _canScrollToBottom  = YES;

    haohualiwuV.expensiveGiftCount = [NSMutableArray array];
    msgList = [[NSMutableArray alloc] init];
    level = (NSString *)[Config getLevel];
    self.content = [NSString stringWithFormat:@" "];
    _chatModels = [NSMutableArray array];
    userCount = 0;
    starisok = 0;
    heartNum = @1;
    
    firstStar = 0;//点亮
    titleColor = @"0";    
    isRotationGame = NO;
    isZhajinhuaGame = NO;
    //屏幕一直亮
//   self.navigationController.navigationBarHidden =YES;
}

//更新最新配置
-(void)buildUpdate{
    // 在这里加载后台配置文件
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Home.getConfig"];
    
    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSDictionary *subdic = [[data valueForKey:@"info"] firstObject];
                if (![subdic isEqual:[NSNull null]]) {
                    liveCommon *commons = [[liveCommon alloc]initWithDic:subdic];
                    [common saveProfile:commons];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (iPhoneX) {
        sssss = 24;
    }else{
        sssss = 0;
    }
    [self buildUpdate];
    ksynotconnected = NO;
    ksyclosed = NO;
    isshow = 0;
    lianmaitime = 10;//推流响应时间10s
    giftViewShow = NO;
    [self initArray];
    self.automaticallyAdjustsScrollViewInsets = NO;
    myUser = [Config myProfile];
    _listArray = [NSMutableArray array];
    [self KSVidioPlay];//播放视频
    [self setView];//加载信息页面
    [self Registnsnotifition];
    [self getNodeJSInfo];//初始化nodejs信息
    isRegistLianMai = NO;
    //计时扣费
    if ([_livetype isEqual:@"3"]) {
        if (!timecoast) {
            timecoast = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timecoastmoney) userInfo:nil repeats:YES];
        }
    }
    coasttime = 60;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField == keyField) {
        [self pushMessage:nil];
    }
    return YES;
}
//加载底部滑动scrollview
-(void)backscroll{

    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,_window_height, _window_width, _window_height)];
    backScrollView.delegate = self;
    backScrollView.contentSize = CGSizeMake(_window_width*2,0);
    [backScrollView setContentOffset:CGPointMake(_window_width,0) animated:YES];
    backScrollView.pagingEnabled = YES;
    backScrollView.backgroundColor = [UIColor clearColor];
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.bounces = NO;
    backScrollView.userInteractionEnabled = YES;
    [self.view addSubview:backScrollView];
    
      fangKeng = !fangKeng;//全部加载完毕了再释放滑动
}
-(void)socketShutUp:(NSString *)name andID:(NSString *)ID{
    [socketDelegate shutUp:name andID:ID];
}
-(void)socketkickuser:(NSString *)name andID:(NSString *)ID{
    [socketDelegate kickuser:name andID:ID];
}
-(void)GetInformessage:(NSDictionary *)subdic{
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
        userView = [[upmessageInfo alloc]initWithFrame:CGRectMake(_window_width/2 - 150,_window_height + 20,upViewW,userviewW) andPlayer:@"movieplay"];
        userView.upmessageDelegate = self;
        userView.backgroundColor = [UIColor whiteColor];
        userView.layer.cornerRadius = 10;
        UIWindow *mainwindows = [UIApplication sharedApplication].keyWindow;
        [mainwindows addSubview:userView];
    }
    //用户弹窗
    self.tanChuangID = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
    [userView getUpmessgeinfo:subdic andzhuboDic:self.playDoc];
    [UIView animateWithDuration:0.2 animations:^{
        userView.frame = CGRectMake( _window_width*0.1,_window_height*0.2,upViewW,userviewW);
    }];
    
    
    /*
     _danmuView->backscrollview 5
     gamevc->backscrollview 6
     userview->backscroll添加 7
     haohualiwuv->backscrollview 8
     liansongliwubottomview->backscrollview 8
     */
}
//几秒后隐藏消失
-(void)doAlpha{
    [UIView animateWithDuration:3.0 animations:^{
        starImage.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [starImage removeFromSuperview];
        });
    }];
}
//点亮星星
-(void)starok{
    if (gameVC) {
    }
    else if (rotationV){
    }
    else if (shell) {
        [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2- 265];
    }

    //wangminxinliwu
    [self changecontinuegiftframe];
    toolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
    [keyField resignFirstResponder];
    [self showBTN];
    keyBTN.hidden = NO;
    [self staredMove];
    //♥点亮
    if (firstStar == 0) {
        firstStar = 1;
        [socketDelegate starlight:level :heartNum];
        titleColor = @"0";
    }
  
    [self zhezhaoBTNdelegate];
}
-(void)staredMove{
    
    CGFloat starX;
    CGFloat starY;
    starX = _liwuBTN.frame.origin.x - 20;
    starY = _liwuBTN.frame.origin.y - 20;
    NSInteger random = arc4random()%5;
    starImage = [[UIImageView alloc]initWithFrame:CGRectMake(starX+random,starY-random,30,30)];
    
    starImage.alpha = 0;
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"plane_heart_cyan.png",@"plane_heart_pink.png",@"plane_heart_red.png",@"plane_heart_yellow.png",@"plane_heart_heart.png", nil];
    
    srand((unsigned)time(0));
    
    starImage.image = [UIImage imageNamed:[array objectAtIndex:random]];
    
    heartNum = [NSNumber numberWithInteger:random];
    
    [UIView animateWithDuration:0.2 animations:^{
            starImage.alpha = 1.0;
            starImage.frame = CGRectMake(starX+random - 10, starY-random - 30, 30, 30);
            CGAffineTransform transfrom = CGAffineTransformMakeScale(1.3, 1.3);
            starImage.transform = CGAffineTransformScale(transfrom, 1, 1);
        }];
    [backScrollView insertSubview:starImage atIndex:10];
    
    CGFloat finishX = _window_width*2 - round(arc4random() % 200);
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
    if (starisok == 0) {
        starisok = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            starisok = 0;
        });
    [socketDelegate starlight];
        
    }
}
/// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIImageView *imageViewsss = (__bridge UIImageView *)(context);
    [imageViewsss removeFromSuperview];
    imageViewsss = nil;
}
/*==================  以上是点亮  ================*/
-(void)setView{
    
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height)];
    backScrollView.delegate = self;
    backScrollView.contentSize = CGSizeMake(_window_width*2,0);
    [backScrollView setContentOffset:CGPointMake(_window_width,0) animated:YES];
    backScrollView.pagingEnabled = YES;
    backScrollView.backgroundColor = [UIColor clearColor];
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.bounces = NO;
    backScrollView.userInteractionEnabled = YES;
    [self.view addSubview:backScrollView];
    
    
    //加载背景模糊图
    buttomimageviews = [[UIImageView alloc]init];
    [buttomimageviews sd_setImageWithURL:[NSURL URLWithString:[self.playDoc valueForKey:@"avatar"]]];
    buttomimageviews.frame = CGRectMake(0,0, _window_width, _window_height);
    buttomimageviews.userInteractionEnabled = YES;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0,_window_width,_window_height);
    [buttomimageviews addSubview:effectview];
    [backScrollView addSubview:buttomimageviews];

    
    setFrontV = [[setViewM alloc] initWithDic:self.playDoc];
    setFrontV.frame = CGRectMake(_window_width,0,_window_width,_window_height);
    setFrontV.frontviewDelegate = self;
    setFrontV.clipsToBounds = YES;
    [backScrollView addSubview:setFrontV];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(_window_width + 10,setFrontV.frame.size.height - _window_height*0.25 - 50,tableWidth,_window_height*0.2) style:UITableViewStylePlain];
    [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 50];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [backScrollView insertSubview:self.tableView atIndex:4];
    self.tableView.clipsToBounds = YES;
    
    useraimation = [[userLoginAnimation alloc]init];
    useraimation.frame = CGRectMake(_window_width + 10,self.tableView.top - 40,_window_width,20);
    [backScrollView insertSubview:useraimation atIndex:4];
    
    _danmuView = [[GrounderSuperView alloc] initWithFrame:CGRectMake(_window_width, 100, self.view.frame.size.width, 140)];
    [backScrollView insertSubview:_danmuView atIndex:5];//添加弹幕
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starok)];
    [_danmuView addGestureRecognizer:tap];
    cs = [[catSwitch alloc] initWithFrame:CGRectMake(6,11,44,22)];
    cs.delegate = self;
    //输入框
    keyField = [[UITextField alloc]initWithFrame:CGRectMake(70,7,_window_width-90 - 50, 30)];
    keyField.returnKeyType = UIReturnKeySend;
    keyField.delegate = self;
    keyField.textColor = [UIColor blackColor];
    keyField.borderStyle = UITextBorderStyleNone;
    keyField.placeholder = YZMsg(@"和大家说些什么");
    #pragma mark -- 绑定键盘
    www = 30;
    //点击弹出键盘
    keyBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [keyBTN setBackgroundImage:[UIImage imageNamed:@"live_聊天"] forState:UIControlStateNormal];
    [keyBTN addTarget:self action:@selector(showkeyboard:) forControlEvents:UIControlEventTouchUpInside];
    
    //发送按钮
    pushBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushBTN setTitle:YZMsg(@"发送") forState:UIControlStateNormal];
    pushBTN.layer.masksToBounds = YES;
    pushBTN.layer.cornerRadius = 5;
    [pushBTN setTitleColor:RGB(255, 204, 0) forState:0];
//    pushBTN.backgroundColor = normalColors;
    [pushBTN addTarget:self action:@selector(pushMessage:) forControlEvents:UIControlEventTouchUpInside];
    pushBTN.frame = CGRectMake(_window_width-55,7,50,30);
    
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
    starTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starok)];
    starTap.delegate = (id<UIGestureRecognizerDelegate>)self;
    starTap.numberOfTapsRequired = 1;
    starTap.numberOfTouchesRequired = 1;
    [setFrontV addGestureRecognizer:starTap];
    
    liansongliwubottomview = [[UIView alloc]init];
    [backScrollView insertSubview:liansongliwubottomview atIndex:8];
    liansongliwubottomview.frame = CGRectMake(_window_width, self.tableView.top-100,_window_width/2,100);

    
    UITapGestureRecognizer *gifttaps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starok)];
    [liansongliwubottomview addGestureRecognizer:gifttaps];
    
    //添加底部按钮
    _returnCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    _returnCancle.tintColor = [UIColor whiteColor];
    [_returnCancle setImage:[UIImage imageNamed:@"live_关闭"] forState:UIControlStateNormal];//直播间观众—关闭
    _returnCancle.backgroundColor = [UIColor clearColor];
    [_returnCancle addTarget:self action:@selector(returnCancless) forControlEvents:UIControlEventTouchUpInside];
    //消息按钮
    _messageBTN =[UIButton buttonWithType:UIButtonTypeCustom];
     self.unReadLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, -5, 16, 16)];
     self.unReadLabel.hidden = YES;
     self.unReadLabel.textAlignment = NSTextAlignmentCenter;
     self.unReadLabel.textColor = [UIColor whiteColor];
     self.unReadLabel.layer.masksToBounds = YES;
     self.unReadLabel.layer.cornerRadius = 8;
     self.unReadLabel.font = [UIFont systemFontOfSize:9];
     self.unReadLabel.backgroundColor = [UIColor redColor];
    [_messageBTN addSubview: self.unReadLabel];
    [_messageBTN setImage:[UIImage imageNamed:@"live_私信"] forState:UIControlStateNormal];//直播间观众—私信
    _messageBTN.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_messageBTN addTarget:self action:@selector(doMessage) forControlEvents:UIControlEventTouchUpInside];
    //分享按钮
    _fenxiangBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    _fenxiangBTN.enabled = YES;
    _fenxiangBTN.tintColor = [UIColor whiteColor];
    [_fenxiangBTN setBackgroundImage:[UIImage imageNamed:@"live_分享"] forState:UIControlStateNormal];
    [_fenxiangBTN addTarget:self action:@selector(doFenxiang:) forControlEvents:UIControlEventTouchUpInside];
    //礼物
    _liwuBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    _liwuBTN.tintColor = [UIColor whiteColor];
    [_liwuBTN setBackgroundImage:[UIImage imageNamed:@"live_礼物"] forState:UIControlStateNormal];
    [_liwuBTN addTarget:self action:@selector(doLiwu) forControlEvents:UIControlEventTouchUpInside];
    /*==================  连麦  ================*/
    //连麦按钮
    _connectVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    [_connectVideo setImage:[UIImage imageNamed:@"live_连麦"]forState:UIControlStateNormal];
    [_connectVideo addTarget:self action:@selector(connectVideos) forControlEvents:UIControlEventTouchUpInside];
    _connectVideo.selected = NO;
    

    [self setbtnframe];
    
    [backScrollView insertSubview:keyBTN atIndex:5];
    [backScrollView insertSubview:_returnCancle atIndex:5];
    
    NSArray *shareplatforms = [common share_type];
    if (shareplatforms.count != 0) {
        [backScrollView insertSubview:_fenxiangBTN atIndex:5];
     }
  
    [backScrollView insertSubview:_messageBTN atIndex:5];
    [backScrollView insertSubview:_liwuBTN atIndex:5];
 // [backScrollView insertSubview:_connectVideo atIndex:9];
    

    
}
-(void)setbtnframe{
    
    CGFloat  width = 30;
    CGFloat y = _window_height - 45;
    _returnCancle.frame = CGRectMake(_window_width + 15,_window_height - 45, www, www);
    _connectVideo.frame = CGRectMake(_window_width*2 - width*5-50,y,width,width);
    _liwuBTN.frame = CGRectMake(_window_width*2 - width*2-20,y,width,width);
    _fenxiangBTN.frame = CGRectMake(_window_width*2 - width*3-30,y, width, width);
    _messageBTN.frame = CGRectMake(_window_width*2 - width*4-40,y, width,width);
    keyBTN.frame = CGRectMake(_window_width*2-width-10,y,width,width);

    NSArray *shareplatforms = [common share_type];
    
    if (shareplatforms.count == 0) {
        _fenxiangBTN.hidden = YES;
        _messageBTN.frame = CGRectMake(_window_width*2 - width*3 - 30,y, width,width);

    }
    
}
-(void)toolbarHidden
{
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
-(void)guanzhuZhuBo{
    [UIView animateWithDuration:0.5 animations:^{
        setFrontV.leftView.frame = CGRectMake(10, 20+sssss, 90, leftW);
        listcollectionviewx = _window_width+110;
        listView.frame = CGRectMake(listcollectionviewx, 20+sssss, _window_width-130,40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-130, 40);
    }];
    setFrontV.newattention.hidden = YES;
    [socketDelegate attentionLive:level];
}
- (void) addObservers {
    //播放器播放完成
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackDidFinishNotification)
                                              object:nil];
    
}
#pragma mark - 连麦鉴权信息
-(void)reloadChongzhi:(NSString *)coin{
    if (giftview) {    
    [giftview chongzhiV:coin];
    }
}
#pragma mark ---- 私信方法
-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    //显示消息数量
    [self labeiHid];
}
-(void)labeiHid{
    self.unRead = [[JMSGConversation getAllUnreadCount] intValue];
    self.unReadLabel.text = [NSString stringWithFormat:@"%d",self.unRead];
    if ([self.unReadLabel.text isEqual:@"0"]) {
        self.unReadLabel.hidden =YES;
    }
    else
    {
        self.unReadLabel.hidden = NO;
    }
}
-(void)Registnsnotifition{
    //点击用户聊天
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forsixin:) name:@"sixinok" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getweidulabel) name:@"gengxinweidu" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shajincheng) name:@"shajincheng" object:nil];
}
-(void)getweidulabel{
    [self labeiHid];
}
//跳往消息列表
-(void)doMessage{
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
                if (liansongliwubottomview) {
                    [self.view insertSubview:liansongliwubottomview atIndex:8];
                }
            }
            chatsmall.view.hidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                chatsmall.view.frame = CGRectMake(0, _window_height-_window_height*0.4, _window_width, _window_height*0.4);
            }];
            chatsmall.msgConversation = resultObject;
            chatsmall.icon = icon;
            chatsmall.chatID = ID;
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
        setFrontV.leftView.frame = CGRectMake(10,20+sssss,140,leftW);
        listcollectionviewx = _window_width+160;
        setFrontV.newattention.hidden = NO;
       listView.frame = CGRectMake(listcollectionviewx, 20+sssss, _window_width-170,40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-170, 40);
        [userView.forceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else{
        setFrontV.leftView.frame = CGRectMake(10,20+sssss,90,leftW);
        listcollectionviewx = _window_width+110;
        setFrontV.newattention.hidden = YES;
        listView.frame = CGRectMake(listcollectionviewx, 20+sssss, _window_width-130,40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-130, 40);
        //EMError *error = [[EMClient sharedClient].contactManager removeUserFromBlackList:self.tanChuangID];
       // NSLog(@"%@",error.errorDescription);
        [userView.forceBtn setTitle:YZMsg(@"已关注") forState:UIControlStateNormal];
        [userView.forceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        if(self.tanChuangID == [self.playDoc valueForKey:@"uid"])
        {
            [socketDelegate attentionLive:level];
        }
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
#pragma mark -- 获取键盘高度
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if (gameVC) {
        gameVC.hidden = YES;
    }
    if (shell) {
        shell.hidden = YES;
    }
    if (rotationV) {
        rotationV.hidden = YES;
    }
    [self doCancle];
    [self hideBTN];
    keyBTN.hidden = YES;
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.origin.y;
    CGFloat heightw = keyboardRect.size.height;
    int newHeight = _window_height - height -44;
    [UIView animateWithDuration:0.3 animations:^{
        [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 40 - heightw];
        toolBar.frame = CGRectMake(0,height-44,_window_width,44);
        listView.frame = CGRectMake(listcollectionviewx,-height,_window_width-130,40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-130, 40);
        setFrontV.frame = CGRectMake(_window_width,-newHeight,_window_width,_window_height);
        [self changeGiftViewFrameY:_window_height*10];
        //wangminxinliwu
        [self changecontinuegiftframe];
        if (zhuangVC) {
            zhuangVC.frame =  CGRectMake(_window_width + 10,20, _window_width/4, _window_width/4 + 20 + _window_width/8);
        }
    }];
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if (gameVC) {
        gameVC.hidden = NO;
    }
    if (shell) {
        shell.hidden = NO;
    }
    if (rotationV) {
        rotationV.hidden = NO;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        setFrontV.frame = CGRectMake(_window_width,0,_window_width,_window_height);
        listView.frame = CGRectMake(listcollectionviewx, 20+sssss, _window_width-130,40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-130, 40);
            if (giftViewShow) {
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2- 265];
            }
            if (gameVC) {
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2- 265];
                
            }
            else if (rotationV){
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - _window_width + _window_width/5];
            }
            else if (shell) {
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2- 265];
            }
            else{
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 50];
            }
            
            //wangminxinliwu
            [self changecontinuegiftframe];
        toolBar.frame = CGRectMake(0,_window_height + 10,_window_width,44);
        [self changeGiftViewFrameY:_window_height*3];
    }];
    if (zhuangVC) {
        zhuangVC.frame =  CGRectMake(_window_width + 10,90, _window_width/4, _window_width/4 + 20 + _window_width/8);
    }
    [self showBTN];
    keyBTN.hidden = NO;
}
-(void)hideBTN{
    _returnCancle.hidden = YES;
    _liwuBTN.hidden = YES;
    _fenxiangBTN.hidden = YES;
    _messageBTN.hidden = YES;
    keyBTN.hidden = YES;
}
//按钮出现
-(void)showBTN{
    _returnCancle.hidden = NO;
    _liwuBTN.hidden = NO;
    _fenxiangBTN.hidden = NO;
    _messageBTN.hidden = NO;
    keyBTN.hidden = NO;
}
//列表信息退出
-(void)doCancle{
    userView.forceBtn.enabled = YES;
    [UIView animateWithDuration:0.2 animations:^{
        userView.frame = CGRectMake( _window_width*0.1,_window_height*2, upViewW,upViewW);
    }];
    self.tableView.userInteractionEnabled = YES;
}
//发送消息
-(void)sendBarrage
{
    [socketDelegate sendBarrageID:[self.playDoc valueForKey:@"uid"] andTEst:keyField.text andDic:self.playDoc and:^(id arrays) {
        NSArray *data = [arrays valueForKey:@"data"];
        NSNumber *code = [data valueForKey:@"code"];
        if([code isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            level = [[[data valueForKey:@"info"] firstObject] valueForKey:@"level"];
            [socketDelegate sendBarrage:level andmessage:[[[data valueForKey:@"info"] firstObject] valueForKey:@"barragetoken"]];
            //刷新本地魅力值
            LiveUser *liveUser = [Config myProfile];
            keyField.text = @"";
            liveUser.coin = [NSString stringWithFormat:@"%@",[[[data valueForKey:@"info"] firstObject] valueForKey:@"coin"]];
            liveUser.level = level;
            [Config updateProfile:liveUser];
            
            
            if (gameVC) {
                [gameVC reloadcoins];
            }
            if (shell) {
                [shell reloadcoins];
            }
            if (rotationV) {
                [rotationV reloadcoins];
            }
            
            if (giftview) {
                [giftview chongzhiV:[NSString stringWithFormat:@"%@",liveUser.coin]];
            }
        }
        else
        {
            [MBProgressHUD showError:[data valueForKey:@"msg"]];
            giftview.continuBTN.hidden = YES;
        }
    }];
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
    if(cs.state == YES)//发送
    {
        if (keyField.text.length <=0) {
            return;
        }
        [self sendBarrage];
        return;
    }
    else{
    titleColor = @"0";
    self.content = keyField.text;
    [socketDelegate sendmessage:self.content andLevel:level];
    keyField.text =nil;
    }
}
//聊天输入框
-(void)showkeyboard:(UIButton *)sender{
    if (chatsmall) {
        chatsmall.view.hidden = YES;
        [chatsmall.view removeFromSuperview];
        chatsmall.view = nil;
        chatsmall = nil;
    }
    [keyField becomeFirstResponder];
}
// 以下是 tableview的方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    chatModel *model = _chatModels[indexPath.row];
    return model.rowHH + 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    chatcell *cell = [chatcell cellWithtableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.chatModels[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    chatcell *cell = [tableView cellForRowAtIndexPath:indexPath];

    chatModel *model = self.chatModels[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [keyField resignFirstResponder];
    NSString *IsUser = [NSString stringWithFormat:@"%@",model.userID];
    if (IsUser.length >0) {
    NSDictionary *subdic = @{@"id":model.userID};
    [self GetInformessage:subdic];
    }
    toolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _canScrollToBottom = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  _canScrollToBottom = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == backScrollView) {
        if (backScrollView.contentOffset.x == 0) {
            _danmuView.hidden = YES;
        }
        else{
            _danmuView.hidden = NO;
        }
        [keyField resignFirstResponder];
        toolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
        [self showBTN];
        keyBTN.hidden = NO;
    }
}
/*************   以上socket.io 监听  *********/
//直播结束跳到此页面
-(void)lastView{
    [timecoast invalidate];
    timecoast = nil;
    [Feedeductionalertc dismissViewControllerAnimated:YES completion:nil];
    [self removetimer];

    [userView removeFromSuperview];
    userView = nil;
    [self releaseall];
    [alertsagree dismissWithClickedButtonIndex:0 animated:YES];
    if (haslianmai) {
       [socketDelegate xiamaisocket];
    }
    [haohualiwuV stopHaoHUaLiwu];
    [self onStopVideo];
    haohualiwuV.expensiveGiftCount = nil;
    [continueGifts stopTimerAndArray];
    continueGifts = nil;
    [haohualiwuV removeFromSuperview];
    [chatsmall.view removeFromSuperview];
    [huanxinviews.view removeFromSuperview];
    [setFrontV removeFromSuperview];
    [listView removeFromSuperview];
    listView = nil;
    

    lastv = [[lastview alloc]initWithFrame:self.view.bounds block:^(NSString *nulls) {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    } andavatar:[NSString stringWithFormat:@"%@",[self.playDoc valueForKey:@"avatar"]]];
    [self.view addSubview:lastv];
}
//注销计时器
-(void)removetimer{
    
    [starMove invalidate];
    starMove = nil;
    [listTimer invalidate];
    listTimer = nil;
    [lianmaitimer invalidate];
    lianmaitimer = nil;
    [timecoast invalidate];
    timecoast = nil;
    
}
-(void)releaseall{
    [Feedeductionalertc dismissViewControllerAnimated:YES completion:nil];
    [self removetimer];
    if (toutiaoView) {
        toutiaoView.isDelloc = YES;
        [toutiaoView removeFromSuperview];
        toutiaoView = nil;
    }
    if (gifhour) {
        [gifhour removeall];
        [gifhour removeFromSuperview];
        gifhour = nil;
    }
    if (zhuangVC) {
        [zhuangVC dismissroom];
        [zhuangVC removeall];
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (haslianmai == YES) {
        [self xiamai];
        [socketDelegate xiamaisocket];
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    haohualiwuV.expensiveGiftCount = nil;
    if (continueGifts) {
        [continueGifts stopTimerAndArray];
        continueGifts = nil;
    }
    if (shell) {
        [shell stopGame];
        [shell releaseAll];
        [shell removeFromSuperview];
        shell = nil;
    }
    if (gameVC) {
        [gameVC releaseAll];
        [gameVC removeFromSuperview];
        gameVC = nil;
    }
    if (rotationV) {
        [rotationV stopRotatipnGameInt];
         [rotationV stoplasttimer];
        [rotationV removeFromSuperview];
        [rotationV removeall];
        rotationV = nil;
    }
    [self onStopVideo];
    [self releaseObservers];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [socketDelegate socketStop];
        socketDelegate = nil;
    });
}
//直播结束时退出房间
-(void)dissmissVC{
    [self removetimer];
    [userView removeFromSuperview];
    userView = nil;
    self.tableView.hidden = YES;
    [self releaseall];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
//获取进入直播间所需要的所有信息全都在这个enterroom这个接口返回
-(void)getNodeJSInfo
{
    socketDelegate = [[socketMovieplay alloc]init];
    socketDelegate.socketDelegate = self;
    [socketDelegate setnodejszhuboDic:self.playDoc Handler:^(id arrays) {
        
        NSMutableArray *info = [[arrays valueForKey:@"info"] firstObject];
        [common saveagorakitid:minstr([info valueForKey:@"agorakitid"])];//保存声网ID
        
        //保存靓号和vip信息
        NSDictionary *liang = [info valueForKey:@"liang"];
        NSString *liangnum = minstr([liang valueForKey:@"name"]);
        NSDictionary *vip = [info valueForKey:@"vip"];
        NSString *type = minstr([vip valueForKey:@"type"]);
        
        
        NSDictionary *subdic = [NSDictionary dictionaryWithObjects:@[type,liangnum] forKeys:@[@"vip_type",@"liang"]];
        [Config saveVipandliang:subdic];
        
        
        self.danmuprice = [info valueForKey:@"barrage_fee"];
        _listArray = [info valueForKey:@"userlists"];
        LiveUser *users = [Config myProfile];
        users.coin = [NSString stringWithFormat:@"%@",[info valueForKey:@"coin"]];
        [Config updateProfile:users];
        
        
        NSString *isattention = [NSString stringWithFormat:@"%@",[info valueForKey:@"isattention"]];
        userCount = [[info valueForKey:@"nums"] intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
           [setFrontV changeState:[info valueForKey:@"votestotal"] andID:[self.playDoc valueForKey:@"uid"]];
           setFrontV.onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
           //userlist_time 间隔时间
               //获取用户列表
           listView = [[ListCollection alloc]initWithListArray:[info valueForKey:@"userlists"] andID:[self.playDoc valueForKey:@"uid"] andStream:[NSString stringWithFormat:@"%@",[self.playDoc valueForKey:@"stream"]]];
           listView.delegate = self;
               userlist_time = [[info valueForKey:@"userlist_time"] intValue];
               if (!listTimer) {
                   listTimer = [NSTimer scheduledTimerWithTimeInterval:userlist_time target:self selector:@selector(reloadUserList) userInfo:nil repeats:YES];
               }
           [backScrollView addSubview:listView];
           [self isAttentionLive:isattention];
       });
        //游戏******************************************
        //获取庄家信息
        NSString *coin = [NSString stringWithFormat:@"%@",[info valueForKey:@"game_banker_coin"]];
        
        NSString *game_banker_limit = [NSString stringWithFormat:@"%@",[info valueForKey:@"game_banker_limit"]];
        NSString *uname = [NSString stringWithFormat:@"%@",[info valueForKey:@"game_banker_name"]];
        NSString *uhead = [NSString stringWithFormat:@"%@",[info valueForKey:@"game_banker_avatar"]];
        NSString *uid = [NSString stringWithFormat:@"%@",[info valueForKey:@"game_bankerid"]];
        NSDictionary *zhuangdic = @{
                                    @"coin":coin,
                                    @"game_banker_limit":game_banker_limit,
                                    @"user_nicename":uname,
                                    @"avatar":uhead,
                                    @"id":uid
                                    };
        [gameState savezhuanglimit:game_banker_limit];//缓存上庄钱数限制
        zhuangstartdic = zhuangdic;
        NSString *gametime = [NSString stringWithFormat:@"%@",[info valueForKey:@"gametime"]];
        NSString *gameaction = [NSString stringWithFormat:@"%@",[info valueForKey:@"gameaction"]];
        if (!gametime || [gametime isEqual:[NSNull null]] || [gametime isEqual:@"<null>"] || [gametime isEqual:@"null"] || [gametime isEqual:@"0"]) {
            //没有游戏
            
        }
        else{
            //有游戏 1炸金花  2海盗  3转盘  4牛牛  5二八贝
            if ([gameaction isEqual:@"1"] || [gameaction isEqual:@"4"] || [gameaction isEqual:@"2"]) {

                if ([gameaction isEqual:@"2"]) {
                    gameVC = [[gameBottomVC alloc]initWIthDic:_playDoc andIsHost:NO andMethod:@"startLodumaniGame" andMsgtype:@"18"];
                }
                if ([gameaction isEqual:@"1"]) {
                    gameVC = [[gameBottomVC alloc]initWIthDic:_playDoc andIsHost:NO andMethod:@"startGame" andMsgtype:@"15"];
                }
                else if ([gameaction isEqual:@"4"]){
                    gameVC = [[gameBottomVC alloc]initWIthDic:_playDoc andIsHost:NO andMethod:@"startCattleGame" andMsgtype:@"17"];
                }
                gameVC.delagate = self;
                gameVC.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
                [self changeBtnFrame:_window_height - 260];
                [backScrollView insertSubview:gameVC atIndex:4];
                [backScrollView insertSubview:_liwuBTN atIndex:5];
                [self tableviewheight:_window_height - _window_height*0.2 - 260];
                [gameVC continueUI];
                [gameVC movieplayStartCut:gametime andGameid:[info valueForKey:@"gameid"]];
                NSArray *arrays = [info valueForKey:@"game"];
                if (arrays) {
                    [gameVC getNewCOins:[info valueForKey:@"game"]];
                }
                NSArray *arraysbet = [info valueForKey:@"gamebet"];
                if (arraysbet) {
                    [gameVC getmyCOIns:[info valueForKey:@"gamebet"]];
                }
                //上庄
                if ([gameaction isEqual:@"4"]) {
                    if (!zhuangVC) {
                        zhuangVC = [[shangzhuang alloc]initWithFrame:CGRectMake(_window_width + 10,90, _window_width/4, _window_width/4 + 20 + _window_width/8) ishost:NO withstreame:[self.playDoc valueForKey:@"stream"]];
                        zhuangVC.deleagte = self;
                        [backScrollView insertSubview:zhuangVC atIndex:10];
                        [backScrollView bringSubviewToFront:zhuangVC];
                        [zhuangVC getbanksCoin:zhuangstartdic];
                        [zhuangVC setpoker];
                        [zhuangVC addtableview];
                    }
                }
            }
            //转盘
            else if ([gameaction isEqual:@"3"]){
                [self getRotation];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [rotationV continueGame:gametime andgameId:[info valueForKey:@"gameid"] andMoney:[info valueForKey:@"game"] andmycoin:[info valueForKey:@"gamebet"]];
                });
            }
            else if ([gameaction isEqual:@"5"]){
                shell = [[shellGame alloc]initWIthDic:_playDoc andIsHost:NO andMethod:@"startShellGame" andMsgtype:@"19" andandBanklist:nil];
                shell.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
                shell.delagate = self;
                [backScrollView insertSubview:shell atIndex:4];
                [backScrollView insertSubview:_liwuBTN atIndex:5];
                [shell movieplayStartCut:gametime andGameid:[info valueForKey:@"gameid"]];
                NSArray *arrays = [info valueForKey:@"game"];
                if (arrays) {
                    [shell getNewCOins:[info valueForKey:@"game"]];
                }
                NSArray *arraysbet = [info valueForKey:@"gamebet"];
                if (arraysbet) {
                    [shell getmyCOIns:[info valueForKey:@"gamebet"]];
                }
                [self changeBtnFrame:_window_height - 45 - 215];
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2- 265];
            }
        }
        [self changecontinuegiftframe];
    
        //进入房间的时候checklive返回的收费金额
        if ([_livetype isEqual:@"3"] || [_livetype isEqual:@"2"]) {
            //此处用于计时收费
            //刷新所有人的影票
            [self addCoin:[_type_val longLongValue]];
            [socketDelegate addvotesenterroom:minstr(_type_val)];
        }
        //isauction
        NSDictionary *auction = [info valueForKey:@"auction"];
        NSString *isauction = minstr([auction valueForKey:@"isauction"]);
        if ([isauction isEqual:@"0"]) {
            
            
            
        }
        else{
            gifhour  = [[Hourglass alloc]initWithDic:self.playDoc andFrame:CGRectMake(_window_width*2 - 60, _window_height*0.35,60,100) Block:^(NSString *task) {
                //点击竞拍压住
                [socketDelegate sendmyjingpaimessage:task];
            } andtask:^(NSString *task) {
            } andjingpaixiangqingblock:^(NSString *task) {
                //进入详情页面
                webH5 *VC = [[webH5 alloc]init];
                VC.isjingpai = @"isjingpai";
                VC.urls = [h5url stringByAppendingFormat:@"g=Appapi&m=Auction&a=detail&id=%@&uid=%@&token=%@",task,[Config getOwnID],[Config getOwnToken]];
                [self presentViewController:VC animated:YES completion:nil];
            } andchongzhi:^(NSString *task) {
                //跳往充值页面
                [self pushCoinV];
            }];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jingpaizuanshi) name:@"isjingpai" object:nil];
            
            [backScrollView addSubview:gifhour];
            [backScrollView insertSubview:gifhour atIndex:4];
            [gifhour addnowfirstpersonmessahevc];
            
            NSString *money = minstr([auction valueForKey:@"bid_price"]);
            NSString *uhead = minstr([auction valueForKey:@"avatar"]);
            NSString *uname = minstr([auction valueForKey:@"user_nicename"]);
            NSString *uid = minstr([auction valueForKey:@"bid_uid"]);
            [gifhour getjingpaimessage:auction];
            [gifhour getnewmessage:@{
                                     @"uhead":uhead,
                                     @"uname":uname,
                                     @"uid":uid,
                                     @"money":money
                                     }];
        }
    }andlivetype:_livetype];
}
//改变连送礼物的frame
-(void)changecontinuegiftframe{
    
    liansongliwubottomview.frame = CGRectMake(_window_width, self.tableView.top - 150,_window_width/2,100);
    if (zhuangVC) {
        liansongliwubottomview.frame = CGRectMake(_window_width, self.tableView.top,_window_width/2,100);
    }
}
-(void)reloadUserList{
    [listView listReloadNoew];
}
-(void)isAttentionLive:(NSString *)isattention{
    if ([isattention isEqual:@"0"]) {
        //未关注
        setFrontV.newattention.hidden = NO;
        setFrontV.leftView.frame = CGRectMake(10,20+sssss,140,leftW);
        listcollectionviewx = _window_width+160;
        listView.frame = CGRectMake(listcollectionviewx, 20+sssss, _window_width-170,40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-170, 40);
    }
    else{
        //关注
        setFrontV.newattention.hidden = YES;
        setFrontV.leftView.frame = CGRectMake(10,20+sssss,90,leftW);
        listcollectionviewx = _window_width+110;
        listView.frame = CGRectMake(listcollectionviewx, 20+sssss, _window_width-130,40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-130, 40);
    }
}
/*************** 以下视频播放 ***************/
-(void)KSVidioPlay
{
    videoView = [[UIView alloc] init];
    videoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:videoView];
    videoView.frame = CGRectMake(0,0, _window_width, _window_height);
    _url = [NSURL URLWithString:[self.playDoc valueForKey:@"pull"]];
    [self setupObservers];
    NSLog(@"======播流地址%@",_url);
    [self onPlayVideo];
}
-(void)handlePlayerNotify:(NSNotification*)notify
{
    if (!_player) {
        return;
    }
    if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification ==  notify.name) {
        NSLog(@"KSYPlayerVC: %@ -- ip:%@", _url, [_player serverAddress]);
        //移除开场加载动画
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    setFrontV.bigAvatarImageView.hidden = YES;
                    [buttomimageviews removeFromSuperview];
                    backScrollView.userInteractionEnabled = YES;
                    backScrollView.contentSize = CGSizeMake(_window_width*2,0);
                });
    }
    if (MPMoviePlayerPlaybackDidFinishNotification ==  notify.name) {
       
            [_player reload:_url flush:NO];
    }
}
- (void)setupObservers
{
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackStateDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackDidFinishNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerLoadStateDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMovieNaturalSizeAvailableNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerFirstVideoFrameRenderedNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerFirstAudioFrameRenderedNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerSuggestReloadNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackStatusNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(toolbarHidden) name:@"toolbarHidden" object:nil];
}
- (void)releaseObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackDidFinishNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerLoadStateDidChangeNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMovieNaturalSizeAvailableNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerFirstVideoFrameRenderedNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerFirstAudioFrameRenderedNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerSuggestReloadNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:MPMoviePlayerPlaybackStatusNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"toolbarHidden" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gengxinweidu" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sixinok" object:nil];
}
- (void)onPlayVideo {
    if (_player) {
        [_player play];
        return;
    }
    _player =  [[KSYMoviePlayerController alloc] initWithContentURL: _url];
    _player.view.backgroundColor = [UIColor clearColor];
    [_player.view setFrame: videoView.bounds];  // player's frame must match parent's
    [videoView addSubview: _player.view];
    _player.shouldAutoplay = TRUE;
    _player.bInterruptOtherAudio = NO;
    _player.shouldEnableKSYStatModule = TRUE;
    if ([minstr([_playDoc valueForKey:@"anyway"]) isEqual:@"1"] || [minstr([_playDoc valueForKey:@"isvideo"]) isEqual:@"1"]) {
        _player.scalingMode = MPMovieScalingModeAspectFit;
    }else{
        _player.scalingMode = MPMovieScalingModeAspectFill;
    }
    [_player prepareToPlay];
    [_player setVolume:2.0 rigthVolume:2.0];
    _player.videoDecoderMode = MPMovieVideoDecoderMode_Software;
}
- (void)onStopVideo{
    if (_player) {
        [_player stop];
        [_player.view removeFromSuperview];
        _player = nil;
    }
}
/*************** 以上视频播放 ***************/
//礼物效果
/************ 礼物弹出及队列显示开始 *************/
-(void)expensiveGiftdelegate:(NSDictionary *)giftData{
    if (!haohualiwuV) {
        haohualiwuV = [[expensiveGiftV alloc]init];
        haohualiwuV.delegate = self;
        [backScrollView addSubview:haohualiwuV];
        [backScrollView insertSubview:haohualiwuV atIndex:8];
        CGAffineTransform t = CGAffineTransformMakeTranslation(_window_width, 0);
        haohualiwuV.transform = t;
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
    if (!haohualiwuV) {
        haohualiwuV = [[expensiveGiftV alloc]init];
        haohualiwuV.delegate = self;
         [backScrollView insertSubview:haohualiwuV atIndex:8];
        CGAffineTransform t = CGAffineTransformMakeTranslation(_window_width, 0);
        haohualiwuV.transform = t;
        
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
    long long ordDate = [setFrontV.yingpiaoLabel.text longLongValue];
    long long newDate = ordDate + coin;
    [setFrontV changeState: [NSString stringWithFormat:@"%lld",newDate] andID:[self.playDoc valueForKey:@"uid"]];
}
-(void)addvotesdelegate:(NSString *)votes{
    [self addCoin:[votes longLongValue]];
}
/************  杨志刚 礼物弹出及队列显示结束 *************/
//跳转充值
-(void)pushCoinV{
//      CoinVeiw *coin = [[CoinVeiw alloc] init];
//      UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:coin];
//      [self presentViewController:navi animated:YES completion:nil];
}
//聊天自动上滚
-(void)jumpLast
{
    if (_canScrollToBottom) {
    NSUInteger sectionCount = [self.tableView numberOfSections];
    if (sectionCount) {
        NSUInteger rowCount = [self.tableView numberOfRowsInSection:0];
        if (rowCount) {
            NSUInteger ii[2] = {0, rowCount - 1};
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }  
    }
     }
}
//切换聊天和弹幕
-(void)switchState:(BOOL)state
{
    if(!state)
    {
        keyField.placeholder = YZMsg(@"和大家说些什么");
    }
    else
    {
        keyField.frame  = CGRectMake(70,7,_window_width-90 - 50, 30);//CGRectMake(50,5,_window_width-60 - 50 , 30);
        keyField.placeholder = [NSString stringWithFormat:@"%@%@ %@",_danmuprice,[common name_coin],YZMsg(@"开启大喇叭")];

    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark 连麦+声网
//连麦
-(void)connectVideos{
    if (haslianmai == NO) {
        haslianmai = YES;
        //发送连麦socket
        [MBProgressHUD showSuccess:@"连麦请求已发送"];
        [socketDelegate connectvideoToHost];
      //  _connectVideo.userInteractionEnabled = NO;
        isshow = 0;
        lianmaitime = 14;
        if (lianmaitimer) {
            [lianmaitimer invalidate];
            lianmaitimer = nil;
        }
        if (!lianmaitimer) {
            lianmaitimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(lianmaiwait) userInfo:nil repeats:YES];
        }
    }
    else{
        UIAlertController  *alertlianmaiVC = [UIAlertController alertControllerWithTitle:@"是否断开连麦" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
        UIAlertAction *defaultActionss = [UIAlertAction actionWithTitle:YZMsg(@"确认") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //关闭连麦
            haslianmai = NO;
            NSLog(@"关闭连麦");
            [self closeconnect];
            [socketDelegate xiamaisocket];
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
        [alertlianmaiVC addAction:defaultActionss];
        [alertlianmaiVC addAction:cancelActionss];
        [self presentViewController:alertlianmaiVC animated:YES completion:nil];
    }
}
-(void)closeconnect{
    
     dispatch_async(dispatch_get_main_queue(), ^{
    [alertsagree dismissWithClickedButtonIndex:0 animated:YES];
    [MBProgressHUD hideHUD];
    [_connectVideo setImage:[UIImage imageNamed:@"live_连麦"] forState:UIControlStateNormal];
    haslianmai = NO;
    _connectVideo.userInteractionEnabled = YES;
    });
}
-(void)hasconnected{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        [_connectVideo setImage:[UIImage imageNamed:@"live_断"] forState:UIControlStateNormal];
        _connectVideo.userInteractionEnabled = YES;
        [alertsagree dismissWithClickedButtonIndex:0 animated:YES];
        UIAlertView *alertsconnect = [[UIAlertView alloc]initWithTitle:@"建立连接" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertsconnect show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertsconnect dismissWithClickedButtonIndex:0 animated:YES];
        });
    });
}
-(void)lianmaiwait{
    lianmaitime -= 1;
    if (lianmaitime == 0) {
        if (isshow == 0) {
            isshow = 1;
            UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:@"主播未响应" message:nil delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
            [alerts show];
            _connectVideo.userInteractionEnabled = YES;
        }
        lianmaitime = 10;
        [lianmaitimer invalidate];
        lianmaitimer = nil;
    }
}
-(void)lianmaidaojishi{
    lianmaitime -= 1;
    if (lianmaisuccess == YES) {
        lianmaitime = 10;
        [lianmaitimer invalidate];
        lianmaitimer = nil;
    }
    if (lianmaitime == 0) {
        lianmaitime = 10;
        [lianmaitimer invalidate];
        lianmaitimer = nil;
        if (lianmaisuccess == NO) {
            [self xiamai];
            [socketDelegate xiamaisocket];
        }
    }
}
//得到主播同意开始连麦
-(void)startConnectvideo{
    //建立连接后 10s内未响应 则退出
    if (!lianmaitimer) {
        lianmaitimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(lianmaidaojishi) userInfo:nil repeats:YES];
    }
    alertsagree = [[UIAlertView alloc]initWithTitle:@"主播接受连麦请求，正在连麦" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alertsagree show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertsagree dismissWithClickedButtonIndex:0 animated:YES];
    });
    __weak moviePlay *weakself = self;
    [weakself startLIanmai];
}
//开始发起连麦
-(void)startLIanmai{
    lianmaitime = 10;
    [lianmaitimer invalidate];
    lianmaitimer = nil;
    haslianmai = YES;
}
-(void)xiamai{
    lianmaisuccess = NO;
    haslianmai = NO;
    _connectVideo.userInteractionEnabled = YES;
    [_connectVideo setImage:[UIImage imageNamed:@"live_连麦"] forState:UIControlStateNormal];
}
-(void)nilkit{
    if (ksyclosed == YES && ksynotconnected == YES) {
        ksyclosed = NO;
        ksynotconnected = NO;
        NSLog(@"我自己加的手动离开");
    }
}
//主播未响应
-(void)hostout{
    lianmaitime = 10;
    [lianmaitimer invalidate];
    lianmaitimer = nil;
    lianmaisuccess = NO;
    haslianmai = NO;
    [_connectVideo setImage:[UIImage imageNamed:@"live_连麦"] forState:UIControlStateNormal];
    _connectVideo.userInteractionEnabled = YES;
    
    if (isshow == 0) {
        
        isshow = 1;
        UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:@"主播未响应" message:nil delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
        [alerts show];
    }
}
//主播正忙碌
-(void)hostisbusy{
    lianmaitime = 10;
    [lianmaitimer invalidate];
    lianmaitimer = nil;
    
    lianmaisuccess = NO;
    haslianmai = NO;
    [_connectVideo setImage:[UIImage imageNamed:@"live_连麦"] forState:UIControlStateNormal];
    _connectVideo.userInteractionEnabled = YES;
}
-(void)confuseConnectvideo{
    lianmaitime = 10;
    [lianmaitimer invalidate];
    lianmaitimer = nil;
    
    lianmaisuccess = NO;
    haslianmai = NO;
    [_connectVideo setImage:[UIImage imageNamed:@"live_连麦"] forState:UIControlStateNormal];
    _connectVideo.userInteractionEnabled = YES;
}
//执行扣费
-(void)timecoastmoney{
    coasttime -= 1;
    if (coasttime == 0) {
        [timecoast invalidate];
        timecoast = nil;
        coasttime = 60;
        [self docoast:@"Live.timeCharge"];
    }
}
//切换房间类型
-(void)changeLive:(NSString *)type_val{
    _type_val = type_val;
    videoView.hidden = YES;
    self.player.shouldMute = YES;
    setFrontV.bigAvatarImageView.hidden = NO;
    if (timecoast) {
        [timecoast invalidate];
        timecoast = nil;
    }
    coasttime = 0;
    Feedeductionalertc = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"当前房间收费%@%@/分钟",type_val,[common name_coin]] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
    UIAlertAction *cancelActionss = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (timecoast) {
            [timecoast invalidate];
            timecoast = nil;
        }
        [self dissmissVC];
    }];
    UIAlertAction *surelActionss = [UIAlertAction actionWithTitle:YZMsg(@"付费") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self docoast:@"Live.roomCharge"];
    }];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 9.0) {
        
    }
    else{
        [surelActionss setValue:normalColors forKey:@"_titleTextColor"];
        [cancelActionss setValue:normalColors forKey:@"_titleTextColor"];
    }
    [Feedeductionalertc addAction:cancelActionss];
    [Feedeductionalertc addAction:surelActionss];
    [self presentViewController:Feedeductionalertc animated:YES completion:nil];
    
}
-(void)docoast:(NSString *)type{
    NSString *url = [purl stringByAppendingFormat:@"service=%@",type];
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken],
                             @"liveuid":[self.playDoc valueForKey:@"uid"],
                             @"stream":[self.playDoc valueForKey:@"stream"]
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
                videoView.hidden = NO;
                self.player.shouldMute = NO;
                coasttime = 60;
                if (!timecoast) {
                    timecoast = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timecoastmoney) userInfo:nil repeats:YES];
                }
                [socketDelegate addvotes:_type_val isfirst:@"0"];
                [self addCoin:[_type_val longLongValue]];
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                LiveUser *user = [Config myProfile];
                user.coin = minstr([info valueForKey:@"coin"]);
                [Config updateProfile:user];
                videoView.hidden = NO;
                self.player.shouldMute = NO;
                setFrontV.bigAvatarImageView.hidden = YES;
            }
            else{
                UIAlertController  *alertlianmaiVC = [UIAlertController alertControllerWithTitle:YZMsg(@"您当前余额不足无法观看") message:@"" preferredStyle:UIAlertControllerStyleAlert];
                //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
                UIAlertAction *cancelActionss = [UIAlertAction actionWithTitle:YZMsg(@"确认") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self dissmissVC];
                }];
                if (timecoast) {
                    [timecoast invalidate];
                    timecoast = nil;
                }
                
                videoView.hidden = YES;
                self.player.shouldMute = YES;
                setFrontV.bigAvatarImageView.hidden = NO;
                
                NSString *version = [UIDevice currentDevice].systemVersion;
                if (version.doubleValue < 9.0) {
                    
                }
                else{
                    [cancelActionss setValue:normalColors forKey:@"_titleTextColor"];
                }
                [alertlianmaiVC addAction:cancelActionss];
                [self presentViewController:alertlianmaiVC animated:YES completion:nil];
  
                
            }
        }
        else{
            
            [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
            if (timecoast) {
                [timecoast invalidate];
                timecoast = nil;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dissmissVC];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (timecoast) {
            [timecoast invalidate];
            timecoast = nil;
        }
        [self dissmissVC];
    }];
}
//竞拍失败
-(void)jingpaifailed{
   [gifhour addjingpairesultview:3 anddic:nil];
}
-(void)jingpaisuccess:(NSDictionary *)dic{
    [gifhour addjingpairesultview:4 anddic:dic];
}
//有人竞拍获取新竞拍信息
-(void)getnewjingpaipersonmessage:(NSDictionary *)dic{
    [gifhour getnewmessage:dic];
}
//交了保证金后刷新钻石
-(void)jingpaizuanshi{
    
    if (gifhour) {
        [gifhour getcoins];
    }
    if (giftview) {
        [giftview chongzhiV:[Config getcoin]];
    }
}
//竞拍 //获取竞拍信息
-(void)getjingpaimessagedelegate:(NSDictionary *)dic{
        
    if (!gifhour) {
        
        gifhour  = [[Hourglass alloc]initWithDic:self.playDoc andFrame:CGRectMake(_window_width*2 - 60,_window_height*0.35,60,100) Block:^(NSString *task) {
            //点击竞拍压住
            [socketDelegate sendmyjingpaimessage:task];
            [self jingpaizuanshi];
            
        } andtask:^(NSString *task) {
            
            
        } andjingpaixiangqingblock:^(NSString *task) {
            //进入详情页面
            webH5 *VC = [[webH5 alloc]init];
            VC.isjingpai = @"isjingpai";
            VC.urls = [h5url stringByAppendingFormat:@"g=Appapi&m=Auction&a=detail&id=%@&uid=%@&token=%@",task,[Config getOwnID],[Config getOwnToken]];
            [self presentViewController:VC animated:YES completion:nil];
        } andchongzhi:^(NSString *task) {
            //跳往充值页面
            [self pushCoinV];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jingpaizuanshi) name:@"isjingpai" object:nil];
        [backScrollView addSubview:gifhour];
        [backScrollView insertSubview:gifhour atIndex:4];
        [gifhour addnowfirstpersonmessahevc];
    }
    if (gifhour) {
        [gifhour getjingpaimessage:dic];
    }
}
//竞拍
-(void)dojingpai{
    
    
    [self addvideoswipe];
    setFrontV.hidden      = YES;
    _danmuView.hidden     = YES;
    listView.hidden       = YES;
    gifhour.hidden        = YES;
    self.tableView.hidden = YES;
    backScrollView.hidden = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        videoView.frame = CGRectMake(_window_width - _window_width/2.5,0, _window_width/2.5, _window_width/2);
        [_player.view setFrame: videoView.bounds];
    }];
    
}
-(void)addvideoswipe{
    if (!videopan) {
        videopan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlepanss:)];
        [videopan setDelegate:self];
        [videoView addGestureRecognizer:videopan];
    }
    if (!videotap) {
        videotap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videotap)];
        [videoView addGestureRecognizer:videotap];
    }
}
-(void)videotap{
    [videoView removeGestureRecognizer:videopan];
    [videoView removeGestureRecognizer:videotap];
    videopan = nil;
    videotap = nil;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        videoView.frame = CGRectMake(0, 0, _window_width, _window_height);
        [_player.view setFrame: videoView.bounds];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.hidden = NO;
        setFrontV.hidden      = NO;
        _danmuView.hidden     = NO;
        listView.hidden       = NO;
        gifhour.hidden        = NO;
        backScrollView.hidden = NO;
    });
}
- (void) handlepanss: (UIPanGestureRecognizer *)rec{
    CGPoint point = [rec translationInView:videoView];
    NSLog(@"%f,%f",point.x,point.y);
    rec.view.center = CGPointMake(rec.view.center.x + point.x, rec.view.center.y + point.y);
    [rec setTranslation:CGPointMake(0, 0) inView:videoView];
}


- (void)goChongZhi{
    UIAlertController *alertCot = [UIAlertController alertControllerWithTitle:nil message:YZMsg(@"对不起，您的钻石余额不足。\n立即去充值？") preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *acton1 = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [acton1 setValue:[UIColor colorWithRed:0.980 green:0.361 blue:0.604 alpha:1.00] forKey:@"_titleTextColor"];
    
    [alertCot addAction:acton1];
    UIAlertAction *acton12 = [UIAlertAction actionWithTitle:YZMsg(@"立即充值") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushCoinV];
    }];
    [acton12 setValue:[UIColor colorWithRed:0.980 green:0.361 blue:0.604 alpha:1.00] forKey:@"_titleTextColor"];
    
    [alertCot addAction:acton12];
    [self presentViewController:alertCot animated:YES completion:nil];
    
}
- (void)zhongjianla:(NSDictionary *)dic{
    [socketDelegate zhongjiangSocket:dic];
}
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
- (BOOL)prefersStatusBarHidden{
    return YES;
}
@end
