#ifndef TXUGCRecordListener_H
#define TXUGCRecordListener_H

#import "TXUGCRecordTypeDef.h"
/**********************************************
 **************  短视频录制回调定义  **************
 **********************************************/
@protocol TXUGCRecordListener <NSObject>

/**
 * 短视频录制进度
 */
@optional
-(void) onRecordProgress:(NSInteger)milliSecond;

/**
 * 短视频录制完成
 */
@optional
-(void) onRecordComplete:(TXUGCRecordResult*)result;

/**
 * 短视频录制事件通知
 */
@optional
-(void) onRecordEvent:(NSDictionary*)evt;

@end

#endif
