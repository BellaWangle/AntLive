//
//  YBNavi.m
//  WaWaJiClient
//
//  Created by Rookie on 2017/11/19.
//  Copyright © 2017年 zego. All rights reserved.
//

#import "AntNavi.h"

@interface AntNavi ()
{
    BOOL isImg;
}
@property (nonatomic,copy) btnBlock leftBack;
@property (nonatomic,copy) btnBlock rightBack;
@end

@implementation AntNavi

- (instancetype)init
{
    self = [super init];
    if (self) {
        isImg = NO;
        [self creatUI];
    }
    return self;
}
-(void)creatUI {
    self.frame = CGRectMake(0, 0, _window_width, 64 + statusbarHeight);
}

//中间图片
-(void)ybNaviLeftName:(NSString *)imgL andLeft:(btnBlock)leftBtn andRightName:(NSString *)imgN andRight:(btnBlock)rightBtn andMidImg:(NSString *)imgName {
    isImg = YES;
    [self publicLeftName:imgL leftBtn:leftBtn rightName:imgN rightBtn:rightBtn mid:imgName];
}
//中间文字
-(void)ybNaviLeftName:(NSString *)imgL andLeft:(btnBlock)leftBtn andRightName:(NSString *)imgN andRight:(btnBlock)rightBtn andMidTitle:(NSString *)midTitle {
    isImg = NO;
    [self publicLeftName:imgL leftBtn:leftBtn rightName:imgN rightBtn:rightBtn mid:midTitle];
}
//公共方法
-(void)publicLeftName:(NSString *)imgL leftBtn:(btnBlock)leftB rightName:(NSString *)imgR rightBtn:(btnBlock)rightB mid:(NSString *)mid{
    
    _leftBack = leftB;
    _rightBack = rightB;
    
    UIImageView *bgi = [[UIImageView alloc]initWithFrame:self.frame];
    bgi.image = [UIImage imageNamed:@"login_navi"];
    bgi.contentMode = UIViewContentModeScaleAspectFill;
    bgi.clipsToBounds = YES;
    bgi.userInteractionEnabled = YES;
    [self addSubview:bgi];
    //左
    UIButton *left_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    left_btn.frame = CGRectMake(10, 22+statusbarHeight, 40, 40);
    left_btn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [left_btn setImage:[UIImage imageNamed:imgL] forState:0];
    [left_btn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgi addSubview:left_btn];
    left_btn.hidden = _leftHidden;
    //左shadow
    UIButton *left_s_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    left_s_btn.frame = CGRectMake(0, 0, 64, 64+statusbarHeight);
    [left_s_btn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    left_s_btn.backgroundColor = [UIColor clearColor];
    [bgi addSubview:left_s_btn];
    left_s_btn.hidden = _leftHidden;
    //中
    if (isImg == YES) {//130.7 * 40
        UIImageView * midIV = [[UIImageView alloc]init];
        midIV.frame = CGRectMake((_window_width-130.7)/2, 22+statusbarHeight, 130.7, 40);
        midIV.image = [UIImage imageNamed:@"logo1"];
        midIV.contentMode = UIViewContentModeScaleAspectFit;
        midIV.clipsToBounds = YES;
        [bgi addSubview:midIV];
    }else {
        UILabel *midL = [[UILabel alloc]init];
        midL.text = mid;
        midL.textAlignment = NSTextAlignmentCenter;
        midL.frame = CGRectMake(_window_width/2-50, 22+statusbarHeight, 100, 40);
        midL.textColor = [UIColor whiteColor];
        midL.font = [UIFont systemFontOfSize:17];
        [bgi addSubview:midL];
        self.H5TL = midL; //H5专用
    }
    //右
    UIButton *right_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    right_btn.frame = CGRectMake(_window_width-50, 22+statusbarHeight, 40, 40);
    right_btn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [right_btn setImage:[UIImage imageNamed:imgR] forState:0];
    [right_btn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgi addSubview:right_btn];
    right_btn.hidden = _rightHidden;
    //右shadow
    UIButton *right_s_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    right_s_btn.frame = CGRectMake(_window_width-64, 0, 64, 64+statusbarHeight);
    [right_s_btn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    right_s_btn.backgroundColor = [UIColor clearColor];
    [bgi addSubview:right_s_btn];
    right_s_btn.hidden = _rightHidden;
    
}
-(void)clickLeftBtn {
    self.leftBack(nil);
}
-(void)clickRightBtn {
    self.rightBack(nil);
}
@end
