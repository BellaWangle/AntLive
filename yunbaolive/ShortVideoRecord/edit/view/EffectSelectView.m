//
//  VideoEffectSlider.m
//  TXLiteAVDemo
//
//  Created by xiang zhang on 2017/11/3.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "EffectSelectView.h"
#import "UIView+Additions.h"
#import "ColorMacro.h"

#define EFFCT_COUNT        4
#define EFFCT_IMAGE_WIDTH  65 * kScaleY
#define EFFCT_IMAGE_SPACE  20

@implementation EffectSelectView
{
    UIScrollView *_effectSelectView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat space = (self.width - EFFCT_IMAGE_WIDTH * EFFCT_COUNT) / (EFFCT_COUNT + 1);
        _effectSelectView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.width,EFFCT_IMAGE_WIDTH)];
        NSArray *effectNameS = @[@"特效一",@"特效二",@"特效三",@"特效四"];
        for (int i = 0 ; i < EFFCT_COUNT ; i ++){
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(space + (space + EFFCT_IMAGE_WIDTH) * i, 0, EFFCT_IMAGE_WIDTH, EFFCT_IMAGE_WIDTH)];
            [btn setTitle:effectNameS[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setBackgroundColor:[UIColor blueColor]];
            btn.layer.cornerRadius = EFFCT_IMAGE_WIDTH / 2.0;
            btn.layer.masksToBounds = YES;
            btn.titleLabel.numberOfLines = 0;
            btn.tag = i;
            
            [btn addTarget:self action:@selector(beginPress:) forControlEvents:UIControlEventTouchDown];
            [btn addTarget:self action:@selector(endPress:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
            [_effectSelectView addSubview:btn];
            
            switch ((TXEffectType)btn.tag) {
                case TXEffectType_ROCK_LIGHT:
                {
                    [btn setBackgroundColor:UIColorFromRGB(0xEC5F9B)];
                }
                    break;
                case TXEffectType_DARK_DRAEM:
                {
                    [btn setBackgroundColor:UIColorFromRGB(0xEC8435)];
                }
                    break;
                case TXEffectType_SOUL_OUT:
                {
                    [btn setBackgroundColor:UIColorFromRGB(0x1FBCB6)];
                }
                    break;
                case TXEffectType_SCREEN_SPLIT:
                {
                    [btn setBackgroundColor:UIColorFromRGB(0x449FF3)];
                }
                    break;
                    
                default:
                    break;
            }
        }
        [self addSubview:_effectSelectView];
    }
    return self;
}


//响应事件
-(void) beginPress: (UIButton *) button {
    TXEffectType type = (TXEffectType)button.tag;
    [self.delegate onVideoEffectBeginClick:type];
}

//响应事件
-(void) endPress: (UIButton *) button {
    TXEffectType type = (TXEffectType)button.tag;
    [self.delegate onVideoEffectEndClick:type];
}
@end
