//
//  LiveOrDynamicView.h
//  iphoneLive
//
//  Created by Rookie on 2017/7/8.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnCallBack) ();

@interface LiveOrDynamicView : UIView


- (instancetype)initWithFrame:(CGRect)frame andLiveBtn:(BtnCallBack)live andDynamicBtn:(BtnCallBack)dynamic andCancelBtn:(BtnCallBack)cancel;

@end
