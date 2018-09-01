#import <UIKit/UIKit.h>
 #import <SocketIO/SocketIO-Swift.h>


typedef void (^coastblock)(NSString *coast);//第一次进房间扣费通知

#pragma socket监听方法
@protocol socketDelegate <NSObject>
@optional
//房间被管理员关闭
-(void)roomCloseByAdmin;
//添加僵尸粉
-(void)addZombieByArray:(NSArray *)array;
//监听文字消息
-(void)messageListen:(NSDictionary *)chats;
//点亮消息
-(void)light:(NSDictionary *)chats;
//用户离开
-(void)UserLeave:(NSDictionary *)msg;
-(void)UserDisconnect:(NSDictionary *)msg;
//用户进入
-(void)UserAccess:(NSDictionary *)msg;
//通知直播关闭
-(void)LiveOff;
//点亮
-(void)sendLight;
//设置管理员
-(void)setAdmin:(NSString *)msg;
//送礼物
-(void)sendGift:(NSDictionary *)chats andLiansong:(NSString *)liansong andTotalCoin:(long)totalcoin andGiftInfo:(NSDictionary *)giftInfo;
//弹幕
-(void)SendBarrage:(NSDictionary *)msg;
//StartEndLive
-(void)StartEndLive;
//踢人
-(void)KickUser:(NSDictionary *)chats;
-(void)kickOK;
-(void)socketKick;
//红包
-(void)sendRed:(NSDictionary *)msg;
-(void)reloadChongzhi:(NSString *)coin;//刷新钻石数量
-(void)addLianMaiCoin;//更新主播收益
-(void)xiamai;//下麦
-(void)startConnectvideo;//主播同意连麦
-(void)confuseConnectvideo;//主播拒绝连麦
-(void)hostisbusy;//主播正忙碌（连麦）
-(void)hostout;//主播未响应（连麦）
-(void)changeLive:(NSString *)type_val;//切换房间类型
-(void)addvotesdelegate:(NSString *)votes;//增加yingpiao

-(void)changeBank:(NSDictionary *)bankdic;//切换庄家

//准备开始炸金花游戏
-(void)prepGameandMethod:(NSString *)method andMsgtype:(NSString *)msgtype;
-(void)takePoker:(NSString *)gameid Method:(NSString *)method andMsgtype:(NSString *)msgtype;//开始发牌
-(void)stopGame ;
-(void)getResult:(NSArray *)array;//炸金花开奖结果
//开始倒数计时
-(void)startGame:(NSString *)time andGameID:(NSString *)gameid;
-(void)getCoin:(NSString *)type andMoney:(NSString *)money;//更新投注金额
//转盘游戏
-(void)prepRotationGame;//准备开始游戏
-(void)startRotationGame;//开始游戏，开始倒数计时
-(void)stopRotationGame;
-(void)startRotationGame:(NSString *)time andGameID:(NSString *)gameid;
-(void)getRotationResult:(NSArray *)array;//开奖结果
-(void)getRotationCoin:(NSString *)type andMoney:(NSString *)money;//更新投注金额
//二八贝游戏
-(void)shellprepGameandMethod:(NSString *)method andMsgtype:(NSString *)msgtype;
-(void)shelltakePoker:(NSString *)gameid Method:(NSString *)method andMsgtype:(NSString *)msgtype;//开始发牌
-(void)shellstopGame ;
-(void)shellgetResult:(NSArray *)array;//炸金花开奖结果
//开始倒数计时
-(void)shellstartGame:(NSString *)time andGameID:(NSString *)gameid;
-(void)shellgetCoin:(NSString *)type andMoney:(NSString *)money;//更新投注金额
//上庄操作
-(void)getzhuangjianewmessagedelegatem:(NSDictionary *)subdic;
-(void)getjingpaimessagedelegate:(NSDictionary *)dic;//获得竞拍信息s
-(void)getnewjingpaipersonmessage:(NSDictionary *)dic;//获取新的竞拍信息
-(void)jingpaifailed;//竞拍失败
-(void)jingpaisuccess:(NSDictionary *)dic;//竞拍成功
//砸金蛋
-(void)sendZhongJiangMsg:(NSDictionary *)dic;

@end
@interface socketMovieplay : NSObject
{
    //环信接受私信
    int unRead;//未读消息
    int sendMessage;
    UILabel *label;
    //socket监听
    LiveUser *users;
    BOOL isReConSocket;
    BOOL isbusy;//主播是否忙碌（连麦）
    NSString *type_val;
    int justonce;
}
@property(nonatomic,copy)NSString *livetype;
@property(nonatomic,assign)id<socketDelegate>socketDelegate;
@property(nonatomic,strong)SocketIOClient *ChatSocket;
@property(nonatomic,strong)NSDictionary *playDoc;
@property(nonatomic,copy)NSString *chatserver;
@property(nonatomic,copy)NSString *shut_time;//禁言时间 
-(void)addNodeListen:(NSDictionary *)dic;//添加cosket监听
//发红包
-(void)sendRed:(NSString *)money andNodejsInfo:(NSMutableArray *)nodejsInfo;//发红包
//点亮
-(void)starlight:(NSString *)level :(NSNumber *)num;
//关注主播
-(void)attentionLive:(NSString *)level;
//发送消息
-(void)sendmessage:(NSString *)text andLevel:(NSString *)level;
//送礼物
-(void)sendGift:(NSString *)level andINfo:(NSString *)info andlianfa:(NSString *)lianfa;
//禁言
-(void)shutUp:(NSString *)name andID:(NSString *)ID;
//踢人
-(void)kickuser:(NSString *)name andID:(NSString *)ID;
//弹幕
-(void)sendBarrage:(NSString *)level andmessage:(NSString *)test;
//点亮
-(void)starlight;
//僵尸粉
-(void)getZombie;
//socket停止
-(void)socketStop;
typedef void (^getResults)(id arrays);
- (void)setnodejszhuboDic:(NSDictionary *)zhubodic Handler:(getResults)handler andlivetype:(NSString *)livetypes;
-(void)sendBarrageID:(NSString *)ID andTEst:(NSString *)content andDic:(NSDictionary *)zhubodic and:(getResults)handler;//发送弹幕
-(void)superStopRoom;

//-(instancetype)initWithcoastblock:(coastblock)coast;//扣费房间第一次进入扣费

//连麦***************************************************//
-(void)sendlianmaicoin;//连麦后把费用发给主播
-(void)xiamaisocket;//发送下麦通知
-(void)connectvideoToHost;
//扣费
-(void)addvotes:(NSString *)votes isfirst:(NSString *)isfirst;
-(void)addvotesenterroom:(NSString *)votes;
//其他压住
-(void)stakePoke:(NSString *)type andMoney:(NSString *)money andMethod:(NSString *)method andMsgtype:(NSString *)msgtype;
//转盘压住
-(void)stakeRotationPoke:(NSString *)type andMoney:(NSString *)money;
//上庄
-(void)getzhuangjianewmessagem:(NSDictionary *)subdic;
//竞拍
-(void)sendmyjingpaimessage:(NSString *)money;//我点击竞拍广播竞拍消息
- (void)zhongjiangSocket:(NSDictionary *)dic;

@end
