//
//  LookVideo.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/8/4.
//  Copyright © 2017年 cat. All rights reserved.
//
/*
 腾讯版：
 短视屏功能：
 发布视频：Video.setVideo
 评论、回复：Video.setComment
 阅读：Video.addView
 点赞：Video.addLike
 视频列表：Video.getVideoList
 视频详情：Video.getVideo
 视频评论列表：Video.getComments
 我的视频：Video.getMyVideo
 删除：Video.del
 */
#import "LookVideo.h"
#import "personMessage.h"
//#import "TXRTMPSDK/TXLivePlayListener.h"
//#import "TXRTMPSDK/TXLivePlayConfig.h"
//#import "TXRTMPSDK/TXLivePlayer.h"
#import <CWStatusBarNotification/CWStatusBarNotification.h>
#import "videoMoewView.h"
#import <SDWebImage/UIImage+GIF.h>
#import "commentview.h"
#import "personMessage.h"
#import "commectDetails.h"
#import "WMPlayer.h"
#import "UIImage+MultiFormat.h"
@interface LookVideo ()<UIActionSheetDelegate,UITextFieldDelegate,WMPlayerDelegate>//TXLivePlayListener
{
  //  TXLivePlayer *       _txLivePlayer;
   // TXLivePlayConfig*    _config;
    CWStatusBarNotification *_notification;

    UIImageView *heartimagev;
    BOOL istouch;
     videoMoewView *videomore;//分享view
    commentview *comment;//评论
    UIView *leftView;//头像
    UIButton *_newattention;//关注
    CGSize namesize;//主播名称长度
    
    UIView *_toolBar;
    UITextField *textField;
    UIButton *enjoybtn;
    UIButton *likebtn;
    UIButton *commentbtn;
    UILabel *titleL;
    UILabel *namel;
    UIButton *IconBTN;
    UIButton *lowbtn;
    UIButton *finishbtn;
    
    WMPlayer  *wmPlayer;//视频播放器
    
}
@property (weak, nonatomic) IBOutlet UIView *frontview;
@property(nonatomic,assign)BOOL isdelete;//
@property(nonatomic,copy)NSString *playUrl;//视频播放url
@property(nonatomic,copy)NSString *videoid;//视频id
@property(nonatomic,copy)NSString *hostid;//主播id
@property(nonatomic,copy)NSString *hosticon;//主播头像
@property(nonatomic,copy)NSString *hostname;
@property(nonatomic,copy)NSString *islike;//是否点赞
@property(nonatomic,copy)NSString *comments;//评论总数
@property(nonatomic,copy)NSString *likes;//点赞数
@property(nonatomic,copy)NSString *video_title;//视频标题
@property(nonatomic,copy)NSString *shares;//分享次数
@property(nonatomic,copy)NSString *steps;//是否踩
@end
@implementation LookVideo
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     if (wmPlayer) {
        [wmPlayer pause];
     }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if (wmPlayer) {
        [wmPlayer play];
    }
    
}
-(void)dealloc{

     [self releaseWMPlayer];
    
}
- (void)releaseWMPlayer
{
    [wmPlayer pause];
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    [wmPlayer.autoDismissTimer invalidate];
    wmPlayer.autoDismissTimer = nil;
    wmPlayer.playerLayer = nil;
    wmPlayer = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    istouch = YES;
    //设置界面按钮
    [self setFrontView];
    [self setData];
    //设置点赞
    [self setliaght];
    //在回复页面回复了之后，在本页面需要增加评论数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloaComments:) name:@"allComments" object:nil];
    //回复之后刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getnewreload) name:@"reloadcomments" object:nil];
    [self getVideo];//视频详情

    
    _playUrl = [NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"href"]];
    wmPlayer = [[WMPlayer alloc]init];
    wmPlayer.delegate = self;
    wmPlayer.URLString = _playUrl;
    //
    
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_hostdic valueForKey:@"thumb"]]]];
    wmPlayer.placeholderImage = image;
    [_videobottomv addSubview:wmPlayer];
    wmPlayer.frame = CGRectMake(0, 0, _window_width, _window_height);
    [wmPlayer play];

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback  error:nil];

}
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    if (state == WMPlayerStatePlaying) {
         wmplayer.placeholderImage = nil;
    }
}
-(void)reloaComments:(NSNotification *)ns{
    NSDictionary *subdic = [ns userInfo];
    [commentbtn setTitle:[NSString stringWithFormat:@"%@",[subdic valueForKey:@"allComments"]] forState:0];
    if (comment) {
        [comment getNewCount:[[subdic valueForKey:@"allComments"] intValue]];
    }
}
-(void)getnewreload{
    
    //获取视频信息
    NSDictionary *userinfo = [_hostdic valueForKey:@"userinfo"];
    _hostid = [NSString stringWithFormat:@"%@",[userinfo valueForKey:@"id"]];
    _hosticon = [NSString stringWithFormat:@"%@",[userinfo valueForKey:@"avatar"]];
    _hostname = [NSString stringWithFormat:@"%@",[userinfo valueForKey:@"user_nicename"]];
    _videoid = [NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"id"]];
    _likes = [NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"likes"]];
    _islike = [NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"islike"]];
    
}
 //点亮
-(void)setliaght{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starlight)];
    [_frontview addGestureRecognizer:tap];
    //设置屏幕中间心动画
    heartimagev = [[UIImageView alloc]init];
    [self.view addSubview:heartimagev];
    heartimagev.frame = CGRectMake(_window_width/2 - 60, _window_height/2 - 80,120, 120);
    UIImage *images = [UIImage sd_animatedGIFNamed:@"动图"];
    [heartimagev setImage:images];
    heartimagev.hidden = YES;
}
//视频详情
-(void)getVideo{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.getVideo"];
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"videoid":[NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"id"]]
                             };
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                _shares =[NSString stringWithFormat:@"%@",[info valueForKey:@"shares"]];
                _likes = [NSString stringWithFormat:@"%@",[info valueForKey:@"likes"]];
                _islike = [NSString stringWithFormat:@"%@",[info valueForKey:@"islike"]];
                _comments = [NSString stringWithFormat:@"%@",[info valueForKey:@"comments"]];
                _steps = [NSString stringWithFormat:@"%@",[info valueForKey:@"steps"]];
                dispatch_async(dispatch_get_main_queue(), ^{
         
                   if ([_steps isEqual:@"0"]) {
                       [lowbtn setImage:[UIImage imageNamed:@"观看页面图标_踩_空心"] forState:0];
                   }
                   else{
                       [lowbtn setImage:[UIImage imageNamed:@"观看页面图标_踩_实心"] forState:0];
                   }
                   //点赞数 评论数 分享数
                   if ([_islike isEqual:@"1"]) {
                       [likebtn setImage:[UIImage imageNamed:@"观看页面下部图标_点赞_实心"] forState:0];
                   }
                   else{
                       [likebtn setImage:[UIImage imageNamed:@"观看页面下部图标_点赞_空心"] forState:0];
                   }
                   [likebtn setTitle:[NSString stringWithFormat:@"%@",_likes] forState:0];
                   [enjoybtn setTitle:[NSString stringWithFormat:@"%@",_shares] forState:0];
                   [commentbtn setTitle:[NSString stringWithFormat:@"%@",_comments] forState:0];
                    //关注了就不显示了
                    NSString *isattent = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[info valueForKey:@"isattent"]]];
                    if ([isattent isEqual:@"1"] || [[Config getOwnID] isEqual:_hostid]) {
                        _newattention.hidden = YES;
                    }
               });
            }
            else{
                 [HUDHelper myalert:[data valueForKey:@"msg"]];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self canclebtn:nil];
             });
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)setData{
    //列表上的信息会存在刷新不及时，需要请求接口刷新Video.getVideo
    //获取视频间信息
    NSDictionary *userinfo = [_hostdic valueForKey:@"userinfo"];
    _hostid = [NSString stringWithFormat:@"%@",[userinfo valueForKey:@"id"]];
    _hosticon = [NSString stringWithFormat:@"%@",[userinfo valueForKey:@"avatar"]];
    _hostname = [NSString stringWithFormat:@"%@",[userinfo valueForKey:@"user_nicename"]];
    _videoid = [NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"id"]];
    _video_title = [NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"title"]];
    titleL.text = _video_title;
    namel.text = _hostname;
    [IconBTN sd_setBackgroundImageWithURL:[NSURL URLWithString:_hosticon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    //计算名称长度
    namesize = [namel.text boundingRectWithSize:CGSizeMake(_window_width - 130, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontMT(20)} context:nil].size;
    namel.frame = CGRectMake(40,0,namesize.width,40);
    _newattention.frame = CGRectMake(namesize.width + 45,5,60,30);
    leftView.frame = CGRectMake(10,_window_height - 130-statusbarHeight,namesize.width + 80,40);
    if ([[Config getOwnID] isEqual:_hostid]) {
        lowbtn.hidden = YES;
    }
}
-(void)setFrontView{

    //更多按钮
    UIButton *morebtn = [UIButton buttonWithType:0];
    morebtn.frame = CGRectMake(_window_width - 60, 15+statusbarHeight, 50, 50);
    [morebtn setImage:[UIImage imageNamed:@"video-more"] forState:0];
    [morebtn setImageEdgeInsets:UIEdgeInsetsMake(10,10,10,10)];
    [morebtn addTarget:self action:@selector(morebtn:) forControlEvents:UIControlEventTouchUpInside];
    morebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //返回按钮
    UIButton *backbtn = [UIButton buttonWithType:0];
    [backbtn setImage:[UIImage imageNamed:@"video-back"] forState:0];
    [backbtn setImageEdgeInsets:UIEdgeInsetsMake(12,12,12,12)];
    backbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    backbtn.frame = CGRectMake(0,15+statusbarHeight,50,50);
    [backbtn addTarget:self action:@selector(canclebtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //👎 踩
    lowbtn = [UIButton buttonWithType:0];
    [lowbtn setImage:[UIImage imageNamed:@"观看页面图标_踩_空心"] forState:0];
    lowbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    lowbtn.frame = CGRectMake(backbtn.right,15+statusbarHeight,50,50);
    [lowbtn setImageEdgeInsets:UIEdgeInsetsMake(13,13,13,13)];
    [lowbtn addTarget:self action:@selector(lowbtn) forControlEvents:UIControlEventTouchUpInside];
    CGFloat btnW = 70;
    CGFloat btnH = 40;
    CGFloat btnY = _window_height - 45-statusbarHeight;
    
    //分享
    enjoybtn = [UIButton buttonWithType:0];
    [enjoybtn setImage:[UIImage imageNamed:@"观看页面下部图标_分享"] forState:0];
    enjoybtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    enjoybtn.frame = CGRectMake(_window_width - btnW - 10, btnY, btnW,btnH);
    [enjoybtn addTarget:self action:@selector(doenjoy) forControlEvents:UIControlEventTouchUpInside];
    enjoybtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    //点赞
    likebtn = [UIButton buttonWithType:0];
    [likebtn setImage:[UIImage imageNamed:@"观看页面下部图标_点赞_空心"] forState:0];
    likebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    likebtn.frame = CGRectMake(enjoybtn.left - btnW, btnY, btnW, btnH);
    [likebtn addTarget:self action:@selector(dolike) forControlEvents:UIControlEventTouchUpInside];
    likebtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    //评论列表
    commentbtn = [UIButton buttonWithType:0];
    [commentbtn setImage:[UIImage imageNamed:@"观看页面下部图标_聊天"] forState:0];
    commentbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    commentbtn.frame = CGRectMake(likebtn.left -btnW, btnY, btnW,btnH);
    [commentbtn addTarget:self action:@selector(messgaebtn:) forControlEvents:UIControlEventTouchUpInside];
    commentbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    //说点什么
    UIButton *talkbtn = [UIButton buttonWithType:0];
    [talkbtn setImage:[UIImage imageNamed:getImagename(@"video-talk")] forState:0];
    talkbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    talkbtn.frame = CGRectMake(10,_window_height - 50-statusbarHeight, commentbtn.left - 10,50);
    [talkbtn addTarget:self action:@selector(showtextfield) forControlEvents:UIControlEventTouchUpInside];

    //设置图文混排
    [enjoybtn setImageEdgeInsets:UIEdgeInsetsMake(5,0,5,25)];
    [commentbtn setImageEdgeInsets:UIEdgeInsetsMake(5,0,5,25)];
    [likebtn setImageEdgeInsets:UIEdgeInsetsMake(5,0,5,25)];
    [enjoybtn setTitleEdgeInsets:UIEdgeInsetsMake(10,-70,10, 0)];
    [commentbtn setTitleEdgeInsets:UIEdgeInsetsMake(10,-70,10, 0)];
    [likebtn setTitleEdgeInsets:UIEdgeInsetsMake(10,-70,10, 0)];
    
    [self.view addSubview:morebtn];
    [self.view addSubview:likebtn];
    [self.view addSubview:enjoybtn];
    [self.view addSubview:commentbtn];
    [self.view addSubview:talkbtn];
    [self.view addSubview:lowbtn];
    [self.view addSubview:backbtn];
    
    //设置头像 名称 标题
    [self setlfteview];
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//踩
-(void)lowbtn{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.addStep&uid=%@&videoid=%@",[Config getOwnID],[_hostdic valueForKey:@"id"]];
    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSString *isstep = [NSString stringWithFormat:@"%@",[[[data valueForKey:@"info"] firstObject] valueForKey:@"isstep"]];
                if ([isstep isEqual:@"1"]) {
                    [lowbtn setImage:[UIImage imageNamed:@"观看页面图标_踩_实心"] forState:0];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[data valueForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alert show];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alert dismissWithClickedButtonIndex:0 animated:YES];
                    });
                    
                }
                else{
                     [lowbtn setImage:[UIImage imageNamed:@"观看页面图标_踩_空心"] forState:0];
                }                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];

}
//评论
-(void)showtextfield{
    
    if (!_toolBar) {
        
        _toolBar = [[UIView alloc]initWithFrame:CGRectMake(0,_window_height - 50, _window_width, 50)];
        _toolBar.backgroundColor = RGB(248, 248, 248);
        [self.view addSubview:_toolBar];
        
        
        //设置输入框
        UIView *vc  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        vc.backgroundColor = [UIColor clearColor];
        textField = [[UITextField alloc]initWithFrame:CGRectMake(10,8, _window_width - 100, 34)];
        textField.backgroundColor = [UIColor whiteColor];
        textField.layer.masksToBounds = YES;
        textField.layer.cornerRadius = 17;
        textField.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        textField.layer.borderWidth = 1.0;
        textField.placeholder = YZMsg(@"说点什么。。");
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        [_toolBar addSubview:textField];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = vc;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        
        finishbtn = [UIButton buttonWithType:0];
        finishbtn.frame = CGRectMake(_window_width - 80,8,70,34);
        [finishbtn setImage:[UIImage imageNamed:getImagename(@"发送按钮_无文字")] forState:0];
        [finishbtn addTarget:self action:@selector(pushmessage) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:finishbtn];
        
    }
    [textField becomeFirstResponder];
}
//监听textfield
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    if (theTextField.text.length == 0) {
         [finishbtn setImage:[UIImage imageNamed:getImagename(@"发送按钮_无文字")] forState:0];
    }
    else{
         [finishbtn setImage:[UIImage imageNamed:getImagename(@"发送按钮_有文字")] forState:0];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self pushmessage];
    return YES;
}
#pragma mark -- 获取键盘高度
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.origin.y;
    _toolBar.frame = CGRectMake(0, height - 50, _window_width, 50);
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.1 animations:^{
        _toolBar.frame = CGRectMake(0, _window_height + 10, _window_width, 50);
    }];
}
-(void)setlfteview{
    leftView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor clearColor];
    //主播头像button
    IconBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [IconBTN addTarget:self action:@selector(zhuboMessage) forControlEvents:UIControlEventTouchUpInside];
    IconBTN.layer.masksToBounds = YES;
    
    [IconBTN sd_setBackgroundImageWithURL:[NSURL URLWithString:_hosticon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    //直播live
    //视频作者名称
    namel = [[UILabel alloc]init];
    namel.textAlignment = NSTextAlignmentLeft;
    namel.textColor = [UIColor whiteColor];
    namel.shadowOffset = CGSizeMake(1,1);//设置阴影
    namel.font = [UIFont systemFontOfSize:19];;

    //视频标题
    titleL = [[UILabel alloc]init];
    titleL.textAlignment = NSTextAlignmentLeft;
    titleL.textColor = [UIColor whiteColor];
    titleL.shadowOffset = CGSizeMake(1,1);//设置阴影
    titleL.numberOfLines = 0;
    titleL.font = [UIFont systemFontOfSize:15];;
    
    //关注按钮
    _newattention = [UIButton buttonWithType:UIButtonTypeCustom];
    [_newattention setImage:[UIImage imageNamed:getImagename(@"icon_video_guanzhu")] forState:0];
    [_newattention addTarget:self action:@selector(guanzhuzhubo) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:_newattention];
    [leftView addSubview:IconBTN];
    [leftView addSubview:namel];
    
    [self.view addSubview:titleL];
    [self.view addSubview:leftView];
    IconBTN.frame = CGRectMake(0,0,30,30);
    namesize = [namel.text boundingRectWithSize:CGSizeMake(_window_width - 120, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontMT(12)} context:nil].size;
    namel.frame = CGRectMake(35,0,namesize.width, 30);
    _newattention.frame = CGRectMake(namesize.width + 40,2.5,40,25);
    leftView.frame = CGRectMake(10,20,namesize.width + 80,30);
    NSString *isattent = [NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"isattent"]];
    if ([isattent isEqual:@"1"] || [[Config getOwnID] isEqual:_hostid]) {
        _newattention.hidden = YES;
        leftView.frame = CGRectMake(10,20,namesize.width + 40,30);
    }
    
    
    IconBTN.frame = CGRectMake(0, 0,40,40);
    IconBTN.layer.cornerRadius = 20;
    
    
    _newattention.layer.masksToBounds = YES;
    _newattention.layer.cornerRadius = 15;
    
    
    titleL.frame = CGRectMake(10,_window_height - 90-statusbarHeight,_window_width - 20,40);
    namel.frame = CGRectMake(50,2,70,40);
    
    
    UITapGestureRecognizer *tapnum = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhuboMessage)];
    tapnum.numberOfTouchesRequired = 1;
    [leftView addGestureRecognizer:tapnum];
    
    
}
//点击关注主播
-(void)guanzhuzhubo{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.setAttent"];
    
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"touid":_hostid
                             };
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                [UIView animateWithDuration:0.5 animations:^{
                    leftView.frame = CGRectMake(10,_window_height - 130-statusbarHeight,namesize.width + 80,40);
                    _newattention.frame = CGRectMake(namesize.width + 45,5,0,0);
                }];
            }
            else{
                  [HUDHelper myalert:[data valueForKey:@"msg"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)zhuboMessage{
    personMessage  *person = [[personMessage alloc]initWithNibName:@"personMessage" bundle:nil];
    person.userID = _hostid;
    [self.navigationController pushViewController:person animated:YES];
}
//点亮
-(void)starlight{
    [textField resignFirstResponder];
    if (videomore) {
        [self hideMoreView];
    }
    if (istouch == YES) {
        if ([_islike isEqual:@"1"]) {
            [likebtn setImage:[UIImage imageNamed:@"观看页面下部图标_点赞_实心"] forState:0];
        }
        else{
            [self dolike];
        }
        istouch = NO;
        heartimagev.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             heartimagev.hidden = YES;
            istouch = YES;
        });
    }
}
- (IBAction)canclebtn:(id)sender {

    
    [self releaseWMPlayer ];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//分享
-(void)doenjoy{
  [self morebtn:nil];
}
- (IBAction)morebtn:(id)sender {
    if (!videomore) {
         __weak LookVideo *weakself = self;
        NSArray *array = [common share_type];
        CGFloat hh = _window_height/2.2;
        if (array.count == 0) {
            hh = _window_height/2.2/2;
        }
        videomore = [[videoMoewView alloc]initWithFrame:CGRectMake(0, _window_height+20, _window_width, hh) andHostDic:_hostdic cancleblock:^(id array) {
            [weakself hideMoreView];
        } delete:^(id array) {
            [weakself canclebtn:nil];
        } share:^(id array) {
            
        _shares = array;
        [enjoybtn setTitle:[NSString stringWithFormat:@"%@",_shares] forState:0];
            
        }];
        [weakself.view addSubview:videomore];
        videomore.hidden = YES;
    }
    if (videomore.hidden == YES) {
      
        [self showMoreView];
    }
    else{
        [self hideMoreView];
    }
}
-(void)showMoreView{
    [UIView animateWithDuration:0.5 animations:^{
        videomore.frame = CGRectMake(0, _window_height - _window_height/2.2, _window_width, _window_height/2.2);
        NSArray *array = [common share_type];
        //如果没有分享
        if (array.count == 0) {
            videomore.frame = CGRectMake(0, _window_height - _window_height/2.2/2, _window_width, _window_height/2.2/2);
        }
        videomore.hidden = NO;
    }];
}
-(void)hideMoreView{
    [UIView animateWithDuration:0.5 animations:^{
        videomore.frame = CGRectMake(0, _window_height +20, _window_width, _window_height/2.2);
        NSArray *array = [common share_type];
        if (array.count == 0) {
            videomore.frame = CGRectMake(0, _window_height +20, _window_width, _window_height/2.2/2);
        }
        videomore.hidden = YES;
    }];
}
//点赞
-(void)dolike{
    __weak LookVideo *weakself = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.addLike&uid=%@&videoid=%@",[Config getOwnID],_videoid];

    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                _islike = [NSString stringWithFormat:@"%@",[info valueForKey:@"islike"]];
                _likes  = [NSString stringWithFormat:@"%@",[info valueForKey:@"likes"]];
                [likebtn setTitle:[NSString stringWithFormat:@"%@",_likes] forState:0];
                if ([_islike isEqual:@"1"]) {
                    [likebtn setImage:[UIImage imageNamed:@"观看页面下部图标_点赞_实心"] forState:0];
                    [weakself starlight];
                }
                else{
                    [likebtn setImage:[UIImage imageNamed:@"观看页面下部图标_点赞_空心"] forState:0];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
//评论列表
- (IBAction)messgaebtn:(id)sender {
    if (comment) {
        [comment removeFromSuperview];
        comment = nil;
    }
    if (!comment) {
        __weak LookVideo *weakself = self;
    comment = [[commentview alloc]initWithFrame:CGRectMake(0,_window_height, _window_width, _window_height) hide:^(NSString *type) {
            [UIView animateWithDuration:0.3 animations:^{
                comment.frame = CGRectMake(0, _window_height, _window_width, _window_height);
            } ];
        } andvideoid:_videoid andhostid:_hostid count:[_comments intValue] talkCount:^(id type) {
            //刷新评论数显示
            [commentbtn setTitle:[NSString stringWithFormat:@"%@",type] forState:0];
            _comments = type;
        } detail:^(id type) {
            [weakself pushdetails:type];
        }];
        [self.view addSubview:comment];
    }
    [comment getNewCount:[_comments intValue]];
    [UIView animateWithDuration:0.3 animations:^{
        comment.frame = CGRectMake(0,0,_window_width, _window_height);
    }];
}
-(void)pushdetails:(NSDictionary *)type{
    commectDetails *detail = [[commectDetails alloc]init];
    detail.hostDic = type;
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)pushmessage{
    /*
     parentid  回复的评论ID
     commentid 回复的评论commentid
     touid     回复的评论UID
     如果只是评论 这三个传0
     */
    if (textField.text.length == 0) {
        [HUDHelper myalert:YZMsg(@"请添加内容后再尝试")];
        return;
    }
    NSString *path = textField.text;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.setComment&videoid=%@&content=%@&uid=%@&token=%@&touid=%@&commentid=%@&parentid=%@",_videoid,path,[Config getOwnID],[Config getOwnToken],_hostid,@"0",@"0"];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [session POST:url parameters:nil
         progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
             NSNumber *number = [responseObject valueForKey:@"ret"] ;
             if([number isEqualToNumber:[NSNumber numberWithInt:200]])
             {
                 NSArray *data = [responseObject valueForKey:@"data"];
                 NSNumber *code = [data valueForKey:@"code"];
                 if([code isEqualToNumber:[NSNumber numberWithInt:0]])
                 {
                     //更新评论数量
                     NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                     NSString *isattent = [NSString stringWithFormat:@"%@",[info valueForKey:@"isattent"]];//对方是否关注我
                     NSString *newComments = [NSString stringWithFormat:@"%@",[info valueForKey:@"comments"]];
                     _comments = newComments;
                     [commentbtn setTitle:[NSString stringWithFormat:@"%@",newComments] forState:0];
                     if (comment) {
                         [comment getNewCount:[newComments intValue]];
                     }
                     NSString *t2u = [NSString stringWithFormat:@"%@",[info valueForKey:@"t2u"]];//对方是否拉黑我
                     
                     if ([t2u isEqual:@"0"]) {
                        [MBProgressHUD showSuccess:minstr([data valueForKey:@"msg"])];
                         if (![_hostid isEqual:[Config getOwnID]]){
                             [JMSGConversation createSingleConversationWithUsername:_hostid completionHandler:^(id resultObject, NSError *error) {
                                 JMSGConversation *msgConversation = resultObject;
                                 JMSGMessage *message = nil;
                                 JMSGOptionalContent *option = [[JMSGOptionalContent alloc]init];
                                 option.noSaveNotification = YES;
                                 JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:[NSString stringWithFormat:@"%@:%@",YZMsg(@"评论"),path]];
                                 //添加附加字段
                                 [textContent addStringExtra:[Config getavatar] forKey:@"avatar"];
                                 message = [msgConversation createMessageWithContent:textContent];
                                 [msgConversation sendMessage:message optionalContent:option];
                             }];
                         }
                         textField.text = @"";
                         textField.placeholder = YZMsg(@"说点什么。。");
                         [self.view endEditing:YES];
                         
                     }
                     else{
                         if (![_hostid isEqual:[Config getOwnID]]){
                             [MBProgressHUD showError:YZMsg(@"对方暂时拒绝接收您的消息")];
                         }
                         textField.text = @"";
                         textField.placeholder = YZMsg(@"说点什么。。");
                         //论完后 把状态清零
                         [self.view endEditing:YES];
                     }
                 }
                 else{
                     [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];
                     textField.text = @"";
                     textField.placeholder = YZMsg(@"说点什么。。");
                     [self.view endEditing:YES];
                 }
                 
             }
         }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
     }];
}
@end
