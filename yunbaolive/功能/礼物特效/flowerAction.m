

#import "flowerAction.h"

@implementation flowerAction


-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        UIImageView *actionImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
        actionImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:actionImage];
        

        NSMutableArray *array=[NSMutableArray array];
        
        for (int j=0; j<10; j++) {
            NSString *imageName=[NSString stringWithFormat:@"fireworks_%d.png",j+1];
            NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:nil];
            UIImage *image=[UIImage imageWithContentsOfFile:path];
            [array addObject:image];
            
        }
        
        
        for (int j=0; j<4; j++) {
            NSString *imageName=[NSString stringWithFormat:@"fireworks_flower%d.png",j+1];
            NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:nil];
            UIImage *image=[UIImage imageWithContentsOfFile:path];
            [array addObject:image];
            
        }
        
        
        for (int i=0; i<20; i++) {
            NSString *imageName=[NSString stringWithFormat:@"gift_heart_%d.png",i+1];
            NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:nil];
            UIImage *image=[UIImage imageWithContentsOfFile:path];
            [array addObject:image];
            
        }
        //要展示的动画
        actionImage.animationImages=array;
        //一次动画的时间
        actionImage.animationDuration=[array count]*0.1;
        //只执行一次动画
        actionImage.animationRepeatCount = 1;
        //开始动画
        [actionImage startAnimating];
        
        //释放内存
        [actionImage performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:[array count]*0.1];
        
    }
    
    return self;
}


@end
