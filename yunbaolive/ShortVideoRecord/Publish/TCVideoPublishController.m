#import "TCVideoPublishController.h"
#import "UIView+CustomAutoLayout.h"
#import "VideoRecordViewController.h"

#import <TXLiteAVSDK_UGC/TXUGCRecord.h>
#import <TXLiteAVSDK_UGC/TXUGCPublish.h>
#import <TXLiteAVSDK_UGC/TXLivePlayer.h>
//#import <TXRTMPSDK/TXUGCRecord.h>
//#import <TXRTMPSDK/TXUGCPublish.h>
//#import <TXRTMPSDK/TXLivePlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Qiniu/QiniuSDK.h>
#import <AVFoundation/AVFoundation.h>
#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKExtension/SSEShareHelper.h>
//#import <ShareSDK/ShareSDK+Base.h>
//#import <ShareSDKExtension/ShareSDK+Extension.h>
@interface TCVideoPublishController()<TXLivePlayListener>
@property UILabel         *labPublishState;
@property BOOL isNetWorkErr;
@property UIImageView      *imgPublishState;

@property (nonatomic,strong) NSString *imagekey;
@property (nonatomic,strong) NSString *videokey;
//分享的视频id 和 截图
@property (nonatomic,strong) NSString *videoid;
@property (nonatomic,strong) NSString *image_thumb;
@end
@implementation TCVideoPublishController
{
      int sharetype;           //分享类型
    NSString *mytitle;
    //分享
    UIView          *_vShare;
    UIView          *_vShareInfo;
    UIView          *_vVideoPreview;
    UITextView       *_txtShareWords;
    UILabel         *_labDefaultWords;
    UILabel         *_labLeftWords;
    UIView          *locationV;
    UILabel         *_labRecordVideo;
    
    UIView          *_vSharePlatform;
    NSMutableArray   *_btnShareArry;
    
    //发布
    UIView          *_vPublishInfo;
    UIImageView      *_imgPublishState;
    UILabel         *_labPublishState;
    
    TXUGCPublish   *_videoPublish;
    TXLivePlayer     *_livePlayer;
    
    TXPublishParam   *_videoPublishParams;
    TXRecordResult   *_recordResult;
    
    NSInteger       _selectBtnTag;
    BOOL            _isPublished;
    
    BOOL            _playEnable;
    
    id              _videoRecorder;
    BOOL            _isNetWorkErr;
    NSString *qntoken;//七牛token
    UIBarButtonItem *publishBtn;
}
- (instancetype)init:(id)videoRecorder recordType:(NSInteger)recordType RecordResult:(TXRecordResult *)recordResult  TCLiveInfo:(NSDictionary *)liveInfo
{
    self = [super init];
    if (self) {
        
        sharetype = 0;
        
        _videoPublishParams = [[TXPublishParam alloc] init];
        
        _recordResult = recordResult;
        
        _videoRecorder = videoRecorder;
        
        _isPublished = NO;
        
        _playEnable  = YES;
        
        _isNetWorkErr = NO;
        
        _selectBtnTag = -1;
        
        _videoPublish = [[TXUGCPublish alloc] initWithUserID:[Config getOwnID]];
        _videoPublish.delegate = self;
        _livePlayer  = [[TXLivePlayer alloc] init];
        _livePlayer.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
    }
    return self;
}
- (instancetype)initWithPath:(NSString *)videoPath videoMsg:(TXVideoInfo *) videoMsg
{
    TXRecordResult *recordResult = [TXRecordResult new];
    recordResult.coverImage = videoMsg.coverImage;
    recordResult.videoPath = videoPath;

    return [self init:nil recordType:0
         RecordResult:recordResult
           TCLiveInfo:nil];
    
}
- (void)dealloc
{
    [_livePlayer removeVideoWidget];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];//UIColorFromRGB(0x0ACCAC);
    self.navigationItem.title = YZMsg(@"发布");
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]}] ;
    self.view.backgroundColor = UIColorFromRGB(0xefeff4);
    
    
    publishBtn = [[UIBarButtonItem alloc] initWithTitle:YZMsg(@"发布") style:UIBarButtonItemStylePlain target:self action:@selector(videoPublish)];
    self.navigationItem.rightBarButtonItems = [NSMutableArray arrayWithObject:publishBtn];

    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    singleTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTap];
    
    
    //分享
    _vShare = [[UIView alloc] init];
    _vShare.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _vShareInfo = [[UIView alloc] init];
    _vShareInfo.backgroundColor = [UIColor whiteColor];
    
    _vVideoPreview = [[UIView alloc] init];
    _txtShareWords = [[UITextView alloc] init];
    _txtShareWords.delegate = self;
    _txtShareWords.layer.borderColor = _vShareInfo.backgroundColor.CGColor;
    _txtShareWords.font = [UIFont systemFontOfSize:16];
    _txtShareWords.textColor = [UIColor blackColor];
    _labDefaultWords = [[UILabel alloc] init];
    _labDefaultWords.text = YZMsg(@"说点什么。。");
    _labDefaultWords.textColor = UIColorFromRGB(0xefeff4);
    _labDefaultWords.font = [UIFont systemFontOfSize:16];
    _labDefaultWords.backgroundColor =[UIColor clearColor];
    _labDefaultWords.textAlignment = NSTextAlignmentLeft;
    
    _labLeftWords = [[UILabel alloc] init];
    _labLeftWords.text = @"0/20";
    _labLeftWords.textColor = UIColorFromRGB(0xefeff4);
    _labLeftWords.font = [UIFont systemFontOfSize:12];
    _labLeftWords.backgroundColor =[UIColor clearColor];
    _labLeftWords.textAlignment = NSTextAlignmentRight;
    
    //显示定位
    locationV = [[UIView alloc]init];
    locationV.backgroundColor = RGB(243, 243, 243);
    locationV.layer.masksToBounds = YES;
    locationV.layer.cornerRadius = 15;
    
    UILabel *locationlabels = [[UILabel alloc]init];
    locationlabels.font = fontMT(15);
    locationlabels.text = [NSString stringWithFormat:@"%@",[locationCache getMyCity]];
    locationlabels.textColor =[UIColor grayColor];
    
    
    CGSize locatSize = [locationlabels.text boundingRectWithSize:CGSizeMake(_window_width*0.7, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontMT(15)} context:nil].size;
    locationlabels.frame = CGRectMake(35,0, locatSize.width,30);
    locationV.frame = CGRectMake(130,140, locatSize.width + 60,30);
    
    UIImageView *imageloca = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_live_location_active"]];
    imageloca.contentMode = UIViewContentModeScaleAspectFit;
    imageloca.frame = CGRectMake(10,7.5,15,15);
    [locationV addSubview:imageloca];
    [locationV addSubview:locationlabels];
    
    _vSharePlatform = [[UIView alloc] init];
    _vSharePlatform.backgroundColor = [UIColor whiteColor];
    
    [_vShare addSubview:_vSharePlatform];
    [self.view addSubview:_vShare];
    [_vShare addSubview:_vShareInfo];
    
    [_vShareInfo addSubview:_vVideoPreview];
    [_vShareInfo addSubview:_txtShareWords];
    [_vShareInfo addSubview:_labDefaultWords];
    [_vShareInfo addSubview:_labLeftWords];
    [_vShareInfo addSubview:locationV];
    
    [_vShare sizeWith:CGSizeMake(self.view.width, self.view.height - [[UIApplication sharedApplication] statusBarFrame].size.height - self.navigationController.navigationBar.height)];
    [_vShare alignParentTopWithMargin:[[UIApplication sharedApplication] statusBarFrame].size.height+self.navigationController.navigationBar.height];
    [_vShare alignParentLeft];
    
    [_vShareInfo setSize:CGSizeMake(self.view.width, 180)];
    [self setBorderWithView:_vShareInfo top:YES left:NO bottom:YES right:NO borderColor:UIColorFromRGB(0xd8d8d8) borderWidth:0.5];
    [_vShareInfo alignParentTopWithMargin:0];
    [_vShareInfo alignParentLeft];
    
    [_vSharePlatform setSize:CGSizeMake(self.view.width, 2000)];
    [self setBorderWithView:_vSharePlatform top:YES left:NO bottom:YES right:NO borderColor:UIColorFromRGB(0xd8d8d8) borderWidth:0.5];
    [_vSharePlatform alignParentTopWithMargin:190];
    [_vSharePlatform alignParentLeft];

    [_vVideoPreview setSize:CGSizeMake(100, 150)];
    [_vVideoPreview alignParentLeftWithMargin:15];
    [_vVideoPreview alignParentTopWithMargin:15];
    
    [_txtShareWords setSize:CGSizeMake(self.view.width - _vVideoPreview.width - 45, _vVideoPreview.height)];
    [_txtShareWords layoutToRightOf:_vVideoPreview margin:15];
    [_txtShareWords alignParentTopWithMargin:15];
    
    [_labDefaultWords setSize:CGSizeMake(90, 16)];
    [_labDefaultWords layoutToRightOf:_vVideoPreview margin:25];
    [_labDefaultWords alignParentTopWithMargin:24];
    
    [_labLeftWords setSize:CGSizeMake(50, 12)];
    [_labLeftWords alignParentRightWithMargin:15];
    [_labLeftWords alignParentBottomWithMargin:15];

    
    NSArray *picNameArray = [common share_type];//获取分享类型
    if (picNameArray.count == 0) {
        _vSharePlatform.hidden = YES;
    }
    else{
        _vSharePlatform.hidden = NO;
    }
    
    //注意：此处涉及到精密计算，轻忽随意改动
    CGFloat W = _window_width/4;
    CGFloat x = 0;
    CGFloat y=20;
    for (int i=0; i<picNameArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.tag = 1000 + i;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"publish%@",picNameArray[i]]] forState:UIControlStateNormal];
        [btn setTitle:picNameArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:picNameArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.frame = CGRectMake(x,y,W,W);
        btn.selected = NO;
        x+=_window_width/4;
        if (x >= _window_width) {
            x=0;
            y+=_window_width/4 + 20;
        }
        [_vSharePlatform addSubview:btn];
    }
    
     //发布
    _vPublishInfo = [[UIView alloc] init];
    _vPublishInfo.backgroundColor = [UIColor clearColor];
    _vPublishInfo.hidden = YES;
    
    _imgPublishState = [[UIImageView alloc] init];
    _imgPublishState.image = [UIImage imageNamed:@"video_record_share_loading_0"];
    
    _labPublishState = [[UILabel alloc] init];
    _labPublishState.text = YZMsg(@"正在上传请稍等");
    _labPublishState.textColor = UIColorFromRGB(0x0ACCAC);
    _labPublishState.font = [UIFont systemFontOfSize:24];
    _labPublishState.backgroundColor =[UIColor clearColor];
    _labPublishState.textAlignment = NSTextAlignmentCenter;
    
    _labRecordVideo = [[UILabel alloc] init];
    _labRecordVideo.text = @"";
    _labRecordVideo.textColor = UIColorFromRGB(0x0ACCAC);
    _labRecordVideo.font = [UIFont systemFontOfSize:12];
    _labRecordVideo.backgroundColor =[UIColor clearColor];
    _labRecordVideo.numberOfLines = 0;
    _labRecordVideo.lineBreakMode = NSLineBreakByWordWrapping;
    _labRecordVideo.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:_vPublishInfo];
    [_vPublishInfo addSubview:_imgPublishState];
    [_vPublishInfo addSubview:_labPublishState];
    [_vPublishInfo addSubview:_labRecordVideo];
    
    [_vPublishInfo sizeWith:CGSizeMake(self.view.width, self.view.height - [[UIApplication sharedApplication] statusBarFrame].size.height - self.navigationController.navigationBar.height)];
    [_vPublishInfo alignParentTopWithMargin:[[UIApplication sharedApplication] statusBarFrame].size.height+self.navigationController.navigationBar.height];
    [_vPublishInfo alignParentLeft];
    
    [_imgPublishState setSize:CGSizeMake(50, 50)];
    [_imgPublishState alignParentTopWithMargin:100];
    _imgPublishState.center = CGPointMake(self.view.center.x, _imgPublishState.center.y);
    
    [_labPublishState setSize:CGSizeMake(self.view.width, 24)];
    [_labPublishState alignParentTopWithMargin:175];
    _labPublishState.center = CGPointMake(self.view.center.x, _labPublishState.center.y);
    
    _labRecordVideo.hidden = YES;
    
    [_livePlayer setupVideoWidget:CGRectZero containView:_vVideoPreview insertIndex:0];
    
}
-(void)share:(UIButton *)sender{
    
    if (sender.selected == NO) {
        
        if ([sender.titleLabel.text isEqual:@"qq"]) {
            sharetype = 1;
        }else if ([sender.titleLabel.text isEqual:@"qzone"]) {
            sharetype = 2;
        }else if ([sender.titleLabel.text isEqual:@"wx"]) {
            sharetype = 3;
        }else if ([sender.titleLabel.text isEqual:@"wchat"]) {
            sharetype = 4;
        }else if ([sender.titleLabel.text isEqual:@"facebook"]) {
            sharetype = 5;
        }else if ([sender.titleLabel.text isEqual:@"twitter"]) {
            sharetype = 6;
        }
        for (UIButton *btn in _vSharePlatform.subviews) {
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"publish%@",btn.titleLabel.text]] forState:UIControlStateNormal];
            btn.selected = NO;
        }
        [sender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"publish_%@",sender.titleLabel.text]] forState:UIControlStateNormal];
        sender.selected = YES;
        
    }
    else{
        sharetype = 0;
        [sender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"publish%@",sender.titleLabel.text]] forState:UIControlStateNormal];
        sender.selected = NO;
    }
}
- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

    _playEnable = YES;
    if (_isPublished == NO) {
        [_livePlayer startPlay:_recordResult.videoPath type:PLAY_TYPE_LOCAL_VIDEO];
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    _playEnable = NO;
    [_livePlayer stopPlay];
}
- (void)closeKeyboard:(UITapGestureRecognizer *)gestureRecognizer
{
    [_txtShareWords resignFirstResponder];
}
- (void)videoPublish
{
   publishBtn.enabled = NO;
   [self.view endEditing:YES];
   [MBProgressHUD showMessage:YZMsg(@"发布中，请稍后")];
   mytitle = [NSString stringWithFormat:@"%@",_txtShareWords.text];//标题
    __weak TCVideoPublishController *weakself = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.getQiniuToken"];
    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *ret = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"ret"]];
        if ([ret isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSDictionary *info =  [[data valueForKey:@"info"] firstObject];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if ([code isEqual:@"0"]) {
                qntoken = [NSString stringWithFormat:@"%@",[info valueForKey:@"token"]];
                [weakself uploadqn];
            }
            else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
                publishBtn.enabled = YES;
            }
        }
        else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
            publishBtn.enabled = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:YZMsg(@"网络连接断开，视频上传失败")];
        publishBtn.enabled = YES;
    }];
    __weak typeof(self) wkSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                [MBProgressHUD showError:YZMsg(@"网络连接断开，视频上传失败")];
                wkSelf.imgPublishState.hidden = YES;
                wkSelf.isNetWorkErr = YES;
                break;
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring]; //开启网络监控
}
//截取视频缩略图
//获取视频的第一帧截图, 返回UIImage
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
-(void)uploadqn{
    
      __weak TCVideoPublishController *weakself = self;
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNFixedZone zone0];
    }];
    QNUploadOption *option = [[QNUploadOption alloc]initWithMime:nil progressHandler:^(NSString *key, float percent) {
        
    } params:nil checkCrc:NO cancellationSignal:nil];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    //获取视频和图片
    NSString *filePath =_recordResult.videoPath;
    
    NSData *imageData = UIImagePNGRepresentation(_recordResult.coverImage);
    NSString *imageName = [self getVideoNameBaseCurrentTime:@".png"];
    //传图片
    [upManager putData:imageData key:[NSString stringWithFormat:@"image_%@",imageName] token:qntoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        if (info.ok) {
            //图片成功
            [weakself uploadimagesuccess:key];
            //传视频
            NSString *videoName = [self getVideoNameBaseCurrentTime:@".mp4"];
            
            [upManager putFile:filePath key:[NSString stringWithFormat:@"video_%@",videoName] token:qntoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (info.ok) {
                    //成功
                    NSLog(@"qn_upload_suc:%@",key);
                    //请求app业务服务器给标题
                    [weakself uploadvideosuccess:key andTitle:mytitle];
                }else {
                    //失败
                    [MBProgressHUD showError:YZMsg(@"上传失败")];
                    publishBtn.enabled = YES;
                }
                NSLog(@"info ===== %@", info);
                NSLog(@"resp ===== %@", resp);
            } option:option];
        }
        else {
            [MBProgressHUD hideHUD];
            //图片失败
            NSLog(@"%@",info.error);
            [MBProgressHUD showError:YZMsg(@"上传失败")];
            publishBtn.enabled = YES;
        }
    } option:option];
}
-(void)root{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.navigationController popToRootViewControllerAnimated:YES];
    });
}
-(void)pushshare{
    switch (sharetype) {
        case 0:
            [self root];
            break;
        case 1:
            [self simplyShare:SSDKPlatformSubTypeQQFriend];
            break;
        case 2:
            [self simplyShare:SSDKPlatformSubTypeQZone];
            break;
        case 3:
            [self simplyShare:SSDKPlatformSubTypeWechatSession];
            break;
        case 4:
            [self simplyShare:SSDKPlatformSubTypeWechatTimeline];
            break;
        case 5:
            [self simplyShare:SSDKPlatformTypeFacebook];
            break;
        case 6:
            [self simplyShare:SSDKPlatformTypeTwitter];
            break;
        default:
            break;
    }
}
-(void)uploadimagesuccess:(NSString *)key{
    _imagekey = key;
    
}
-(void)uploadvideosuccess:(NSString *)key andTitle:(NSString *)myTitle{
    _videokey = key;
    [self requstAPPServceTitle:myTitle andVideo:_videokey andImage:_imagekey];
}
//以当前时间合成视频名称
- (NSString *)getVideoNameBaseCurrentTime:(NSString *)suf {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *nameStr = [[dateFormatter stringFromDate:[NSDate date]] stringByAppendingString:suf];
    return [NSString stringWithFormat:@"%@_%@",[Config getOwnID],nameStr];
}
//请求业务服务器
-(void)requstAPPServceTitle:(NSString *)myTile andVideo:(NSString *)video andImage:(NSString *)image {
    
    __weak TCVideoPublishController *weakself = self;
    NSDictionary *pullDic = @{
                              @"uid":[Config getOwnID],
                              @"token":[Config getOwnToken],
                              @"title":myTile,
                              @"href":video,
                              @"thumb":image,
                              @"lng":[NSString stringWithFormat:@"%@",[locationCache getMylng]],
                              @"lat":[NSString stringWithFormat:@"%@",[locationCache getMylat]],
                              @"city":[NSString stringWithFormat:@"%@",[locationCache getMyCity]]
                              };
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.setVideo"];
    [session POST:url parameters:pullDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *ret = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"ret"]];
        if ([ret isEqual:@"200"]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if ([code isEqual:@"0"]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:YZMsg(@"发布成功")];
                
                BOOL isOk = [[NSFileManager defaultManager] removeItemAtPath:_recordResult.videoPath error:nil];
                NSLog(@"%d shanchushanchushanchu",isOk);
                
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                _videoid = [NSString stringWithFormat:@"%@",[info valueForKey:@"id"]];
                _image_thumb = [NSString stringWithFormat:@"%@",[info valueForKey:@"thumb_s"]];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself pushshare];
                //发布成功后刷新首页
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadlist" object:nil];
                 publishBtn.enabled = NO;
                });
            }
            else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
                 publishBtn.enabled = YES;
            }
        }
        else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
            publishBtn.enabled = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:YZMsg(@"网络连接断开，视频上传失败")];
        publishBtn.enabled = YES;
    }];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView*)textView
{
    if([textView.text length] == 0){
        _labDefaultWords.hidden = NO;
    }else{
        _labDefaultWords.hidden = YES;
    }
    _labLeftWords.text = [NSString stringWithFormat:@"%02ld/20", 20 - [textView.text length]];
}
- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    if (range.location >= 20)
    {
        return NO;
    } else {
        return YES;
    }
}
#pragma mark - TXVideoPublishListener
-(void) onPublishProgress:(NSInteger)uploadBytes totalBytes: (NSInteger)totalBytes
{
    NSInteger progress = 8 * uploadBytes / totalBytes;
    _imgPublishState.image = [UIImage imageNamed:[NSString stringWithFormat:@"video_record_share_loading_%ld", progress]];
}
-(void)onPublishComplete:(TXPublishResult*)result
{
    if (!result.retCode) {
        _labPublishState.text = YZMsg(@"发布成功啦！");
    } else {
        if (_isNetWorkErr == NO) {
            _labPublishState.text = [NSString stringWithFormat:@"%@[%d]",YZMsg(@"发布失败啦!"), result.retCode];
        }
        return;
    }
    NSString *title = _txtShareWords.text;
    if (title.length<=0) title = YZMsg(@"小视频");
    _imgPublishState.image = [UIImage imageNamed:@"video_record_success"];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:YZMsg(@"完成") style:UIBarButtonItemStylePlain target:self action:@selector(publishFinished)];
    self.navigationItem.rightBarButtonItems = [NSMutableArray arrayWithObject:btn];
}
- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}
- (void) toastTip:(NSString*)toastInfo
{
    CGRect frameRC = [[UIScreen mainScreen] bounds];
    frameRC.origin.y = frameRC.size.height - 110;
    frameRC.size.height -= 110;
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
- (void)selectShare:(UIButton *)button
{
    for(int i=0; i<_btnShareArry.count; ++i)
    {
        UIButton *btn = [_btnShareArry objectAtIndex:i];
        if (button == btn) {
            continue;
        }
        btn.selected = NO;
    }
    if (button.selected == YES) {
        button.selected = NO;
        _selectBtnTag = -1;
    } else {
        button.selected = YES;
        _selectBtnTag = button.tag;
    }
}
- (void)simplyShare:(int)SSDKPlatformType
    {
        /**
         * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
         **/
        int SSDKContentType = SSDKContentTypeAuto;
        NSURL *ParamsURL = [NSURL URLWithString:[h5url stringByAppendingFormat:@"g=appapi&m=video&a=index&videoid=%@",@""]];
        //创建分享参数
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        NSString *titles = _txtShareWords.text;
        if (_txtShareWords.text.length == 0) {
            
            titles = [NSString stringWithFormat:@"%@%@",[Config getOwnNicename],[common video_share_des]];
            
        }
//        [common video_share_title]
        [shareParams SSDKSetupShareParamsByText:titles
                                         images:_image_thumb
                                            url:ParamsURL
                                          title:[common video_share_title]
                                           type:SSDKContentType];
        [ShareSDK share:SSDKPlatformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {

            if (state == SSDKResponseStateSuccess) {
                [MBProgressHUD showSuccess:YZMsg(@"分享成功")];

            }
            else if (state == SSDKResponseStateFail){
                [MBProgressHUD showError:YZMsg(@"分享失败")];
            }

            [self.navigationController popToRootViewControllerAnimated:YES];

        }];
    }
- (void)applicationWillEnterForeground:(NSNotification *)noti
{
    //temporary fix bug
    if ([self.navigationItem.title isEqualToString:YZMsg(@"发布中")])
        return;
    
    if (_isPublished == NO) {

        [_livePlayer startPlay:_recordResult.videoPath type:PLAY_TYPE_LOCAL_VIDEO];
    }
}
- (void)publishFinished
{
    if ([_videoRecorder isMemberOfClass:[TXLivePlayer class]]) {
        [self.navigationController  popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
- (void)applicationDidEnterBackground:(NSNotification *)noti
{
    [_livePlayer stopPlay];
}
#pragma mark TXLivePlayListener
-(void) onPlayEvent:(int)EvtID withParam:(NSDictionary*)param
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_PLAY_END && _playEnable) {
            [_livePlayer startPlay:_recordResult.videoPath type:PLAY_TYPE_LOCAL_VIDEO];
            return;
        }
    });

}
-(void) onNetStatus:(NSDictionary*) param
{
    return;
}
@end
