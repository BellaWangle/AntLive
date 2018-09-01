//
//  catSwitch.m
//  yunbaolive
//
//  Created by 志刚杨 on 16/7/2.
//  Copyright © 2016年 cat. All rights reserved.
//
#import "catSwitch.h"
@implementation catSwitch
{
    @protected UIButton *selectButton;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        [selectButton setImage:[UIImage imageNamed:getImagename(@"icon_danmu_unchecked")] forState:UIControlStateNormal];
        [selectButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectButton];
        self.layer.cornerRadius = 3;
        selectButton.layer.cornerRadius = 3;
    }
    return self;
}
-(void)toggle
{
    if(!_state)
    {
        [selectButton setImage:[UIImage imageNamed:getImagename(@"icon_danmu_checked")] forState:UIControlStateNormal];
//        [UIView animateWithDuration:0.5 // 动画时长
//                         animations:^{
//                             selectButton.frame = CGRectMake(self.frame.size.width-2-selectButton.frame.size.width, self.frame.origin.y - 2, self.frame.size.width * 2/3, self.frame.size.height - 6);
//                         }];
        _state = YES;
    }
    else
    {
        [selectButton setImage:[UIImage imageNamed:getImagename(@"icon_danmu_unchecked")] forState:UIControlStateNormal];
//        [UIView animateWithDuration:0.5 // 动画时长
//                         animations:^{
//                             selectButton.frame = CGRectMake(2, self.frame.origin.y - 2, self.frame.size.width * 2/3, self.frame.size.height - 6);
//                         }];
        _state = NO;
    }
    [self.delegate switchState:_state];
}
@end
