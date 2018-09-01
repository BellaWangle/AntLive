//
//  LiveNodeTableViewCell.m
//  yunbaolive
//
//  Created by cat on 16/4/6.
//  Copyright © 2016年 cat. All rights reserved.
//
#import "backLiveCell.h"
#import "backLiveModel.h"
@implementation backLiveCell
-(void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx,1);
    CGContextSetStrokeColorWithColor(ctx,[UIColor groupTableViewBackgroundColor].CGColor);
    CGContextMoveToPoint(ctx,0,self.frame.size.height);
    CGContextAddLineToPoint(ctx,(self.frame.size.width),self.frame.size.height);
    CGContextStrokePath(ctx);
}
-(void)setModel:(backLiveModel *)model{
    
    _model = model;
    self.labTitle.text = _model.title;
    self.labStartTime.text = _model.datestarttime;
    self.labNums.text = _model.nums;
    self.labNums.textColor = normalColors;
}
+(backLiveCell *)cellWithTV:(UITableView *)tv{
    backLiveCell *cell = [tv dequeueReusableCellWithIdentifier:@"a"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"showNote" owner:self options:nil].lastObject;
    }
    cell.kanguo.text = YZMsg(@"看过");
    return cell;
}
@end
