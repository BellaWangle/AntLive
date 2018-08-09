#import "fenXiangView.h"
@implementation fenXiangView
{
    NSMutableArray *picNameArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        picNameArray = [common share_type].mutableCopy;
        [picNameArray removeObject:@"wx"];
        [picNameArray removeObject:@"wchat"];
        //注意：此处涉及到精密计算，轻忽随意改动
        CGFloat w = 50;
        CGFloat x = 0;
        CGFloat centerX = _window_width/2;
        if (picNameArray.count % 2 == 0) {
            //iphone5
            if (IS_IPHONE_5) {
              x =  centerX - picNameArray.count/2*w - (picNameArray.count - 1)*5 + 25;
            }else
            x =  centerX - picNameArray.count/2*w - (picNameArray.count - 1)*5;
        }
        else{
            if (IS_IPHONE_5) {
                x =  centerX - (picNameArray.count - 1)/2*w - w/2 - (picNameArray.count - 1)*5 + 25;
            }else
            x =  centerX - (picNameArray.count - 1)/2*w - w/2 - (picNameArray.count - 1)*5;
        }
        for (int i=0; i<picNameArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:0];
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"share_%@",picNameArray[i]]] forState:UIControlStateNormal];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [btn setTitle:picNameArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(doSomething:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(x,10,w,w);
            if (IS_IPHONE_5) {
                x+=w;
            }else{
                x+=w+10;
            }
            [self addSubview:btn];
        }
    }
    return self;
}
-(void)doSomething:(UIButton *)sender{
    NSLog(@"分享到%@",picNameArray[sender.tag]);
    NSDictionary *dic = [NSDictionary dictionaryWithObject:picNameArray[sender.tag] forKey:@"fenxiang"];
    [self FenXiang:dic];
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    sender.userInteractionEnabled = YES;
    });
}
-(void)FenXiang:(NSDictionary *)dic{
    NSString *fenxiang = [dic valueForKey:@"fenxiang"];
    if ([fenxiang isEqual:@"qzone"]) {
        [self simplyShare:SSDKPlatformSubTypeQZone];
    }
    else if([fenxiang isEqual:@"qq"])
    {
        [self simplyShare:SSDKPlatformSubTypeQQFriend];
    }
    else if([fenxiang isEqual:@"facebook"])
    {
        [self simplyShare:SSDKPlatformTypeFacebook];
    }
    else if([fenxiang isEqual:@"twitter"])
    {
        [self simplyShare:SSDKPlatformTypeTwitter];
    }
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
        //拼装分享地址
        NSString *strFullUrl = [[common wx_siteurl] stringByAppendingFormat:@"%@",[self.zhuboDic valueForKey:@"uid"]];
        ParamsURL = [NSURL URLWithString:strFullUrl];
    }
    else{//app_ios
        ParamsURL = [NSURL URLWithString:[common app_ios]];
    }
    //判断是不是微信分享
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@",[self.zhuboDic valueForKey:@"user_nicename"],[common share_des]]
                                     images:[self.zhuboDic valueForKey:@"avatar_thumb"]
                                        url:ParamsURL
                                      title:[common share_title]
                                       type:SSDKContentType];
    
    [shareParams SSDKEnableUseClientShare];
    //进行分享
    [ShareSDK share:SSDKPlatformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [MBProgressHUD showSuccess:YZMsg(@"分享成功")];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [MBProgressHUD showError:YZMsg(@"分享失败")];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 break;
             }
             default:
                 break;
         }
     }];
}
-(void)GetDIc:(NSDictionary *)dic{
    self.zhuboDic = dic;
}
@end
