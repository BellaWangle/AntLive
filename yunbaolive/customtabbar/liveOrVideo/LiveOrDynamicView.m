//
//  LiveOrDynamicView.m
//  iphoneLive
//
//  Created by Rookie on 2017/7/8.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "LiveOrDynamicView.h"
@interface LiveOrDynamicView()
{
    UIView *bottomv;
}
@property (nonatomic,copy) BtnCallBack liveBlock;
@property (nonatomic,copy) BtnCallBack dynamicBlock;
@property (nonatomic,copy) BtnCallBack cancelBlock;

@property (nonatomic,strong) UIButton *dynamicBtn;
@property (nonatomic,strong) UILabel *dynamicL;
@property (nonatomic,strong) UIButton *liveBtn;
@property (nonatomic,strong) UILabel *liveL;
@property (nonatomic,strong) UIButton *cancelBtn;

@end

@implementation LiveOrDynamicView

- (instancetype)initWithFrame:(CGRect)frame andLiveBtn:(BtnCallBack)live andDynamicBtn:(BtnCallBack)dynamic andCancelBtn:(BtnCallBack)cancel{
    self = [super initWithFrame:frame];
    if (self) {
        
        _liveBlock = live;
        _dynamicBlock = dynamic;
        _cancelBlock = cancel;
        
        [self creatUI];
        [self layoutBtn];
    }
    return self;
}
-(void)creatUI {
    
    bottomv = [[UIView alloc] initWithFrame:CGRectMake(0, _window_height*3/4, _window_width, _window_height/4)];
    bottomv.backgroundColor = RGB(242, 242, 242);
    [self addSubview:bottomv];
    
    
    UIButton *dBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [dBtn setImage:[UIImage imageNamed:@"发起直播"] forState:UIControlStateNormal];
    [dBtn addTarget:self action:@selector(doLiveBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomv addSubview:dBtn];
    self.dynamicBtn = dBtn;
    
    UILabel *dL = [[UILabel alloc]init];
    dL.text = YZMsg(@"直播");
    dL.textAlignment = NSTextAlignmentCenter;
    dL.font = fontMT(15.0);
    dL.textColor = [UIColor grayColor];
    [bottomv addSubview:dL];
    self.dynamicL = dL;
    
    UIButton *lBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lBtn setImage:[UIImage imageNamed:@"发起录制视频"] forState:UIControlStateNormal];
    [lBtn addTarget:self action:@selector(doDynamicBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomv addSubview:lBtn];
    self.liveBtn = lBtn;
    
    UILabel *lL = [[UILabel alloc]init];
    lL.text = YZMsg(@"视频");
    lL.textAlignment = NSTextAlignmentCenter;
    lL.font = fontMT(15.0);
    lL.textColor = [UIColor grayColor];
    [bottomv addSubview:lL];
    self.liveL = lL;
    
    UIButton *cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [cBtn addTarget:self action:@selector(doCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomv addSubview:cBtn];
    self.cancelBtn = cBtn;
    
}
-(void)doDynamicBtn {
    self.dynamicBlock();
}
-(void)doLiveBtn {
    self.liveBlock();
}
-(void)doCancelBtn {
    self.cancelBlock();
}
-(void)layoutBtn {
    [self.dynamicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.top.mas_equalTo(bottomv.mas_top).offset(20);
//        make.left.mas_equalTo(bottomv.mas_left).offset((bottomv.width-100)/3);
        make.centerX.equalTo(bottomv).multipliedBy(0.65);
    }];
    [self.dynamicL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.dynamicBtn.mas_bottom).offset(10);
//        make.left.mas_equalTo(bottomv.mas_left).offset((bottomv.width-100)/3);
        make.centerX.equalTo(bottomv).multipliedBy(0.65);

    }];
    [self.liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.top.mas_equalTo(bottomv.mas_top).offset(20);
//        make.right.mas_equalTo(bottomv.mas_right).offset(-(bottomv.width-100)/3);
        make.centerX.equalTo(bottomv).multipliedBy(1.35);

    }];
    [self.liveL mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.liveBtn.mas_bottom).offset(10);
//        make.right.mas_equalTo(bottomv.mas_right).offset(-(bottomv.width-100)/3);
        make.centerX.equalTo(bottomv).multipliedBy(1.35);

    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerX.mas_equalTo(bottomv.mas_centerX).offset(0);
        make.bottom.mas_equalTo(bottomv.mas_bottom).offset(-(bottomv.height-120)/2);
    }];
}
@end
