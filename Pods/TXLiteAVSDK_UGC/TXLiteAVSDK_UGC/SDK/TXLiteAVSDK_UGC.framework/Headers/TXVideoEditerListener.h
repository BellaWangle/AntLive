#ifndef TXVideoEditerListener_H
#define TXVideoEditerListener_H

#import "TXVideoEditerTypeDef.h"

/**********************************************
 **************  视频预览回调  **************
 **********************************************/
@protocol TXVideoPreviewListener <NSObject>

/**
 * 短视频预览进度
 * time 视频预览的当前时间 (s)
 */
@optional
-(void) onPreviewProgress:(CGFloat)time;

/**
 * 短视频预览结束回调
 */
@optional
-(void) onPreviewFinished;

@end


/**********************************************
 **************  视频生成回调  **************
 **********************************************/
@protocol TXVideoGenerateListener<NSObject>
/**
 * 短视频生成完成
 * progress 生成视频进度百分比
 */
@optional
-(void) onGenerateProgress:(float)progress;

/**
 * 短视频生成完成
 */
@optional
-(void) onGenerateComplete:(TXGenerateResult *)result;

@end


/**********************************************
 **************  视频合成回调  **************
 **********************************************/
@protocol TXVideoJoinerListener<NSObject>
/**
 * 短视频合成完成
 * progress 合成视频进度百分比
 */
@optional
-(void) onJoinProgress:(float)progress;

/**
 * 短视频合成完成
 */
@optional
-(void) onJoinComplete:(TXJoinerResult *)result;

@end
#endif
