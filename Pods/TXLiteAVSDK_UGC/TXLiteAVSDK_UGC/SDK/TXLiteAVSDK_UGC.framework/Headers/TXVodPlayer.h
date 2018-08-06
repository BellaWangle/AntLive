//
//  TXVodPlayer.h
//  TXLiteAVSDK
//
//  Created by annidyfeng on 2017/9/12.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TXLivePlayListener.h"
#import "TXVodPlayListener.h"
#import "TXVodPlayConfig.h"
#import "TXVideoCustomProcessDelegate.h"
#import "TXBitrateItem.h"
#import "TXPlayerAuthParams.h"

@interface TXVodPlayer : NSObject

@property(nonatomic, weak) id <TXLivePlayListener> delegate __attribute__((deprecated("use vodDelegate instead")));

@property(nonatomic, weak) id <TXVodPlayListener> vodDelegate;

/**
 * 视频渲染回调。（仅硬解支持）
 */
@property(nonatomic, weak) id <TXVideoCustomProcessDelegate> videoProcessDelegate;

@property(nonatomic, assign) BOOL enableHWAcceleration;

@property(nonatomic, copy) TXVodPlayConfig *config;

@property BOOL isAutoPlay;  /// startPlay后是否立即播放，默认YES

/**
 * 加密HLS的token。设置此值后，播放器自动在URL中的文件名之前增加voddrm.token.<Token>
 */
@property (nonatomic, strong) NSString *token;

/* setupContainView 创建Video渲染View,该控件承载着视频内容的展示。
 * 参数:
 *      view  : 父view
 *      idx   : Widget在父view上的层级位置
 */
- (void)setupVideoWidget:(UIView *)view insertIndex:(unsigned int)idx;

/* removeVideoView 移除Video渲染View
 */
- (void)removeVideoWidget;

/**
 * startPlay 启动从指定URL播放
 *
 * @prarm url 完整的URL(如果播放的是本地视频文件，这里传本地视频文件的完整路径)
 * @return 0 = OK
 */
- (int)startPlay:(NSString *)url;

/**
 * 通过fileid方式播放.
 * TODO: 附加文档地址
 *
 *  @return 0 = OK
 */
- (int)startPlayWithParams:(TXPlayerAuthParams *)params;

/* stopPlay 停止播放音视频流
 * 返回: 0 = OK
 */
- (int)stopPlay;

/* isPlaying 是否正在播放
 * 返回： YES 拉流中，NO 没有拉流
 */
- (bool)isPlaying;

/* pause 暂停播放
 *
 */
- (void)pause;

/* resume 继续播放
 *
 */
- (void)resume;

/*
 seek 播放跳转到音视频流某个时间
 * time: 流时间，单位为秒
 * 返回: 0 = OK
 */
- (int)seek:(float)time;

/**
 * 获取当前播放时间
 */
- (float)currentPlaybackTime;

/**
 * 获取视频总时长
 */
- (float)duration;

/*
 * setRenderRotation 设置画面的方向
 * 参数：
 *       rotation : 详见 TX_Enum_Type_HomeOrientation 的定义.
 */
- (void)setRenderRotation:(int)rotation;

/* setRenderMode 设置画面的裁剪模式
 * 参数
 *       renderMode : 详见 TX_Enum_Type_RenderMode 的定义。
 */
- (void)setRenderMode:(int)renderMode;


/**
 * 设置静音
 */
- (void)setMute:(BOOL)bEnable;

/*
 * 截屏
 * 参  数：
 *       snapshotCompletionBlock 通过回调返回当前图像
 * 返回值：
 */
- (void)snapshot:(void (^)(UIImage *))snapshotCompletionBlock;

/**
 * 设置播放速率
 *
 * 参  数：
 *       rate 正常速度为1.0；小于为慢速；大于为快速。最大建议不超过2.0
 *
 */
- (void)setRate:(float)rate;

/**
 * 当播放地址为master playlist，返回支持的码率（清晰度）
 *
 * 注 意：
 *  在收到PLAY_EVT_PLAY_BEGIN事件后才能正确返回结果
 *
 * 返回值：
 *      无多码率返回空数组
 */
- (NSArray<TXBitrateItem *> *)supportedBitrates;

/**
 * 获取当前正在播放的码率索引
 */
- (NSInteger)bitrateIndex;

/**
 * 设置当前正在播放的码率索引，无缝切换清晰度
 *  清晰度切换可能需要等待一小段时间。腾讯云支持多码率HLS分片对齐，保证最佳体验。
 *
 * 参 数：
 *     index 码率索引
 */
- (void)setBitrateIndex:(NSInteger)index;

@end
