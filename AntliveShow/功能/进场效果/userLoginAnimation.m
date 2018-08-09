//
//  userLoginAnimation.m
//  AntliveShow
//
//  Created by 王敏欣 on 2017/2/21.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "userLoginAnimation.h"
@implementation userLoginAnimation
-(instancetype)init{
    self = [super init];
    if (self) {
        _isUserMove = 0;
        _userLogin = [NSMutableArray array];
    }
    return self;
}
-(void)addUserMove:(NSDictionary *)msg{
    
    if (msg == nil) {
        
        
        
    }
    else
    {
        [_userLogin addObject:msg];
    }
    if(_isUserMove == 0){
        [self userLoginOne];
    }
}
-(void)userLoginOne{
    
    if (_userLogin.count == 0 || _userLogin == nil) {
        return;
    }
    NSDictionary *Dic = [_userLogin firstObject];
    [_userLogin removeObjectAtIndex:0];
    [self userPlar:Dic];
}
/*
 vip_type 0表示无VIP，1表示普通VIP，2表示至尊VIP
 
 
 */
-(void)userPlar:(NSDictionary *)dic{
    UIColor *nameclor;
    
    
    //只有vip的时候 名字 紫红色 RGB(243, 94, 217)    背景 黄 (vip进场效果.png)
    //vip+坐骑     名字 黄    RGB(254, 249,84)     背景绿色(坐骑vip都有.png)
    //普通用户      名字 绿    RGB(65,212,131)      背景 橘黄（以前的不换图）
    
    //vip 蓝色至尊  红色普通
    _isUserMove = 1;
    _userMoveImageV = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width + 20,10, _window_width*0.8,40)];
    
    [self addSubview:_userMoveImageV];
    NSDictionary *ct = [dic valueForKey:@"ct"];
    _vipimage = [[UIImageView alloc]init];
    NSString *vip_type = minstr([ct valueForKey:@"vip_type"]);//vip
    NSString *car_id = minstr([ct valueForKey:@"car_id"]);//坐骑
    
    //蓝色至尊
    if ([vip_type isEqual:@"1"]) {
        [_vipimage setImage:[UIImage imageNamed:@"vip图标_1"]];
        _vipimage.frame = CGRectMake(2,-10,40,40);
        [_userMoveImageV setImage:[UIImage imageNamed:@"vip进场效果"]];
        nameclor = RGB(243, 94, 217);
        
        if (![car_id isEqual:@"0"]) {
             [_userMoveImageV setImage:[UIImage imageNamed:@"坐骑vip都有"]];
             nameclor = RGB(254, 249,84);
        }
        

    }
    //红色普通
    else  if ([vip_type isEqual:@"2"]) {
        [_vipimage setImage:[UIImage imageNamed:@"vip图标_2"]];
         _vipimage.frame = CGRectMake(2,-10,40,40);
        [_userMoveImageV setImage:[UIImage imageNamed:@"vip进场效果"]];
        nameclor = RGB(243, 94, 217);
        if (![car_id isEqual:@"0"]) {
            [_userMoveImageV setImage:[UIImage imageNamed:@"坐骑vip都有"]];
            nameclor = RGB(254, 249,84);
            
        }
        
     }
    else  if ([vip_type isEqual:@"0"]) {
    _vipimage.frame = CGRectZero;
    nameclor = backColor;
        if ([car_id isEqual:@"0"]) {
            [_userMoveImageV setImage:[UIImage imageNamed:@"userloginMove"]];
        }
        else{
            [_userMoveImageV setImage:[UIImage imageNamed:@"坐骑进场效果"]];
        }
        
     }
    
    
    UIImageView *levelImage = [[UIImageView alloc]initWithFrame:CGRectMake(_vipimage.right + 4,13,16,16)];
    [levelImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"leve%@",[ct valueForKey:@"level"]]]];
    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(levelImage.right + 5,5,200,30)];
    nameL.text = [NSString stringWithFormat:@"%@%@",[ct valueForKey:@"user_nicename"],YZMsg(@"进入房间")];
    nameL.textColor = [UIColor whiteColor];
    nameL.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:nameL.text];
    NSRange redRange = NSMakeRange(0, minstr([ct valueForKey:@"user_nicename"]).length);
    
    [noteStr addAttribute:NSForegroundColorAttributeName value:nameclor range:redRange];
    
    [noteStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:15] range:redRange];
    
    [nameL setAttributedText:noteStr];
    [_userMoveImageV addSubview:_vipimage];
    [_userMoveImageV addSubview:levelImage];
    [_userMoveImageV addSubview:nameL];
    [UIView animateWithDuration:1.5 animations:^{
        _userMoveImageV.frame = CGRectMake(-15,10,_window_width*0.8,40);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            _userMoveImageV.frame = CGRectMake(-15,10,_window_width*0.8,40);
            _userMoveImageV.alpha = 0;
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_userMoveImageV removeFromSuperview];
        _userMoveImageV = nil;
        _userMoveImageV = 0;
        _isUserMove = 0;
        if (_userLogin.count >0) {
            [self addUserMove:nil];
        }
    });
}
@end
