//
//  zajindan.m
//  iphoneLive
//
//  Created by Boom on 2017/7/25.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "goldEggs.h"
#import "tributeView.h"
@implementation goldEggs{
    NSString *_liveID;
    int index;
    UIImageView *chuiziImage;
    UIImageView *dandan;
    UIButton *jinchuiziBtn;
    UIButton *yinchuiziBtn;
    UIButton *muchuiziBtn;
    NSInteger taggggg;
    UILabel *laebl;
    NSTimer *anmationTimer;
    int anmationCount;
    UIButton *closeBtn;
    NSMutableArray *imageArr;
    float time;
    NSArray *chuiziArr;
    NSMutableArray *attStrArr;
    UIButton *fiveBtn;
    UIButton *tenBtn;
}

-(instancetype)initWithLiveId:(NSString *)liveid andChuiziArray:(NSArray *)array{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, _window_width, _window_height);
        _liveID = liveid;
        index = 1;
        imageArr = [NSMutableArray array];
        chuiziArr = array;
        for (int i = 1; i<13; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dandan_%d",i]];
            [imageArr addObject:image];
        }
        [self creatUI];
        
    }
    return self;
}

- (void)creatUI{
    //五连砸
    fiveBtn = [UIButton buttonWithType:0];
    fiveBtn.tag = 100;
    [fiveBtn addTarget:self action:@selector(lianxuza:) forControlEvents:UIControlEventTouchUpInside];
    [fiveBtn setImage:[UIImage imageNamed:getImagename(@"five")] forState:0];
    [fiveBtn setImage:[UIImage imageNamed:getImagename(@"five_select")] forState:UIControlStateSelected];
    [self addSubview:fiveBtn];
    [fiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-0.07*_window_height);
        make.width.equalTo(self).with.multipliedBy(0.35);
        make.height.equalTo(fiveBtn.mas_width).with.multipliedBy(0.333);
        make.right.equalTo(self.mas_right).with.offset(-0.1*_window_width);
    }];
    //十连砸
    tenBtn = [UIButton buttonWithType:0];
    tenBtn.tag = 101;
    [tenBtn addTarget:self action:@selector(lianxuza:) forControlEvents:UIControlEventTouchUpInside];
    [tenBtn setImage:[UIImage imageNamed:getImagename(@"ten")] forState:0];
    [tenBtn setImage:[UIImage imageNamed:getImagename(@"ten_select")] forState:UIControlStateSelected];
    [self addSubview:tenBtn];
    [tenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-0.07*_window_height);
        make.width.equalTo(self).with.multipliedBy(0.35);
        make.height.equalTo(fiveBtn.mas_width).with.multipliedBy(0.333);
        make.left.equalTo(self).with.offset(0.1*_window_width);
    }];
    UILabel *label1 = [[UILabel alloc]init];
    label1.backgroundColor = [UIColor colorWithRed:0.980 green:0.361 blue:0.604 alpha:1.00];
    label1.numberOfLines = 2;
    label1.font = fontThin(11);
    label1.tag = 102;
    label1.text = [NSString stringWithFormat:@"%@%@/%@\n%@:%@",[chuiziArr[0] valueForKey:@"hammer_price"],[common name_coin],YZMsg(@"锤"),YZMsg(@"头奖"),[chuiziArr[0] valueForKey:@"giftname"]];
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.adjustsFontSizeToFitWidth = YES;
    [self addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(tenBtn.mas_height);
        make.bottom.equalTo(self).with.offset(-0.16*_window_height);
        make.width.equalTo(label1.mas_height).with.multipliedBy(2);
        make.left.equalTo(self).with.offset(0.1*_window_width);
    }];
    UILabel *label2 = [[UILabel alloc]init];
    label2.backgroundColor = [UIColor colorWithRed:0.980 green:0.361 blue:0.604 alpha:1.00];
    label2.numberOfLines = 2;
    label2.font = fontThin(11);
    label2.tag = 103;
    label2.text = [NSString stringWithFormat:@"%@%@/%@\n%@:%@",[chuiziArr[1] valueForKey:@"hammer_price"],[common name_coin],YZMsg(@"锤"),YZMsg(@"头奖"),[chuiziArr[1] valueForKey:@"giftname"]];
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.adjustsFontSizeToFitWidth = YES;
    [self addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(label1.mas_height);
        make.bottom.equalTo(label1.mas_bottom);
        make.width.equalTo(label2.mas_height).with.multipliedBy(2);
        make.centerX.equalTo(self).with.multipliedBy(1);
    }];
    UILabel *label3 = [[UILabel alloc]init];
    label3.backgroundColor = [UIColor colorWithRed:0.980 green:0.361 blue:0.604 alpha:1.00];
    label3.numberOfLines = 2;
    label3.font = fontThin(11);
    label3.tag = 104;
    label3.text = [NSString stringWithFormat:@"%@%@/%@\n%@:%@",[chuiziArr[2] valueForKey:@"hammer_price"],[common name_coin],YZMsg(@"锤"),YZMsg(@"头奖"),[chuiziArr[2] valueForKey:@"giftname"]];
    label3.textColor = [UIColor whiteColor];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.adjustsFontSizeToFitWidth = YES;
    [self addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(label1.mas_height);
        make.bottom.equalTo(label1.mas_bottom);
        make.width.equalTo(label3.mas_height).with.multipliedBy(2);
        make.right.equalTo(self).with.offset(-0.1*_window_width);
    }];
    //
    jinchuiziBtn = [UIButton buttonWithType:0];
    jinchuiziBtn.tag = 105;
    [jinchuiziBtn addTarget:self action:@selector(za:) forControlEvents:UIControlEventTouchUpInside];
    [jinchuiziBtn setImage:[UIImage imageNamed:@"jinchuizi"] forState:0];
    [self addSubview:jinchuiziBtn];
    [jinchuiziBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(label3.mas_width);
        make.bottom.equalTo(label3.mas_top).with.offset(-0.03*_window_height);
        make.width.equalTo(label3.mas_width);
        make.left.equalTo(label1.mas_left);
    }];
    //
    yinchuiziBtn = [UIButton buttonWithType:0];
    yinchuiziBtn.tag = 106;
    [yinchuiziBtn addTarget:self action:@selector(za:) forControlEvents:UIControlEventTouchUpInside];
    [yinchuiziBtn setImage:[UIImage imageNamed:@"yinchuizi"] forState:0];
    [self addSubview:yinchuiziBtn];
    [yinchuiziBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(label3.mas_width);
        make.bottom.equalTo(label3.mas_top).with.offset(-0.03*_window_height);
        make.width.equalTo(label3.mas_width);
        make.left.equalTo(label2.mas_left);
    }];
    //
    muchuiziBtn = [UIButton buttonWithType:0];
    muchuiziBtn.tag = 107;
    [muchuiziBtn addTarget:self action:@selector(za:) forControlEvents:UIControlEventTouchUpInside];
    [muchuiziBtn setImage:[UIImage imageNamed:@"muchuizi"] forState:0];
    [self addSubview:muchuiziBtn];
    [muchuiziBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(label3.mas_width);
        make.bottom.equalTo(label3.mas_top).with.offset(-0.03*_window_height);
        make.width.equalTo(label3.mas_width);
        make.left.equalTo(label3.mas_left);
    }];
//
    dandan = [[UIImageView alloc]init];
    dandan.image = [UIImage imageNamed:@"dandan"];
    dandan.userInteractionEnabled = YES;
    [self addSubview:dandan];
    [dandan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(jinchuiziBtn.mas_top).with.offset(-0.05*_window_height);
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(dandan.mas_width);
    }];
    
    chuiziImage = [[UIImageView alloc]init];
    chuiziImage.backgroundColor = [UIColor clearColor];
    
//    chuiziImage.image = [UIImage imageNamed:@"muchuizi"];
    [self addSubview:chuiziImage];
    [chuiziImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dandan.mas_right).with.offset(-0.35*_window_width);
        make.centerY.equalTo(dandan).with.multipliedBy(1.5);
        make.width.equalTo(muchuiziBtn.mas_width);
        make.height.equalTo(muchuiziBtn.mas_width);
    }];
//    chuiziImage.transform=CGAffineTransformMakeRotation(-M_PI/8);
    //
    closeBtn = [UIButton buttonWithType:0];
    [closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"dandan_close"] forState:0];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0.2*_window_height);
        make.right.equalTo(self).with.offset(-0.1*_window_width);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    [self layoutIfNeeded];
    label1.layer.masksToBounds = YES;
    label1.layer.cornerRadius = label1.height/3;
    label2.layer.masksToBounds = YES;
    label2.layer.cornerRadius = label1.height/3;
    label3.layer.masksToBounds = YES;
    label3.layer.cornerRadius = label1.height/3;
    closeBtn.layer.masksToBounds = YES;
    closeBtn.layer.cornerRadius = 15;
}
-(void)lianxuza:(UIButton *)button{
    if (button.tag==100) {
        UIButton *btn = (UIButton *)[self viewWithTag:101];
        btn.selected = NO;
        button.selected = !button.selected;
        if (button.selected) {
            index = 5;
        }else{
            index = 1;
        }
    }else{
        UIButton *btn = (UIButton *)[self viewWithTag:100];
        btn.selected = NO;
        button.selected = !button.selected;
        if (button.selected) {
            index = 10;
        }else{
            index = 1;

        }
    }
}
- (void)za:(UIButton *)button{
    yinchuiziBtn.userInteractionEnabled = NO;
    muchuiziBtn.userInteractionEnabled = NO;
    jinchuiziBtn.userInteractionEnabled = NO;
    closeBtn.userInteractionEnabled = NO;
    fiveBtn.userInteractionEnabled = NO;
    tenBtn.userInteractionEnabled = NO;
    attStrArr = [NSMutableArray array];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Goldeneggs.hitGoldeneggs"];
    
    NSDictionary *parameterDic = @{
                                   @"uid":[Config getOwnID],
                                   @"token":[Config getOwnToken],
                                   @"hammernum":[NSString stringWithFormat:@"%d",index],
                                   @"hammertype":[chuiziArr[button.tag-105] valueForKey:@"hammer_type"]
                                   };
    
    [session POST:url parameters:parameterDic
         progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
             NSNumber *number = [responseObject valueForKey:@"ret"] ;
             if([number isEqualToNumber:[NSNumber numberWithInt:200]])
             {
                 NSArray *data = [responseObject valueForKey:@"data"];
                 NSNumber *code = [data valueForKey:@"code"];
                 if([code isEqualToNumber:[NSNumber numberWithInt:0]])
                 {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"zajindanle" object:nil];
                     tributeView *giftView = [[tributeView alloc]init];
                     LiveUser *liveUser = [Config myProfile];
                     liveUser.coin = [NSString stringWithFormat:@"%d",[liveUser.coin intValue]-[[chuiziArr[button.tag-105] valueForKey:@"hammer_price"] intValue]*index];
                     [Config updateProfile:liveUser];
                     [giftView chongzhiV:liveUser.coin];
                     NSArray *info = [data valueForKey:@"info"];
                     for (NSDictionary *dic in info) {
                         NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:YZMsg(@"获得")];
                         
                         // 创建图片图片附件
                         NSTextAttachment *attach = [[NSTextAttachment alloc] init];
                         attach.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:minstr([dic valueForKey:@"gifticon"])]]];
                         NSLog(@"%@",[NSString stringWithFormat:@"%@%@",h5url,[dic valueForKey:@"gifticon"]]);
                         attach.bounds = CGRectMake(0, -3, 20, 20);
                         NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
                         
                         
                         [string appendAttributedString:attachString];
                         
                         [string appendAttributedString:[[NSAttributedString alloc] initWithString:YZMsg(@"一个")]];
                         [attStrArr addObject:string];
                         if ([[dic valueForKey:@"gold_type"] intValue] == 1) {
                             [self.delegate zhongjianla:dic];
                         }
                     }

                         anmationCount = index-1;
                     
                         laebl = [[UILabel alloc]initWithFrame:CGRectMake(0, dandan.height*0.75, dandan.width, 20)];
                         laebl.tag = 1000;
                         laebl.textColor = [UIColor redColor];
                         laebl.font = fontThin(15);
                         laebl.textAlignment = NSTextAlignmentCenter;
                         laebl.hidden = YES;
                         laebl.attributedText = attStrArr[0];
                         [dandan addSubview:laebl];
                     
                     
                     
                         button.hidden = YES;
                         button.y -=70;
                         chuiziImage.hidden = NO;
                         
                         if (button.tag == 105) {
                             chuiziImage.image = [UIImage imageNamed:@"jinchuizi"];
                         }else if (button.tag == 106) {
                             chuiziImage.image = [UIImage imageNamed:@"yinchuizi"];
                         }else if (button.tag == 107) {
                             chuiziImage.image = [UIImage imageNamed:@"muchuizi"];
                         }
                     
                         [UIView animateWithDuration:0.1 animations:^{
                             chuiziImage.transform=CGAffineTransformMakeRotation(-M_PI/4);
                             
                         }];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];
                         
                         shakeAnim.keyPath = @"transform.translation.x";
                         
                         shakeAnim.duration = 0.1;
                         
                         CGFloat delta = 10;
                         
                         shakeAnim.values = @[@0 , @(-delta), @(delta), @0];
                         
                         shakeAnim.repeatCount = 2;
                         
                         [dandan.layer addAnimation:shakeAnim forKey:nil];
//                         [UIView animateWithDuration:0.025 animations:^{
//                             dandan.transform=CGAffineTransformMakeRotation(M_PI/8);
//                             
//                         }];
//                         [UIView animateWithDuration:0.05 animations:^{
//                             dandan.transform=CGAffineTransformMakeRotation(-M_PI/8);
//                             
//                         }];
//                         [UIView animateWithDuration:0.025 animations:^{
//                             dandan.transform=CGAffineTransformMakeRotation(0);
//                             
//                         }];
                     });
                     if (index == 10) {
                         time = 5.0;
                     }else if (index == 5) {
                         time = 2.5;
                     }else{
                         time = 1.2;
                     }

                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             
                             //        CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
                             //        shake.fromValue = [NSNumber numberWithFloat:-5];
                             //        shake.toValue = [NSNumber numberWithFloat:5];
                             //        shake.duration = 0.1;//执行时间
                             //        shake.autoreverses = YES; //是否重复
                             //        shake.repeatCount = 2;//次数
                             //        [dandan.layer addAnimation:shake forKey:@"shakeAnimation"];
                             
                             dandan.animationImages = imageArr;
                             dandan.animationRepeatCount = 1;
                             
                             
                             
                             dandan.animationDuration = time;
                             [dandan startAnimating];
                             
                             
                             if (!anmationTimer && index != 1) {
                                 anmationTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeLabel) userInfo:nil repeats:YES];
                             }
                             
                             laebl.hidden = NO;
                             CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///.y的话就向下移动。
                             NSNumber *tovalue = [NSNumber numberWithFloat:-(dandan.height/3)];
                             animation.toValue = tovalue;
                             animation.duration = 0.5;
                             animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
                             animation.repeatCount = index;
                             animation.fillMode = kCAFillModeForwards;
                             animation.delegate = self;
                             [laebl.layer addAnimation:animation forKey:nil];
                             
                         });
                     float aaa = 0.6 + time;

                         NSLog(@"------++++++-----%.2f===========%d",aaa,index);
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(aaa * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             
                             chuiziImage.transform=CGAffineTransformMakeRotation(0);
                             chuiziImage.hidden = YES;
                             button.hidden = NO;
                             yinchuiziBtn.userInteractionEnabled = YES;
                             muchuiziBtn.userInteractionEnabled = YES;
                             jinchuiziBtn.userInteractionEnabled = YES;
                             closeBtn.userInteractionEnabled = YES;
                             fiveBtn.userInteractionEnabled = YES;
                             tenBtn.userInteractionEnabled = YES;
                             dandan.image = [UIImage imageNamed:@"dandan"];
                             [UIView animateWithDuration:0.1 animations:^{
                                 button.y+=70;
                             }];
                         });

                     
                 }else if([code isEqualToNumber:[NSNumber numberWithInt:1001]]){
                     [self.delegate goChongZhi];
                     yinchuiziBtn.userInteractionEnabled = YES;
                     muchuiziBtn.userInteractionEnabled = YES;
                     jinchuiziBtn.userInteractionEnabled = YES;
                     closeBtn.userInteractionEnabled = YES;
                     fiveBtn.userInteractionEnabled = YES;
                     tenBtn.userInteractionEnabled = YES;

                 }else if([code isEqualToNumber:[NSNumber numberWithInt:1003]]){
                     button.hidden = YES;
                     button.y -=70;
                     chuiziImage.hidden = NO;
                     
                     if (button.tag == 105) {
                         chuiziImage.image = [UIImage imageNamed:@"jinchuizi"];
                     }else if (button.tag == 106) {
                         chuiziImage.image = [UIImage imageNamed:@"yinchuizi"];
                     }else if (button.tag == 107) {
                         chuiziImage.image = [UIImage imageNamed:@"muchuizi"];
                     }
                     
                     [UIView animateWithDuration:0.1 animations:^{
                         chuiziImage.transform=CGAffineTransformMakeRotation(-M_PI/4);
                         
                     }];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];
                         
                         shakeAnim.keyPath = @"transform.translation.x";
                         
                         shakeAnim.duration = 0.1;
                         
                         CGFloat delta = 10;
                         
                         shakeAnim.values = @[@0 , @(-delta), @(delta), @0];
                         
                         shakeAnim.repeatCount = 2;
                         
                         [dandan.layer addAnimation:shakeAnim forKey:nil];
                         dandan.image = [UIImage imageNamed:@"dandan_12"];
                     });

                     UILabel *nolaebl = [[UILabel alloc]initWithFrame:CGRectMake(0, dandan.height*0.75-70, dandan.width, 20)];
                     nolaebl.textColor = [UIColor redColor];
                     nolaebl.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
                     nolaebl.textAlignment = NSTextAlignmentCenter;
                     nolaebl.text = minstr([data valueForKey:@"msg"]);
                     [dandan addSubview:nolaebl];

                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [nolaebl removeFromSuperview];
                         chuiziImage.transform=CGAffineTransformMakeRotation(0);
                         chuiziImage.hidden = YES;
                         button.hidden = NO;
                         yinchuiziBtn.userInteractionEnabled = YES;
                         muchuiziBtn.userInteractionEnabled = YES;
                         jinchuiziBtn.userInteractionEnabled = YES;
                         closeBtn.userInteractionEnabled = YES;
                         fiveBtn.userInteractionEnabled = YES;
                         tenBtn.userInteractionEnabled = YES;
                         dandan.image = [UIImage imageNamed:@"dandan"];
                         [UIView animateWithDuration:0.1 animations:^{
                             button.y+=70;
                         }];
                     });

                 }else{
                     [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]]];
                     yinchuiziBtn.userInteractionEnabled = YES;
                     muchuiziBtn.userInteractionEnabled = YES;
                     jinchuiziBtn.userInteractionEnabled = YES;
                     closeBtn.userInteractionEnabled = YES;
                     fiveBtn.userInteractionEnabled = YES;
                     tenBtn.userInteractionEnabled = YES;

                 }
             }
             
         }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         yinchuiziBtn.userInteractionEnabled = YES;
         muchuiziBtn.userInteractionEnabled = YES;
         jinchuiziBtn.userInteractionEnabled = YES;
         closeBtn.userInteractionEnabled = YES;
         fiveBtn.userInteractionEnabled = YES;
         tenBtn.userInteractionEnabled = YES;
         [MBProgressHUD showError:YZMsg(@"无网络")];
        
     }];
    

    
    
    


    }
- (void)hide{
    self.transform = CGAffineTransformMakeScale(1, 1);
//    self.alpha = 1;
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [rootWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }];

}
- (void)changeLabel{
    anmationCount--;

    laebl.attributedText = attStrArr[index - anmationCount-1];

    if (anmationCount == 0) {
        [anmationTimer invalidate];
        anmationTimer = nil;
    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [laebl.layer removeAllAnimations];
        [laebl removeFromSuperview];
        laebl = nil;
    });
    
}

@end
