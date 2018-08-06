//
//  ViewController.h
//  KSYGPUStreamerVC
//
//  Created by cat
//  Copyright (c) 2016 cat. All rights reserved.
//
//音乐界面
#import "musicView.h"
#import "Utils.h"
//环信半屏
#import "huanxinsixinview.h"
#import "chatsmallview.h"
//歌词
#import "YLYMusicLRC.h"
#import "YLYOKLRCView.h"
//管理员
#import "adminLists.h"
#import "chatcell.h"
#import "chatModel.h"
#import "personMessage.h"
#import "ZFModalTransitionAnimator.h"
#import "CSActionPicker.h"
#import "CSActionSheet.h"
#import "GrounderSuperView.h"
#import "personList.h"
/*******  分享 头文件结束 *********/
#import "GrounderSuperView.h"
#import "catSwitch.h"
#import "expensiveGiftV.h"
#import "continueGift.h"
#import "socketLive.h"
#import "ListCollection.h"
#import "upmessageInfo.h"
#import "userLoginAnimation.h"
//游戏
#import "gameBottomVC.h"
#import "WPFRotateView.h"
//推流
#import <libksygpulive/KSYGPUStreamerKit.h>
#import <GPUImage/GPUImage.h>
#import <AVFoundation/AVFoundation.h>
#import "libksygpulive/KSYMoviePlayerController.h"

#import "coastselectview.h"
#import "shellGame.h"
#import "shangzhuang.h"
#import "gameselected.h"
#import "CoinVeiw.h"
#import "jingpaiwebview.h"
#import "hostjingpaiVC.h"
#import <CWStatusBarNotification/CWStatusBarNotification.h>
#import "viplogin.h"
#import "bottombuttonv.h"
#import "beautifulview.h"
#import "JMListen.h"
@interface Livebroadcast : JMListen
{
    beautifulview *beautifulgirl;//美颜
    viplogin *vipanimation;//坐骑
    userLoginAnimation *useraimation;//用户进入动画
    upmessageInfo *userView;//用户列表弹窗
    CWStatusBarNotification *_notification;
    UIActionSheet *actionSheetMG;//管理弹窗
    socketLive *socketL;//socket
    expensiveGiftV *haohualiwuV;//豪华礼物
    continueGift *continueGifts;//连送礼物
    //私信
    huanxinsixinview *huanxinviews;
    chatsmallview *chatsmall;
    gameselected *gameselectedVC;//游戏选择界面
    NSString *urlStrtimestring;
    
    UIButton *pushBTN;
    UIButton *buttonmusic;//音乐播放暂停
    NSString *haohualiwu;//判断豪华礼物
    NSString *titleColor;
    
    YLYOKLRCView *lrcView;
    bottombuttonv *bottombtnV;//更多
    //管理员列表
    adminLists *adminlist;
    UIViewController *zhezhaoList;
    UITextField *keyField;//聊天&输入框
    UIView *toolBar;
    UIView *frontView;//信息底部透明页面
    
    UITextField *yingpiao;//魅力值数
    UILabel *onlineLabel;//在线人数
    UILabel *labell;//用于显示左上角影票数
    
    
    UIButton *btn;
    UIButton *keyBTN;
    CGFloat www;
    
    
    UIButton *messageBTN;//私信
    UIButton *moreBTN;//更多
    
    catSwitch *cs;//发送弹幕按钮
    //开始动画倒计时123
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UIView *backView;
    //点亮图片
    UIImageView *starImage;
    CGFloat starX;
    CGFloat  starY;
    //信息UI
    UILabel *yingpiaoLabel;
    UIImageView *imageVh;
    UIView *imagebackImage;
    CGSize yingpiaoSize;
    UIView *leftView;
    //音乐
    NSString *muaicPath;//歌曲路径
    NSString *lrcPath;//歌词路径
    UIView *musicV;//音乐界面
    UIButton *btnUserViewClose;//连麦
    //弹幕
    
    GrounderSuperView *danmuview;//弹幕
    
    
    ListCollection *listView;//用户列表
    AFNetworkReachabilityManager *managerAFH;//判断网络状态
    
    
    
    gameBottomVC *gameVC;//游戏demo
    WPFRotateView *rotationV;
    
    UIPanGestureRecognizer *panGestureRecognizer;
    UISwipeGestureRecognizer *_swipeGest;
    UIView *liansongliwubottomview;//连送礼物底部view
    
    
    UIAlertController *alertlianmaiVC;
    NSString *lianmaiID;
    NSString *haslianmaiID;//已经连麦的ID
    
    coastselectview * coastview;//价格选择列表
    NSString *coastmoney;//收费价格
    shellGame *shell;//二八贝
    shangzhuang *zhuangVC;
    UIImageView *levelimage;
    UIView *pushbottomV;
    UIView *videobottom;
    
    UIPanGestureRecognizer *videopan;//视频拖拽手势
    UITapGestureRecognizer *videotap;
    jingpaiwebview *jingpaiweb;
    
    hostjingpaiVC *hostjingpai;//竞拍显示
    
    int _count;
    int backTime;//返回后台时间60s
    int lianmaitime;//连麦的请求时间10s
    int userlist_time;//定时刷新用户列表间隔
    long allCoin;//总收获的魅力值s
    long long userCount;//用户数量
    
    BOOL isjingpaiwriting;//正在天蝎竞拍信息
    BOOL isclosenetwork;//判断断网回后台
    BOOL ismessgaeshow;//限制直有发送消息得时候键盘弹出
    BOOL haslianmai;
    BOOL _joined;
    BOOL _canScrollToBottom;
  //  BOOL isShow;//是否在这个页面
    BOOL _isPlayLrcing;//滚动歌词状态
    
    NSTimer *listTimer;//定时刷新用户列表
    NSTimer *backGroundTimer;//检测后台时间（超过60秒执行断流操作）
    NSTimer *lrcTimer;;//音乐
    NSTimer *lianmaitimer;//连麦计时10s
}
@property(nonatomic,assign)BOOL canFee;//是否开启计时收费
@property(nonatomic,strong)NSString *shut_time;//禁言时间
@property(nonatomic,strong)NSString *namesssssssss;
@property(nonatomic,assign)int type;//直播类型
@property(nonatomic,strong)NSString *type_val;//类型值
@property(nonatomic,strong)NSString *auction_switch;//竞拍开关　
@property(nonatomic,strong)UIImage *uploadImage;
@property(nonatomic,strong)NSDictionary *roomDic;//开始直播信息
@property(nonatomic,strong)NSArray *game_switch;//游戏开关
@property(nonatomic,strong)NSDictionary *zhuangDic;//上庄信息
@property(nonatomic,copy)NSString *isgameroom;//判断隐藏游戏图标


@property KSYGPUStreamerKit * gpuStreamer;
//推流
@property (strong , nonatomic)AVAudioPlayer *player;

@property GPUImageFilter     * filter;
@property(nonatomic,copy)NSString *socketUrl;
@property(nonatomic,copy)NSString *danmuPrice;
//danmuprice
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property(nonatomic,copy)NSString *tanChuangID;//弹窗用户的id
@property(nonatomic,strong)personMessage *person;//个人信息页
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *chatModels;//模型数组
@property(nonatomic,strong)NSString *tanchuangName;
@property (strong , nonatomic)NSMutableArray *lrcList;//歌词
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)NSString *voteNums;//收获数
@property(nonatomic,copy)NSString *method;//游戏
@property(nonatomic,copy)NSString *msgtype;//游戏


// 推流地址 完整的URL
@property(nonatomic,strong) NSURL * hostURL;
@end

