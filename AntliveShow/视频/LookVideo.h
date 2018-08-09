//
//  LookVideo.h
//  iphoneLive
//
//  Created by 王敏欣 on 2017/8/4.
//  Copyright © 2017年 cat. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "JMListen.h"
@interface LookVideo : JMListen
@property(nonatomic,strong)NSDictionary *hostdic;
@property (weak, nonatomic) IBOutlet UIView *videobottomv;
@end
