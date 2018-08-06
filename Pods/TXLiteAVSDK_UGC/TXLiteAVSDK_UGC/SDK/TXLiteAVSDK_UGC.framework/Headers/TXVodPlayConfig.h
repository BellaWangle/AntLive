//
//  TXVodPlayConfig.h
//  TXLiteAVSDK
//
//  Created by annidyfeng on 2017/9/12.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#ifndef TXVodPlayConfig_h
#define TXVodPlayConfig_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TX_Enum_PlayerType) {
    PLAYER_FFPLAY   = 0,          //基于FFmepg，支持软解，兼容性更好
    PLAYER_AVPLAYER = 1,          //基于系统播放器
};

@interface TXVodPlayConfig : NSObject

//播放器连接重试次数 : 最小值为 1， 最大值为 10, 默认值为 3
@property(nonatomic, assign) int connectRetryCount;

//播放器连接重试间隔 : 单位秒，最小值为 3, 最大值为 30， 默认值为 3
@property(nonatomic, assign) int connectRetryInterval;

@property NSTimeInterval timeout;           /// 超时时间： 单位秒，默认10s

///视频渲染对象回调的视频格式. 支持kCVPixelFormatType_32BGRA、kCVPixelFormatType_420YpCbCr8BiPlanarFullRange、kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
@property(nonatomic, assign) OSType playerPixelFormatType;

@property NSString *cacheFolderPath;        /// 视频缓存目录，点播MP4、HLS有效

@property int maxCacheItems;                /// 最多缓存文件个数

@property NSInteger playerType;             /// 播放器类型

@property NSDictionary *headers;            /// 自定义HTTP Headers

@property BOOL enableAccurateSeek;          /// 是否精确seek，默认YES
                                            /// 开启精确后seek，seek的时间平均多出200ms


@property BOOL autoRotate;                  /// 播放mp4文件时，若设为YES则根据文件中的旋转角度自动旋转。旋转角度可在PLAY_EVT_CHANGE_ROATION事件中获得。默认YES
@end

#endif /* TXVodPlayConfig_h */
