//
//  VideoRecordMusicView.m
//  TXLiteAVDemo
//
//  Created by zhangxiang on 2017/9/13.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "VideoRecordMusicView.h"
#import "ColorMacro.h"
#import "UIView+Additions.h"

@implementation VideoRecordMusicView
{
    UISlider *_sldVolumeForBGM;
    UISlider *_sldVolumeForVoice;
    UISlider *_sldProcessForBGM;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    
    //***
    //BGM
    UIButton *btnSelectBGM = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, 50, 20)];
    btnSelectBGM.titleLabel.font = [UIFont systemFontOfSize:12.f];
    btnSelectBGM.layer.borderColor = UIColorFromRGB(0x0ACCAC).CGColor;
    [btnSelectBGM.layer setMasksToBounds:YES];
    [btnSelectBGM.layer setCornerRadius:6];
    [btnSelectBGM.layer setBorderWidth:1.0];
    [btnSelectBGM setTitle:YZMsg(@"伴奏") forState:UIControlStateNormal];
    [btnSelectBGM setTitleColor:UIColorFromRGB(0x0ACCAC) forState:UIControlStateNormal];
    [btnSelectBGM addTarget:self action:@selector(onBtnMusicSelected) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnStopBGM = [[UIButton alloc] initWithFrame:CGRectMake(btnSelectBGM.right + 10, 15, 50, 20)];
    btnStopBGM.titleLabel.font = [UIFont systemFontOfSize:12.f];
    btnStopBGM.layer.borderColor = UIColorFromRGB(0x0ACCAC).CGColor;
    [btnStopBGM.layer setMasksToBounds:YES];
    [btnStopBGM.layer setCornerRadius:6];
    [btnStopBGM.layer setBorderWidth:1.0];
    [btnStopBGM setTitle:YZMsg(@"结束") forState:UIControlStateNormal];
    [btnStopBGM setTitleColor:UIColorFromRGB(0x0ACCAC) forState:UIControlStateNormal];
    [btnStopBGM addTarget:self action:@selector(onBtnMusicStoped) forControlEvents:UIControlEventTouchUpInside];

    UILabel *labVolumeForBGM = [[UILabel alloc] initWithFrame:CGRectMake(15, btnSelectBGM.bottom + 25, 30, 20)];
    [labVolumeForBGM setText:YZMsg(@"伴奏")];
    [labVolumeForBGM setFont:[UIFont systemFontOfSize:12.f]];
    labVolumeForBGM.textColor = UIColorFromRGB(0x0ACCAC);
    //    [_labVolumeForBGM sizeToFit];
    
    _sldVolumeForBGM = [[UISlider alloc] initWithFrame:CGRectMake(labVolumeForBGM.right + 40, labVolumeForBGM.y, 300, 20)];
    _sldVolumeForBGM.minimumValue = 0;
    _sldVolumeForBGM.maximumValue = 2;
    _sldVolumeForBGM.value = 1;
    [_sldVolumeForBGM setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [_sldVolumeForBGM setMinimumTrackImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
    [_sldVolumeForBGM setMaximumTrackImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [_sldVolumeForBGM addTarget:self action:@selector(onBGMValueChange:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *labVolumeForVoice = [[UILabel alloc] initWithFrame:CGRectMake(15, _sldVolumeForBGM.bottom + 15, 30, 20)];
    [labVolumeForVoice setText:YZMsg(@"人声")];
    [labVolumeForVoice setFont:[UIFont systemFontOfSize:12.f]];
    labVolumeForVoice.textColor = UIColorFromRGB(0x0ACCAC);
    //    [_labVolumeForVoice sizeToFit];
    
    _sldVolumeForVoice = [[UISlider alloc] initWithFrame:CGRectMake(labVolumeForVoice.right + 40, labVolumeForVoice.y, 300, 20)];
    _sldVolumeForVoice.minimumValue = 0;
    _sldVolumeForVoice.maximumValue = 2;
    _sldVolumeForVoice.value = 1;
    [_sldVolumeForVoice setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [_sldVolumeForVoice setMinimumTrackImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
    [_sldVolumeForVoice setMaximumTrackImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [_sldVolumeForVoice addTarget:self action:@selector(onVoiceValueChange:) forControlEvents:UIControlEventValueChanged];
    
    
    UILabel *labBGMProcess = [[UILabel alloc] initWithFrame:CGRectMake(15, _sldVolumeForVoice.bottom + 15, 30, 20)];
    [labBGMProcess setText:YZMsg(@"音乐")];
    [labBGMProcess setFont:[UIFont systemFontOfSize:12.f]];
    labBGMProcess.textColor = UIColorFromRGB(0x0ACCAC);
    //    [_labVolumeForVoice sizeToFit];
    
    _sldProcessForBGM = [[UISlider alloc] initWithFrame:CGRectMake(labBGMProcess.right + 40, labBGMProcess.y, 300, 20)];
    _sldProcessForBGM.minimumValue = 0;
    _sldProcessForBGM.maximumValue = 0;
    _sldProcessForBGM.value = 0;
    [_sldProcessForBGM setContinuous:NO];
    [_sldProcessForBGM setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [_sldProcessForBGM setMinimumTrackImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
    [_sldProcessForBGM setMaximumTrackImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [_sldProcessForBGM addTarget:self action:@selector(onBGMPlayChange:) forControlEvents:UIControlEventValueChanged];
    [_sldProcessForBGM addTarget:self action:@selector(onBGMPlayBeginChange:) forControlEvents:UIControlEventTouchDragInside];
    
    [self addSubview:btnSelectBGM];
    [self addSubview:btnStopBGM];
    [self addSubview:labVolumeForBGM];
    [self addSubview:_sldVolumeForBGM];
    [self addSubview:labVolumeForVoice];
    [self addSubview:_sldVolumeForVoice];
    [self addSubview:labBGMProcess];
    [self addSubview:_sldProcessForBGM];
}

-(void)setBGMDuration:(CGFloat)duration
{
    _sldProcessForBGM.maximumValue = duration;
}

-(void)setBGMPlayTime:(CGFloat)time
{
    _sldProcessForBGM.value = time;
}

-(void)onBtnMusicSelected
{
    if (_delegate && [_delegate respondsToSelector:@selector(onBtnMusicSelected)]) {
        [_delegate onBtnMusicSelected];
    }
}

-(void)onBtnMusicStoped
{
    if (_delegate && [_delegate respondsToSelector:@selector(onBtnMusicStoped)]) {
        [_delegate onBtnMusicStoped];
    }
}

-(void)onBGMPlayBeginChange:(UISlider *)slider
{
    if (_delegate && [_delegate respondsToSelector:@selector(onBGMValueChange:)]) {
        [_delegate onBGMPlayBeginChange];
    }
}

-(void)onBGMValueChange:(UISlider *)slider
{
    if (_delegate && [_delegate respondsToSelector:@selector(onBGMValueChange:)]) {
        [_delegate onBGMValueChange:slider];
    }
}

-(void)onVoiceValueChange:(UISlider *)slider
{
    if (_delegate && [_delegate respondsToSelector:@selector(onVoiceValueChange:)]) {
        [_delegate onVoiceValueChange:slider];
    }
}

-(void)onBGMPlayChange:(UISlider *)slider
{
    if (_delegate && [_delegate respondsToSelector:@selector(onBGMPlayChange:)]) {
        [_delegate onBGMPlayChange:slider];
    }
}

-(void)resetUI
{
    _sldVolumeForBGM.value = 1;
    _sldVolumeForVoice.value = 1;
    _sldProcessForBGM.value = 0;
}
@end
