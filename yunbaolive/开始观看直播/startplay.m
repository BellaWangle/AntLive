#import "startplay.h"
#import "customTextView.h"
#import "Livebroadcast.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "Config.h"
#import <ShareSDK/ShareSDK.h>
#import "ZFModalTransitionAnimator.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Additions.h"
#import "Utils.h"
#import "coastselectview.h"
@interface startplay ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UIImageView *startImageView;
    UIButton *kaishibtn; //开始直播
    UIButton *startCancle;//关闭
    UITextField *nameT;
    CGFloat www;
    UIButton *tempBtn;
    NSString *secret;//密码
    NSString *coast;//收费
    UIAlertView *coastAlert; //扣费alert
    UIAlertView *secretAlert;//密码alert
    UIButton *uploadBtn;     //上传图片
    UIImage *selectImage;    //选择的图片
    int  liveType;           //直播类型  0是一般直播，1是私密直播，2是收费直播，3是计时直播
    int sharetype;           //分享类型
    /*
     0.未选择
     1.qq
     2.qzone
     3.wx
     4.wchat
     5.facebook
     6.twitter
     */
    UILabel *yingpiaoNumL;
    UILabel *playtimeNuml;
    UILabel *guankannumsL;
    UIActionSheet *sheetphoto;//选择图片
    UIButton *livetypebtn;//选择开播类型
    coastselectview * coastview;//价格选择列表
    UIView *sharev;//分享
    BOOL canFee;//计时收费开关
    
}
@property(nonatomic,strong)NSString *timeString;
@property(nonatomic, strong) ZFModalTransitionAnimator *animator;
@end
@implementation startplay
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [MBProgressHUD hideHUD];
    [nameT resignFirstResponder];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"coin" object:nil];
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
                    
                    
                    //判断是否显示收费
                    NSArray *arrays = [common live_type];
                    for (NSArray *array in arrays) {
                        NSString *ids = [NSString stringWithFormat:@"%@",[array firstObject]];
                        if ([ids isEqual:@"3"]) {
                            canFee = YES;
                        }
                    }
                    
                    
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    canFee = NO;
    [self buildUpdate];
    
    
    sharetype = 0;
    _timeString = @"0";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(soeasy:) name:@"coin" object:nil];
    liveType = 0;
    
    
    //弹出相机权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
        
        
    }];
    //弹出麦克风权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        
        
    }];
    
    
    www = 40;
    startImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    startImageView.userInteractionEnabled = YES;
    [startImageView sd_setImageWithURL:[NSURL URLWithString:[Config getavatar]]];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0,_window_width,_window_height);
    [startImageView addSubview:effectview];
    
    
    //创建开始btn
    kaishibtn = [UIButton buttonWithType:0];
    kaishibtn.frame = CGRectMake(30,_window_height *0.8, _window_width-60,50);
//    kaishibtn.tintColor = [UIColor grayColor];
//    [kaishibtn setImage:[UIImage imageNamed:@"开始直播123"] forState:UIControlStateNormal];
    [kaishibtn setTitle:YZMsg(@"开始直播") forState:UIControlStateNormal];
    [kaishibtn setBackgroundColor:[UIColor grayColor]];
    kaishibtn.layer.cornerRadius = 25.0;
    kaishibtn.layer.masksToBounds = YES;

    [kaishibtn addTarget:self action:@selector(doHidden:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //关闭按钮
    startCancle = [UIButton buttonWithType:UIButtonTypeSystem];
    startCancle.tintColor = [UIColor whiteColor];
    [startCancle setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    startCancle.imageEdgeInsets = UIEdgeInsetsMake(5,5,5,5);
    [startCancle addTarget:self action:@selector(Quit) forControlEvents:UIControlEventTouchUpInside];
    startCancle.frame = CGRectMake(_window_width - www-10,30,40, 40);
    uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadBtn.frame = CGRectMake(_window_width*0.35,_window_height *0.2,_window_width*0.3,_window_width*0.3);
    uploadBtn.backgroundColor = [UIColor clearColor];
    [uploadBtn setBackgroundImage:[UIImage imageNamed:@"封面"] forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(doUploadPicture) forControlEvents:UIControlEventTouchUpInside];
    
    livetypebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    livetypebtn.frame = CGRectMake(_window_width*0.35,uploadBtn.bottom + 20,_window_width*0.3,60);
    [livetypebtn setImage:[UIImage imageNamed:getImagename(@"选择类型_普通")] forState:UIControlStateNormal];
    livetypebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    livetypebtn.imageEdgeInsets = UIEdgeInsetsMake(15,25,15,25);
    [livetypebtn addTarget:self action:@selector(dochangelivetype) forControlEvents:UIControlEventTouchUpInside];
    
    
    //分割线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(_window_width*0.2, livetypebtn.bottom, _window_width*0.6, 1)];
    line.backgroundColor = [UIColor whiteColor];
    
    UILabel *sharewords = [[UILabel alloc]initWithFrame:CGRectMake(_window_width*0.2,kaishibtn.frame.origin.y - 130, _window_width*0.6,30)];
    sharewords.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    sharewords.text = YZMsg(@"直播分享到");
    [sharewords setAdjustsFontSizeToFitWidth:YES];
    sharewords.textAlignment = NSTextAlignmentCenter;
    sharewords.textColor = RGB(227, 226, 226);
    
    
    //直播标题
    nameT = [[UITextField alloc]initWithFrame:CGRectMake(0,uploadBtn.top - 60, _window_width,50)];
//    nameT.delegate = self;
    nameT.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    nameT.backgroundColor = [UIColor clearColor];
//    nameT.scrollEnabled = NO;
//    nameT.showsHorizontalScrollIndicator = NO;
//    nameT.showsVerticalScrollIndicator = NO;
    nameT.textColor = RGB(227, 226, 226);
    nameT.textAlignment = NSTextAlignmentCenter;
//    UITextRange *range = nameT.selectedTextRange;
//    UITextPosition* start = [nameT positionFromPosition:range.start inDirection:UITextLayoutDirectionLeft offset:nameT.text.length];
//    if (start)
//    {
//        [nameT setSelectedTextRange:[nameT textRangeFromPosition:start toPosition:start]];
//    }
    // 就下面这两行是重点
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:YZMsg(@"给直播写个标题吧") attributes:
                                      @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                        NSFontAttributeName:nameT.font
                                        }];
    nameT.attributedPlaceholder = attrString;
    
    sharev = [[UIView alloc]initWithFrame:CGRectMake(0,kaishibtn.frame.origin.y - 80, _window_width, 60)];
    
    
    [startImageView addSubview:kaishibtn];
    [startImageView addSubview:nameT];
    [startImageView addSubview:startCancle];
    [startImageView addSubview:uploadBtn];
    [startImageView addSubview:livetypebtn];
    [startImageView addSubview:line];
    [startImageView addSubview:sharewords];
    [self.view addSubview:startImageView];
    [startImageView addSubview:sharev];
    
    NSMutableArray *plantforms = [common share_type].mutableCopy;//获取分享类型
    [plantforms removeObject:@"wx"];
    [plantforms removeObject:@"wchat"];
    if (plantforms.count == 0) {
        sharewords.hidden = YES;
    }
    else{
        sharewords.hidden = NO;
    }
    //直播分享按钮
    CGFloat W = 40;
    CGFloat H = 60;
    CGFloat x;
    CGFloat centerX = _window_width/2;
    if (plantforms.count % 2 == 0) {
        x =  centerX - plantforms.count/2*W - (plantforms.count - 1)*5;
    }
    else{
        x =  centerX - (plantforms.count - 1)/2*W - W/2 - (plantforms.count - 1)*5;
    }
    for (int i=0; i<plantforms.count; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.tag = 1000 + i;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"share%@",plantforms[i]]] forState:UIControlStateNormal];
        [btn setTitle:plantforms[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:plantforms[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.frame = CGRectMake(x,0,W,H);
        btn.selected = NO;
        x+=W+10;
        [sharev addSubview:btn];
    }
    
}
-(void)share:(UIButton *)sender{
    
    if (sender.selected == NO) {
    
    if ([sender.titleLabel.text isEqual:@"qq"]) {
        sharetype = 1;
    }else if ([sender.titleLabel.text isEqual:@"qzone"]) {
        sharetype = 2;
    }else if ([sender.titleLabel.text isEqual:@"facebook"]) {
        sharetype = 3;
    }else if ([sender.titleLabel.text isEqual:@"twitter"]) {
        sharetype = 4;
    }
    for (UIButton *btn in sharev.subviews) {
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"share%@",btn.titleLabel.text]] forState:UIControlStateNormal];
    btn.selected = NO;
    }
    [sender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"share_%@",sender.titleLabel.text]] forState:UIControlStateNormal];
    sender.selected = YES;
    
    }
    else{
        sharetype = 0;
        [sender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"share%@",sender.titleLabel.text]] forState:UIControlStateNormal];
        sender.selected = NO;
    }
}
//切换房间类型
-(void)dochangelivetype{
    NSArray *arrays = [common live_type];
    
    for (NSArray *array in arrays) {
        
        NSString *ids = [NSString stringWithFormat:@"%@",[array firstObject]];
        
        if ([ids isEqual:@"3"]) {
            canFee = YES;
            
        }
        
    }
    
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"选择房间类型" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i=0; i<arrays.count; i++) {
        
     
    UIAlertAction *action = [UIAlertAction actionWithTitle:arrays[i][1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *typestring = arrays[i][0];
            int types = [typestring intValue];
            switch (types) {
                case 0:
                      liveType = 0;
                      coast = @"";
                      [livetypebtn setImage:[UIImage imageNamed:getImagename(@"选择类型_普通")] forState:UIControlStateNormal];
                    break;
                case 1:
                      [self doSecret];
                    break;
                case 2:
                      [self doCoast];
                    break;
                case 3:
                     [self doCoasttimer];
                    break;
                default:
                    break;
            }
        }];
    [alertC addAction:action];
    }
    UIAlertAction *cancleaction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
   [alertC addAction:cancleaction];
   [self presentViewController:alertC animated:YES completion:nil];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == secretAlert) {
        if (buttonIndex ==0) {
          
            return;
        }
        else if (buttonIndex == 1){
            UITextField *field = [alertView textFieldAtIndex:0];
            secret = field.text;
            if (field.text.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"密码不能为空") message:nil delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            else{
                liveType = 1;
                [livetypebtn setImage:[UIImage imageNamed:getImagename(@"选择类型_密码")] forState:UIControlStateNormal];
            }
        }
    }
    else if (alertView == coastAlert){
        if (buttonIndex == 0) {
                        return;
        }
    else if (buttonIndex == 1){
            UITextField *field = [alertView textFieldAtIndex:0];
            coast = field.text;
            if ([coast isEqualToString:@"0"] || field.text.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"请输入正确的金额") message:nil delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            else
            {
        liveType = 2;
        [livetypebtn setImage:[UIImage imageNamed:getImagename(@"选择类型_门票")] forState:UIControlStateNormal];
            }
        }
    }
    
}
//密码房间
-(void)doSecret{
    secretAlert = [[UIAlertView alloc]initWithTitle:@"" message:YZMsg(@"设置您的密码房间") delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确认"), nil];
    secretAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *field = [secretAlert textFieldAtIndex:0];
    field.keyboardType = UIKeyboardTypeNumberPad;
    [secretAlert show];
}
//开启收费模式
-(void)doCoast{
    
    coastAlert = [[UIAlertView alloc]initWithTitle:YZMsg(@"输入您的收费金额") message:YZMsg(@"收益以直播结束显示为准") delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确认"), nil];
    coastAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *field = [coastAlert textFieldAtIndex:0];
    field.keyboardType = UIKeyboardTypeNumberPad;
    [coastAlert show];
    
}
-(void)hidecoastview{
    
    [UIView animateWithDuration:0.3 animations:^{
        coastview.frame = CGRectMake(0, -_window_height, _window_width, _window_height);
    }];
    
}
//开启计时收费模式
-(void)doCoasttimer{
    
    if (!coastview) {
        coastview = [[coastselectview alloc]initWithFrame:CGRectMake(0, -_window_height, _window_width, _window_height) andsureblock:^(NSString *type) {
            liveType = 3;
            coast = type;
             [livetypebtn setImage:[UIImage imageNamed:getImagename(@"选择类型_计时")] forState:UIControlStateNormal];
            //收费金额
            [self hidecoastview];
        } andcancleblock:^(NSString *type) {
            //取消
            [self hidecoastview];
        }];
        [startImageView addSubview:coastview];
    }
    [UIView animateWithDuration:0.3 animations:^{
        coastview.frame = CGRectMake(0,0, _window_width, _window_height);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            coastview.frame = CGRectMake(0,20,_window_width, _window_height);
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            coastview.frame = CGRectMake(0, 0, _window_width, _window_height);
        }];
    });
    coastview.userInteractionEnabled = YES;
    
}
-(void)hidekeyboaed{
    [nameT resignFirstResponder];
}
-(void)soeasy:(NSNotification *)ns{
    NSDictionary *subdic = [ns userInfo];
    _timeString = [subdic valueForKey:@"stream"];
    [self lastview];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Live.stopInfo&stream=%@",_timeString];
   
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSArray *info = [data valueForKey:@"info"];
                NSDictionary *subdic = [info firstObject];
                yingpiaoNumL.text = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"votes"]];
                NSString *time = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"length"]];
//                if (time.length<=2) {
//                    playtimeNuml.text = [NSString stringWithFormat:@"%@s",time];
//                }else{
                    playtimeNuml.text = time;
//                }
                guankannumsL.text = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"nums"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}
-(void)lastview{
    
    
    UIImageView *lastView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    lastView.userInteractionEnabled = YES;
    [lastView sd_setImageWithURL:[NSURL URLWithString:[Config getavatar]]];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0,_window_width,_window_height);
    [lastView addSubview:effectview];
    
    
    
    UIImageView *iconIMage = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width*0.35, _window_height*0.1, _window_width*0.3, _window_width*0.3)];
    [iconIMage sd_setImageWithURL:[NSURL URLWithString:[Config getavatar]] placeholderImage:[UIImage imageNamed:@"bg1"]];
    iconIMage.layer.masksToBounds = YES;
    iconIMage.layer.cornerRadius = _window_width*0.15;
    [lastView addSubview:iconIMage];
    
    
    
    UILabel *nameL= [[UILabel alloc]initWithFrame:CGRectMake(0,iconIMage.bottom+10, _window_width, 30)];
    nameL.textColor = RGB(223, 222, 222);
    nameL.text = [Config getOwnNicename];
    nameL.textAlignment = NSTextAlignmentCenter;
    nameL.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [lastView addSubview:nameL];
    
    
    
    UILabel *labell= [[UILabel alloc]initWithFrame:CGRectMake(0,nameL.bottom+20, _window_width, 30)];
    labell.textColor = [UIColor whiteColor];
    labell.text = YZMsg(@"直播结束");
    labell.textAlignment = NSTextAlignmentCenter;
    labell.font = [UIFont fontWithName:@"Helvetica-Bold" size:32];
    
    
    
    UILabel *yingpiaoL = [[UILabel alloc]initWithFrame:CGRectMake(0,_window_height *0.45 + 20,_window_width,40)];
    yingpiaoL.textAlignment = NSTextAlignmentCenter;
    yingpiaoL.textColor = [UIColor grayColor];
    yingpiaoL.text = [NSString stringWithFormat:@"%@%@",YZMsg(@"收获"),[common name_votes]];
    yingpiaoL.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [lastView addSubview:yingpiaoL];
    
    
    
    yingpiaoNumL = [[UILabel alloc]initWithFrame:CGRectMake(0,_window_height *0.45 - 15,_window_width,40)];
    yingpiaoNumL.textColor = [UIColor whiteColor];
    yingpiaoNumL.textAlignment = NSTextAlignmentCenter;
    yingpiaoNumL.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
    [lastView addSubview:yingpiaoNumL];
    
    
    UILabel *line1 = [[UILabel alloc]init];
    line1.backgroundColor = [UIColor whiteColor];
    [lastView addSubview:line1];
    line1.frame = CGRectMake(_window_width*0.2,yingpiaoL.bottom + 20, _window_width*0.6,1);
    
    
    
    UILabel *playtimel = [[UILabel alloc]initWithFrame:CGRectMake(10,line1.bottom + 40,_window_width/2,40)];
    playtimel.textColor = [UIColor grayColor];
    playtimel.textAlignment = NSTextAlignmentCenter;
    playtimel.text = [NSString stringWithFormat:@"%@", YZMsg(@"直播时长")];
    [lastView addSubview:playtimel];
    
    
    UILabel *guankannum = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2-10,line1.bottom + 40,_window_width/2,40)];
    guankannum.textColor = [UIColor grayColor];
    guankannum.textAlignment = NSTextAlignmentCenter;
    guankannum.text = [NSString stringWithFormat:@"%@", YZMsg(@"观看人数")];
    [lastView addSubview:guankannum];

    
    
    playtimeNuml = [[UILabel alloc]initWithFrame:CGRectMake(10,line1.bottom + 10,_window_width/2 - 20,40)];

    playtimeNuml.textColor = [UIColor whiteColor];
    playtimeNuml.textAlignment = NSTextAlignmentCenter;
    playtimeNuml.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [lastView addSubview:playtimeNuml];
    
    
    guankannumsL = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2-10,line1.bottom + 10,_window_width/2 - 20,40)];
    guankannumsL.textColor = [UIColor whiteColor];
    guankannumsL.textAlignment = NSTextAlignmentCenter;
    guankannumsL.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [lastView addSubview:guankannumsL];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(_window_width*0.1,_window_height *0.8, _window_width*0.8,50);
    [button setTitle:YZMsg(@"确认") forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor grayColor]];
    button.layer.cornerRadius = 25.0;
    button.layer.masksToBounds = YES;
//    [button setImage:[UIImage imageNamed:@"last确定"] forState:UIControlStateNormal];
    
//    [button setTitleColor:normalColors forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button addTarget:self action:@selector(docancle) forControlEvents:UIControlEventTouchUpInside];
    [lastView addSubview:button];
    [lastView addSubview:labell];
    [self.view addSubview:lastView];
    
    
    
}
-(void)docancle{
    [coastview removeFromSuperview];
    coastview = nil;
    coastview.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createroom{
    NSString *type_vals;
    if (liveType == 0) {
        type_vals = @"";
    }
    else if (liveType == 1){
        type_vals = secret;
    }
    else if (liveType == 2 ||liveType == 3)
    {
        type_vals = coast;
    }
    //获取定位信息
    NSString *title = [nameT.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Live.createRoom&uid=%@&token=%@&user_nicename=%@&title=%@&province=%@&city=%@&lng=%@&lat=%@&type=%d&type_val=%@",[Config getOwnID],[Config getOwnToken],[Config getOwnNicename],title,@"",[cityDefault getMyCity],[cityDefault getMylng],[cityDefault getMylat],liveType,type_vals];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *parameters = @{
                                 @"avatar":[self encodeString:minstr([Config getavatar])],
                                 @"avatar_thumb":[self encodeString:minstr([Config getavatarThumb])]
                                 };
    [session POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (selectImage) {
            [formData appendPartWithFileData:[Utils compressImage:selectImage] name:@"file" fileName:@"duibinaf.png" mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *data = [responseObject valueForKey:@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
        if ([code isEqual:@"0"]) {
            NSDictionary *info = [[data valueForKey:@"info"] firstObject];

            NSString *shut_time = [NSString stringWithFormat:@"%@",[info valueForKey:@"shut_time"]];//禁言时间

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

            NSString *agorakitid = [NSString stringWithFormat:@"%@",[info valueForKey:@"agorakitid"]];
            [common saveagorakitid:agorakitid];//保存声网ID
            //保存靓号和vip信息
            NSDictionary *liang = [info valueForKey:@"liang"];
            NSString *liangnum = minstr([liang valueForKey:@"name"]);
            NSDictionary *vip = [info valueForKey:@"vip"];
            NSString *type = minstr([vip valueForKey:@"type"]);
            NSDictionary *subdic = [NSDictionary dictionaryWithObjects:@[type,liangnum] forKeys:@[@"vip_type",@"liang"]];
            [Config saveVipandliang:subdic];
            NSString *auction_switch = minstr([info valueForKey:@"auction_switch"]);//竞拍开关
            NSArray *game_switch = [info valueForKey:@"game_switch"];//游戏开关
            Livebroadcast *lives = [[Livebroadcast alloc]init];
            lives.type = liveType;
            lives.shut_time = shut_time;
            lives.roomDic = info;
            lives.canFee = canFee;
            lives.auction_switch = auction_switch;
            lives.game_switch = game_switch;
            lives.zhuangDic = zhuangdic;
            [self.navigationController pushViewController:lives animated:NO];

        }
        else{
         UIAlertView  *alertsexper = [[UIAlertView alloc]initWithTitle:[data valueForKey:@"msg"] message:nil delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
            [alertsexper show];
        }
         [MBProgressHUD hideHUDForView:self.view];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:YZMsg(@"无网络")];
        
//        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"error message" message:minstr(error) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [errorAlert show];

    }];
    
    
    
}
-(void)doHidden:(UIButton *)sender{
    
    
    [nameT resignFirstResponder];
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(@"相机权限受限");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"权限受阻") message:YZMsg(@"请在设置中开启相机权限") delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
        [alert show];
        
        
        return;
    }
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        
        if (granted) {
            
            // 用户同意获取麦克风
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"权限受阻") message:YZMsg(@"请在设置中开启麦克风权限") delegate:self cancelButtonTitle:YZMsg(@"确认") otherButtonTitles:nil, nil];
            
            [alert show];
            
        return ;
            
        }
        
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    switch (sharetype) {
        case 0:
              [self createroom];
            break;
        case 1:
            [self simplyShare:SSDKPlatformSubTypeQQFriend];
            break;
        case 2:
            [self simplyShare:SSDKPlatformSubTypeQZone];
            break;
        case 3:
             [self simplyShare:SSDKPlatformTypeFacebook];
            break;
        case 4:
            [self simplyShare:SSDKPlatformTypeTwitter];
            break;
            
            
        default:
            break;
    }
}
-(void)weiboBtnClick:(UIButton *)sharbtnV
{
    [tempBtn removeFromSuperview];
    if(sharbtnV.selected == YES)
    {
        sharbtnV.selected = NO;
    }
    else
    {
        [self setSelectSharBtn:sharbtnV];
    }
}
-(void)qqBtnClick:(UIButton *)sharbtnV
{
    [tempBtn removeFromSuperview];
    
    if(sharbtnV.selected == YES)
    {
        sharbtnV.selected = NO;
    }
    else
    {
        [self setSelectSharBtn:sharbtnV];

    }}
-(void)qzoneBtnClick:(UIButton *)sharbtnV
{
    [tempBtn removeFromSuperview];
    if(sharbtnV.selected == YES)
    {
        sharbtnV.selected = NO;
    }
    else
    {
        [self setSelectSharBtn:sharbtnV];
    }
}
-(void)wechatBtnClick:(UIButton *)sharbtnV
{
    
    [tempBtn removeFromSuperview];
    
    if(sharbtnV.selected == YES)
    {
        sharbtnV.selected = NO;
    }
    else
    {
        [self setSelectSharBtn:sharbtnV];

    }
}
-(void)timeline:(UIButton *)sharbtnV
{
    [tempBtn removeFromSuperview];
    if(sharbtnV.selected == YES)
    {
        sharbtnV.selected = NO;
    }
    else
    {
        [self setSelectSharBtn:sharbtnV];
    }
}
-(void)setSelectSharBtn:(UIButton *)selectButton
{

}
- (void)simplyShare:(int)SSDKPlatformType
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    
    int SSDKContentType = SSDKContentTypeAuto;
    
    NSURL *ParamsURL;

    
    if(SSDKPlatformType == SSDKPlatformTypeSinaWeibo)
    {
        SSDKContentType = SSDKContentTypeImage;
    }
    else if((SSDKPlatformType == SSDKPlatformSubTypeWechatSession || SSDKPlatformType == SSDKPlatformSubTypeWechatTimeline))
    {
        NSString *strFullUrl = [[common wx_siteurl] stringByAppendingFormat:@"%@",[Config getOwnID]];
        ParamsURL = [NSURL URLWithString:strFullUrl];
    }else{
        
        ParamsURL = [NSURL URLWithString:[common app_ios]];
    }
    //获取我的头像
    LiveUser *user = [Config myProfile];
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@",[Config getOwnNicename],[common share_des]]
                                     images:user.avatar_thumb
                                        url:ParamsURL
                                      title:[common share_title]
                                       type:SSDKContentType];
    [shareParams SSDKEnableUseClientShare];
    [ShareSDK share:SSDKPlatformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showSuccess:YZMsg(@"分享成功")];
        }
        else if (state == SSDKResponseStateFail){
            [MBProgressHUD showError:YZMsg(@"分享失败")];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            [self createroom];
        });
    }];
  }
-(void)Quit{
    [coastview removeFromSuperview];
    coastview = nil;
    coastview.hidden = YES;
     [self.navigationController popViewControllerAnimated:YES];
}
-(void)doUploadPicture{
    
   sheetphoto = [[UIActionSheet alloc]initWithTitle:YZMsg(@"选择上传方式") delegate:self cancelButtonTitle:YZMsg(@"取消") destructiveButtonTitle:YZMsg(@"相册") otherButtonTitles:YZMsg(@"拍照"), nil];
    [sheetphoto showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet == sheetphoto) {
        if (buttonIndex == 0) {
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
        else if (buttonIndex == 1){
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = YES;
        imagePickerController.showsCameraControls = YES;
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
     }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        selectImage = image;
        [uploadBtn setImage:image forState:UIControlStateNormal];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(NSString*)encodeString:(NSString*)unencodedString{
    NSString*encodedString=(NSString*)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
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
