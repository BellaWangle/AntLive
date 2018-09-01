//
//  coastselecell.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/7/1.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "timeChargeCell.h"

@implementation timeChargeCell

+(timeChargeCell *)cellWithTableView:(UITableView *)tableview{
    timeChargeCell *cell = [tableview dequeueReusableCellWithIdentifier:@"coastselecell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"timeChargeCell" owner:self options:nil].lastObject;
    }
    return cell;
}
@end
