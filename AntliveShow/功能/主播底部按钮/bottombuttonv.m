//
//  bottombuttonv.m
//  AntliveShow
//
//  Created by 王敏欣 on 2017/8/2.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "bottombuttonv.h"
@interface bottombuttonv ()
{
    UIView *bottomv;
    BOOL canFEE;
}
@property(nonatomic,strong)NSMutableArray *buttonarray;
@end
@implementation bottombuttonv
-(instancetype)initWithFrame:(CGRect)frame music:(buttonblock)music meiyan:(buttonblock)meiyan coast:(buttonblock)coast light:(buttonblock)light camera:(buttonblock)camera game:(buttonblock)game jingpai:(buttonblock)jingpai showjingpai:(NSString *)isjingpai showgame:(NSArray *)gametypearray showcoase:(int)coastshow hideself:(buttonblock)hide and:(BOOL)canFee{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _buttonarray = [NSMutableArray array];
        self.musicblock = music;
        self.gameblock = game;
        self.lightblock = light;
        self.meiyanblock = meiyan;
        self.coastblock = coast;
        self.camerablock = camera;
        self.jingpaiblock = jingpai;
        self.hideselfblock = hide;
        canFEE = canFee;//是不是显示计时收费按钮
        
        bottomv = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height - _window_width/5 * 3.5, _window_width, _window_width/5 * 3.5)];
        
        
        bottomv.backgroundColor = [UIColor whiteColor];
        bottomv.layer.cornerRadius = 5;
        bottomv.layer.masksToBounds = YES;
        [self addSubview:bottomv];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, _window_width,40)];
        label1.font = fontMT(17);
        label1.text = YZMsg(@"功能");
        label1.textColor = RGB(92, 92, 92);
        [bottomv addSubview:label1];
        
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20,40, _window_width - 40,1)];
        label2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [bottomv addSubview:label2];
        
        
        //图片名字 命名
//        _buttonarray =[NSMutableArray arrayWithObjects: @"coast-button",@"beaytiful-button",@"Flip-button",@"music-button",@"game-button",@"Auction-button",@"light-button", nil];
        
        _buttonarray = [NSMutableArray arrayWithObjects:getImagename(@"icon_live_function_time"),getImagename(@"icon_live_function_meiyan"),getImagename(@"icon_live_function_camera"),getImagename(@"icon_live_function_music"),getImagename(@"icon_live_function_game"),getImagename(@"icon_live_function_auction"),getImagename(@"icon_live_function_flash"), nil];
        //判断如果游戏数量为0 则不添加游戏按钮
        if (gametypearray.count == 0) {
            [_buttonarray removeObject:getImagename(@"icon_live_function_game")];
        }
        
        //判断是否显示竞拍 1 显示， 其他 不显示
        if (![isjingpai isEqual:@"1"]) {
             [_buttonarray removeObject:getImagename(@"icon_live_function_auction")];
        }
        
        //判断是否显示收费 1 不显示 其他 显示
        if (coastshow == 1) {
            [_buttonarray removeObject:getImagename(@"icon_live_function_time")];
        }
        
        if (canFee == NO) {
             [_buttonarray removeObject:getImagename(@"icon_live_function_time")];
        }
        
        CGFloat X = 0;
        CGFloat Y = 50;
        for (int i=0; i<_buttonarray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:0];
            [btn setTitle:_buttonarray[i] forState:0];
            [btn setImage:[UIImage imageNamed:_buttonarray[i]] forState:0];
            btn.imageEdgeInsets = UIEdgeInsetsMake(17, 17, 17, 17);
            btn.backgroundColor = [UIColor clearColor];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [btn addTarget:self action:@selector(doaction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor clearColor] forState:0];
            btn.frame = CGRectMake(X, Y, _window_width/5, _window_width/5);
            [bottomv addSubview:btn];
            X+=_window_width/5;
            if (X > _window_width/5 * 4) {
                X = 0;
                Y += _window_width/5;
            }
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
-(void)hide{
    self.hideselfblock(@"1");
}
-(void)hidebtn{
    for (UIButton *btn in bottomv.subviews) {
          if ([btn isKindOfClass:[UIButton class]]) {
              
        if ([btn.titleLabel.text isEqual:getImagename(@"icon_live_function_auction")]) {
            btn.hidden = YES;
        }
              
          }
    }
}
-(void)showbtn{
    for (UIButton *btn in bottomv.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
        if ([btn.titleLabel.text isEqual:getImagename(@"icon_live_function_auction")]) {
            btn.hidden = NO;
        }
    }
    }
}
-(void)doaction:(UIButton *)sender{

    if ([sender.titleLabel.text isEqual:getImagename(@"icon_live_function_time")]) {
        self.coastblock(@"1");
    }
    else if ([sender.titleLabel.text isEqual:getImagename(@"icon_live_function_meiyan")]) {
        self.meiyanblock(@"1");
    }
    else if ([sender.titleLabel.text isEqual:getImagename(@"icon_live_function_camera")]) {
        self.camerablock(@"1");
    }
    else if ([sender.titleLabel.text isEqual:getImagename(@"icon_live_function_music")]) {
        self.musicblock(@"1");
    }
    else if ([sender.titleLabel.text isEqual:getImagename(@"icon_live_function_game")]) {
        self.gameblock(@"1");
    }
    else if ([sender.titleLabel.text isEqual:getImagename(@"icon_live_function_auction")]) {
        self.jingpaiblock(@"1");
    }
    else if ([sender.titleLabel.text isEqual:getImagename(@"icon_live_function_flash")]) {
        self.lightblock(@"1");
    }
    self.hideselfblock(@"1");
}
@end
