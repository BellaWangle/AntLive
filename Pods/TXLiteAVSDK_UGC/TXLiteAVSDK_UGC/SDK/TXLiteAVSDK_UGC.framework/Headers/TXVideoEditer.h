//
//  TXUGCEdit.h
//  TXRTMPSDK
//
//  Created by xiang zhang on 2017/4/10.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import "TXVideoEditerListener.h"
#import "TXVideoEditerTypeDef.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////  UGC list /////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

// 注意：获取视频信息需要用到一些类别的方法，加载类别方法需要在工程配置：Build Settings -> Linking -> Other Linker Flags 添加 -ObjC
//      具体请参考demo配置

@interface TXVideoInfoReader : NSObject
/*
 * number 当前采样的是第几张图片（number 从1开始）
 * image  当前采样图片
 * return 是否继续获取下一张图片，YES：继续获取  NO：终止获取
 * 注意：sampleProcess 回调不在主线程，如果在回调里面有UI操作，请自行切换到主线程，具体可以参考demo代码
 */
typedef BOOL(^sampleProcess)(int number , UIImage * image);

/* 获取视频文件信息
 * videoPath 视频文件路径
 */
+ (TXVideoInfo *)getVideoInfo:(NSString *)videoPath;

/* 获取视频文件信息
 * asset 视频文件属性
 */
+ (TXVideoInfo *)getVideoInfoWithAsset:(AVAsset *)videoAsset;

/*获取视频的采样图列表
 *count         获取的采样图数量（均匀采样）
 *videoPath     视频文件路径
 *sampleProcess 采样进度
 */
+ (void)getSampleImages:(int)count
              videoPath:(NSString *)videoPath
               progress:(sampleProcess)sampleProcess;

/*获取视频的采样图列表
 *count         获取的采样图数量（均匀采样）
 *videoAsset   视频文件属性
 *sampleProcess 采样进度
 */
+ (void)getSampleImages:(int)count
             videoAsset:(AVAsset *)videoAsset
               progress:(sampleProcess)sampleProcess;

/**
 * 根据时间获取单帧图片
 * time 获取图片的时间
 * videoPath 视频文件路径
 */
+ (UIImage *)getSampleImage:(float)time
                  videoPath:(NSString *)videoPath;

/**
 * 根据时间获取单帧图片
 * time 获取图片的时间
 * videoAsset 视频文件属性
 */
+ (UIImage *)getSampleImage:(float)time
                 videoAsset:(AVAsset *)videoAsset;
@end


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////  Video Edit //////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface TXVideoEditer : NSObject
@property (nonatomic ,weak) id<TXVideoGenerateListener> generateDelegate;
@property (nonatomic ,weak) id<TXVideoPreviewListener>  previewDelegate;

- (instancetype)initWithPreview:(TXPreviewParam *)param;

/*
 *videoPath:视频文件路径
 * 返回值：
 *       0 成功；
 *      -1 视频文件不存在；
 */
- (int)setVideoPath:(NSString *)videoPath;

/*
 *videoAsset:视频属性asset,从本地相册loading出来的视频，可以直接传入对应的视频属性，会极大的降低视频从相册loading的时间，具体请参考demo用法
 * 返回值：
 *       0 成功；
 *      -1 视频属性asset 为nil；
 */
- (int)setVideoAsset:(AVAsset *)videoAsset;


/*渲染某一时刻的视频画面
 *time      预览帧时间(s)
 */
- (void)previewAtTime:(CGFloat)time;

/*播放某一时间段的视频
 *startTime     播放起始时间(s)
 *endTime       播放结束时间(s)
 */
- (void)startPlayFromTime:(CGFloat)startTime
                   toTime:(CGFloat)endTime;

/*
 *暂停播放
 */
- (void)pausePlay;


/*继续播放
 */
- (void)resumePlay;

/*停止播放
 */
- (void)stopPlay;

/*
 *设置全局水印
 *waterMark            全局水印图片
 *normalizationFrame   水印相对于视频图像的归一化frame，x,y,width,height 取值范围 0~1；
                       height不用设置，sdk内部会根据水印宽高比自动计算height；
                       比如视频图像大小为（540，960） frame设置为（0.1，0.1，0.1,0）,水印的实际像素坐标为（540 * 0.1，960 * 0.1，540 * 0.1 ，540 * 0.1 * waterMark.size.height / waterMark.size.width）
 */
- (void) setWaterMark:(UIImage *)waterMark  normalizationFrame:(CGRect)normalizationFrame;

/*
 *设置片尾水印
 *tailWaterMark        片尾水印图片
 *normalizationFrame   水印相对于视频图像的归一化frame，x,y,width,height 取值范围 0~1；
                       height不用设置，sdk内部会根据水印宽高比自动计算height；
                       比如视频图像大小为（540，960） frame设置为（0.1，0.1，0.1,0）,水印的实际像素坐标为（540 * 0.1，960 * 0.1，540 * 0.1 ，540 * 0.1 * waterMark.size.height / waterMark.size.width）
 *duration             水印的持续时长
 */
- (void) setTailWaterMark:(UIImage *)tailWaterMark normalizationFrame:(CGRect)normalizationFrame duration:(CGFloat)duration;

/*
 *设置美颜，美白级别
 */

- (void) setBeautyFilter:(float)beautyLevel setWhiteningLevel:(float)whiteningLevel;

/*
 *设置特效滤镜
 */
- (void) setFilter:(UIImage *)image;

/*
 *设置视频加速播级别
 */
- (void) setSpeedList:(NSArray<TXSpeed *> *)speedList;

/*
 *设置背景音乐
 *path      音乐文件路径
 *result
 *       0 成功；
 *      -1 音乐文件格式不支持
 */
- (void) setBGM:(NSString *)path result:(void(^)(int))result;

/*
 *设置背景音乐的起始时间和结束时间
 *startTime 音乐起始时间
 *endTime   音乐结束时间
 */
- (void) setBGMStartTime:(float)startTime endTime:(float)endTime;

/*
 *设置背景音乐是否循环播放
 */
- (void) setBGMLoop:(BOOL)isLoop;

/*
 *设置背景音乐在视频的添加的起始位置
 */
- (void) setBGMAtVideoTime:(float)time;

/*
 *设置视频声音大小
 *volume 0 ~ 1.0
 */
- (void) setVideoVolume:(float)volume;

/*
 *设置背景音乐声音大小  
 *volume 0 ~ 1.0
 */
- (void) setBGMVolume:(float)volume;

/*
 *设置字幕（气泡）列表
 *subtitleList 字幕列表
 */
- (void) setSubtitleList:(NSArray<TXSubtitle *> *)subtitleList;

/*
 *设置静态贴纸
 *subtitleList 静态贴纸列表
 */
- (void) setPasterList:(NSArray<TXPaster *> *)pasterList;

/*
 *设置动图列表
 *subtitleList 动态贴纸列表
 */
- (void) setAnimatedPasterList:(NSArray<TXAnimatedPaster *> *)animatedPasterList;

/*
 *设置倒放
 */
- (void) setReverse:(BOOL)isReverse;

/*
 *设置重复播放
 */
- (void) setRepeatPlay:(NSArray<TXRepeat *> *)repeatList;

/*
 *开始特效
 */
- (void) startEffect:(TXEffectType)type  startTime:(float)startTime;

/*
 *结束特效
 */
- (void) stopEffect:(TXEffectType)type  endTime:(float)endTime;

/*
 *删除最后一个添加的特效
 */
- (void) deleteLastEffect;

/*
 *设置视频剪裁
 *startTime 视频起始时间
 *endTime   视频结束时间
 */
- (void) setCutFromTime:(float)startTime toTime:(float)endTime;

/*
 *设置视频码率
 *bitrate  视频码率 单位:kbps
 *如果设置了码率，SDK生成视频会优先使用这个码率，注意码率不要太大或则太小，码率太小视频会模糊不清，码率太大，生成视频体积会很大
  这里建议设置范围为：600~3600，如果没有调用这个接口，SDK内部会根据压缩质量自动计算码率
 */
- (void) setVideoBitrate:(int)bitrate;

/*
 *生成视频
 *优点：兼容性好，支持各种操作类型的视频生成，生成的视频文件在各个平台播放的兼容性好
 *缺点：生成视频速度稍慢
 *videoCompressed 视频压缩质量
 *videoOutputPath 视频操作之后存储路径
 *generateVideo 之后在TXVideoGenerateListener里面监听结果回调
 */
- (void) generateVideo:(TXVideoCompressed)videoCompressed videoOutputPath:(NSString *)videoOutputPath;

/*
 *使用系统函数快速生成视频
 *优点：生成视频速度快
 *缺点：1，剪切出来的视频在各个平台播放的兼容性稍差
       2，只有剪切和压缩操作才会使用系统函数，其他情况系统不支持，SDK内部会自动走正常视频生成的逻辑
 *videoCompressed 视频压缩质量
 *videoOutputPath 视频操作之后存储路径
 *quickGenerateVideo 之后在TXVideoGenerateListener里面监听结果回调
 */
- (void) quickGenerateVideo:(TXVideoCompressed)videoCompressed videoOutputPath:(NSString *)videoOutputPath;

/*SDK生成视频默认采用的是硬编码（编码效率高，编码出来的图像效果好），硬编码器在程序进后台后会停止工作，从而导致视频生成失败，
  这里新增了两个接口pauseGenerate，resumeGenerate，程序进后台后您可以调用pauseGenerate暂停视频生成，程序重新进前台后，
  您可以调用resumeGenerate 继续视频生成，这里需要注意的是，调用resumeGenerate，sdk会重启硬编码器，会有一定的概率重启失败，
  或则重启后前几帧数据编码失败，这个时候SDK内部会在 TXVideoGenerateListener 抛出编码错误事件，收到错误事件后您需要重新生成视频。
  */
/*
 *暂停视频生成，仅适用于generateVideo，quickGenerateVideo调用无效
 */
- (void) pauseGenerate;

/*
 *继续视频生成，仅适用于generateVideo，quickGenerateVideo调用无效
 */
- (void) resumeGenerate;

/*
 *停止视频文件生成
 */
- (void) cancelGenerate;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////  UGC Joiner //////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@interface TXVideoJoiner : NSObject
@property (nonatomic ,weak) id<TXVideoJoinerListener>  joinerDelegate;
@property (nonatomic ,weak) id<TXVideoPreviewListener> previewDelegate;

/*
 * param:参考 TXPreviewParam
 */
- (instancetype)initWithPreview:(TXPreviewParam *)param;

/*设置视频文件列表 app本地的视频文件建议使用这个接口
 *videoPathList  :视频列表文件
 * 返回值：
 *       0 成功；
 *      -1 视频列表文件不存在；
*/
- (int)setVideoPathList:(NSArray *)videoPathList;

/*设置视频文件列表 相册的视频文件建议使用这个接口
 *videoAssetList:视频属性asset列表,从本地相册loading出视频列表后，可以直接传入对应的视频属性列表，会极大的降低视频从相册loading的时间，具体请参考demo用法
 * 返回值：
 *       0 成功；
 *      -1 视频属性asset列表不存在；
 */
- (int)setVideoAssetList:(NSArray<AVAsset *> *)videoAssetList;

/* 开启视频播放，会从视频的起始位置开始播放 （需要在setVideoPathList之后调用）
 */
- (void)startPlay;

/*暂停播放
 */
- (void)pausePlay;

/*继续播放
 */
- (void)resumePlay;

/*停止播放
 */
- (void)stopPlay;

/*合成视频
 *SDK内部会自动判断视频是否可以快速合成，如果可以，会优先走快速合成逻辑
 *videoCompressed 视频压缩质量
 *videoOutputPath 生成新的视频存储路径
 *joinVideo之后在TXVideoComposeListener里面监听结果回调
 *注意：需要合成的视频列表中，每个视频必须要有video data 和 audio data 数据
 */
- (void)joinVideo:(TXVideoCompressed)videoCompressed  videoOutputPath:(NSString *)videoOutputPath;

/*
 *注意：当前接口已经被废弃，请使用 joinVideo 接口，SDK内部会自动判断视频是否具有快速合成的条件
 */
//- (void)quickJoinVideo:(TXVideoCompressed)videoCompressed  videoOutputPath:(NSString *)videoOutputPath;

/*
 *停止视频文件合成
 */
- (void)cancelJoin;

@end



