#import "playerView.h"
#import "Config.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>

@implementation playerView{
    int sssss;
}

-(void)leftviews{
    _leftView = [[UIView alloc]init];

    _leftView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    //左上角 直播live
    iPhoneX?24:0;
    _leftView.frame = CGRectMake(10,20+sssss,isAttention_leftView_wtidth,leftW);
    _leftView.layer.cornerRadius = leftW/2;
    UITapGestureRecognizer *tapleft = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhuboMessage)];
    tapleft.numberOfTapsRequired = 1;
    tapleft.numberOfTouchesRequired = 1;
    [_leftView addGestureRecognizer:tapleft];
    //关注主播
    _newattention = [UIButton buttonWithType:UIButtonTypeCustom];
    _newattention.frame = CGRectMake(108,(leftW-24)/2,24,24);
    _newattention.layer.masksToBounds = YES;
    _newattention.layer.cornerRadius = 12;
    [_newattention setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_newattention addTarget:self action:@selector(guanzhuzhubo) forControlEvents:UIControlEventTouchUpInside];
    _newattention.hidden = YES;
    //主播头像button
    _IconBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [_IconBTN addTarget:self action:@selector(zhuboMessage) forControlEvents:UIControlEventTouchUpInside];

    _IconBTN.frame = CGRectMake(3, 3, leftW-6, leftW-6);
    _IconBTN.layer.masksToBounds = YES;
    _IconBTN.layer.cornerRadius = (leftW-6)/2;
    
    //添加主播等级
    _levelimage = [[UIImageView alloc]initWithFrame:CGRectMake(_IconBTN.right - 13,_IconBTN.bottom - 15,15,15)];
    _levelimage.layer.masksToBounds = YES;
    _levelimage.layer.cornerRadius = 7.5;
    _levelimage.layer.borderColor = [UIColor whiteColor].CGColor;
    _levelimage.layer.borderWidth = 1;
    [_levelimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"host_%@",minstr([self.zhuboDic valueForKey:@"level_anchor"])]]];
    
    
    NSString *path = [self.zhuboDic valueForKey:@"avatar"];
    NSURL *url = [NSURL URLWithString:path];
    [_IconBTN sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head"]];
    //直播live
    UILabel *liveLabel = [[UILabel alloc]initWithTextColor:[UIColor whiteColor] font:13 textAliahment:NSTextAlignmentLeft text:[self.zhuboDic valueForKey:@"user_nicename"]];
    liveLabel.frame = CGRectMake(leftW+7,4,isAttention_leftView_wtidth - leftW - 7-10,18);
    liveLabel.shadowOffset = CGSizeMake(1,1);//设置阴影
    //在线人数
    
    UIImageView * hotImgeView = [[UIImageView alloc]init];
    hotImgeView.image = [UIImage imageNamed:@"ic_live_hot"];
    hotImgeView.frame = CGRectMake(liveLabel.left,liveLabel.bottom+1,10,12);
    
    _onlineLabel = [[UILabel alloc]init];
    _onlineLabel.frame = CGRectMake(hotImgeView.right+3,hotImgeView.top,liveLabel.width- 15,hotImgeView.height);

    _onlineLabel.textAlignment = NSTextAlignmentLeft;
    _onlineLabel.textColor = [UIColor whiteColor];
    _onlineLabel.font = fontMT(10);
    
    
    
    [_leftView addSubview:_onlineLabel];
    [_leftView addSubview:liveLabel];
    [_leftView addSubview:hotImgeView];
    [_leftView addSubview:_IconBTN];
    [_leftView addSubview:_levelimage];//主播等级
    
    [self addSubview:_leftView];//添加左上角信息
    [_leftView addSubview:_newattention];
    
    _imagebackImage = [[UIView alloc]init];
    _imagebackImage.layer.cornerRadius = 15;
    UITapGestureRecognizer *yingpiaoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yingpiao)];
    _imagebackImage.userInteractionEnabled = YES;
    [_imagebackImage addGestureRecognizer:yingpiaoTap];
    _imagebackImage.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:_imagebackImage];
    [_imagebackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_leftView);
        make.top.mas_equalTo(_leftView.mas_bottom).offset(6);
        make.height.mas_equalTo(30);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    UIImageView *zuanshiImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2.5, 15, 15)];;
    zuanshiImage.image = [UIImage imageNamed:@"coin"];
    zuanshiImage.backgroundColor = [UIColor clearColor];
    [_imagebackImage addSubview:zuanshiImage];
    [zuanshiImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(9);
        make.centerY.mas_equalTo(_imagebackImage);
        make.width.height.mas_equalTo(20);
    }];
    
    //修改 魅力值 适应字体 欣
    _yingpiaoLabel  = [[UILabel alloc]initWithTextColor:[UIColor whiteColor] font:13 textAliahment:NSTextAlignmentLeft text:nil];
    [_imagebackImage addSubview:_yingpiaoLabel];
    [_yingpiaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(zuanshiImage.mas_trailing).offset(6);
        make.centerY.mas_equalTo(_imagebackImage);
        make.width.height.mas_greaterThanOrEqualTo(0);
    }];
    
    //主播id号
    //frontView
    _roomID = [[UILabel alloc]initWithTextColor:[UIColor whiteColor] font:13 textAliahment:NSTextAlignmentLeft text:nil];
    [_imagebackImage addSubview:_roomID];
    [_roomID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_yingpiaoLabel.mas_trailing).offset(8);
        make.centerY.mas_equalTo(_imagebackImage);
        make.width.height.mas_greaterThanOrEqualTo(0);
    }];
    
    _imageVh = [[UIImageView alloc]initWithFrame:CGRectMake(_yingpiaoSize.width+10,0,15,15)];
    _imageVh.image = [UIImage imageNamed:@"room_yingpiao_check.png"];
    [_imagebackImage addSubview:_imageVh];//箭头
    [_imageVh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_roomID.mas_trailing).offset(9);
        make.centerY.mas_equalTo(_imagebackImage);
        make.width.height.mas_equalTo(16);
        make.trailing.mas_equalTo(-7);
    }];
}
-(instancetype)initWithDic:(NSDictionary *)playDic{
    self = [super init];
    if (self) {
        if (iPhoneX) {
            sssss = 24;
        }else{
            sssss = 0;
        }
        self.zhuboDic = playDic;
        //添加遮罩层
        _ZheZhaoBTN = [UIButton buttonWithType:UIButtonTypeSystem];
        _ZheZhaoBTN.frame = CGRectMake(0, 0, _window_width, _window_height);
        _ZheZhaoBTN.backgroundColor = [UIColor clearColor];
        [_ZheZhaoBTN addTarget:self action:@selector(zhezhaoBTN) forControlEvents:UIControlEventTouchUpInside];
        _ZheZhaoBTN.hidden = YES;
        //一开始进入显示的背景
        _bigAvatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,_window_width, _window_height+200)];
        _bigAvatarImageView.image = [UIImage imageNamed:[playDic valueForKey:@"avatar"]];
        [_bigAvatarImageView sd_setImageWithURL:[NSURL URLWithString:[playDic valueForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_bg.png"]];
        
        _bigAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_ZheZhaoBTN];//添加遮罩
        [self addSubview:_bigAvatarImageView];//添加背景图
        //*********************************************************************************//
    }
    return self;
}
//点击关注主播
-(void)guanzhuzhubo{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.setAttent"];
    
    
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"touid":[self.zhuboDic valueForKey:@"uid"]
                             };
    
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                
                [self.frontviewDelegate guanzhuZhuBo];
                
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//改变左上角 映票数量
-(void)changeState:(NSString *)texts andID:(NSString *)ID{
    if (!_leftView) {
        [self leftviews];
    }
    if (!texts || texts == NULL || [texts isEqual:[NSNull null]]) {
        _yingpiaoLabel.text = @"0";
    }
    else{
        _yingpiaoLabel.text = texts;
    }
    
    NSString *laingname = minstr([self.zhuboDic valueForKey:@"goodnum"]);
    
    if ([laingname isEqual:@"0"]) {
        _roomID.text = [NSString stringWithFormat:@"%@%@",YZMsg(@"房间:"),ID];
    }
    else{
        _roomID.text = [NSString stringWithFormat:@"%@%@%@",YZMsg(@"房间:"),YZMsg(@"靓"),laingname];
    }
}
//跳魅力值页面
-(void)yingpiao{
    [self.frontviewDelegate gongxianbang];
}
-(void)zhuboMessage{
    [self.frontviewDelegate zhubomessage];
}
-(void)zhezhaoBTN{
    [self.frontviewDelegate zhezhaoBTNdelegate];
}
@end
