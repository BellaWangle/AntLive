//
//  toutiaoAnimation.m
//  iphoneLive
//
//  Created by Boom on 2017/6/16.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "toutiaoAnimation.h"

@implementation toutiaoAnimation{
}

-(instancetype)init{
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        _isUserMove = 0;
        _userLogin = [NSMutableArray array];
        
        _isDelloc = NO;
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
-(void)userPlar:(NSDictionary *)dic{
    _isUserMove = 1;
    _toutiaoMoveImageV = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width + 20,0, _window_width,20)];
//    [_toutiaoMoveImageV setImage:[UIImage imageNamed:@"userloginMove"]];//vehicle_bg_tail.9
    [self addSubview:_toutiaoMoveImageV];

    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(0,5,_window_width,20)];
    nameL.textColor = [UIColor whiteColor];
    nameL.font = fontThin(11);
//    NSString *oldStr = [NSString stringWithFormat:@"恭喜%@玩砸金蛋获得一个%@",[dic valueForKey:@"uname"],[dic valueForKey:@"giftname"]];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@ %@ %@",YZMsg(@"恭喜"),[dic valueForKey:@"uname"],YZMsg(@"玩砸金蛋获得一个"),[dic valueForKey:@"giftname"]]];
    NSRange redRange = NSMakeRange([YZMsg(@"恭喜") length], [[dic valueForKey:@"uname"] length]);
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.980 green:0.361 blue:0.604 alpha:1.00] range:redRange];
    NSRange redRange2 = NSMakeRange(string.length - [[dic valueForKey:@"giftname"] length], [[dic valueForKey:@"giftname"] length]);
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.980 green:0.361 blue:0.604 alpha:1.00] range:redRange2];
    // 创建图片图片附件
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"gifticon"]]]]];
    attach.bounds = CGRectMake(0, -4, 15, 15);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    
    
    [string appendAttributedString:attachString];
    nameL.attributedText = string;
    

    [_toutiaoMoveImageV addSubview:nameL];
    [UIView animateWithDuration:0.5 animations:^{
        _toutiaoMoveImageV.frame = CGRectMake(_window_width/2,0,_window_width,20);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:5.0 animations:^{
            _toutiaoMoveImageV.frame = CGRectMake(-_window_width/2,0,_window_width,20);
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            _toutiaoMoveImageV.frame = CGRectMake(-_window_width,0,_window_width,20);
        } completion:^(BOOL finished) {
            [_toutiaoMoveImageV removeFromSuperview];
            _toutiaoMoveImageV = nil;
            _isUserMove = 0;
            if (_userLogin.count >0) {
                [self addUserMove:nil];

            }else{
                if (!_isDelloc) {
                    [self.delegate bofangjieshu];
                }

            }
        }];
        
    });
}
- (void)dealloc{
}
@end
