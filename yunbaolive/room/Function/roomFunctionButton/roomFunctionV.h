//
//  bottombuttonv.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/8/2.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^buttonblock)(NSString *type);


@interface roomFunctionV : UIView


@property(nonatomic,copy)buttonblock camerablock;
@property(nonatomic,copy)buttonblock gameblock;
@property(nonatomic,copy)buttonblock coastblock;
@property(nonatomic,copy)buttonblock lightblock;
@property(nonatomic,copy)buttonblock meiyanblock;
@property(nonatomic,copy)buttonblock musicblock;
@property(nonatomic,copy)buttonblock jingpaiblock;
@property(nonatomic,copy)buttonblock hideselfblock;
@property(nonatomic,copy)buttonblock feedblock;

-(instancetype)initWithFrame:(CGRect)frame music:(buttonblock)music meiyan:(buttonblock)meiyan coast:(buttonblock)coast light:(buttonblock)light camera:(buttonblock)camera game:(buttonblock)game jingpai:(buttonblock)jingpai showjingpai:(NSString *)isjingpai showgame:(NSArray *)gametypearray showcoase:(int)coastshow hideself:(buttonblock)hide and:(BOOL)canFee;

//-(void)hidebtn;
//-(void)showbtn;
@end
