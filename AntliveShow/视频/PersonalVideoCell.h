//
//  PersonalVideoCell.h
//  iphoneLive
//
//  Created by YangBiao on 2017/9/7.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyVideoModel.h"
@interface PersonalVideoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeAndAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;

@property (nonatomic,strong) NearbyVideoModel *model;

@end
