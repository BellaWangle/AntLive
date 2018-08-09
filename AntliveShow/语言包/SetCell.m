//
//  SetCell.m
//  iphoneLive
//
//  Created by Boom on 2017/9/8.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "SetCell.h"

@implementation SetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)swichBtnClick:(id)sender {
    if (_swichBtn.selected) {
        [_swichBtn setImage:[UIImage imageNamed:@"tw_swich_guan"] forState:0];
    }else{
        [_swichBtn setImage:[UIImage imageNamed:@"tw_swich_kai"] forState:0];
    }
    _swichBtn.selected = !_swichBtn.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
