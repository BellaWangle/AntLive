//
//  RankCell.m
//  AntliveShow
//
//  Created by YunBao on 2018/2/2.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "RankCell.h"

@implementation RankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
+(RankCell *)cellWithTab:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    RankCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"RankCell" owner:nil options:nil]objectAtIndex:0];
        }
        cell.iconIV.layer.masksToBounds = YES;
        cell.iconIV.layer.cornerRadius = cell.iconIV.size.width/2;
        
    }else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"otherCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"RankCell" owner:nil options:nil]objectAtIndex:1];
        }
        cell.iconIV.layer.masksToBounds = YES;
        cell.iconIV.layer.cornerRadius = 20;
    }
    return cell;
}

-(void)setModel:(RankModel *)model {
    _model = model;
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:_model.iconStr] placeholderImage:[UIImage imageNamed:@"bg1"]];
    _nameL.text = _model.unameStr;
    //收益榜-0 消费榜-1
    if ([_model.type isEqual:@"0"]) {
        _levelIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"host_%@",_model.levelStr]];
    }else {
        _levelIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"leve%@",_model.levelStr]];
    }
    _moneyL.text = _model.totalCoinStr;
    
    if ([_model.isAttentionStr isEqual:@"0"]) {
        [_followBtn setTitle:[NSString stringWithFormat:@"+%@",YZMsg(@"关注")] forState:0];
        [_followBtn setTitleColor:normalColors forState:0];
        _followBtn.layer.borderColor = normalColors.CGColor;
    }else {
        [_followBtn setTitle:YZMsg(@"已关注") forState:0];
        [_followBtn setTitleColor:RGB(170, 170, 170) forState:0];
        _followBtn.layer.borderColor = RGB(170, 170, 170).CGColor;
    }
    _followBtn.layer.borderWidth = 1;
    _followBtn.layer.masksToBounds = YES;
    _followBtn.layer.cornerRadius = 15;
}


@end
