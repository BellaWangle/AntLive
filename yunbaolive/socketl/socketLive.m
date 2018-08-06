//
//  socketLive.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/1/24.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "socketLive.h"
@implementation socketLive
-(void)zhaJinHua:(NSString *)gameid andTime:(NSString *)time andJinhuatoken:(NSString *)Jinhuatoken ndMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": method,
                                        @"action": @"4",
                                        @"msgtype": msgtype,
                                        @"liveuid":[Config getOwnID],
                                        @"gameid":gameid,
                                        @"time":time,
                                        @"token":Jinhuatoken
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
//主播发送通知用户开始游戏 展示游戏界面
-(void)prepGameandMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_":method,
                                        @"action": @"1",
                                        @"msgtype":msgtype,
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
//开始发牌
-(void)takePoker:(NSString *)gameid ndMethod:(NSString *)method andMsgtype:(NSString *)msgtype andBanklist:(NSDictionary *)banklist{
    if (banklist != nil) {
        NSArray *msgData =@[
                            @{
                                @"msg": @[
                                        @{
                                            @"_method_": method,
                                            @"action": @"2",
                                            @"msgtype":msgtype,
                                            @"gameid":gameid,
                                            @"bankerlist":banklist
                                            }
                                        ],
                                @"retcode": @"000000",
                                @"retmsg": @"OK"
                                }
                            ];
        [ChatSocket emit:@"broadcast" with:msgData];
    }
    else{
        NSArray *msgData =@[
                            @{
                                @"msg": @[
                                        @{
                                            @"_method_": method,
                                            @"action": @"2",
                                            @"msgtype":msgtype,
                                            @"gameid":gameid,
                                            }
                                        ],
                                @"retcode": @"000000",
                                @"retmsg": @"OK"
                                }
                            ];
        [ChatSocket emit:@"broadcast" with:msgData];
    }
}
-(void)stopGamendMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": method,
                                        @"action": @"3",
                                        @"msgtype":msgtype,
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
//出现界面
-(void)prepRotationGame{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"startRotationGame",
                                        @"action": @"1",
                                        @"msgtype":@"16",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
//停止游戏
-(void)stopRotationGame{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"startRotationGame",
                                        @"action": @"3",
                                        @"msgtype":@"16",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
//开始倒计时
-(void)RotatuonGame:(NSString *)gameid andTime:(NSString *)time androtationtoken:(NSString *)rotationtoken{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"startRotationGame",
                                        @"action": @"4",
                                        @"msgtype": @"16",
                                        @"liveuid":[Config getOwnID],
                                        @"gameid":gameid,
                                        @"time":time,
                                        @"token":rotationtoken
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
//开奖
-(void)sendMessage:(NSString *)text{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendMsg",
                                        @"action": @"0",
                                        @"ct":text,
                                        @"msgtype": @"2",
                                        @"timestamp": @"",
                                        @"touid": @"0",
                                        @"ugood": [Config getOwnID],
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"uhead":user.avatar,
                                        @"level":[Config getLevel],
                                        @"vip_type":[Config getVip_type],
                                        @"liangname":[Config getliang]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];

    
}
-(void)sendBarrage:(NSString *)info{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendBarrage",
                                        @"action": @"7",
                                        @"ct":info ,
                                        @"msgtype": @"1",
                                        @"timestamp": @"",
                                        @"tougood": @"",
                                        @"touid": @"0",
                                        @"touname": @"",
                                        @"ugood": [Config getOwnID],
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"roomnum": [Config getOwnID],
                                        @"level":[Config getLevel],
                                        @"usign":@"",
                                        @"uhead":user.avatar,
                                        @"sex":@"",
                                        @"city":@"",
                                        @"vip_type":[Config getVip_type],
                                        @"liangname":[Config getliang]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    
    [ChatSocket emit:@"broadcast" with:msgData];
}
-(void)shutUp:(NSString *)ID andName:(NSString *)name{
    
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
                                           @"uname":name,
                                           @"msgtype":@"4",
                                           @"timestamp":@"",
                                           @"tougood":@"",
                                           @"touid":@"",
                                           @"toname":name,
                                           @"ugood":@"",
                                           @"time":_shut_time
                                           }],
                                 @"retcode":@"000000",
                                 @"retmsg":@"OK"}];
    [ChatSocket emit:@"broadcast" with:jinyanArray];
}
-(void)kickuser:(NSString *)ID andName:(NSString *)name{
    
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
                                           @"touid":@"",
                                           @"toname":name,
                                           @"ugood":@""
                                           }],
                                 @"retcode":@"000000",
                                 @"retmsg":@"OK"}];
    [MBProgressHUD showSuccess:YZMsg(@"踢人成功")];
    [ChatSocket emit:@"broadcast" with:jinyanArray];
    
}
-(void)setAdminID:(NSString *)ID andName:(NSString *)name andCt:(NSString *)ct{
    NSString *msgType;
    if ([ct isEqualToString:@"被设为管理员"]) {
        msgType = @"101";
    }else{
        msgType = @"102";
    }
    NSArray *guanliArray =@[
                            @{
                                @"msg":@[
                                        @{
                                            @"_method_":@"SystemNot",
                                            @"action":@"13",
                                            @"ct":ct,
                                            @"msgtype":msgType,
                                            @"uid":[Config getOwnID],
                                            @"uname":@"直播间消息",
                                            @"touid":ID,
                                            @"toname":name,
                                            @"cts":ct
                                            }
                                        ],
                                @"retcode":@"000000",
                                @"retmsg":@"ok"
                                }
                            ];
    [ChatSocket emit:@"broadcast" with:guanliArray];
}
-(void)getZombie{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"requestFans",
                                        @"timestamp":@"",
                                        @"msgtype": @"0",
                                        @"action":@"3"
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
-(void)phoneCall:(NSString *)message{
    NSLog(@"lalala");
    NSString *msgType;
    if ([message isEqualToString:@"主播回来了"]) {
        msgType = @"104";
    }else{
        msgType = @"103";
    }

    NSArray *guanliArray =@[
                            @{
                                @"msg":@[
                                        @{
                                            @"_method_":@"SystemNot",
                                            @"action":@"13",
                                            @"ct":message,
                                            @"msgtype":msgType,
                                            @"uid":@"",
                                            @"uname":@"直播间消息",
                                            @"touid":@"",
                                            @"touname":@"",
                                            @"cts":message
                                            }
                                        ],
                                @"retcode":@"000000",
                                @"retmsg":@"ok"
                                }
                            ];
    [ChatSocket emit:@"broadcast" with:guanliArray];
}
-(void)closeRoom{
    NSArray *msgData1 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_": @"StartEndLive",
                                         @"action": @"18",
                                         @"ct":@"直播关闭",
                                         @"msgtype": @"1",
                                         @"timestamp": @"",
                                         @"tougood": @"",
                                         @"touid": @"",
                                         @"touname": @"",
                                         @"ugood": @"",
                                         @"uid": [Config getOwnID],
                                         @"uname": [Config getOwnNicename],
                                         @"equipment": @"app",
                                         @"roomnum": [Config getOwnID]
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [ChatSocket emit:@"broadcast" with:msgData1];
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendMsg",
                                        @"action": @"18",
                                        @"ct":@"直播关闭",
                                        @"msgtype": @"1",
                                        @"timestamp": @"",
                                        @"tougood": @"",
                                        @"touid": @"",
                                        @"touname": @"",
                                        @"ugood":@"",
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"roomnum": [Config getOwnID]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
-(void)colseSocket{
    [ChatSocket disconnect];
    [ChatSocket off:@""];
    [ChatSocket leaveNamespace];
    ChatSocket = nil;
}
-(void)getshut_time:(NSString *)shut_time{
    
    _shut_time = [NSString stringWithFormat:@"%@",shut_time];
}
-(void)addNodeListen:(NSString *)socketUrl andTimeString:(NSString *)timestring{
    
    __weak socketLive *weakself = self;
    
    isbusy = NO;
    user = [Config myProfile];
    NSURL* url = [[NSURL alloc] initWithString:socketUrl];//@"http://live.yunbaozhibo.com:19965"
    ChatSocket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @NO,@"forcePolling":@YES,@"reconnectWait":@1}];
    NSArray *cur = @[@{@"username":[Config getOwnNicename],
                       @"uid":[Config getOwnID],
                       @"token":[Config getOwnToken],
                       @"roomnum":[Config getOwnID],
                       @"stream":timestring,
                       @"language":[Config canshu],
                       }];
    [ChatSocket connect];
    [ChatSocket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {        
            [ChatSocket emit:@"conn" with:cur];
    }];
    [ChatSocket on:@"conn" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"进入房间");
         [weakself getZombie];
        
        
        
    }];
    
    [ChatSocket on:@"broadcastingListen" callback:^(NSArray* data, SocketAckEmitter* ack) {

            if([[data[0] firstObject] isEqual:@"stopplay"])
            {
            NSLog(@"%@",[data[0] firstObject]);
            [self.delegate superStopRoom:@""];
            UIAlertView  *alertsLimit = [[UIAlertView alloc]initWithTitle:YZMsg(@"涉嫌违规") message:nil delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
            [alertsLimit show];
            return ;
          }
        
            for (NSString *path in data[0]) {
            NSDictionary *jsonArray = [path JSONValue];
            NSDictionary *msg = [[jsonArray valueForKey:@"msg"] firstObject];
            NSString *retcode = [NSString stringWithFormat:@"%@",[jsonArray valueForKey:@"retcode"]];
                
            if ([retcode isEqual:@"409002"]) {
                [MBProgressHUD showError:YZMsg(@"你已被禁言")];
                return;
            }
            NSString *method = [msg valueForKey:@"_method_"];
            [weakself getmessage:msg andMethod:method];
        }
       
        
    }];
}
-(void)getmessage:(NSDictionary *)msg andMethod:(NSString *)method{
    
    if ([method isEqual:@"requestFans"]) {
        NSString *msgtype = [msg valueForKey:@"msgtype"];
        if([msgtype isEqual:@"0"]){
            NSString *action = [msg valueForKey:@"action"];
            //僵尸粉
            if ([action isEqual:@"3"]) {
                NSArray *ct = [msg valueForKey:@"ct"];
                NSArray *data = [ct valueForKey:@"data"];
                if ([[data valueForKey:@"code"]isEqualToNumber:@0]) {
                    NSArray *info = [data valueForKey:@"info"];
                    NSArray *list = [info valueForKey:@"list"];
                    [self.delegate getZombieList:list];
                }
            }
        }
    }
    else if ([method isEqual:@"updateVotes"]){
        
        NSString *msgtype = [msg valueForKey:@"msgtype"];
        if ([msgtype isEqual:@"26"])
        {
            [self.delegate addvotesdelegate:[msg valueForKey:@"votes"]];
        }
    }
    else if ([method isEqual:@"SendMsg"]) {
        
        NSString *msgtype = [msg valueForKey:@"msgtype"];
        if([msgtype isEqual:@"2"])
        {
            NSString* ct;
            NSDictionary *heartDic = [[NSArray arrayWithObject:msg] firstObject];
            NSArray *sub_heart = [heartDic allKeys];
            
            if ([sub_heart containsObject:@"heart"]) {
                NSString *lightColor = [heartDic valueForKey:@"heart"];
                NSString *light = @"light";
                _titleColor = [light stringByAppendingFormat:@"%@",lightColor];
//                ct = [NSString stringWithFormat:@"%@", [msg valueForKey:@"ct"]];
                ct = [NSString stringWithFormat:@"%@",YZMsg(@"我点亮了")];
                NSString* uname = [msg valueForKey:@"uname"];
                NSString *levell = [msg valueForKey:@"level"];
                NSString *ID = [msg valueForKey:@"uid"];
                NSString *vip_type =minstr([msg valueForKey:@"vip_type"]);
                NSString *liangname =minstr([msg valueForKey:@"liangname"]);
                NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",_titleColor,@"titleColor",vip_type,@"vip_type",liangname,@"liangname",nil];
                [self.delegate sendMessage:chat];
            }
            else {
                ct = [NSString stringWithFormat:@"%@", [msg valueForKey:@"ct"]];
                _titleColor = @"0";
                NSString* uname = [msg valueForKey:@"uname"];
                NSString *levell = [msg valueForKey:@"level"];
                NSString *ID = [msg valueForKey:@"uid"];
                
                NSString *vip_type =minstr([msg valueForKey:@"vip_type"]);
                NSString *liangname =minstr([msg valueForKey:@"liangname"]);
                NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",_titleColor,@"titleColor",vip_type,@"vip_type",liangname,@"liangname",nil];
                
                [self.delegate sendMessage:chat];
                
                
            }
        }
        if([msgtype isEqual:@"0"])
        {
            NSString *action = [msg valueForKey:@"action"];
            //用户离开
            if ([action isEqual:@"1"]) {
                NSString *ID = [[msg valueForKey:@"ct"] valueForKey:@"id"];
                [self.delegate socketUserLive:ID and:msg];
            }
            //用户进入
            if ([action isEqual:@"0"]) {
                NSDictionary *dic = [msg valueForKey:@"ct"];
                NSString *ID = [dic valueForKey:@"id"];
                [self.delegate socketUserLogin:ID andDic:msg];
            }
        }
    }
    else if ([method isEqual:@"stopLive"])//stopLiveStartEndLive
    {
        [self.delegate superStopRoom:@""];
    }
    else if([method isEqual:@"StartEndLive"])
    {
        NSString *action = [msg valueForKey:@"action"];
        if ([action isEqual:@"19"]) {
            [self.delegate loginOnOtherDevice];
        }
    }
    else if ([method isEqual:@"light"]){
        NSString *msgtype = [msg valueForKey:@"msgtype"];
        if([msgtype isEqual:@"0"]){
            NSString *action = [msg valueForKey:@"action"];
            //点亮
            if ([action isEqual:@"2"]) {
                [self.delegate socketLight];
                NSLog(@"收到点亮消息");
            }
        }
    }
    else if([method isEqual:@"SendGift"])
    {
        [self.delegate sendGift:msg];
    }
    else if([method isEqual:@"SendBarrage"])
    {
        [self.delegate sendDanMu:msg];
    }else if ([method isEqual:@"ShutUpUser"] ){
        NSString *ct = [NSString stringWithFormat:@"%@%@%@",minstr([msg valueForKey:@"toname"]),YZMsg(@"被禁言"),_shut_time];
        if (ct) {
            [self.delegate socketSystem:ct];
        }

    }else if ([method isEqual:@"KickUser"] ){
        NSString *ct = [NSString stringWithFormat:@"%@%@",minstr([msg valueForKey:@"toname"]),YZMsg(@"被踢出房间")];
        if (ct) {
            [self.delegate socketSystem:ct];
        }
        
    }
    else if ([method isEqual:@"SystemNot"]){
        NSString *action = [msg valueForKey:@"action"];
        if ([action isEqual:@"13"]) {
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
                [self.delegate socketSystem:ct];
            }

        }else{
            NSString *ct = [NSString stringWithFormat:@"%@",[msg valueForKey:@"ct"]];
            if (ct) {
                [self.delegate socketSystem:ct];
            }
        }
    }
    else if([method isEqual:@"disconnect"])
    {
        NSString *action = [msg valueForKey:@"action"];
        //用户离开
        if ([action isEqual:@"1"]) {
            NSString *ID = [[msg valueForKey:@"ct"] valueForKey:@"id"];
            [self.delegate socketUserLive:ID and:msg];
        }
        
        /**************************  礼物结束  ***************************/
        
    }
    //炸金花游戏结果
    //游戏
    else if ([method isEqual:@"startGame"] || [method isEqual:@"startCattleGame"] || [method isEqual:@"startLodumaniGame"] ){
        
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        if ([action isEqual:@"2"]) {
            
                        
        }
        if ([action isEqual:@"6"]) {
            NSArray *ct = [msg valueForKey:@"ct"];
            [self.delegate getResult:ct];
        }
        else if ([action isEqual:@"5"]){
            NSString *money = [NSString stringWithFormat:@"%@",[msg valueForKey:@"money"]];
            NSString *type = [NSString stringWithFormat:@"%@",[msg valueForKey:@"type"]];
            [self.delegate getCoin:type andMoney:money];
        }
    }
    else if ([method isEqual:@"startRotationGame"]){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        if ([action isEqual:@"6"]) {
            NSArray *ct = [msg valueForKey:@"ct"];
            [self.delegate getRotationResult:ct];
        }
        else if ([action isEqual:@"5"]){
            NSString *money = [NSString stringWithFormat:@"%@",[msg valueForKey:@"money"]];
            NSString *type = [NSString stringWithFormat:@"%@",[msg valueForKey:@"type"]];
            [self.delegate getRotationCoin:type andMoney:money];
        }
    }
    else if ([method isEqual:@"startShellGame"] ){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        if ([action isEqual:@"6"]) {
            NSArray *ct = [msg valueForKey:@"ct"];
            [self.delegate getShellResult:ct];
        }
        else if ([action isEqual:@"5"]){
            NSString *money = [NSString stringWithFormat:@"%@",[msg valueForKey:@"money"]];
            NSString *type = [NSString stringWithFormat:@"%@",[msg valueForKey:@"type"]];
            [self.delegate getShellCoin:type andMoney:money];
        }
    }
    //上庄
    /*
     action 1上庄
     */
    else if ([method isEqual:@"shangzhuang"]){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        if ([action isEqual:@"1"]) {
            NSDictionary *subdic = @{
                                     @"uid":[msg valueForKey:@"uid"],
                                     @"uhead":[msg valueForKey:@"uhead"],
                                     @"uname":[msg valueForKey:@"uname"],
                                     @"coin":[msg valueForKey:@"coin"]
                                     };
            [self.delegate getzhuangjianewmessagedelegate:subdic];
        }
    }
#pragma 连麦+声网
    //连麦
    /*
    1 有人发送连麦请求s
    2同意
    3拒绝
    5主播关闭连麦
    */
    else if ([method isEqual:@"ConnectVideo"]){//andAudienceID 连麦申请者ID
#pragma mark 连麦暂时隐藏
        /*
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];        
        if ([action isEqual:@"1"]) {
            [self.delegate  getConnectvideo:[msg valueForKey:@"uname"] andAudienceID:[msg valueForKey:@"uid"]];
        }
        else if ([action isEqual:@"4"]){
            //下麦
            [self.delegate xiamai:[msg valueForKey:@"uname"] andID:[msg valueForKey:@"uid"]];
        }
         */
    }
    /*
     竞拍1  主播发送竞拍消息
     2 服务端返回竞拍的信息
     */
    else if ([method isEqual:@"auction"]){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        if ([action isEqual:@"1"]) {
            NSDictionary *ct = [msg valueForKey:@"ct"];
            [self.delegate getjingpaimessagedelegate:ct];
        }else if ([action isEqual:@"2"]){
            [self.delegate getnewmessage:msg];
        }
    }else if ([method isEqual:@"SendGoldeneggGift"]){
        NSString *msgtype = [NSString stringWithFormat:@"%@",[msg valueForKey:@"msgtype"]];
        if ([msgtype isEqual:@"153"]) {
            NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
            if ([action isEqual:@"153"]) {
                [self.delegate sendZhongJiangMsg:msg];
            }
        }
        
    }
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
    [ChatSocket emit:@"broadcast" with:msgData];
}
//回复连麦  3拒绝 2同意
-(void)replyConnectvideo:(NSString *)action andAudienceID:(NSString *)uid{
    _lianmaiID = uid;
    NSArray *msgData2 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_":@"ConnectVideo",
                                         @"action": action,
                                         @"msgtype": @"10",
                                         @"uid": [Config getOwnID],
                                         @"uname": [Config getOwnNicename],
                                         @"touid":uid
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [ChatSocket emit:@"broadcast" with:msgData2];
}
-(void)closevideo:(NSString *)ID{
    NSArray *msgData2 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_":@"ConnectVideo",
                                         @"action": @"4",
                                         @"msgtype": @"10",
                                         @"uid": [Config getOwnID],
                                         @"uname": [Config getOwnNicename],
                                         @"touid":ID
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [ChatSocket emit:@"broadcast" with:msgData2];
}
-(void)hostisbusy:(NSString *)touid{
    
    NSArray *msgData2 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_":@"ConnectVideo",
                                         @"action": @"5",
                                         @"msgtype": @"10",
                                         @"uid": [Config getOwnID],
                                         @"uname": [Config getOwnNicename],
                                         @"touid":touid
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [ChatSocket emit:@"broadcast" with:msgData2];
}
-(void)hostout:(NSString *)touid{
    
    NSArray *msgData2 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_":@"ConnectVideo",
                                         @"action": @"6",
                                         @"msgtype": @"10",
                                         @"uid": [Config getOwnID],
                                         @"uname": [Config getOwnNicename],
                                         @"touid":touid
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [ChatSocket emit:@"broadcast" with:msgData2];
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
    [ChatSocket emit:@"broadcast" with:msgData2];
}
-(void)changeLiveType:(NSString *)type_val{
    NSArray *guanliArray =@[
                            @{
                                @"msg":@[
                                        @{
                                            @"_method_":@"changeLive",
                                            @"action":@"1",
                                            @"msgtype":@"27",
                                            @"type_val":type_val,
                                            }
                                        ],
                                @"retcode":@"000000",
                                @"retmsg":@"ok"
                                }
                            ];
    [ChatSocket emit:@"broadcast" with:guanliArray];
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
    [ChatSocket emit:@"broadcast" with:msgData];
}
-(void)jingpaiovermessage:(NSDictionary *)dic andaction:(NSString *)action{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_":@"auction",
                                        @"action":action,
                                        @"msgtype":@"55",
                                        @"touname":[dic valueForKey:@"user_nicename"],
                                        @"touhead":[dic valueForKey:@"avatar"],
                                        @"money":[dic valueForKey:@"bid_price"],
                                        @"bid_uid":[dic valueForKey:@"bid_uid"]
                                        //                                       @"auctionid":type,
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
    
}
-(void)sendjiangpaimessage:(NSString *)type{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_":@"auction",
                                        @"action":@"1",
                                        @"msgtype":@"55",
                                        @"auctionid":type,
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
    
}
@end
