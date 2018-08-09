//
//  PersonalVideoCell.m
//  iphoneLive
//
//  Created by YangBiao on 2017/9/7.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "PersonalVideoCell.h"
@implementation PersonalVideoCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(NearbyVideoModel *)model{
    _model = model;
    [self.videoImage sd_setImageWithURL:[NSURL URLWithString:model.videoImage]];
    self.videoTitle.text = model.videoTitle;
    if (model.city.length <= 0 || [model.city isEqualToString:@"(null)"] || !model.city) {
        self.timeAndAddressLabel.text = [NSString stringWithFormat:@"%@",model.time];
    }
    else{
        self.timeAndAddressLabel.text = [NSString stringWithFormat:@"%@·%@",model.time,model.city];
    }
    
    self.commentNumLabel.text = [NSString stringWithFormat:@"%@",model.commentNum];
}

@end
