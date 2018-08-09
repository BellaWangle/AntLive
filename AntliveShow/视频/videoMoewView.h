//
//  videoMoewView.h
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/5.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^xinxinblock)(id array);


@interface videoMoewView : UIView

@property(nonatomic,copy)xinxinblock cancleblock;

@property(nonatomic,copy)xinxinblock deleteblock;

@property(nonatomic,copy)xinxinblock shareblock;

-(instancetype)initWithFrame:(CGRect)frame andHostDic:(NSDictionary *)dic cancleblock:(xinxinblock)block delete:(xinxinblock)deleteblock share:(xinxinblock)share;


@end
