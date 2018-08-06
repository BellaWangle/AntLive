#import <UIKit/UIKit.h>
#import "JMListen.h"
@interface chatController : JMListen
@property(nonatomic,strong)NSString *chatID;
@property(nonatomic,strong)NSString *chatname;
@property(nonatomic,strong)NSString *avatar;
@property(nonatomic,strong)JMSGConversation *msgConversation;
@end
