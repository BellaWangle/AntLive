//
//  videoMoewView.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/5.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "videoMoewView.h"
#import <ShareSDK/ShareSDK.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface videoMoewView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CGFloat collectionvh;
    MBProgressHUD *hud;
    NSURL *fullPathsss;
}
@property(nonatomic,strong)NSDictionary *hostdic;
@property(nonatomic,strong)NSMutableArray *itemarray;
@property(nonatomic,strong)UICollectionView *colelction;
@end
@implementation videoMoewView
-(instancetype)initWithFrame:(CGRect)frame andHostDic:(NSDictionary *)dic cancleblock:(xinxinblock)block delete:(xinxinblock)deleteblock share:(xinxinblock)share{
    self = [super initWithFrame:frame];
    if (self) {
        self.deleteblock = deleteblock;
        self.cancleblock = block;
        self.shareblock = share;
        _hostdic = [NSDictionary dictionaryWithDictionary:dic];
        _itemarray = [NSMutableArray arrayWithArray:[common share_type]];
        [_itemarray removeObject:@"wx"];
        [_itemarray removeObject:@"wchat"];

        collectionvh = (_window_height/2.2 - 50)/2;
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow.itemSize = CGSizeMake(_window_width/4, collectionvh);
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;

        
        _colelction = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, _window_width,collectionvh) collectionViewLayout:flow];
        _colelction.delegate = self;
        _colelction.dataSource = self;
        [_colelction registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"videoMore"];
        [self addSubview:_colelction];
        _colelction.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *lineso = [[UILabel alloc]initWithFrame:CGRectMake(0,collectionvh,_window_width,1)];
        lineso.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineso];
        
        
        UILabel *lineso2 = [[UILabel alloc]initWithFrame:CGRectMake(0,collectionvh*2,_window_width,1)];
        lineso2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineso2];
        
        
        //取消
        UIButton *canclebtn = [UIButton buttonWithType:0];
        [canclebtn setTitle:YZMsg(@"取消") forState:0];
        [canclebtn setTitleColor:[UIColor blackColor] forState:0];
        canclebtn.frame = CGRectMake(0,collectionvh*2, _window_width, 50);
        [canclebtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:canclebtn];
        
        NSString *ID = [NSString stringWithFormat:@"%@",[[_hostdic valueForKey:@"userinfo"] valueForKey:@"id"]];
        NSArray *array = @[getImagename(@"icon_share_black"),getImagename(@"icon_share_report"),getImagename(@"icon_share_link"),getImagename(@"icon_share_save")];
        if ([ID isEqual:[Config getOwnID]]) {
            array =@[getImagename(@"icon_share_delete"),getImagename(@"icon_share_link"),getImagename(@"icon_share_save")];
        }
        //如果没有分享
        CGFloat btny = collectionvh;
        if (_itemarray.count == 0) {
            _colelction.frame = CGRectMake(0, 0, 0, 0);
            btny = 0;
            CGFloat  www = _window_height/2.2/2 -collectionvh;
            canclebtn.frame = CGRectMake(0,collectionvh, _window_width,www);
        }
        CGFloat btnx = 0;
        CGFloat btnw = _window_width/4;
        for (int i=0; i<array.count; i++) {
            UIButton *btn = [UIButton buttonWithType:0];
            btn.frame = CGRectMake(btnx, btny, btnw, collectionvh);
            [btn setImage:[UIImage imageNamed:array[i]] forState:0];
            [btn setTitleColor:[UIColor clearColor] forState:0];
            [btn setTitle:array[i] forState:0];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [btn addTarget:self action:@selector(makeaction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
            btnx+=btnw;
            [self addSubview:btn];
        }
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)makeaction:(UIButton *)sender{
    if ([sender.titleLabel.text isEqual:getImagename(@"icon_share_black")]) {
        [self setBlack:sender];
    }else if ([sender.titleLabel.text isEqual:getImagename(@"icon_share_report")]) {
        [self jubao];
    }
    else if ([sender.titleLabel.text isEqual:getImagename(@"icon_share_link")]) {
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        paste.string = [NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"href"]];
        [MBProgressHUD showSuccess:YZMsg(@"复制成功")];
    }
    else if ([sender.titleLabel.text isEqual:getImagename(@"icon_share_save")]) {
        [self downloadVideo:sender];
    }
    else if ([sender.titleLabel.text isEqual:getImagename(@"icon_share_delete")]) {
        [self deletemovie:sender];
    }
}
//下载视频到本地
-(void)downloadVideo:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    sender.userInteractionEnabled = YES;
        
    });
    NSString *href = [NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"href"]];
    NSString *title = [NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"title"]];
    if (title.length == 0) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970]*1000;
        NSString *timeString = [NSString stringWithFormat:@"%d", (int)a];
        title = timeString;
    }
    hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = YZMsg(@"正在下载视频");
    //1.创建会话管理者
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    NSURL *url = [NSURL URLWithString:href];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        hud.progress = downloadProgress.fractionCompleted;
        //监听下载进度
        //completedUnitCount 已经下载的数据大小
        //totalUnitCount     文件数据的中大小
        NSLog(@"%f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        NSLog(@"targetPath:%@",targetPath);
        NSLog(@"fullPath:%@",fullPath);
        
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        fullPathsss = filePath;
       NSLog(@"%@",filePath);

        
    UISaveVideoAtPathToSavedPhotosAlbum([filePath path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }];
    
    //3.执行Task
    [download resume];
    
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (error == nil) {
    NSLog(@"视频保存成功");
        hud.labelText = YZMsg(@"视频保存成功");
    }else{
    NSLog(@"视频保存失败");
        hud.labelText = YZMsg(@"视频保存失败");
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self animated:YES];
    });
     BOOL isOk = [[NSFileManager defaultManager] removeItemAtPath:[fullPathsss path] error:nil];
    NSLog(@"%d",isOk);
}
- (void)save:(NSString*)urlString{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL fileURLWithPath:urlString]
                                completionBlock:^(NSURL *assetURL, NSError *error) {
                                    if (error) {
                                        NSLog(@"Save video fail:%@",error);
                                    } else {
                                        NSLog(@"Save video succeed.");
                                    }
                                }];
}
-(void)cancel{
    self.cancleblock(NULL);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemarray.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoMore" forIndexPath:indexPath];
    UIImageView *imagevc = [[UIImageView alloc]initWithFrame:CGRectMake(20,20,_window_width/4 - 40,collectionvh - 40)];
    [imagevc setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_share_%@_%@",_itemarray[indexPath.row],[Config canshu]]]];
    imagevc.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imagevc];
    return cell;
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *fenxiang = _itemarray[indexPath.row];
    
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
//分享
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
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    int SSDKContentType = SSDKContentTypeAuto;
    NSURL *ParamsURL;

        NSString *titles = [_hostdic valueForKey:@"title"];

        if (titles.length == 0) {
            titles = [NSString stringWithFormat:@"%@%@",[[_hostdic valueForKey:@"userinfo"] valueForKey:@"user_nicename"],[common video_share_des]];
        }

        ParamsURL = [NSURL URLWithString:[h5url stringByAppendingFormat:@"/index.php?g=appapi&m=video&a=index&videoid=%@",[_hostdic valueForKey:@"id"]]];

        [shareParams SSDKSetupShareParamsByText:titles
                                         images:[_hostdic valueForKey:@"thumb_s"]
                                            url:ParamsURL
                                          title:[common video_share_title]
                                           type:SSDKContentType];
    if (SSDKPlatformType==SSDKPlatformTypeFacebook) {
        [shareParams SSDKEnableUseClientShare];
    }

    __weak videoMoewView *weakself = self;
    //进行分享
    [ShareSDK share:SSDKPlatformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [MBProgressHUD showSuccess:YZMsg(@"分享成功")];
                 [weakself addShare];
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
//举报
-(void)jubao{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.report"];
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken],
                             @"videoid":[NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"id"]],
                             @"content":YZMsg(@"涉嫌违规")
                             };
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                [MBProgressHUD showSuccess:YZMsg(@"感谢您的举报,我们会尽快作出处理")];
            }
            else{
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
}
//拉黑
-(void)setBlack:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.setBlack&uid=%@&token=%@&videoid=%@",[Config getOwnID],[Config getOwnToken],[NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"id"]]];

    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                [MBProgressHUD showSuccess:YZMsg(@"拉黑成功")];
                //刷新外部列表
                NSDictionary *dic = @{
                                      @"videoid":[NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"id"]]
                                      };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"delete" object:nil userInfo:dic];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.deleteblock(NULL);
                });
                
            }
            else{
                
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}
//删除
-(void)deletemovie:(UIButton *)sender{
     sender.userInteractionEnabled = NO;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.del"];
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken],
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
                [MBProgressHUD showSuccess:YZMsg(@"删除成功")];
                //刷新外部列表
                NSDictionary *dic = @{
                                      @"videoid":[NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"id"]]
                                      };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"delete" object:nil userInfo:dic];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.deleteblock(NULL);
                });
                
            }
            else{
                

                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}
-(void)addShare{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.addShare&uid=%@&videoid=%@",[Config getOwnID],[_hostdic valueForKey:@"id"]];

    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                
            self.shareblock([NSString stringWithFormat:@"%@",[info valueForKey:@"shares"]]);
           
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];

}
@end
