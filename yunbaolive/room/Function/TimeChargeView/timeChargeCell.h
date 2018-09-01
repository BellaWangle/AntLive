//
//  coastselecell.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/7/1.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timeChargeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *showlabel;

+(timeChargeCell *)cellWithTableView:(UITableView *)tableview;

@end
