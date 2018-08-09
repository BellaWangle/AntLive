//
//  socketLive.h
//  AntliveShow
//
//  Created by 王敏欣 on 2017/1/24.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
 #import <SocketIO/SocketIO-Swift.h>

@protocol socketLiveDelegate <NSObject>

@optional
-(void)socketCloseShow;
-(void)getZombieList:(NSArray *)list;
-(void)sendMessage:(NSDictionary *)dic;
-(void)sendDanMu:(NSDictionary *)dic;
-(void)socketUserLive:(NSString *)ID and:(NSDictionary *)msg;
-(void)socketUserLogin:(NSString *)ID andDic:(NSDictionary *)dic;
-(void)socketLight;
-(void)sendGift:(NSDictionary *)msg;
-(void)socketSystem:(NSString *)ct;
-(void)sendBarrage:(NSDictionary *)msg;

-(void)getResult:(NSArray *)array;//炸金花开奖结果
-(void)getCoin:(NSString *)type andMoney:(NSString *)money;//更新投注金额
//转盘
-(void)getRotationResult:(NSArray *)array;//转盘开奖结果
-(void)getRotationCoin:(NSString *)type andMoney:(NSString *)money;//更新投注金额
//二八贝
-(void)getShellResult:(NSArray *)array;//二八贝开奖结果
-(void)getShellCoin:(NSString *)type andMoney:(NSString *)money;//二八贝更新投注金额
-(void)getzhuangjianewmessagedelegate:(NSDictionary *)subdic;

//超管禁用直播
-(void)superStopRoom:(NSString *)state;

-(void)addvotesdelegate:(NSString *)votes;
//连麦**************************************************************
-(void)getConnectvideo:(NSString *)AudienceName andAudienceID:(NSString *)Audience;
-(void)xiamai:(NSString *)uname andID:(NSString *)uid;

-(void)getjingpaimessagedelegate:(NSDictionary *)dic;//竞拍

-(void)getnewmessage:(NSDictionary *)dic;//有人竞拍更新信息

-(void)jingpaioverdelegate:(NSDictionary *)dic;//竞拍结束

-(void)loginOnOtherDevice;
//砸金蛋
-(void)sendZhongJiangMsg:(NSDictionary *)dic;

@end
@interface socketLive : NSObject
{
    SocketIOClient *ChatSocket;
    LiveUser *user;
    BOOL isbusy;
}

@property(nonatomic,assign)id<socketLiveDelegate>delegate;
@property(nonatomic,strong)NSString *titleColor;
@property(nonatomic,strong)NSString *lianmaiID;//连麦人的ID
@property(nonatomic,strong)NSString *shut_time;//禁言时间
-(void)getshut_time:(NSString *)shut_time;//获取禁言时间（createroom获取）
-(void)addNodeListen:(NSString *)socketUrl andTimeString:(NSString *)timestring;//添加cosket监听
-(void)colseSocket;
-(void)closeRoom;
-(void)phoneCall:(NSString *)message;
-(void)getZombie;
-(void)setAdminID:(NSString *)ID andName:(NSString *)name andCt:(NSString *)ct;
-(void)shutUp:(NSString *)ID andName:(NSString *)name;
-(void)kickuser:(NSString *)ID andName:(NSString *)name;
-(void)sendBarrage:(NSString *)info;
-(void)sendMessage:(NSString *)text;

//炸金花游戏
-(void)zhaJinHua:(NSString *)gameid andTime:(NSString *)time andJinhuatoken:(NSString *)Jinhuatoken ndMethod:(NSString *)method andMsgtype:(NSString *)msgtype;
//主播发送通知用户开始游戏
-(void)prepGameandMethod:(NSString *)method andMsgtype:(NSString *)msgtype;
-(void)takePoker:(NSString *)gameid ndMethod:(NSString *)method andMsgtype:(NSString *)msgtype andBanklist:(NSDictionary *)banklist;//开始发牌
-(void)stopGamendMethod:(NSString *)method andMsgtype:(NSString *)msgtype;//主播关闭游戏
//转盘游戏
-(void)RotatuonGame:(NSString *)gameid andTime:(NSString *)time androtationtoken:(NSString *)rotationtoken;
-(void)stopRotationGame;
-(void)prepRotationGame;
//压住
-(void)stakePoke:(NSString *)type andMoney:(NSString *)money andMethod:(NSString *)method andMsgtype:(NSString *)msgtype;
//改变房间类型
-(void)changeLiveType:(NSString *)type_val;
//下麦
-(void)xiamaisocket;
//连麦回复
-(void)replyConnectvideo:(NSString *)action andAudienceID:(NSString *)uid;
-(void)closevideo:(NSString *)ID;
-(void)hostisbusy:(NSString *)touid;//主播正忙碌（连麦）
-(void)hostout:(NSString *)touid;//主播未响应（连麦）
-(void)sendjiangpaimessage:(NSString *)type;//竞拍消息
//竞拍结束
-(void)jingpaiovermessage:(NSDictionary *)dic andaction:(NSString *)action;
-(void)getzhuangjianewmessagem:(NSDictionary *)subdic;
@end
