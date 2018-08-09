
#import <Foundation/Foundation.h>
#import "VideoRecordViewController.h"
//#import "TCVideoPublishController.h"
#import "VideoPreviewViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMediaPickerController.h>
#import "ColorMacro.h"
#import "UIView+Additions.h"
#import "BeautySettingPanel.h"
#import "VideoRecordProcessView.h"
#import "VideoRecordMusicView.h"
#import "VideoEditViewController.h"
#import "MBProgressHUD.h"
#import "musicView.h"
#import <QBImagePickerController/QBImagePickerController.h>
#define BUTTON_RECORD_SIZE          75
#define BUTTON_CONTROL_SIZE         32
#define BUTTON_MASK_HEIGHT          170
#define BUTTON_PROGRESS_HEIGHT      3
#define BUTTON_SPEED_WIDTH          57
#define BUTTON_SPEED_HEIGHT         15
#define BUTTON_SPEED_INTERVAL       20
#define BUTTON_SPEED_COUNT          5
#define MAX_RECORD_TIME             60
#define MIN_RECORD_TIME             5

typedef NS_ENUM(NSInteger,SpeedMode)
{
    SpeedMode_VerySlow,
    SpeedMode_Slow,
    SpeedMode_Standard,
    SpeedMode_Quick,
    SpeedMode_VeryQuick,
};

@implementation VideoConfigure
-(instancetype)init
{
    self = [super init];
    if (self) {
        _videoResolution = VIDEO_RESOLUTION_540_960;
        _videoRatio = VIDEO_ASPECT_RATIO_9_16;
        _bps = 2400;
        _fps = 20;
        _gop = 3;
    }
    return self;
}

@end

@implementation RecordMusicInfo

@end

@interface VideoRecordViewController()<
TXUGCRecordListener,
BeautySettingPanelDelegate,
TXVideoCustomProcessDelegate,QBImagePickerControllerDelegate
>
{
    UIImage *videobackImage;
    NSString *exportPath;

    BOOL                            _cameraFront;
    BOOL                            _lampOpened;
    
    int                             _beautyDepth;
    int                             _whitenDepth;
    
    BOOL                            _cameraPreviewing;
    BOOL                            _videoRecording;
    BOOL                            _isPaused;
    BOOL                            _isFlash;
    
    UIButton *                      _btnRatio;
    UIButton *                      _btnRatio43;
    UIButton *                      _btnRatio11;
    UIButton *                      _btnRatio169;
    CGRect                          _btnRatioFrame;
    UIView *                        _mask_buttom;
    UIView *                        _videoRecordView;
    UIButton *                      _btnDelete;
    UIButton *                      _btnStartRecord;
    UIButton *                      _btnFlash;
    UIButton *                      _btnCamera;
    UIButton *                      _btnBeauty;
    UIButton *                      _btnMusic;
    UIButton *                      _btnLamp;
    UIButton *                      _btnDone;
    UILabel *                       _recordTimeLabel;
    CGFloat                         _currentRecordTime;
    
    UIButton *                      _systemVideoBtn;
    BeautySettingPanel*             _vBeauty;
    
    BOOL                            _navigationBarHidden;
    BOOL                            _statusBarHidden;
    BOOL                            _appForeground;
    
    UIView*                         _tmplBar;
    
    UIDeviceOrientation             _deviceOrientation;
    AVAudioPlayer*                  _player;
    NSTimer*                        _timer;
    
    NSMutableArray*                 _speedBtnList;
    NSString*                       _BGMPath;
    CGFloat                         _BGMDuration;
    
    VideoRecordProcessView *        _progressView;
    VideoRecordMusicView *          _musicView;
    VideoConfigure*                 _videoConfig;
    TXVideoAspectRatio              _aspectRatio;
    SpeedMode                       _speedMode;
    BOOL                            _isBackDelete;
    BOOL                            _bgmRecording;
    int                             _deleteCount;
    float                           _zoom;
    NSInteger                       _speedBtnSelectTag;
    
    CGFloat                         _bgmBeginTime;
    BOOL                            _receiveBGMProgress;
    
    MBProgressHUD*                  _hub;
}
@end

@interface VideoRecordViewController()<MPMediaPickerControllerDelegate,VideoRecordMusicViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation VideoRecordViewController

-(instancetype)initWithConfigure:(VideoConfigure*)configure;
{
    self = [super init];
    if (self)
    {
        _videoConfig = configure;
        _cameraFront = YES;
        _lampOpened = NO;
        _cameraPreviewing = NO;
        _videoRecording = NO;
        _bgmRecording = NO;
        _receiveBGMProgress = YES;
        
        _beautyDepth = 6.3;
        _whitenDepth = 2.7;
        _zoom        = 1.0;
        _bgmBeginTime = 0;
        _currentRecordTime = 0;
        
        [TXUGCRecord shareInstance].recordDelegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onAudioSessionEvent:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeMusic:) name:@"changemusicaaaaa" object:nil];

        _appForeground = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self initBeautyUI];
    self.view.backgroundColor = UIColor.blackColor;

//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"feng.mp3" withExtension:nil];
    
    // 创建播放器
//    NSError *error = nil;
//    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//    [_player prepareToPlay];
//    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

//-(void)updateProgress{
//    //进度条显示播放进度
//    NSLog(@"%@",[NSString stringWithFormat:@"当前播放时间%f",_player.currentTime]);
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.userInteractionEnabled = YES;

    _navigationBarHidden = self.navigationController.navigationBar.hidden;
    self.navigationController.navigationBar.hidden = YES;
    
    if (_cameraPreviewing == NO) {
         [self startCameraPreview];
    }

//    _statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
//    [self.navigationController setNavigationBarHidden:YES];
//    self.navigationController.navigationBar.hidden = NO;
//    [[UIApplication sharedApplication]setStatusBarHidden:YES];


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = _navigationBarHidden;
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}


- (void)didMoveToParentViewController:(UIViewController*)parent
{
    if(!parent){
        [self stopCameraPreview];
    }
}

-(void)onBtnPopClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)onAudioSessionEvent:(NSNotification*)notification
{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        // 在10.3及以上的系统上，分享跳其它app后再回来会收到AVAudioSessionInterruptionWasSuspendedKey的通知，不处理这个事件。
        if ([info objectForKey:@"AVAudioSessionInterruptionWasSuspendedKey"]) {
          
            
            return;
        }
        _appForeground = NO;
        if (!_isPaused && _videoRecording)
            [self onBtnRecordStartClicked];
       
    }else{
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            _appForeground = YES;
        }
    }
}

- (void)onAppDidEnterBackGround:(UIApplication*)app
{
    _appForeground = NO;
    if (!_isPaused && _videoRecording){
        [self onBtnRecordStartClicked];
    }
    
    if (!_vBeauty.hidden) {
        [self onBtnBeautyClicked];
    }
}

- (void)onAppWillEnterForeground:(UIApplication*)app
{
    _appForeground = YES;

}

 - (void)onAppWillResignActive:(UIApplication*)app
{
    _appForeground = NO;
    if (!_isPaused && _videoRecording)
        [self onBtnRecordStartClicked];
    
    if (!_vBeauty.hidden) {
        [self onBtnBeautyClicked];
    }
    
}
- (void)onAppDidBecomeActive:(UIApplication*)app
{
    _appForeground = YES;

}

#pragma mark ---- Common UI ----
-(void)initUI
{
    self.title = @"";
    _videoRecordView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_videoRecordView];
    
    UIPinchGestureRecognizer* pinchGensture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [_videoRecordView addGestureRecognizer:pinchGensture];
    
    UIButton *btnPop = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPop.bounds = CGRectMake(0, 0, BUTTON_CONTROL_SIZE, BUTTON_CONTROL_SIZE);
    btnPop.center = CGPointMake(17, 30 + BUTTON_CONTROL_SIZE / 2 - 5);
    [btnPop setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnPop addTarget:self action:@selector(onBtnPopClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPop];
    
    _btnRatio169 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRatio169.bounds = CGRectMake(0, 0, BUTTON_CONTROL_SIZE, BUTTON_CONTROL_SIZE);
    _btnRatio169.center = CGPointMake(CGRectGetWidth(self.view.bounds) - 20 - BUTTON_CONTROL_SIZE / 2, 30 + BUTTON_CONTROL_SIZE / 2 - 5);
    [_btnRatio169 setImage:[UIImage imageNamed:@"169"] forState:UIControlStateNormal];
    [_btnRatio169 setImage:[UIImage imageNamed:@"169_hover"] forState:UIControlStateHighlighted];
    [_btnRatio169 addTarget:self action:@selector(onBtnRatioClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnRatio169.tag = VIDEO_ASPECT_RATIO_9_16;
    _btnRatio169.hidden = NO;
    [self.view addSubview:_btnRatio169];
    _btnRatioFrame = _btnRatio169.frame;
    
    _btnRatio11 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRatio11.frame = CGRectOffset(_btnRatioFrame, -(30 + BUTTON_CONTROL_SIZE), 0);
    [_btnRatio11 setImage:[UIImage imageNamed:@"11"] forState:UIControlStateNormal];
    [_btnRatio11 setImage:[UIImage imageNamed:@"11_hover"] forState:UIControlStateHighlighted];
    [_btnRatio11 addTarget:self action:@selector(onBtnRatioClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnRatio11.tag = VIDEO_ASPECT_RATIO_1_1;
    _btnRatio11.hidden = YES;
    [self.view addSubview:_btnRatio11];
    
    _btnRatio43 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRatio43.frame = CGRectOffset(_btnRatio11.frame, -(30 + BUTTON_CONTROL_SIZE), 0);
    [_btnRatio43 setImage:[UIImage imageNamed:@"43"] forState:UIControlStateNormal];
    [_btnRatio43 setImage:[UIImage imageNamed:@"43_hover"] forState:UIControlStateHighlighted];
    [_btnRatio43 addTarget:self action:@selector(onBtnRatioClicked:) forControlEvents:UIControlEventTouchUpInside];
    _btnRatio43.tag = VIDEO_ASPECT_RATIO_3_4;
    _btnRatio43.hidden = YES;
    [self.view addSubview:_btnRatio43];
    
    switch (_videoConfig.videoRatio) {
        case VIDEO_ASPECT_RATIO_3_4:
            [self onBtnRatioClicked:_btnRatio43];
            break;
        case VIDEO_ASPECT_RATIO_1_1:
            [self onBtnRatioClicked:_btnRatio11];
            break;
        case VIDEO_ASPECT_RATIO_9_16:
            [self onBtnRatioClicked:_btnRatio169];
            break;
            
        default:
            break;
    }
    
    UILabel *ratioLabel = [[UILabel alloc] initWithFrame:CGRectMake(_btnRatio169.x-10, _btnRatio169.bottom + 10, BUTTON_CONTROL_SIZE+20, 11)];
    ratioLabel.text = YZMsg(@"屏比");
    ratioLabel.textColor = UIColorFromRGB(0xffffffff);
    ratioLabel.font = [UIFont systemFontOfSize:12];
    ratioLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ratioLabel];
    
    _btnBeauty = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnBeauty.frame = CGRectOffset(_btnRatio169.frame, 0, 72);
    [_btnBeauty setImage:[UIImage imageNamed:@"beauty_record"] forState:UIControlStateNormal];
    [_btnBeauty setImage:[UIImage imageNamed:@"beauty_hover"] forState:UIControlStateHighlighted];
    [_btnBeauty addTarget:self action:@selector(onBtnBeautyClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnBeauty];
    
    UILabel *beautyLabel = [[UILabel alloc] initWithFrame:CGRectMake(_btnBeauty.x-5, _btnBeauty.bottom + 10, BUTTON_CONTROL_SIZE+10, 11)];
    beautyLabel.text = YZMsg(@"美颜");
    beautyLabel.textColor = UIColorFromRGB(0xffffffff);
    beautyLabel.font = [UIFont systemFontOfSize:12];
    beautyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:beautyLabel];
    
    _btnMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnMusic.frame = CGRectOffset(_btnBeauty.frame, 0, 72);
    [_btnMusic setImage:[UIImage imageNamed:@"backMusic"] forState:UIControlStateNormal];
    [_btnMusic setImage:[UIImage imageNamed:@"backMusic_hover"] forState:UIControlStateHighlighted];
    [_btnMusic addTarget:self action:@selector(onBtnMusicClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnMusic];
    
    UILabel *musicLabel = [[UILabel alloc] initWithFrame:CGRectMake(_btnMusic.x-5, _btnMusic.bottom + 10, BUTTON_CONTROL_SIZE+10, 11)];
    musicLabel.text = YZMsg(@"音乐");
    musicLabel.textColor = UIColorFromRGB(0xffffffff);
    musicLabel.font = [UIFont systemFontOfSize:12];
    musicLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:musicLabel];
    
    _musicView = [[VideoRecordMusicView alloc] initWithFrame:CGRectMake(0, self.view.bottom - 175, self.view.width, 175)];
    _musicView.delegate = self;
    _musicView.hidden = YES;
    [self.view addSubview:_musicView];
    
    _mask_buttom = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - BUTTON_MASK_HEIGHT, self.view.frame.size.width, BUTTON_MASK_HEIGHT)];
    [_mask_buttom setBackgroundColor:UIColorFromRGB(0x000000)];
    [_mask_buttom setAlpha:0.3];
    [self.view addSubview:_mask_buttom];
    
    _btnStartRecord = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BUTTON_RECORD_SIZE, BUTTON_RECORD_SIZE)];
    _btnStartRecord.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - BUTTON_RECORD_SIZE + 10);
    [_btnStartRecord setImage:[UIImage imageNamed:@"start_record"] forState:UIControlStateNormal];
    [_btnStartRecord setBackgroundImage:[UIImage imageNamed:@"start_ring"] forState:UIControlStateNormal];
    [_btnStartRecord addTarget:self action:@selector(onBtnRecordStartClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnStartRecord];
    
    _btnFlash = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnFlash.bounds = CGRectMake(0, 0, BUTTON_CONTROL_SIZE, BUTTON_CONTROL_SIZE);
    _btnFlash.center = CGPointMake(_btnMusic.center.x, musicLabel.bottom+10+BUTTON_CONTROL_SIZE/2);
    if (_cameraFront) {
        [_btnFlash setImage:[UIImage imageNamed:@"openFlash_disable"] forState:UIControlStateNormal];
        _btnFlash.enabled = NO;
    }else{
        [_btnFlash setImage:[UIImage imageNamed:@"closeFlash"] forState:UIControlStateNormal];
        [_btnFlash setImage:[UIImage imageNamed:@"closeFlash_hover"] forState:UIControlStateHighlighted];
        _btnFlash.enabled = YES;
    }
    [_btnFlash addTarget:self action:@selector(onBtnFlashClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnFlash];
    
    
    _systemVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _systemVideoBtn.bounds = CGRectMake(0, 0, BUTTON_CONTROL_SIZE, BUTTON_CONTROL_SIZE);
    _systemVideoBtn.center = CGPointMake(25 + BUTTON_CONTROL_SIZE / 2, _btnStartRecord.center.y);
    [_systemVideoBtn addTarget:self action:@selector(onBtnLocalVideoClicked) forControlEvents:UIControlEventTouchUpInside];
    [_systemVideoBtn setImage:[UIImage imageNamed:@"上传"] forState:0];
    [self.view addSubview:_systemVideoBtn];
    
    _btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCamera.bounds = CGRectMake(0, 0, BUTTON_CONTROL_SIZE, BUTTON_CONTROL_SIZE);
    _btnCamera.center = CGPointMake(_systemVideoBtn.right + 25 + BUTTON_CONTROL_SIZE / 2, _btnStartRecord.center.y);
//    _btnCamera.frame = CGRectOffset(_btnMusic.frame, 0, 72);
    [_btnCamera setImage:[UIImage imageNamed:@"camera_record"] forState:UIControlStateNormal];
    [_btnCamera setImage:[UIImage imageNamed:@"camera_hover"] forState:UIControlStateHighlighted];
    [_btnCamera addTarget:self action:@selector(onBtnCameraClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnCamera];
    
    _btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnDone.bounds = CGRectMake(0, 0, BUTTON_CONTROL_SIZE, BUTTON_CONTROL_SIZE);
    _btnDone.center = CGPointMake(CGRectGetWidth(self.view.bounds) - 25 - BUTTON_CONTROL_SIZE / 2 , _btnStartRecord.center.y);
    [_btnDone setImage:[UIImage imageNamed:@"confirm_disable"] forState:UIControlStateNormal];
    [_btnDone setTitleColor:UIColor.brownColor forState:UIControlStateNormal];
    [_btnDone addTarget:self action:@selector(onBtnDoneClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnDone];
    _btnDone.enabled = NO;
    
    _btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnDelete.bounds = CGRectMake(0, 0, BUTTON_CONTROL_SIZE, BUTTON_CONTROL_SIZE);
    _btnDelete.center = CGPointMake(_btnDone.left - 25 - BUTTON_CONTROL_SIZE / 2, _btnStartRecord.center.y);
    [_btnDelete setImage:[UIImage imageNamed:@"backDelete"] forState:UIControlStateNormal];
    [_btnDelete setImage:[UIImage imageNamed:@"backDelete_hover"] forState:UIControlStateHighlighted];
    [_btnDelete addTarget:self action:@selector(onBtnDeleteClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnDelete];
    
    _progressView = [[VideoRecordProcessView alloc] initWithFrame:CGRectMake(0,_mask_buttom.y - BUTTON_PROGRESS_HEIGHT + 0.5, self.view.frame.size.width, BUTTON_PROGRESS_HEIGHT)];
    _progressView.backgroundColor = [UIColor blackColor];
    _progressView.alpha = 0.4;
    [self.view addSubview:_progressView];
    
    _recordTimeLabel = [[UILabel alloc]init];
    _recordTimeLabel.frame = CGRectMake(0, 0, 100, 100);
    [_recordTimeLabel setText:@"00:00"];
    _recordTimeLabel.font = [UIFont systemFontOfSize:10];
    _recordTimeLabel.textColor = [UIColor whiteColor];
    _recordTimeLabel.textAlignment = NSTextAlignmentLeft;
    [_recordTimeLabel sizeToFit];
    _recordTimeLabel.center = CGPointMake(CGRectGetMaxX(_progressView.frame) - _recordTimeLabel.frame.size.width / 2, _progressView.frame.origin.y - _recordTimeLabel.frame.size.height);
    [self.view addSubview:_recordTimeLabel];
    
    [self createSpeedBtnS];
}

//加速录制
-(void)createSpeedBtnS
{
    _speedBtnList = [NSMutableArray array];
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat btnInterval = 0.f;
    if (viewWidth > 320) {
        btnInterval = BUTTON_SPEED_INTERVAL;
    }else{
        btnInterval = BUTTON_SPEED_INTERVAL * 2.0 / 3;
    }
    CGFloat btnBeginCenterX = (viewWidth - BUTTON_SPEED_WIDTH * BUTTON_SPEED_COUNT - btnInterval * (BUTTON_SPEED_COUNT - 1)) / 2 + BUTTON_SPEED_WIDTH / 2;
    for(int i = 0 ; i < BUTTON_SPEED_COUNT ; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.bounds = CGRectMake(0, 0, BUTTON_SPEED_WIDTH, BUTTON_SPEED_HEIGHT);
        btn.center = CGPointMake(btnBeginCenterX + (btnInterval + BUTTON_SPEED_WIDTH) * i, self.view.frame.size.height - 146);
        [btn setTitle:[self getSpeedText:(SpeedMode)i] forState:UIControlStateNormal];
        btn.tag = i;
        if (i == SpeedMode_Standard) {
            [btn setTitleColor:UIColorFromRGB(0x00f5ac) forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
            _speedBtnSelectTag = btn.tag;
        }else{
            [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        }
        //最后一个按钮的宽度大点
        if (i == SpeedMode_VeryQuick) {
            btn.width = BUTTON_SPEED_WIDTH+10;
        }
        [btn addTarget:self action:@selector(onBtnSpeedClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [_speedBtnList addObject:btn];
    }
}

-(void)setSpeedBtnHidden:(BOOL)hidden{
    for(UIButton *btn in _speedBtnList){
        [btn setHidden:hidden];
    }
}

- (void)handlePinch:(UIPinchGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        [[TXUGCRecord shareInstance] setZoom:MIN(MAX(1.0, _zoom * recognizer.scale),5.0)];
    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        _zoom = MIN(MAX(1.0, _zoom * recognizer.scale),5.0);
        recognizer.scale = 1;
    }
}

-(NSString *)getSpeedText:(SpeedMode)speedMode
{
    NSString *text = nil;
    switch (speedMode) {
        case SpeedMode_VerySlow:
            text = YZMsg(@"极慢");
            break;
        case SpeedMode_Slow:
            text = YZMsg(@"慢");
            break;
        case SpeedMode_Standard:
            text = YZMsg(@"标准");
            break;
        case SpeedMode_Quick:
            text = YZMsg(@"快");
            break;
        case SpeedMode_VeryQuick:
            text = YZMsg(@"极快");
            break;
        default:
            break;
    }
    return text;
}

-(void)onBtnRatioClicked:(UIButton *)btn
{
    switch (btn.tag) {
        case VIDEO_ASPECT_RATIO_9_16:
        {
            if (btn.right + 20 == self.view.frame.size.width && [self ratioIsClosure]) {
                _btnRatio11.frame = CGRectOffset(btn.frame, -(30 + BUTTON_CONTROL_SIZE), 0);
                _btnRatio43.frame = CGRectOffset(_btnRatio11.frame, -(30 + BUTTON_CONTROL_SIZE), 0);
                _btnRatio11.hidden = NO;
                _btnRatio43.hidden = NO;
            }else{
                btn.frame = _btnRatioFrame;
                _btnRatio11.frame = _btnRatioFrame;
                _btnRatio43.frame = _btnRatioFrame;
                _btnRatio11.hidden = YES;
                _btnRatio43.hidden = YES;
            }
            CGFloat height = _videoRecordView.frame.size.width * 16 / 9;
            [UIView animateWithDuration:0.2 animations:^{
                _videoRecordView.frame = CGRectMake(0, (self.view.frame.size.height - height) / 2.0, _videoRecordView.frame.size.width, height);;
            }];
            _aspectRatio = VIDEO_ASPECT_RATIO_9_16;
            [[TXUGCRecord shareInstance] setAspectRatio:_aspectRatio];
        }
            break;
        case VIDEO_ASPECT_RATIO_1_1:
        {
            if (btn.right + 20 == self.view.frame.size.width && [self ratioIsClosure]) {
                _btnRatio43.frame = CGRectOffset(btn.frame, -(30 + BUTTON_CONTROL_SIZE), 0);
                _btnRatio169.frame = CGRectOffset(_btnRatio43.frame, -(30 + BUTTON_CONTROL_SIZE), 0);
                _btnRatio43.hidden = NO;
                _btnRatio169.hidden = NO;
            }else{
                btn.frame = _btnRatioFrame;
                _btnRatio43.frame = _btnRatioFrame;
                _btnRatio169.frame = _btnRatioFrame;
                _btnRatio43.hidden = YES;
                _btnRatio169.hidden = YES;
            }
            CGFloat height = _videoRecordView.frame.size.width;
            [UIView animateWithDuration:0.2 animations:^{
                _videoRecordView.frame = CGRectMake(0, (self.view.frame.size.height - height) / 2.0, _videoRecordView.frame.size.width, height);;
            }];
            _aspectRatio = VIDEO_ASPECT_RATIO_1_1;
            [[TXUGCRecord shareInstance] setAspectRatio:_aspectRatio];
        }
            
            break;
        case VIDEO_ASPECT_RATIO_3_4:
        {
            if (btn.right + 20 == self.view.frame.size.width && [self ratioIsClosure]) {
                _btnRatio169.frame = CGRectOffset(btn.frame, -(30 + BUTTON_CONTROL_SIZE), 0);
                _btnRatio11.frame = CGRectOffset(_btnRatio169.frame, -(30 + BUTTON_CONTROL_SIZE), 0);
                _btnRatio169.hidden = NO;
                _btnRatio11.hidden = NO;
            }else{
                btn.frame = _btnRatioFrame;
                _btnRatio169.frame = _btnRatioFrame;
                _btnRatio11.frame = _btnRatioFrame;
                _btnRatio169.hidden = YES;
                _btnRatio11.hidden = YES;
            }
            CGFloat height = _videoRecordView.frame.size.width * 4 / 3;
            [UIView animateWithDuration:0.2 animations:^{
                _videoRecordView.frame = CGRectMake(0, (self.view.frame.size.height - height) / 2.0, _videoRecordView.frame.size.width, height);;
            }];
            _aspectRatio = VIDEO_ASPECT_RATIO_3_4;
            [[TXUGCRecord shareInstance] setAspectRatio:_aspectRatio];
        }
            
            break;
        default:
            break;
    }
    btn.hidden = NO;
}

-(BOOL)ratioIsClosure
{
    if (CGRectEqualToRect(_btnRatio43.frame, _btnRatio11.frame)) {
        return YES;
    }
    return NO;
}

- (void)onBtnMusicClicked
{
    _musicView.hidden = !_musicView.hidden;
    _vBeauty.hidden = YES;
    [self hideBottomView:!_musicView.hidden];
}

-(void)onBtnSpeedClicked:(UIButton *)btn
{
    for(int i = 0 ; i < _speedBtnList.count ; i ++)
    {
        if (i == btn.tag) {
            [_speedBtnList[i] setTitleColor:UIColorFromRGB(0x00f5ac) forState:UIControlStateNormal];
            [[(UIButton *)_speedBtnList[i] titleLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
            _speedBtnSelectTag = i;
        }else{
            [_speedBtnList[i] setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [[(UIButton *)_speedBtnList[i] titleLabel] setFont:[UIFont systemFontOfSize:13]];
        }
    }
}

-(void)setSpeedRate{
    switch ((SpeedMode)_speedBtnSelectTag) {
        case SpeedMode_VerySlow:
            [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_SLOWEST];
            break;
        case SpeedMode_Slow:
            [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_SLOW];
            break;
        case SpeedMode_Standard:
            [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_NOMAL];
            break;
        case SpeedMode_Quick:
            [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_FAST];
            break;
        case SpeedMode_VeryQuick:
            [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_FASTEST];
            break;
        default:
            break;
    }
}

-(void)onBtnFlashClicked
{
    if (_isFlash) {
        [_btnFlash setImage:[UIImage imageNamed:@"closeFlash"] forState:UIControlStateNormal];
        [_btnFlash setImage:[UIImage imageNamed:@"closeFlash_hover"] forState:UIControlStateHighlighted];
    }else{
        [_btnFlash setImage:[UIImage imageNamed:@"openFlash"] forState:UIControlStateNormal];
        [_btnFlash setImage:[UIImage imageNamed:@"openFlash_hover"] forState:UIControlStateHighlighted];
    }
    _isFlash = !_isFlash;
    [[TXUGCRecord shareInstance] toggleTorch:_isFlash];
}

-(void)onBtnDeleteClicked
{
    if (_videoRecording && !_isPaused) {
        [self onBtnRecordStartClicked];
    }
    if (0 == _deleteCount) {
        [_progressView prepareDeletePart];
    }else{
        [_progressView comfirmDeletePart];
        [[TXUGCRecord shareInstance].partsManager deleteLastPart];
        _isBackDelete = YES;
        
        if ([TXUGCRecord shareInstance].partsManager.getVideoPathList.count ==0) {
            [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_NOMAL];
        }
    }
    if (2 == ++ _deleteCount) {
        _deleteCount = 0;
    }
}

-(void)onBtnRecordStartClicked
{
    if (!_videoRecording)
    {
        [self startVideoRecord];
    }
    else
    {
        if (_isPaused) {
            [self setSpeedRate];
            
            if (_bgmRecording) {
                [self resumeBGM];
            }else{
                [self playBGM:_bgmBeginTime];
                _bgmRecording = YES;
            }
            [[TXUGCRecord shareInstance] resumeRecord];
            
            [_btnStartRecord setImage:[UIImage imageNamed:@"pause_record"] forState:UIControlStateNormal];
            [_btnStartRecord setBackgroundImage:[UIImage imageNamed:@"pause_ring"] forState:UIControlStateNormal];
            _btnStartRecord.bounds = CGRectMake(0, 0, BUTTON_RECORD_SIZE * 0.85, BUTTON_RECORD_SIZE * 0.85);
          
            if (_deleteCount == 1) {
                [_progressView cancelDelete];
                _deleteCount = 0;
            }
            [self setSpeedBtnHidden:YES];
            
            _isPaused = NO;
        }
        else {
            [[TXUGCRecord shareInstance] pauseRecord];
            [self pauseBGM];
            
            [_btnStartRecord setImage:[UIImage imageNamed:@"start_record"] forState:UIControlStateNormal];
            [_btnStartRecord setBackgroundImage:[UIImage imageNamed:@"start_ring"] forState:UIControlStateNormal];
            _btnStartRecord.bounds = CGRectMake(0, 0, BUTTON_RECORD_SIZE, BUTTON_RECORD_SIZE);
            
            [_progressView pause];
            [self setSpeedBtnHidden:NO];
            
            _isPaused = YES;
        }
    }
}

- (void)onBtnDoneClicked
{
    if (!_videoRecording)
        return;
    
    [self stopVideoRecord];
}

-(void)startCameraPreview
{

    if (_cameraPreviewing == NO)
    {
        //简单设置
        //        TXUGCSimpleConfig * param = [[TXUGCSimpleConfig alloc] init];
        //        param.videoQuality = VIDEO_QUALITY_MEDIUM;
        //        [[TXUGCRecord shareInstance] startCameraSimple:param preview:_videoRecordView];
        //自定义设置
        TXUGCCustomConfig * param = [[TXUGCCustomConfig alloc] init];
        param.videoResolution =  _videoConfig.videoResolution;
        param.videoFPS = _videoConfig.fps;
        param.videoBitratePIN = _videoConfig.bps;
        param.GOP = _videoConfig.gop;
        param.minDuration = MIN_RECORD_TIME;
        param.maxDuration = MAX_RECORD_TIME;
        [[TXUGCRecord shareInstance] startCameraCustom:param preview:_videoRecordView];
        [[TXUGCRecord shareInstance] setAspectRatio:_aspectRatio];
        [TXUGCRecord shareInstance].videoProcessDelegate = self;
        //[[TXUGCRecord shareInstance] setZoom:2.5];
        
        UIImage *watermark = [UIImage imageNamed:@"watermark.png"];
        CGRect watermarkFrame = (CGRect){0.01, 0.01, 0.3 , 0};
        [[TXUGCRecord shareInstance] setWaterMark:watermark normalizationFrame:watermarkFrame];
        [_vBeauty resetValues];

        _cameraPreviewing = YES;
    }

}

/* 各种情况下的横竖屏推流 参数设置
 //activity竖屏模式，竖屏推流
 [[TXUGCRecord shareInstance] setHomeOrientation:VIDEO_HOME_ORIENTATION_DOWN];
 [[TXUGCRecord shareInstance] setRenderRotation:0];
 
 //activity竖屏模式，home在右横屏推流
 [[TXUGCRecord shareInstance] setHomeOrientation:VIDOE_HOME_ORIENTATION_RIGHT];
 [[TXUGCRecord shareInstance] setRenderRotation:90];
 
 //activity竖屏模式，home在左横屏推流
 [[TXUGCRecord shareInstance] setHomeOrientation:VIDEO_HOME_ORIENTATION_LEFT];
 [[TXUGCRecord shareInstance] setRenderRotation:270];
 
 //activity横屏模式，home在右横屏推流 注意：渲染view要跟着activity旋转
 [[TXUGCRecord shareInstance] setHomeOrientation:VIDOE_HOME_ORIENTATION_RIGHT];
 [[TXUGCRecord shareInstance] setRenderRotation:0];
 
 //activity横屏模式，home在左横屏推流 注意：渲染view要跟着activity旋转
 [[TXUGCRecord shareInstance] setHomeOrientation:VIDEO_HOME_ORIENTATION_LEFT];
 [[TXUGCRecord shareInstance] setRenderRotation:0];
 */

- (void)statusBarOrientationChanged:(NSNotification *)note  {
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationPortrait:        //activity竖屏模式，竖屏录制
        {
            if (_deviceOrientation != UIDeviceOrientationPortrait) {
                
                [[TXUGCRecord shareInstance] setHomeOrientation:VIDEO_HOME_ORIENTATION_DOWN];
                [[TXUGCRecord shareInstance] setRenderRotation:0];
            }
        }
            break;
        case UIDeviceOrientationLandscapeLeft:   //activity横屏模式，home在右横屏录制 注意：渲染view要跟着activity旋转
        {
            if (_deviceOrientation != UIDeviceOrientationLandscapeLeft) {
                [[TXUGCRecord shareInstance] setHomeOrientation:VIDOE_HOME_ORIENTATION_RIGHT];
                [[TXUGCRecord shareInstance] setRenderRotation:0];
//                [[TXUGCRecord shareInstance] startRecord];
            }
            
        }
            break;
        case UIDeviceOrientationLandscapeRight:   //activity横屏模式，home在左横屏录制 注意：渲染view要跟着activity旋转
        {
            if (_deviceOrientation != UIDeviceOrientationLandscapeRight) {
                
                [[TXUGCRecord shareInstance] setHomeOrientation:VIDEO_HOME_ORIENTATION_LEFT];
                [[TXUGCRecord shareInstance] setRenderRotation:0];
//                [[TXUGCRecord shareInstance] startRecord];
            }
        }
            break;
        default:
            break;
    }
}


-(void)stopCameraPreview
{
    if (_cameraPreviewing == YES)
    {
        [[TXUGCRecord shareInstance] stopCameraPreview];
        [TXUGCRecord shareInstance].videoProcessDelegate = nil;
        _cameraPreviewing = NO;
    }
}

-(void)startVideoRecord
{
    [self refreshRecordTime:0];
    [self startCameraPreview];
    [self setSpeedRate];
    int result = [[TXUGCRecord shareInstance] startRecord];
    if(0 != result)
    {
        if(-3 == result) [self alert:YZMsg(@"启动录制失败") msg:YZMsg(@"请在设置中开启相机权限")];
        if(-4 == result) [self alert:YZMsg(@"启动录制失败") msg:YZMsg(@"请在设置中开启麦克风权限")];
    }else{
        [self playBGM:_bgmBeginTime];
        _bgmRecording = YES;
        _videoRecording = YES;
        _isPaused = NO;
        [self setSpeedBtnHidden:YES];
        [_btnStartRecord setImage:[UIImage imageNamed:@"pause_record"] forState:UIControlStateNormal];
        [_btnStartRecord setBackgroundImage:[UIImage imageNamed:@"pause_ring"] forState:UIControlStateNormal];
        _btnStartRecord.bounds = CGRectMake(0, 0, BUTTON_RECORD_SIZE * 0.85, BUTTON_RECORD_SIZE * 0.85);
    }
}

-(void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
    [alert show];
}

-(void)stopVideoRecord
{
    [[TXUGCRecord shareInstance] stopRecord];
    [self resetVideoUI];
}

-(void)resetVideoUI
{
    [_progressView deleteAllPart];
    [_btnStartRecord setImage:[UIImage imageNamed:@"start_record"] forState:UIControlStateNormal];
    [_btnStartRecord setBackgroundImage:[UIImage imageNamed:@"start_ring"] forState:UIControlStateNormal];
    _btnStartRecord.bounds = CGRectMake(0, 0, BUTTON_RECORD_SIZE, BUTTON_RECORD_SIZE);
    
    [self resetSpeedBtn];
    [_musicView resetUI];
    
    _btnRatio169.enabled = YES;
    _btnRatio43.enabled = YES;
    _btnRatio11.enabled = YES;
    _btnMusic.enabled = YES;
    _isPaused = NO;
    _videoRecording = NO;
}

-(void)resetSpeedBtn{
    [self setSpeedBtnHidden:NO];
    for(UIButton *btn in _speedBtnList){
        if (btn.tag == 2) {
            [self onBtnSpeedClicked:btn];
        }
    }
}

-(void)onBtnCameraClicked
{
    _cameraFront = !_cameraFront;
    [[TXUGCRecord shareInstance] switchCamera:_cameraFront];
    if (_cameraFront) {
        [_btnFlash setImage:[UIImage imageNamed:@"openFlash_disable"] forState:UIControlStateNormal];
        _btnFlash.enabled = NO;
    }else{
        if (_isFlash) {
            [_btnFlash setImage:[UIImage imageNamed:@"openFlash"] forState:UIControlStateNormal];
            [_btnFlash setImage:[UIImage imageNamed:@"openFlash_hover"] forState:UIControlStateHighlighted];
        }else{
            [_btnFlash setImage:[UIImage imageNamed:@"closeFlash"] forState:UIControlStateNormal];
            [_btnFlash setImage:[UIImage imageNamed:@"closeFlash_hover"] forState:UIControlStateHighlighted];
        }
        _btnFlash.enabled = YES;
    }
    [[TXUGCRecord shareInstance] toggleTorch:_isFlash];
}

-(void)onBtnBeautyClicked
{
    _vBeauty.hidden = !_vBeauty.hidden;
    _musicView.hidden = YES;
    [self hideBottomView:!_vBeauty.hidden];
}

- (void)hideBottomView:(BOOL)bHide
{
    for (UIButton *btn in _speedBtnList) {
        if (_videoRecording && !_isPaused) {
            btn.hidden = YES;
        }else{
            btn.hidden = bHide;
        }
    }
    _btnFlash.hidden = bHide;
    _btnCamera.hidden = bHide;
    _btnStartRecord.hidden = bHide;
    _btnDelete.hidden = bHide;
    _btnDone.hidden = bHide;
    _progressView.hidden = bHide;
    _recordTimeLabel.hidden = bHide;
    _mask_buttom.hidden = bHide;
    _systemVideoBtn.hidden = bHide;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint _touchPoint = [touch locationInView:self.view];
    if (!_vBeauty.hidden) {
        if (NO == CGRectContainsPoint(_vBeauty.frame, _touchPoint))
        {
            [self onBtnBeautyClicked];
        }
    }
    
    if (!_musicView.hidden) {
        if (NO == CGRectContainsPoint(_musicView.frame, _touchPoint))
        {
            [self onBtnMusicClicked];
        }
    }
}

#pragma mark - VideoRecordMusicViewDelegate
-(void)onBtnMusicSelected
{
//    MPMediaPickerController *mpc = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
//    mpc.delegate = self;
//    mpc.editing = YES;
//    mpc.allowsPickingMultipleItems = NO;
//    [self presentViewController:mpc animated:YES completion:nil];
    musicView *music = [[musicView alloc]init];
    [self presentViewController:music animated:YES completion:nil];
    
    [self onBtnMusicClicked];
}

-(void)onBtnMusicStoped
{
    _BGMPath = nil;
    _bgmRecording = NO;
    [[TXUGCRecord shareInstance] stopBGM];
    if (!_musicView.hidden) {
        [self onBtnMusicClicked];
    }
}

-(void)onBGMValueChange:(UISlider *)slider
{
    [[TXUGCRecord shareInstance] setBGMVolume:slider.value];
}

-(void)onVoiceValueChange:(UISlider *)slider
{
    [[TXUGCRecord shareInstance] setMicVolume:slider.value];
}

-(void)onBGMPlayBeginChange
{
    _receiveBGMProgress = NO;
}

-(void)onBGMPlayChange:(UISlider *)slider
{
    [self playBGM:slider.value];
    _receiveBGMProgress = YES;
}

#pragma mark - MPMediaPickerControllerDelegate
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    _hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hub.label.text = @"音频读取中...";
    
    NSArray *items = mediaItemCollection.items;
    MPMediaItem *songItem = [items objectAtIndex:0];
    
    NSURL *url = [songItem valueForProperty:MPMediaItemPropertyAssetURL];
    NSString* songName = [songItem valueForProperty: MPMediaItemPropertyTitle];
    NSString* authorName = [songItem valueForProperty:MPMediaItemPropertyArtist];
    NSNumber* duration = [songItem valueForKey:MPMediaItemPropertyPlaybackDuration];
    NSLog(@"MPMediaItemPropertyAssetURL = %@", url);
    
    RecordMusicInfo* musicInfo = [RecordMusicInfo new];
    musicInfo.duration = duration.floatValue;
    musicInfo.soneName = songName;
    musicInfo.singerName = authorName;
    
    if (mediaPicker.editing) {
        mediaPicker.editing = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveAssetURLToFile:musicInfo assetURL:url];
        });
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//选择网络音乐
-(void)changeMusic:(NSNotification *)notifition{
    NSDictionary *dic = [notifition userInfo];
    NSString *muaicPath = [dic valueForKey:@"music"];
    NSFileManager *managers=[NSFileManager defaultManager];
    NSArray *subArray = [muaicPath componentsSeparatedByString:@"*"];
    NSString *songName = [subArray objectAtIndex:1];
    NSString *name = [subArray objectAtIndex:2];
    NSArray *nameArray = [name componentsSeparatedByString:@"."];
    name = [nameArray objectAtIndex:0];
    RecordMusicInfo* musicInfo = [RecordMusicInfo new];
    NSURL *url = [NSURL fileURLWithPath:muaicPath];
    AVURLAsset *musicAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    musicInfo.duration = musicAsset.duration.value / musicAsset.duration.timescale;
    musicInfo.filePath = muaicPath;
    musicInfo.soneName = songName;
    musicInfo.singerName = name;
    if ([managers fileExistsAtPath:muaicPath]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveAssetURLToFile:musicInfo assetURL:url];
        });
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//点击取消时回调
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 将AssetURL(音乐)导出到app的文件夹并播放
- (void)saveAssetURLToFile:(RecordMusicInfo*)musicInfo assetURL:(NSURL*)assetURL
{
    [self onSetBGM:musicInfo.filePath];

//    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
//
//    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:songAsset presetName:AVAssetExportPresetAppleM4A];
//    NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
//    exporter.outputFileType = @"com.apple.m4a-audio";
//
//    [AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset];
//    NSString *docDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"LocalMusics/"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath:docDir]) {
//        [fileManager createDirectoryAtPath:docDir withIntermediateDirectories:NO attributes:nil error:nil];
//    }
//    //    NSString *exportFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.m4a", musicInfo.soneName, musicInfo.singerName]];
//    NSString *exportFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.m4a", musicInfo.soneName, musicInfo.singerName]];
//
//    exporter.outputURL = [NSURL fileURLWithPath:exportFilePath];
//    musicInfo.filePath = exportFilePath;
//
//    if ([[NSFileManager defaultManager] fileExistsAtPath:exportFilePath]) {
//        [self onSetBGM:musicInfo.filePath];
//        return;
//    }
//
//
//    // do the export
//    __weak __typeof(self) weakSelf = self;
//    [exporter exportAsynchronouslyWithCompletionHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        });
//        int exportStatus = exporter.status;
//        switch (exportStatus) {
//            case AVAssetExportSessionStatusFailed: {
//                NSLog (@"AVAssetExportSessionStatusFailed: %@", exporter.error);
//                break;
//
//            }
//            case AVAssetExportSessionStatusCompleted: {
//                NSLog(@"AVAssetExportSessionStatusCompleted: %@", exporter.outputURL);
//
//                // 播放背景音乐
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf onSetBGM:musicInfo.filePath];
//                });
//                break;
//            }
//            case AVAssetExportSessionStatusUnknown: { NSLog (@"AVAssetExportSessionStatusUnknown"); break;}
//            case AVAssetExportSessionStatusExporting: { NSLog (@"AVAssetExportSessionStatusExporting"); break;}
//            case AVAssetExportSessionStatusCancelled: { NSLog (@"AVAssetExportSessionStatusCancelled"); break;}
//            case AVAssetExportSessionStatusWaiting: { NSLog (@"AVAssetExportSessionStatusWaiting"); break;}
//            default: { NSLog (@"didn't get export status"); break;}
//        }
//    }];
}

-(void)onSetBGM:(NSString *)path
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    _BGMPath = path;
    _BGMDuration =  [[TXUGCRecord shareInstance] setBGM:_BGMPath];
    [_musicView setBGMDuration:_BGMDuration];
    
    //试听音乐这里要把RecordSpeed 设置为VIDEO_RECORD_SPEED_NOMAL，否则音乐可能会出现加速或则慢速播现象
    [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_NOMAL];
    
    _bgmRecording = NO;
    [self playBGM:0];
}

-(void)playBGM:(CGFloat)beginTime{
    if (_BGMPath != nil) {
        [[TXUGCRecord shareInstance] playBGMFromTime:beginTime toTime:_BGMDuration withBeginNotify:^(NSInteger errCode) {
            
        } withProgressNotify:^(NSInteger progressMS, NSInteger durationMS) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_receiveBGMProgress) {
                    [_musicView setBGMPlayTime:progressMS / 1000.0];
                }
            });
        } andCompleteNotify:^(NSInteger errCode) {
            
        }];
        _bgmBeginTime = beginTime;
    }
}

-(void)pauseBGM{
    if (_BGMPath != nil) {
        [[TXUGCRecord shareInstance] pauseBGM];
    }
}

- (void)resumeBGM
{
    if (_BGMPath != nil) {
        [[TXUGCRecord shareInstance] resumeBGM];
    }
}

#pragma mark - BeautyLoadPituDelegate
- (void)onLoadPituStart
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hub.mode = MBProgressHUDModeText;
        _hub.label.text = @"开始加载资源";
    });
}
- (void)onLoadPituProgress:(CGFloat)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _hub.label.text = [NSString stringWithFormat:@"正在加载资源%d %%",(int)(progress * 100)];
    });
}
- (void)onLoadPituFinished
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _hub.label.text = @"资源加载成功";
        [_hub hideAnimated:YES afterDelay:1];
    });
}
- (void)onLoadPituFailed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _hub.label.text = @"资源加载失败";
        [_hub hideAnimated:YES afterDelay:1];
    });
}

#pragma mark - BeautySettingPanelDelegate
- (void)onSetBeautyStyle:(int)beautyStyle beautyLevel:(float)beautyLevel whitenessLevel:(float)whitenessLevel ruddinessLevel:(float)ruddinessLevel{
    [[TXUGCRecord shareInstance] setBeautyStyle:beautyStyle beautyLevel:beautyLevel whitenessLevel:whitenessLevel ruddinessLevel:ruddinessLevel];
}

- (void)onSetEyeScaleLevel:(float)eyeScaleLevel
{
    [[TXUGCRecord shareInstance] setEyeScaleLevel:eyeScaleLevel];
}

- (void)onSetFaceScaleLevel:(float)faceScaleLevel
{
    [[TXUGCRecord shareInstance] setFaceScaleLevel:faceScaleLevel];
}

- (void)onSetFilter:(UIImage*)filterImage
{
    [[TXUGCRecord shareInstance] setFilter:filterImage];
}

- (void)onSetGreenScreenFile:(NSURL *)file
{
    [[TXUGCRecord shareInstance] setGreenScreenFile:file];
}

- (void)onSelectMotionTmpl:(NSString *)tmplName inDir:(NSString *)tmplDir
{
    [[TXUGCRecord shareInstance] selectMotionTmpl:tmplName inDir:tmplDir];
}

- (void)onSetFaceVLevel:(float)faceVLevel{
    [[TXUGCRecord shareInstance] setFaceVLevel:faceVLevel];
}

- (void)onSetChinLevel:(float)chinLevel{
    [[TXUGCRecord shareInstance] setChinLevel:chinLevel];
}

- (void)onSetNoseSlimLevel:(float)slimLevel{
    [[TXUGCRecord shareInstance] setNoseSlimLevel:slimLevel];
}

- (void)onSetFaceShortLevel:(float)faceShortlevel{
    [[TXUGCRecord shareInstance] setFaceShortLevel:faceShortlevel];
}

- (void)onSetMixLevel:(float)mixLevel{
    [[TXUGCRecord shareInstance] setSpecialRatio:mixLevel / 10.0];
}

#pragma mark ---- Video Beauty UI ----
-(void)initBeautyUI
{
    NSUInteger controlHeight = [BeautySettingPanel getHeight];
    _vBeauty = [[BeautySettingPanel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - controlHeight, self.view.frame.size.width, controlHeight)];
    _vBeauty.hidden = YES;
    _vBeauty.delegate = self;
    _vBeauty.pituDelegate = self;
    [self.view addSubview:_vBeauty];
}

-(void)refreshRecordTime:(float)second
{
    _currentRecordTime = second;
    [_progressView update:_currentRecordTime / MAX_RECORD_TIME];
    NSInteger min = (int)_currentRecordTime / 60;
    NSInteger sec = (int)_currentRecordTime % 60;
    
    [_recordTimeLabel setText:[NSString stringWithFormat:@"%02ld:%02ld", min, sec]];
    [_recordTimeLabel sizeToFit];
}

#pragma mark ---- VideoRecordListener ----
-(void) onRecordProgress:(NSInteger)milliSecond;
{
    [self refreshRecordTime: milliSecond / 1000.0];
    
    if (milliSecond / 1000 >= MIN_RECORD_TIME) {
        [_btnDone setImage:[UIImage imageNamed:@"confirm"] forState:UIControlStateNormal];
        [_btnDone setImage:[UIImage imageNamed:@"confirm_hover"] forState:UIControlStateHighlighted];
        _btnDone.enabled = YES;
    }else{
        [_btnDone setImage:[UIImage imageNamed:@"confirm_disable"] forState:UIControlStateNormal];
        _btnDone.enabled = NO;
    }
    if(0 == milliSecond / 1000.0){
        _btnRatio169.enabled = YES;
        _btnRatio43.enabled = YES;
        _btnRatio11.enabled = YES;
        _btnMusic.enabled = YES;
    }else{
        _btnRatio169.enabled = NO;
        _btnRatio43.enabled = NO;
        _btnRatio11.enabled = NO;
        _btnMusic.enabled = NO;
    }
    
//    if (milliSecond / 1000 > 10) {
//        [[TXUGCRecord shareInstance] stopRecord];
//    }
}

-(void) onRecordComplete:(TXUGCRecordResult*)result;
{
    if (_appForeground)
    {
        if (result.retCode == UGC_RECORD_RESULT_OK) {
            VideoEditViewController *vc = [[VideoEditViewController alloc] init];
            [vc setVideoPath:result.videoPath];
//            VideoPreviewViewController* vc = [[VideoPreviewViewController alloc]
//                                              initWithCoverImage:result.coverImage
//                                              videoPath:result.videoPath
//                                              renderMode:_aspectRatio == VIDEO_ASPECT_RATIO_9_16 ? RENDER_MODE_FILL_SCREEN : RENDER_MODE_FILL_EDGE
//                                              isFromRecord:YES];
//
//            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
//            [self presentViewController:nav animated:YES completion:nil];
            [self.navigationController pushViewController:vc animated:YES];
            [self stopCameraPreview];
        }
        else if(result.retCode == UGC_RECORD_RESULT_OK_BEYOND_MAXDURATION){
            VideoEditViewController *vc = [[VideoEditViewController alloc] init];
            [vc setVideoPath:result.videoPath];
//            VideoPreviewViewController* vc = [[VideoPreviewViewController alloc]
//                                              initWithCoverImage:result.coverImage
//                                              videoPath:result.videoPath
//                                              renderMode:_aspectRatio == VIDEO_ASPECT_RATIO_9_16 ? RENDER_MODE_FILL_SCREEN : RENDER_MODE_FILL_EDGE
//                                              isFromRecord:YES];
//            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
//            [self presentViewController:nav animated:YES completion:nil];
            [self.navigationController pushViewController:vc animated:YES];

            [self stopCameraPreview];
            [self resetVideoUI];
        }
        else if(result.retCode == UGC_RECORD_RESULT_OK_INTERRUPT){
            [self toastTip:YZMsg(@"录制被打断")];
        }
        else if(result.retCode == UGC_RECORD_RESULT_OK_UNREACH_MINDURATION){
            [self toastTip:YZMsg(@"至少要录够5秒")];
        }
        else if(result.retCode == UGC_RECORD_RESULT_FAILED){
            [self toastTip:YZMsg(@"视频录制失败")];
        }
    }
    [[TXUGCRecord shareInstance].partsManager deleteAllParts];
    [self refreshRecordTime:0];
}

#pragma mark - Misc Methods

- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (void) toastTip:(NSString*)toastInfo
{
    CGRect frameRC = [[UIScreen mainScreen] bounds];
    frameRC.origin.y = frameRC.size.height - 100;
    frameRC.size.height -= 100;
    __block UITextView * toastView = [[UITextView alloc] init];
    
    toastView.editable = NO;
    toastView.selectable = NO;
    
    frameRC.size.height = [self heightForString:toastView andWidth:frameRC.size.width];
    
    toastView.frame = frameRC;
    
    toastView.text = toastInfo;
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.alpha = 0.5;
    
    [self.view addSubview:toastView];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(){
        [toastView removeFromSuperview];
        toastView = nil;
    });
}

#pragma mark - TXVideoCustomProcessDelegate
- (GLuint)onPreProcessTexture:(GLuint)texture width:(CGFloat)width height:(CGFloat)height
{
    static int i = 0;
    if (i++ % 100 == 0) {
        NSLog(@"onPreProcessTexture width:%f height:%f", width, height);
    }
    
    return texture;
}

- (void)onTextureDestoryed
{
    NSLog(@"onTextureDestoryed");
}

- (void)onDetectFacePoints:(NSArray *)points
{
    static int i = 0;
    if (i++ % 100 == 0) {
        NSLog(@"onDetectFacePoints.count:%lu", points.count);
    }
}
//本地视频
-(void)onBtnLocalVideoClicked{
    
    
    _systemVideoBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _systemVideoBtn.userInteractionEnabled = YES;
    });
    
    
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.assetCollectionSubtypes = @[
                                                      @(PHAssetCollectionSubtypeSmartAlbumUserLibrary), //相机胶卷
                                                      @(PHAssetCollectionSubtypeAlbumMyPhotoStream), //我的照片流
                                                      @(PHAssetCollectionSubtypeSmartAlbumPanoramas), //全景图
                                                      @(PHAssetCollectionSubtypeSmartAlbumVideos), //视频
                                                      @(PHAssetCollectionSubtypeSmartAlbumBursts) //连拍模式拍摄的照片
                                                      ];
    imagePickerController.mediaType = QBImagePickerMediaTypeVideo;
//    imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    [self presentViewController:imagePickerController animated:YES completion:nil];
//    [self.navigationController pushViewController:imagePickerController animated:YES];
}
#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    [MBProgressHUD showMessage:YZMsg(@"视频转码中")];

    PHAsset *expAsset = assets[0];
    PHVideoRequestOptions *options = [PHVideoRequestOptions new];
    // 最高质量的视频
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
    // 可从iCloud中获取图片
    options.networkAccessAllowed = YES;
    // 如果是iCloud的视频，可以获取到下载进度
    options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
//        [weakSelf loadingCloudVideoProgress:progress];
//        *stop = _loadingIsInterrupt;
    };
    [[PHImageManager defaultManager] requestAVAssetForVideo:expAsset options:options resultHandler:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        //SDK内部通过avAsset 读取视频数据，会极大的降低视频loading时间
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (avAsset) {
                [MBProgressHUD hideHUD];

                VideoEditViewController *vc = [VideoEditViewController new];
                //vc.videoPath = _localPaths[0];
                vc.videoAsset = avAsset;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:YZMsg(@"转码失败")];

            }
        });
    }];
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loadvc];
//    [self presentViewController:nav animated:YES completion:nil];
//    [loadvc exportAssetList:assets];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"imagePicker Canceled.");
    
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark ================ imagePickerDelegate ===============
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.movie"])
    {
        //先把图片转成NSData
        NSString *url = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        if (url) {
            [self zhuanma:url];
        }else{
            [MBProgressHUD showError:@"请重新选择视频"];
            return;
        }
    }
}
-(void)zhuanma:(NSString *)videlPathsss{
    [MBProgressHUD showMessage:@"视频转码中"];
    //转码
    //获取缩略图
    videobackImage = [self getVideoPreViewImageWithPath:[NSURL fileURLWithPath:videlPathsss]];
    // 视频转码
    NSInteger random = arc4random()%10000;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videlPathsss] options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPreset1280x720];
    exportPath = [NSString stringWithFormat:@"%@/%ld.mp4",
                  [NSHomeDirectory() stringByAppendingString:@"/tmp"],
                  random];
    exportSession.outputURL = [NSURL fileURLWithPath:exportPath];
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exportSession.status;
        switch (exportStatus) {
            case AVAssetExportSessionStatusFailed:
                dispatch_async(dispatch_get_main_queue(), ^{

                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"转码失败"];
                });
                NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export canceled");
                dispatch_async(dispatch_get_main_queue(), ^{

                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"转码失败"];
                });
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"转换成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    TXRecordResult *recordResult = [TXRecordResult new];
                    recordResult.coverImage = videobackImage;
                    recordResult.videoPath  = exportPath;
                    self.view.userInteractionEnabled = NO;
                    [self pushresult:recordResult];
                });
                break;
        }
    }];
}
-(void)pushresult:(TXRecordResult *)recordResult{
    [MBProgressHUD hideHUD];
    VideoEditViewController *vc = [[VideoEditViewController alloc] init];
    [vc setVideoPath:recordResult.videoPath];
    [self.navigationController pushViewController:vc animated:YES];
}
//需要导入AVFoundation.h
- (UIImage*) getVideoPreViewImageWithPath:(NSURL *)videoPath
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time   = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error  = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img   = [[UIImage alloc] initWithCGImage:image];
    return img;
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.frame.size.width < 42) {
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}

@end
