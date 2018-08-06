#ifndef TXUGCRecordTypeDef_H
#define TXUGCRecordTypeDef_H

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 * CameraRecord 录制视频质量类型
 */
typedef NS_ENUM(NSInteger, TXVideoQuality)
{
    VIDEO_QUALITY_LOW                               = 0,            //resolution  360×640     fps 20   bitrate 600
    VIDEO_QUALITY_MEDIUM                            = 1,            //resolution  540×960     fps 20   bitrate 2400
    VIDEO_QUALITY_HIGH                              = 2,            //resolution  720×1280    fps 20   bitrate 3600
};

/*
 * CameraRecord 录制分辨率类型定义
 */
typedef NS_ENUM(NSInteger, TXVideoResolution)
{
    VIDEO_RESOLUTION_360_640                  = 0,
    VIDEO_RESOLUTION_540_960                  = 1,
    VIDEO_RESOLUTION_720_1280                 = 2,
};

/*
 * CameraRecord 录制视频比例类型定义
 */
typedef NS_ENUM(NSInteger, TXVideoAspectRatio) {
    VIDEO_ASPECT_RATIO_3_4,           // 3:4
    VIDEO_ASPECT_RATIO_9_16,          // 9:16
    VIDEO_ASPECT_RATIO_1_1            // 1:1
};

/*
 * CameraRecord 录制视频速率
 */
typedef NS_ENUM(NSInteger, TXVideoRecordSpeed) {
    VIDEO_RECORD_SPEED_SLOWEST,       //急慢速
    VIDEO_RECORD_SPEED_SLOW,          //慢速
    VIDEO_RECORD_SPEED_NOMAL,         //正常速
    VIDEO_RECORD_SPEED_FAST,          //快速
    VIDEO_RECORD_SPEED_FASTEST,       //极快速
};

/*
 * 横竖屏录制类型定义
 */
typedef NS_ENUM(NSInteger, TXVideoHomeOrientation) {
    VIDOE_HOME_ORIENTATION_RIGHT  = 0,        // home在右边横屏录制
    VIDEO_HOME_ORIENTATION_DOWN,              // home在下面竖屏录制
    VIDEO_HOME_ORIENTATION_LEFT,              // home在左边横屏录制
    VIDOE_HOME_ORIENTATION_UP,                // home在上面竖屏录制
};

/*
 * 录制参数定义
 */

@interface TXUGCSimpleConfig : NSObject
@property (nonatomic, assign) TXVideoQuality        videoQuality;        //录制视频质量
//这里的水印设置参数已经废弃，设置水印请直接调用TXUGCRecord.h 里面的setWaterMark接口
//@property (nonatomic, retain) UIImage *           watermark;           //设置水印图片. 设为nil等同于关闭水印
//@property (nonatomic, assign) CGPoint             watermarkPos;        //设置水印位置
@property (nonatomic, assign) BOOL                  frontCamera;         //是否是前置摄像头
@property (nonatomic, assign) float                 minDuration;         //设置视频录制的最小时长，大于0         (s)
@property (nonatomic, assign) float                 maxDuration;         //设置视频录制的最大时长，建议不超过300  (s)
@end

@interface TXUGCCustomConfig : NSObject
@property (nonatomic, assign) TXVideoResolution     videoResolution;     //自定义分辨率
@property (nonatomic, assign) int                   videoFPS;            //自定义fps   15~30
@property (nonatomic, assign) int                   videoBitratePIN;     //自定义码率   600~3600
//这里的水印设置参数已经废弃，设置水印请直接调用TXUGCRecord.h 里面的setWaterMark接口
//@property (nonatomic, retain) UIImage *           watermark;           //设置水印图片. 设为nil等同于关闭水印
//@property (nonatomic, assign) CGPoint             watermarkPos;        //设置水印位置
@property (nonatomic, assign) BOOL                  frontCamera;         //是否是前置摄像头
@property (nonatomic, assign) int                   GOP;                 //关键帧间隔（1 ~10）,默认3s          (s)
@property (nonatomic, assign) float                 minDuration;         //设置视频录制的最小时长，大于0         (s)
@property (nonatomic, assign) float                 maxDuration;         //设置视频录制的最大时长，建议不超过300  (s)
@end


/*
 * 录制结果错误码定义
 */
typedef NS_ENUM(NSInteger, TXUGCRecordResultCode)
{
    UGC_RECORD_RESULT_OK                                = 0,    //录制成功（业务层主动结束录制）
    UGC_RECORD_RESULT_OK_INTERRUPT                      = 1,    //录制成功（因为进后台，或则闹钟，电话打断等自动结束录制）
    UGC_RECORD_RESULT_OK_UNREACH_MINDURATION            = 2,    //录制成功（录制时长未达到设置的最小时长）
    UGC_RECORD_RESULT_OK_BEYOND_MAXDURATION             = 3,    //录制成功（录制时长超过设置的最大时长）
    UGC_RECORD_RESULT_FAILED                            = 1001, //录制失败
};


/*
 * 录制结果
 */
@interface TXUGCRecordResult : NSObject
@property (nonatomic, assign) TXUGCRecordResultCode retCode;        //错误码
@property (nonatomic, strong) NSString*             descMsg;        //错误描述信息
@property (nonatomic, strong) NSString*             videoPath;      //视频文件path
@property (nonatomic, strong) UIImage*              coverImage;     //视频封面
@end

#endif
