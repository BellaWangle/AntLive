//
//  LiveNodeTableViewCell.h
//  yunbaolive
//
//  Created by cat on 16/4/6.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "backLiveModel.h"
@interface backLiveCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labStartTime;

@property (weak, nonatomic) IBOutlet UILabel *labNums;

@property (weak, nonatomic) IBOutlet UILabel *kanguo;

@property(nonatomic,strong)backLiveModel *model;

+(backLiveCell *)cellWithTV:(UITableView *)tv;

@end
