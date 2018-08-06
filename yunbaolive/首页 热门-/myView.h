
#import <UIKit/UIKit.h>
#include "slideDelegate.h"
@interface myView : UIView
@property (nonatomic, weak) id<slideDelegate> delegate;


-(void)reload:(NSArray *)list;
@end
