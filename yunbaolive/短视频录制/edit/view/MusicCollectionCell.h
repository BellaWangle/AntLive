//
//  MusicCollectionCell.h
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/15.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicInfo : NSObject
@property (nonatomic, copy) NSString* filePath;
@property (nonatomic, copy) NSString* soneName;
@property (nonatomic, copy) NSString* singerName;
@property (nonatomic, assign) CGFloat duration;
@end

@interface MusicCollectionCell : UICollectionViewCell

@property (nonatomic) UIImageView* iconView;
@property (nonatomic) UILabel*  songNameLabel;
@property (nonatomic) UILabel*  authorNameLabel;
@property (nonatomic) UIButton* deleteBtn;

- (void)setModel:(MusicInfo*)model;

@end
