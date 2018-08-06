#import "hietoryPlay.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "JRPlayerView.h"
#import "JRControlView.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#define backcolor [UIColor colorWithRed:52/255.0 green:54/255.0 blue:58/255.0 alpha:1.0];
@interface hietoryPlay () <JRControlViewDelegate,UIAlertViewDelegate>
{
    UIButton *backBTN;
    UIButton *returnCancle;
    UIButton *startBTN;
    NetworkStatus remoteHostStatus;
    int setvishis;
    NSTimer *payTheMoneyTimer;
    BOOL playOK;
    NSString *info;
    UIButton *newPlaybtn;
    BOOL firstLogin;
    int playokokokokook;
}
@property (nonatomic, strong)JRPlayerView		*player;
@property(nonatomic,strong)NSArray *listModelArray;//用户列表数组模型
@property(nonatomic,strong)NSString *ismagic;
@property(nonatomic,strong)NSArray *listArray;
@property(nonatomic,copy)NSString *tanChuangID;
@end
@implementation hietoryPlay
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    setvishis = 0;
    [self.player pause];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    setvishis = 1;
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *returnBtns = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtns.tintColor = [UIColor whiteColor];
    returnBtns.frame = CGRectMake(0,27+statusbarHeight,40,30);[returnBtns.imageView setContentMode:UIViewContentModeScaleAspectFit];
    returnBtns.tintColor = [UIColor whiteColor];
    [returnBtns setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtns addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtns];
    self.view.backgroundColor = [UIColor whiteColor];
    self.player = [[JRPlayerView alloc] initWithFrame:CGRectMake(0,0,_window_width,_window_height)
                                                        asset:[NSURL URLWithString:_url]];
    [self.view addSubview:self.player];
    [self.player pause];
    [self.view addSubview:backBTN];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor whiteColor];
    returnBtn.frame = CGRectMake(0,27+statusbarHeight,40,30);[returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    returnBtn.tintColor = [UIColor whiteColor];
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    playokokokokook  = 0;
    newPlaybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newPlaybtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    newPlaybtn.frame = CGRectMake(10, _window_height*0.8, 80, 80);
    newPlaybtn.center = self.view.center;
    [newPlaybtn addTarget:self action:@selector(onPlayVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newPlaybtn];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backspace)];
    [self.view addGestureRecognizer:tap];
}
-(void)backspace{
    [self onPlayVideo];
}
-(void)onPlayVideo{
    if (playokokokokook == 0) {
        [newPlaybtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [self.player play];
        playokokokokook = 1;
        newPlaybtn.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            newPlaybtn.hidden = YES;
        });

    }
    else{
        [newPlaybtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.player pause];
        newPlaybtn.hidden = NO;
        playokokokokook =0;

    }
}
-(void)doReturn{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
