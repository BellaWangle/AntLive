#ifndef TXVideoEditerTypeDef_H
#define TXVideoEditerTypeDef_H

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
 * 视频信息
 */
@interface TXVideoInfo : NSObject
@property (nonatomic, strong) UIImage*              coverImage;     //视频首帧图片
@property (nonatomic, assign) CGFloat               duration;       //视频时长(s)
@property (nonatomic, assign) unsigned long long    fileSize;       //视频大小(byte)
@property (nonatomic, assign) int                   fps;            //视频fps
@property (nonatomic, assign) int                   bitrate;        //视频码率 (kbps)
@property (nonatomic, assign) int                   audioSampleRate;//音频采样率
@property (nonatomic, assign) int                   width;          //视频宽度
@property (nonatomic, assign) int                   height;         //视频高度
@property (nonatomic, assign) int                   angle;          //视频旋转角度
@end


/*
 * 短视频预览参数
 */
typedef NS_ENUM(NSInteger, TXPreviewRenderMode)
{
    PREVIEW_RENDER_MODE_FILL_SCREEN                 = 0,            //填充模式，尽可能充满屏幕不留黑边，所以可能会裁剪掉一部分画面
    PREVIEW_RENDER_MODE_FILL_EDGE                   = 1,            //黑边模式，尽可能保持画面完整，但当宽高比不合适时会有黑边出现
};

/*
 * 短视频预览参数
 */
@interface TXPreviewParam : NSObject
@property (nonatomic, strong) UIView*               videoView;      //视频预览View
@property (nonatomic, assign) TXPreviewRenderMode   renderMode;     //填充模式

@end

/*
 * 字幕
 */
@interface TXSubtitle: NSObject
@property (nonatomic, strong) UIImage*              titleImage;     //字幕图片   （这里需要客户把承载文字的控件转成image图片）
@property (nonatomic, assign) CGRect                frame;          //字幕的frame（注意这里的frame坐标是相对于渲染view的坐标）
@property (nonatomic, assign) CGFloat               startTime;      //字幕起始时间(s)
@property (nonatomic, assign) CGFloat               endTime;        //字幕结束时间(s)
@end

/*
 * 贴纸
 */
@interface TXPaster: NSObject
@property (nonatomic, strong) UIImage*              pasterImage;         //贴纸图片
@property (nonatomic, assign) CGRect                frame;          //贴纸frame（注意这里的frame坐标是相对于渲染view的坐标）
@property (nonatomic, assign) CGFloat               startTime;      //贴纸起始时间(s)
@property (nonatomic, assign) CGFloat               endTime;        //贴纸结束时间(s)
@end


/*
 * 动图
 */
@interface TXAnimatedPaster: NSObject
@property (nonatomic, strong) NSString*             animatedPasterpath;  //动图文件路径
@property (nonatomic, assign) CGRect                frame;          //动图的frame（注意这里的frame坐标是相对于渲染view的坐标）
@property (nonatomic, assign) CGFloat               rotateAngle;    //动图旋转角度 (0 ~ 360)
@property (nonatomic, assign) CGFloat               startTime;      //动图起始时间(s)
@property (nonatomic, assign) CGFloat               endTime;        //动图结束时间(s)
@end


/*
 * 重复播放
 */
@interface TXRepeat: NSObject
@property (nonatomic, assign) CGFloat               startTime;      //重复播放起始时间(s)
@property (nonatomic, assign) CGFloat               endTime;        //重复播放结束时间(s)
@property (nonatomic, assign) int                   repeatTimes;    //重复播放次数
@end


/*
 * 快慢速播放类型
 */
typedef NS_ENUM(NSInteger, TXSpeedLevel) {
    SPEED_LEVEL_SLOWEST,       //极慢速
    SPEED_LEVEL_SLOW,          //慢速
    SPEED_LEVEL_NOMAL,         //正常速
    SPEED_LEVEL_FAST,          //快速
    SPEED_LEVEL_FASTEST,       //极快速
};

/*
 * 加速播放
 */
@interface TXSpeed: NSObject
@property (nonatomic, assign) CGFloat               startTime;      //加速播放起始时间(s)
@property (nonatomic, assign) CGFloat               endTime;        //加速播放结束时间(s)
@property (nonatomic, assign) TXSpeedLevel          speedLevel;     //加速级别
@end


/*
 * 视频特效类型
 */
typedef  NS_ENUM(NSInteger,TXEffectType)
{
    TXEffectType_ROCK_LIGHT,  //动感光波
    TXEffectType_DARK_DRAEM,  //暗黑幻境
    TXEffectType_SOUL_OUT,    //灵魂出窍
    TXEffectType_SCREEN_SPLIT,//视频分裂
};


/*
 * 生成视频结果错误码定义
 */
typedef NS_ENUM(NSInteger, TXGenerateResultCode)
{
    GENERATE_RESULT_OK                                   = 0,       //生成视频成功
    GENERATE_RESULT_FAILED                               = -1,      //生成视频失败
    GENERATE_RESULT_CANCEL                               = -2,      //生成视频取消
};

/*
 * 生成视频结果
 */
@interface TXGenerateResult : NSObject
@property (nonatomic, assign) TXGenerateResultCode  retCode;        //错误码
@property (nonatomic, strong) NSString*             descMsg;        //错误描述信息
@end

/*
 * 视频合成结果错误码定义
 */
typedef NS_ENUM(NSInteger, TXJoinerResultCode)
{
    JOINER_RESULT_OK                                = 0,            //合成成功
    JOINER_RESULT_FAILED                            = -1,           //合成失败
};
/*
 * 短视频合成结果
 */
@interface TXJoinerResult : NSObject
@property (nonatomic, assign) TXJoinerResultCode    retCode;         //错误码
@property (nonatomic, strong) NSString*             descMsg;         //错误描述信息

/*
 * 短视频压缩质量
 * 注意如果视频的分辨率小于压缩到的目标分辨率，视频不会被压缩，会保留原画
 */
typedef NS_ENUM(NSInteger, TXVideoCompressed)
{
    VIDEO_COMPRESSED_360P                              = 0,  //压缩至360P分辨率
    VIDEO_COMPRESSED_480P                              = 1,  //压缩至480P分辨率
    VIDEO_COMPRESSED_540P                              = 2,  //压缩至540P分辨率
    VIDEO_COMPRESSED_720P                              = 3,  //压缩至720P分辨率
};

@end

#endif
