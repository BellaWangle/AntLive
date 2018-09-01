//#import "TCMsgModel.h"
#import <TXLiteAVSDK_UGC/TXVideoEditerTypeDef.h>
//#import "TXVideoEditerTypeDef.h"
//#import "TXUGCPublishListener.h"
#import <TXLiteAVSDK_UGC/TXUGCPublishListener.h>
#define kRecordType_Camera 0
#define kRecordType_Play 1

@interface TCVideoPublishController : UIViewController<UITextViewDelegate, TXVideoPublishListener>

@property (strong, nonatomic) UITableView      *tableView;

//- (instancetype)init:(id)videoRecorder recordType:(NSInteger)recordType RecordResult:(TXRecordResult *)recordResult TCLiveInfo:(NSDictionary *)liveInfo;

- (instancetype)initWithPath:(NSString *)videoPath videoMsg:(TXVideoInfo *) videoMsg;

@end
