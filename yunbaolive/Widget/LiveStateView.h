//
//  LiveStateView.h
//  AntLive
//
//  Created by 毅力起 on 2018/8/30.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveTypeView : UIView

-(instancetype)initWithBig;

@property (nonatomic, assign) NSInteger liveType; //0是一般直播，1是私密直播，2是收费直播，3是计时直播

@end

@interface LiveStateView : UIView

@property (nonatomic, strong) UILabel * titleLabel;

-(instancetype)initWithFocus;

@end
