//
//  TXAudioCustomProcessDelegate.h
//  TXLiteAVSDK
//
//  Created by realingzhou on 2018/1/15.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#ifndef TXAudioCustomProcessDelegate_h
#define TXAudioCustomProcessDelegate_h
#import <Foundation/Foundation.h>

@protocol TXAudioCustomProcessDelegate <NSObject>

/**
 * 声音回调
 * @prarm data pcm数据
 * @prarm timeStamp 时间戳
 * @prarm sampleRate 采样率
 * @prarm channels 声道数
 */
@optional
- (void)onRecordPcmData:(NSData *)data timeStamp:(unsigned long long)timeStamp sampleRate:(int)sampleRate channels:(int)channels;

@end

#endif /* TXAudioCustomProcessDelegate_h */
