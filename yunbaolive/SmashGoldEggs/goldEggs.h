//
//  zajindan.h
//  iphoneLive
//
//  Created by Boom on 2017/7/25.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol zajindanDelegate <NSObject>

- (void)goChongZhi;
- (void)zhongjianla:(NSDictionary *)dic;
@end
@interface goldEggs : UIView<CAAnimationDelegate>
@property(nonatomic,assign) id<zajindanDelegate> delegate;
-(instancetype)initWithLiveId:(NSString *)liveid andChuiziArray:(NSArray *)array;
- (void)show;

@end
