
#import <UIKit/UIKit.h>

#import "MJRefresh.h"


#import "MainListRootViewController.h"

@interface AntHotpage : MainListRootViewController
//筛选省份  性别。。
@property(nonatomic,copy,nonnull)NSString *province;
@property(nonatomic,copy,nonnull)NSString *sex;
@property(nonatomic,copy,nonnull)NSString *biaoji;
@property(nonatomic,copy,nonnull)NSString *zhuboTitle;
@property(nonatomic,strong,nonnull) UILabel *label;
@property(nonatomic,copy,nonnull)NSString *url;

@end
