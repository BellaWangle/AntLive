//
//  VideoEditViewController.m
//  TCLVBIMDemo
//
//  Created by xiang zhang on 2017/4/10.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "VideoEditViewController.h"
#import "TXVideoEditer.h"
#import <MediaPlayer/MPMediaPickerController.h>
#import "VideoPreview.h"
#import "VideoRangeSlider.h"
#import "VideoRangeConst.h"
//#import "TCVideoPublishController.h"
#import "VideoPreviewViewController.h"
#import "UIView+Additions.h"
#import "ColorMacro.h"
#import "MBProgressHUD.h"
#import "FilterSettingView.h"
#import "BottomTabBar.h"
#import "VideoCutView.h"
#import "MusicMixView.h"
#import "PasterAddView.h"
#import "TextAddView.h"
#import "TimeSelectView.h"
#import "EffectSelectView.h"
//#import "MusicCollectionViewController.h"
#import "VideoTextViewController.h"
#import "VideoPasterViewController.h"
#import "musicView.h"
#import "TCVideoPublishController.h"
typedef  NS_ENUM(NSInteger,ActionType)
{
    ActionType_Save,
    ActionType_Publish,
    ActionType_Save_Publish,
};

typedef  NS_ENUM(NSInteger,TimeType)
{
    TimeType_Clear,
    TimeType_Back,
    TimeType_Repeat,
    TimeType_Speed,
};

@interface VideoEditViewController ()<TXVideoGenerateListener,VideoPreviewDelegate, FilterSettingViewDelegate, BottomTabBarDelegate, VideoCutViewDelegate, MusicMixViewDelegate, PasterAddViewDelegate, TextAddViewDelegate, VideoPasterViewControllerDelegate, VideoTextViewControllerDelegate,VideoEffectViewDelegate,TimeSelectViewDelegate,MPMediaPickerControllerDelegate, UIActionSheetDelegate, UITabBarDelegate>

@end

@implementation VideoEditViewController
{
    TXVideoEditer*   _ugcEdit;        //sdk编辑器
    VideoPreview*    _videoPreview;   //视频预览
    
    //裁剪时间
    CGFloat         _leftTime;
    CGFloat         _rightTime;
    
    NSMutableArray  *_cutPathList;
    NSString        *_videoOutputPath;
    ActionType      _actionType;
    
    //生成时的进度浮层
    UILabel*        _generationTitleLabel;
    UIView*         _generationView;
    UIProgressView* _generateProgressView;
    UIButton*       _generateCannelBtn;
    
    UILabel*        _cutTipsLabel;
    UIColor*        _barTintColor;
    
    BottomTabBar*       _bottomBar;     //底部栏
    VideoCutView*       _videoCutView;  //裁剪
    FilterSettingView*  _filterView;    //滤镜
    MusicMixView*       _musixMixView;  //混音
    
    PasterAddView*      _pasterView;         //贴图
    TextAddView*        _textView;           //字幕
    TimeSelectView*     _timeSelectView;     //时间特效栏
    EffectSelectView*   _effectSelectView;   //动效选择
    
    int                 _effectType;
    TimeType            _timeType;
    
    NSMutableArray<VideoTextInfo*>*   _videoTextInfos;   //保存己添加的字幕
    NSMutableArray<VideoPasterInfo*>* _videoPaterInfos;  //保存己添加的贴纸
    NSString*     _filePath;
    
    BOOL  _isReverse;
    CGFloat _playTime;
}



-(instancetype)init
{
    self = [super init];
    if (self) {
        _cutPathList = [NSMutableArray array];
        _videoOutputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"outputCut.mp4"];
        _videoTextInfos = [NSMutableArray new];
        _videoPaterInfos = [NSMutableArray new];
        _effectType = -1;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeMusic:) name:@"changemusicaaaaa" object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _barTintColor =  self.navigationController.navigationBar.barTintColor;
    self.navigationController.navigationBar.barTintColor =  UIColorFromRGB(0x181818);
    self.navigationController.navigationBar.translucent  =  NO;
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor =  _barTintColor;
    self.navigationController.navigationBar.translucent  =  YES;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    [_videoCutView stopGetImageList];
}

- (void)dealloc
{
    [_videoPreview removeNotification];
    _videoPreview = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    if (_videoAsset == nil && _videoPath != nil) {
        NSURL *avUrl = [NSURL fileURLWithPath:_videoPath];
        _videoAsset = [AVAsset assetWithURL:avUrl];
    }
    
    UILabel *barTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 , 100, 44)];
    barTitleLabel.backgroundColor = [UIColor clearColor];
    barTitleLabel.font = [UIFont boldSystemFontOfSize:17];
    barTitleLabel.textColor = [UIColor whiteColor];
    barTitleLabel.textAlignment = NSTextAlignmentCenter;
    barTitleLabel.text = YZMsg(@"编辑视频");
    self.navigationItem.titleView = barTitleLabel;
    
    UIBarButtonItem *customBackButton = [[UIBarButtonItem alloc] initWithTitle:YZMsg(@"取消")
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = customBackButton;
    
    UIBarButtonItem *customSaveButton = [[UIBarButtonItem alloc] initWithTitle:YZMsg(@"保存")
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(goSave)];
    customBackButton.tintColor = [UIColor whiteColor];
    customSaveButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = customSaveButton;
    
    self.view.backgroundColor = UIColor.blackColor;
    
    _videoPreview = [[VideoPreview alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 350 * kScaleY) coverImage:nil];
    _videoPreview.delegate = self;
    [self.view addSubview:_videoPreview];
    
    
    TXVideoInfo *videoMsg = [TXVideoInfoReader getVideoInfoWithAsset:_videoAsset];
    CGFloat duration = videoMsg.duration;
    _rightTime = duration;
    
    _bottomBar = [[BottomTabBar alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - 50 * kScaleY, self.view.width, 50 * kScaleY)];
    _bottomBar.delegate = self;
    [self.view addSubview:_bottomBar];
    
    CGFloat selectViewHeight = [UIScreen mainScreen].bounds.size.height >= 667 ? 90 * kScaleY : 80 * kScaleY;
    _timeSelectView = [[TimeSelectView alloc] initWithFrame:CGRectMake(0, _bottomBar.top -  selectViewHeight, self.view.width, selectViewHeight)];
    _timeSelectView.delegate = self;
    
    _effectSelectView = [[EffectSelectView alloc] initWithFrame:_timeSelectView.frame];
    _effectSelectView.delegate = self;
    
    _cutTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _bottomBar.top -  100 * kScaleY, self.view.width, 90 * kScaleY)];
    _cutTipsLabel.textAlignment = NSTextAlignmentCenter;
    _cutTipsLabel.text = YZMsg(@"请拖拽两侧滑块选择裁剪区域");
    _cutTipsLabel.textColor = [UIColor whiteColor];
    _cutTipsLabel.font = [UIFont systemFontOfSize:16];
    [_cutTipsLabel setAdjustsFontSizeToFitWidth:YES];
    [self.view addSubview:_cutTipsLabel];

    _videoCutView = [[VideoCutView alloc] initWithFrame:CGRectMake(0, _videoPreview.bottom, self.view.width, _timeSelectView.y - _videoPreview.bottom) videoPath:_videoPath videoAssert:_videoAsset];
    _videoCutView.delegate = self;
    [_videoCutView setCenterPanHidden:YES];
    [self.view addSubview:_videoCutView];

    
    _filterView = [[FilterSettingView alloc] initWithFrame:CGRectMake(0, _videoPreview.bottom + 10 * kScaleY, self.view.width, _bottomBar.y - _videoPreview.bottom - 10 * kScaleY)];
    _filterView.delegate = self;
    
    _musixMixView = [[MusicMixView alloc] initWithFrame:CGRectMake(0, _videoPreview.bottom + 10 * kScaleY, self.view.width, _bottomBar.y - _videoPreview.bottom - 10 * kScaleY)];
    _musixMixView.delegate = self;
    
    _pasterView = [[PasterAddView alloc] initWithFrame:CGRectMake(0, _videoPreview.bottom + 30 * kScaleY, self.view.width, _bottomBar.y - _videoPreview.bottom - 30 * kScaleY)];
    _pasterView.delegate = self;
    
    _textView = [[TextAddView alloc] initWithFrame:CGRectMake(0, _videoPreview.bottom + 30 * kScaleY, self.view.width, _bottomBar.y - _videoPreview.bottom - 30 * kScaleY)];
    _textView.delegate = self;
    
    TXPreviewParam *param = [[TXPreviewParam alloc] init];
    param.videoView = _videoPreview.renderView;
    param.renderMode = PREVIEW_RENDER_MODE_FILL_EDGE;
    _ugcEdit = [[TXVideoEditer alloc] initWithPreview:param];
    _ugcEdit.generateDelegate = self;
    _ugcEdit.previewDelegate = _videoPreview;
    
    //[_ugcEdit setVideoPath:_videoPath];
    [_ugcEdit setVideoAsset:_videoAsset];
    
//    UIImage *waterimage = [UIImage imageNamed:@"watermark"];
//    [_ugcEdit setWaterMark:waterimage normalizationFrame:CGRectMake(0.01, 0.01, 0.3 , 0)];
    
//    UIImage *tailWaterimage = [UIImage imageNamed:@"tcloud_logo"];
//    float w = 0.15;
//    float x = (1.0 - w) / 2.0;
//    float width = w * videoMsg.width;
//    float height = width * tailWaterimage.size.height / tailWaterimage.size.width;
//    float y = (videoMsg.height - height) / 2 / videoMsg.height;
//    [_ugcEdit setTailWaterMark:tailWaterimage normalizationFrame:CGRectMake(x,y,w,0) duration:2];
}

- (UIView*)generatingView
{
    /*用作生成时的提示浮层*/
    if (!_generationView) {
        _generationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height + 64)];
        _generationView.backgroundColor = UIColor.blackColor;
        _generationView.alpha = 0.9f;
        
        _generateProgressView = [UIProgressView new];
        _generateProgressView.center = CGPointMake(_generationView.width / 2, _generationView.height / 2);
        _generateProgressView.bounds = CGRectMake(0, 0, 225, 20);
        _generateProgressView.progressTintColor = UIColorFromRGB(0x0accac);
        [_generateProgressView setTrackImage:[UIImage imageNamed:@"slide_bar_small"]];
        //_generateProgressView.trackTintColor = UIColor.whiteColor;
        //_generateProgressView.transform = CGAffineTransformMakeScale(1.0, 2.0);
        
        _generationTitleLabel = [UILabel new];
        _generationTitleLabel.font = [UIFont systemFontOfSize:14];
        _generationTitleLabel.text = YZMsg(@"视频生成中");
        _generationTitleLabel.textColor = UIColor.whiteColor;
        _generationTitleLabel.textAlignment = NSTextAlignmentCenter;
        _generationTitleLabel.frame = CGRectMake(0, _generateProgressView.y - 34, _generationView.width, 14);
        
        _generateCannelBtn = [UIButton new];
        [_generateCannelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        _generateCannelBtn.frame = CGRectMake(_generateProgressView.right + 15, _generationTitleLabel.bottom + 10, 20, 20);
        [_generateCannelBtn addTarget:self action:@selector(onGenerateCancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_generationView addSubview:_generationTitleLabel];
        [_generationView addSubview:_generateProgressView];
        [_generationView addSubview:_generateCannelBtn];
        [[[UIApplication sharedApplication] delegate].window addSubview:_generationView];
    }
    
    _generateProgressView.progress = 0.f;
    return _generationView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_videoPreview.isPlaying) {
        [_videoPreview playVideo];
    }
}

- (void)goBack
{
    [self pause];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//保存
- (void)goSave
{
    [self pause];
    
    _actionType = ActionType_Save;
    
    
    //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.label.text = @"视频生成中...";
    //    _isGenerating = YES;
    _generationView = [self generatingView];
    _generationView.hidden = NO;
    
    [_ugcEdit setCutFromTime:_leftTime toTime:_rightTime];
    [self checkVideoOutputPath];
    
    [_ugcEdit generateVideo:VIDEO_COMPRESSED_720P videoOutputPath:_videoOutputPath];
    
    [self onVideoPause];
    [_videoPreview setPlayBtn:NO];
    
}

- (void)onGenerateCancelBtnClicked:(UIButton*)sender
{
    _generationView.hidden = YES;
    [_ugcEdit cancelGenerate];
}

- (void)pause
{
    [_ugcEdit pausePlay];
    [_videoPreview setPlayBtn:NO];
}

- (void)checkVideoOutputPath
{
    NSFileManager *manager = [[NSFileManager alloc] init];
    if ([manager fileExistsAtPath:_videoOutputPath]) {
        BOOL success =  [manager removeItemAtPath:_videoOutputPath error:nil];
        if (success) {
            NSLog(@"Already exist. Removed!");
        }
    }
}

#pragma mark FilterSettingViewDelegate
//设滤镜效果
- (void)onSetFilterWithImage:(UIImage *)image
{
    [_ugcEdit setFilter:image];
}

#pragma mark - BottomTabBarDelegate
- (void)onCutBtnClicked
{
    //    [self pause];
    [_filterView removeFromSuperview];
    [_musixMixView removeFromSuperview];
    [_pasterView removeFromSuperview];
    [_textView removeFromSuperview];
    [_timeSelectView removeFromSuperview];
    [_effectSelectView removeFromSuperview];

    [self.view addSubview:_videoCutView];
    [self.view addSubview:_cutTipsLabel];
    [_videoCutView setEffectDeleteBtnHidden:YES];
}

-(void)onTimeBtnClicked
{
    [_filterView removeFromSuperview];
    [_musixMixView removeFromSuperview];
    [_pasterView removeFromSuperview];
    [_textView removeFromSuperview];
    [_effectSelectView removeFromSuperview];
    [_cutTipsLabel removeFromSuperview];

    [self.view addSubview:_videoCutView];
    [self.view addSubview:_timeSelectView];
    [_videoCutView setEffectDeleteBtnHidden:YES];
}

- (void)onEffectBtnClicked
{
    [_filterView removeFromSuperview];
    [_musixMixView removeFromSuperview];
    [_pasterView removeFromSuperview];
    [_textView removeFromSuperview];
    [_timeSelectView removeFromSuperview];
    [_cutTipsLabel removeFromSuperview];
    
    [self.view addSubview:_videoCutView];
    [self.view addSubview:_effectSelectView];
    [_videoCutView setEffectDeleteBtnHidden:NO];
}


- (void)onFilterBtnClicked
{
    //    [self pause];
    [_videoCutView removeFromSuperview];
    [_musixMixView removeFromSuperview];
    [_pasterView removeFromSuperview];
    [_textView removeFromSuperview];
    [_timeSelectView removeFromSuperview];
    [_effectSelectView removeFromSuperview];
    [_cutTipsLabel removeFromSuperview];
    
    [self.view addSubview:_filterView];
    _videoCutView.videoRangeSlider.hidden = NO;
}

- (void)onMusicBtnClicked
{
    //    [self pause];
    [_filterView removeFromSuperview];
    [_videoCutView removeFromSuperview];
    [_pasterView removeFromSuperview];
    [_textView removeFromSuperview];
    [_timeSelectView removeFromSuperview];
    [_effectSelectView removeFromSuperview];
    [_cutTipsLabel removeFromSuperview];
    
    [self.view addSubview:_musixMixView];
    _videoCutView.videoRangeSlider.hidden = NO;
}

- (void)onPasterBtnClicked
{
    //    [self pause];
    [_filterView removeFromSuperview];
    [_videoCutView removeFromSuperview];
    [_musixMixView removeFromSuperview];
    [_textView removeFromSuperview];
    [_timeSelectView removeFromSuperview];
    [_effectSelectView removeFromSuperview];
    [_cutTipsLabel removeFromSuperview];
    
    [self.view addSubview:_pasterView];
    _videoCutView.videoRangeSlider.hidden = NO;
}

- (void)onTextBtnClicked
{
    //    [self pause];
    [_filterView removeFromSuperview];
    [_videoCutView removeFromSuperview];
    [_musixMixView removeFromSuperview];
    [_pasterView removeFromSuperview];
    [_timeSelectView removeFromSuperview];
    [_effectSelectView removeFromSuperview];
    [_cutTipsLabel removeFromSuperview];
    
    [self.view addSubview:_textView];
    _videoCutView.videoRangeSlider.hidden = NO;
}

#pragma mark VideoEffectViewDelegate
- (void)onVideoEffectBeginClick:(TXEffectType)effectType
{
    _effectType = effectType;
    switch ((TXEffectType)_effectType) {
        case TXEffectType_ROCK_LIGHT:
            [_videoCutView startColoration:UIColorFromRGB(0xEC5F9B) alpha:0.7];
            break;
        case TXEffectType_DARK_DRAEM:
            [_videoCutView startColoration:UIColorFromRGB(0xEC8435) alpha:0.7];
            break;
        case TXEffectType_SOUL_OUT:
            [_videoCutView startColoration:UIColorFromRGB(0x1FBCB6) alpha:0.7];
            break;
        case TXEffectType_SCREEN_SPLIT:
            [_videoCutView startColoration:UIColorFromRGB(0x449FF3) alpha:0.7];
            break;
        default:
            break;
    }
    [_ugcEdit startEffect:(TXEffectType)_effectType startTime:_playTime];
    if (!_isReverse) {
        [_ugcEdit startPlayFromTime:_videoCutView.videoRangeSlider.currentPos toTime:_videoCutView.videoRangeSlider.rightPos];
    }else{
        [_ugcEdit startPlayFromTime:_videoCutView.videoRangeSlider.leftPos toTime:_videoCutView.videoRangeSlider.currentPos];
    }
    [_videoPreview setPlayBtn:YES];
}

- (void)onVideoEffectEndClick:(TXEffectType)effectType
{
    if (_effectType != -1) {
        [_videoPreview setPlayBtn:NO];
        [_videoCutView stopColoration];
        [_ugcEdit stopEffect:effectType endTime:_playTime];
        [_ugcEdit pausePlay];
        _effectType = -1;
    }
}

#pragma mark TimeSelectViewDelegate
- (void)onVideoTimeEffectsClear
{
    _timeType = TimeType_Clear;
    _isReverse = NO;
    [_ugcEdit setReverse:_isReverse];
    [_ugcEdit setRepeatPlay:nil];
    [_ugcEdit setSpeedList:nil];
    [_ugcEdit startPlayFromTime:_videoCutView.videoRangeSlider.leftPos toTime:_videoCutView.videoRangeSlider.rightPos];
    
    [_videoPreview setPlayBtn:YES];
    [_videoCutView setCenterPanHidden:YES];
}
- (void)onVideoTimeEffectsBackPlay
{
    _timeType = TimeType_Back;
    _isReverse = YES;
    [_ugcEdit setReverse:_isReverse];
    [_ugcEdit setRepeatPlay:nil];
    [_ugcEdit setSpeedList:nil];
    [_ugcEdit startPlayFromTime:_videoCutView.videoRangeSlider.leftPos toTime:_videoCutView.videoRangeSlider.rightPos];
    
    [_videoPreview setPlayBtn:YES];
    [_videoCutView setCenterPanHidden:YES];
    _videoCutView.videoRangeSlider.hidden = NO;
}
- (void)onVideoTimeEffectsRepeat
{
    _timeType = TimeType_Repeat;
    _isReverse = NO;
    [_ugcEdit setReverse:_isReverse];
    [_ugcEdit setSpeedList:nil];
    TXRepeat *repeat = [[TXRepeat alloc] init];
    repeat.startTime = _leftTime + (_rightTime - _leftTime) / 5;
    repeat.endTime = repeat.startTime + 0.5;
    repeat.repeatTimes = 3;
    [_ugcEdit setRepeatPlay:@[repeat]];
    [_ugcEdit startPlayFromTime:_videoCutView.videoRangeSlider.leftPos toTime:_videoCutView.videoRangeSlider.rightPos];
    
    [_videoPreview setPlayBtn:YES];
    [_videoCutView setCenterPanHidden:NO];
    [_videoCutView setCenterPanFrame:repeat.startTime];
}

- (void)onVideoTimeEffectsSpeed
{
    _timeType = TimeType_Speed;
    _isReverse = NO;
    [_ugcEdit setReverse:_isReverse];
    [_ugcEdit setRepeatPlay:nil];
    TXSpeed *speed =[[TXSpeed alloc] init];
    speed.startTime = _leftTime + (_rightTime - _leftTime) * 1.5 / 5;
    speed.endTime = _videoCutView.videoRangeSlider.rightPos;
    speed.speedLevel = SPEED_LEVEL_SLOW;
    [_ugcEdit setSpeedList:@[speed]];
    [_ugcEdit startPlayFromTime:_videoCutView.videoRangeSlider.leftPos toTime:_videoCutView.videoRangeSlider.rightPos];
    
    [_videoPreview setPlayBtn:YES];
    [_videoCutView setCenterPanHidden:NO];
    [_videoCutView setCenterPanFrame:speed.startTime];
}

#pragma mark TXVideoGenerateListener
-(void) onGenerateProgress:(float)progress
{
    //    MBProgressHUD* hub = [MBProgressHUD HUDForView:self.view];
    //    hub.label.text = [NSString stringWithFormat:@"视频生成中:%.02f%%", progress * 100];
    //NSLog(@"progress === %f",progress);
    _generateProgressView.progress = progress;
}

-(void) onGenerateComplete:(TXGenerateResult *)result
{
    
    _generationView.hidden = YES;
    if (result.retCode == 0) {
        
//        TXVideoInfo *videoInfo = [TXVideoInfoReader getVideoInfo:_videoOutputPath];
//        VideoPreviewViewController* vc = [[VideoPreviewViewController alloc] initWithCoverImage:videoInfo.coverImage videoPath:_videoOutputPath renderMode:RENDER_MODE_FILL_EDGE isFromRecord:NO];
//        [self.navigationController pushViewController:vc animated:YES];
        TCVideoPublishController *vc = [[TCVideoPublishController alloc] initWithPath:_videoOutputPath
                                                                             videoMsg:[TXVideoInfoReader getVideoInfo:_videoOutputPath]];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"视频生成失败"
                                                            message:[NSString stringWithFormat:@"错误码：%ld 错误信息：%@",(long)result.retCode,result.descMsg]
                                                           delegate:self
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}


#pragma mark VideoPreviewDelegate
- (void)onVideoPlay
{
    CGFloat currentPos = _videoCutView.videoRangeSlider.currentPos;
    if (currentPos < _leftTime || currentPos > _rightTime)
        currentPos = _leftTime;
    
    if(_isReverse && currentPos != 0){
        [_ugcEdit startPlayFromTime:0 toTime:currentPos];
    }
    else if(_videoCutView.videoRangeSlider.rightPos != 0){
        [_ugcEdit startPlayFromTime:currentPos toTime:_videoCutView.videoRangeSlider.rightPos];
    }
    else{
        [_ugcEdit startPlayFromTime:currentPos toTime:_rightTime];
    }
}

- (void)onVideoPause
{
    [_ugcEdit pausePlay];
}

- (void)onVideoResume
{
//    [_ugcEdit resumePlay];
    [self onVideoPlay];
}

- (void)onVideoPlayProgress:(CGFloat)time
{
    _playTime = time;
    [_videoCutView setPlayTime:_playTime];
}

- (void)onVideoPlayFinished
{
    if (_effectType != -1) {
        [self onVideoEffectEndClick:_effectType];
    }else{
        [_ugcEdit startPlayFromTime:_leftTime toTime:_rightTime];
    }
}

- (void)onVideoEnterBackground
{
    [_ugcEdit pauseGenerate];
}

- (void)onVideoWillEnterForeground
{
    [_ugcEdit resumeGenerate];
}


#pragma mark - VideoCutViewDelegate
//裁剪
- (void)onVideoLeftCutChanged:(VideoRangeSlider *)sender
{
    //[_ugcEdit pausePlay];
    [_videoPreview setPlayBtn:NO];
    [_ugcEdit previewAtTime:sender.leftPos];
}

- (void)onVideoRightCutChanged:(VideoRangeSlider *)sender
{
    [_videoPreview setPlayBtn:NO];
    [_ugcEdit previewAtTime:sender.rightPos];
}

- (void)onVideoCutChangedEnd:(VideoRangeSlider *)sender
{
    _leftTime = sender.leftPos;
    _rightTime = sender.rightPos;
    [_ugcEdit startPlayFromTime:sender.leftPos toTime:sender.rightPos];
    [_videoPreview setPlayBtn:YES];
}

- (void)onVideoCenterRepeatChanged:(VideoRangeSlider*)sender
{
    [_videoPreview setPlayBtn:NO];
    [_ugcEdit previewAtTime:sender.centerPos];
}

- (void)onVideoCenterRepeatEnd:(VideoRangeSlider*)sender;
{
    _leftTime = sender.leftPos;
    _rightTime = sender.rightPos;
    
    if (_timeType == TimeType_Repeat) {
        TXRepeat *repeat = [[TXRepeat alloc] init];
        repeat.startTime = sender.centerPos;
        repeat.endTime = sender.centerPos + 0.5;
        repeat.repeatTimes = 3;
        [_ugcEdit setRepeatPlay:@[repeat]];
        [_ugcEdit setSpeedList:nil];
    }
    else if (_timeType == TimeType_Speed) {
        TXSpeed *speed = [[TXSpeed alloc] init];
        speed.startTime = sender.centerPos;
        speed.endTime = sender.rightPos;
        speed.speedLevel = SPEED_LEVEL_SLOW;
        [_ugcEdit setSpeedList:@[speed]];
        [_ugcEdit setRepeatPlay:nil];
    }
    
    if (_isReverse) {
        [_ugcEdit startPlayFromTime:sender.leftPos toTime:sender.centerPos + 1.5];
    }else{
        [_ugcEdit startPlayFromTime:sender.centerPos toTime:sender.rightPos];
    }
    [_videoPreview setPlayBtn:YES];
}

- (void)onVideoCutChange:(VideoRangeSlider *)sender seekToPos:(CGFloat)pos
{
    _playTime = pos;
    [_ugcEdit previewAtTime:_playTime];
    [_videoPreview setPlayBtn:NO];
}

//美颜
- (void)onSetBeautyDepth:(float)beautyDepth WhiteningDepth:(float)whiteningDepth
{
    [_ugcEdit setBeautyFilter:beautyDepth setWhiteningLevel:whiteningDepth];
}

- (void)onEffectDelete
{
    [_ugcEdit deleteLastEffect];
}

#pragma mark - TextAddViewDelegate
//打开字幕操作viewcontroller
- (void)onAddTextBtnClicked
{
    [_videoPreview removeFromSuperview];
    
    //己有添加字幕的话只操作本地裁剪时间内的
    NSMutableArray* inRangeVideoTexts = [NSMutableArray new];
    for (VideoTextInfo* info in _videoTextInfos) {
        if (info.startTime >= _rightTime || info.endTime <= _leftTime)
            continue;
        
        [inRangeVideoTexts addObject:info];
    }
    
    [_ugcEdit pausePlay];
    [_videoPreview setPlayBtn:NO];
    
    VideoTextViewController* vc = [[VideoTextViewController alloc] initWithVideoEditer:_ugcEdit previewView:_videoPreview startTime:_leftTime endTime:_rightTime videoTextInfos:inRangeVideoTexts];
    vc.delegate = self;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)onSetVideoPasterInfosFinish:(NSArray<VideoPasterInfo*>*)videoPasterInfos
{
    //更新贴纸信息
    [_videoPaterInfos removeAllObjects];
    [_videoPaterInfos addObjectsFromArray:videoPasterInfos];
    
    _videoPreview.frame = CGRectMake(0, 0, self.view.width, 350 * kScaleY);
    _videoPreview.delegate = self;
    [_videoPreview setPlayBtnHidden:NO];
    [self.view addSubview:_videoPreview];
    
    if (videoPasterInfos.count > 0) {
        [_textView setEdited:YES];
    }else {
        [_textView setEdited:NO];
    }
}

#pragma mark - VideoTextViewControllerDelegate
- (void)onSetVideoTextInfosFinish:(NSArray<VideoTextInfo *> *)videoTextInfos
{
    //更新文字信息
    //新增的
    for (VideoTextInfo* info in videoTextInfos) {
        if (![_videoTextInfos containsObject:info]) {
            [_videoTextInfos addObject:info];
        }
    }
    
    NSMutableArray* removedTexts = [NSMutableArray new];
    for (VideoTextInfo* info in _videoTextInfos) {
        //删除的
        NSUInteger index = [videoTextInfos indexOfObject:info];
        if ( index != NSNotFound) {
            continue;
        }
        
        if (info.startTime < _rightTime && info.endTime > _leftTime)
            [removedTexts addObject:info];
    }
    
    if (removedTexts.count > 0)
        [_videoTextInfos removeObjectsInArray:removedTexts];
    
    _videoPreview.frame = CGRectMake(0, 0, self.view.width, 350 * kScaleY);
    _videoPreview.delegate = self;
    [_videoPreview setPlayBtnHidden:NO];
    [self.view addSubview:_videoPreview];
    
    if (videoTextInfos.count > 0) {
        [_textView setEdited:YES];
    }
    else {
        [_textView setEdited:NO];
    }
}

#pragma mark - PasterAddViewDelegate
- (void)onAddPasterBtnClicked
{
    [_videoPreview removeFromSuperview];
    
    //己有添加字幕的话只操作本地裁剪时间内的
    NSMutableArray* inRangeVideoPasters = [NSMutableArray new];
    for (VideoPasterInfo* info in _videoPaterInfos) {
        if (info.startTime >= _rightTime || info.endTime <= _leftTime)
            continue;
        
        [inRangeVideoPasters addObject:info];
    }
    
    [_ugcEdit pausePlay];
    [_videoPreview setPlayBtn:NO];
    
    VideoPasterViewController* vc = [[VideoPasterViewController alloc] initWithVideoEditer:_ugcEdit previewView:_videoPreview startTime:_leftTime endTime:_rightTime videoPasterInfos:inRangeVideoPasters];
    vc.delegate = self;
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - MPMediaPickerControllerDelegate
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    NSArray *items = mediaItemCollection.items;
    MPMediaItem *songItem = [items objectAtIndex:0];
    
    NSURL *url = [songItem valueForProperty:MPMediaItemPropertyAssetURL];
    NSString* songName = [songItem valueForProperty: MPMediaItemPropertyTitle];
    NSString* authorName = [songItem valueForProperty:MPMediaItemPropertyArtist];
    NSNumber* duration = [songItem valueForKey:MPMediaItemPropertyPlaybackDuration];
    NSLog(@"MPMediaItemPropertyAssetURL = %@", url);
    
    MusicInfo* musicInfo = [MusicInfo new];
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

//点击取消时回调
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 将AssetURL(音乐)导出到app的文件夹并播放
- (void)saveAssetURLToFile:(MusicInfo*)musicInfo assetURL:(NSURL*)assetURL
{
    [_musixMixView addMusicInfo:musicInfo];

//    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
//
//    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:songAsset presetName:AVAssetExportPresetAppleM4A];
//    NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
//    exporter.outputFileType = @"com.apple.m4a-audio";
//
//    [AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset];
//    NSString *docDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"LocalMusics/"];
//    NSString *exportFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.m4a", musicInfo.soneName, musicInfo.singerName]];
//
//    exporter.outputURL = [NSURL fileURLWithPath:exportFilePath];
//    musicInfo.filePath = exportFilePath;
//
//    if ([[NSFileManager defaultManager] fileExistsAtPath:exportFilePath]) {
//        [_musixMixView addMusicInfo:musicInfo];
//        return;
//    }
//
//    MBProgressHUD* hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hub.label.text = @"音频读取中...";
//
//
//
//    // do the export
//    //__weak typeof(self) weakSelf = self;
//    [exporter exportAsynchronouslyWithCompletionHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
//                    [_musixMixView addMusicInfo:musicInfo];
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

#pragma mark - MusicMixViewDelegate
//打开本地系统音乐
- (void)onOpenLocalMusicList
{
    [self pause];
    //    MusicCollectionViewController* vc = [[MusicCollectionViewController alloc] initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    //    [self.navigationController pushViewController:vc animated:YES];
//    MPMediaPickerController *mpc = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
//    mpc.delegate = self;
//    mpc.editing = YES;
//    mpc.allowsPickingMultipleItems = NO;
//    [self presentViewController:mpc animated:YES completion:nil];
    musicView *music = [[musicView alloc]init];
    [self presentViewController:music animated:YES completion:nil];

}

//设音量效果
- (void)onSetVideoVolume:(CGFloat)videoVolume musicVolume:(CGFloat)musicVolume
{
    [_ugcEdit setVideoVolume:videoVolume];
    [_ugcEdit setBGMVolume:musicVolume];
}

- (void)onSetBGMWithFilePath:(NSString *)filePath startTime:(CGFloat)startTime endTime:(CGFloat)endTime
{
    if (![_filePath isEqualToString:filePath]) {
        __weak __typeof(self) weakSelf = self;
        [_ugcEdit setBGM:filePath result:^(int result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result == -1){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设置背景音乐失败"
                                                                        message:@"不支持当前格式的背景音乐!"
                                                                       delegate:weakSelf
                                                              cancelButtonTitle:@"知道了"
                                                              otherButtonTitles:nil, nil];
                    [alertView show];
                }else{
                    [weakSelf setBGMVolume:filePath startTime:startTime endTime:endTime];
                }
            });
        }];
    }else{
        [self setBGMVolume:filePath startTime:startTime endTime:endTime];
    }

}

-(void)setBGMVolume:(NSString *)filePath startTime:(CGFloat)startTime endTime:(CGFloat)endTime
{
    _filePath = filePath;
    [_ugcEdit setBGMStartTime:startTime endTime:endTime];
    [_ugcEdit setBGMAtVideoTime:0.0];
    if (_filePath == nil) {
        [_ugcEdit setVideoVolume:1.f];
    }
    
    [_ugcEdit startPlayFromTime:0 toTime:_rightTime];
    [_videoPreview setPlayBtn:YES];
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
    MusicInfo* musicInfo = [MusicInfo new];
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
@end
