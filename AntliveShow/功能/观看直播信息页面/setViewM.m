#import "setViewM.h"
#import "Config.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
@implementation setViewM{
    int sssss;
}

-(void)leftviews{
    _leftView = [[UIView alloc]init];

    _leftView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    //左上角 直播live
    iPhoneX?24:0;
    _leftView.frame = CGRectMake(10,20+sssss,90,leftW);
    _leftView.layer.cornerRadius = leftW/2;
    UITapGestureRecognizer *tapleft = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhuboMessage)];
    tapleft.numberOfTapsRequired = 1;
    tapleft.numberOfTouchesRequired = 1;
    [_leftView addGestureRecognizer:tapleft];
    //关注主播
    _newattention = [UIButton buttonWithType:UIButtonTypeCustom];
    _newattention.frame = CGRectMake(90,8,40,25);
    _newattention.layer.masksToBounds = YES;
    _newattention.layer.cornerRadius = 12.5;
    [_newattention setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _newattention.titleLabel.font = [UIFont systemFontOfSize:11];
    [_newattention setTitle:YZMsg(@"关注") forState:UIControlStateNormal];
    [_newattention setBackgroundColor:normalColors];
    _newattention.contentMode = UIViewContentModeScaleAspectFit;
    [_newattention addTarget:self action:@selector(guanzhuzhubo) forControlEvents:UIControlEventTouchUpInside];
    _newattention.hidden = YES;
    //主播头像button
    _IconBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [_IconBTN addTarget:self action:@selector(zhuboMessage) forControlEvents:UIControlEventTouchUpInside];

        _IconBTN.frame = CGRectMake(4, 2, leftW-5, leftW-5);
        _IconBTN.layer.masksToBounds = YES;
        _IconBTN.layer.borderWidth = 1;
        _IconBTN.layer.borderColor = normalColors.CGColor;
        _IconBTN.layer.cornerRadius = (leftW-5)/2;
    
    //添加主播等级
    _levelimage = [[UIImageView alloc]initWithFrame:CGRectMake(_IconBTN.right - 13,_IconBTN.bottom - 15,15,15)];
    _levelimage.layer.masksToBounds = YES;
    _levelimage.layer.cornerRadius = 7.5;
    [_levelimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"host_%@",minstr([self.zhuboDic valueForKey:@"level_anchor"])]]];
    
    
    NSString *path = [self.zhuboDic valueForKey:@"avatar"];
    NSURL *url = [NSURL URLWithString:path];
    [_IconBTN sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head"]];
    //直播live
    UILabel *liveLabel;
    liveLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftW+7,2,70,20)];
    liveLabel.textAlignment = NSTextAlignmentLeft;
    liveLabel.text = YZMsg(@"直播Live");
    liveLabel.textColor = [UIColor whiteColor];
    liveLabel.shadowOffset = CGSizeMake(1,1);//设置阴影
    liveLabel.font = fontMT(10);
    //在线人数
    _onlineLabel = [[UILabel alloc]init];
    _onlineLabel.frame = CGRectMake(leftW+10,17,70,20);

    _onlineLabel.textAlignment = NSTextAlignmentLeft;
    _onlineLabel.textColor = [UIColor whiteColor];
    _onlineLabel.font = fontMT(10);
    //魅力值//魅力值
    //修改 魅力值 适应字体 欣
    _yingpiaoLabel  = [[UILabel alloc]init];
    _yingpiaoLabel.backgroundColor = [UIColor clearColor];
    _yingpiaoLabel.font = fontMT(13);
    _yingpiaoLabel.textAlignment = NSTextAlignmentCenter;
    _yingpiaoLabel.textColor = [UIColor whiteColor];
    _imagebackImage = [[UIView alloc]init];
    _imagebackImage.layer.cornerRadius = 10;
    UITapGestureRecognizer *yingpiaoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yingpiao)];
    _imagebackImage.userInteractionEnabled = YES;
    [_imagebackImage addGestureRecognizer:yingpiaoTap];
    _imagebackImage.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    //魅力值文字
    labell = [[UILabel alloc]init];//WithFrame:CGRectMake(30,0,45,20)
    labell.text = [NSString stringWithFormat:@"%@:",YZMsg(@"蚁币")];
    labell.textAlignment = NSTextAlignmentLeft;
    labell.textColor = [UIColor whiteColor];
    labell.font = fontMT(13);
//    CGSize voteSize = [labell.text boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontMT(13)} context:nil].size;
    labell.frame = CGRectMake(30, 0, 0, 20);
    UIImageView *zuanshiImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2.5, 15, 15)];;
    zuanshiImage.image = [UIImage imageNamed:@"zuanshi"];
    zuanshiImage.backgroundColor = [UIColor clearColor];
    [_imagebackImage addSubview:zuanshiImage];
    //主播id号
    //frontView
    _roomID = [[UILabel alloc] init];
    [_roomID setTextColor:[UIColor whiteColor]];
    _roomID.font = fontMT(13);

//    NSString *laingname = minstr([self.zhuboDic valueForKey:@"goodnum"]);
//    
//    if ([laingname isEqual:@"0"]) {
//        _roomID.text = [NSString stringWithFormat:@"房间:%@",[self.zhuboDic valueForKey:@"id"]];
//    }
//    else{
//        _roomID.text = [NSString stringWithFormat:@"房间:靓%@",laingname];
//    }
    _roomsize = [_roomID.text boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontMT(13)} context:nil].size;
    //魅力值图标
    _imageVh = [[UIImageView alloc]initWithFrame:CGRectMake(_yingpiaoSize.width+10,0,15,15)];
    _imageVh.image = [UIImage imageNamed:@"room_yingpiao_check.png"];
    [_imagebackImage addSubview:_yingpiaoLabel];
    [_imagebackImage addSubview:_roomID];
    [_imagebackImage addSubview:labell];
    [_imagebackImage addSubview:_imageVh];//箭头
    
    [_leftView addSubview:_onlineLabel];
    [_leftView addSubview:liveLabel];
    [_leftView addSubview:_IconBTN];
    [_leftView addSubview:_levelimage];//主播等级
    [self addSubview:_imagebackImage];//
    [self addSubview:_leftView];//添加左上角信息
    [_leftView addSubview:_newattention];
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
    _yingpiaoSize= [_yingpiaoLabel.text boundingRectWithSize:CGSizeMake(300, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontMT(13)} context:nil].size;
    _yingpiaoLabel.frame = CGRectMake(labell.right,0,_yingpiaoSize.width,20);
    _roomsize = [_roomID.text boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontMT(13)} context:nil].size;
    _roomID.frame = CGRectMake(_yingpiaoLabel.frame.origin.x + _yingpiaoLabel.frame.size.width + 5, 0, _roomsize.width, 20);
    _imagebackImage.frame = CGRectMake(10,30+_leftView.frame.size.height + sssss,_yingpiaoSize.width+ 105 + _roomID.frame.size.width,20);
    _imageVh.frame = CGRectMake(_imagebackImage.frame.size.width - 20,3,15,15);
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
