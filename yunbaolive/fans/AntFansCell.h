//
//  fans.h
//  yunbaolive
//
//  Created by cat on 16/4/1.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol guanzhu <NSObject>

-(void)doGuanzhu:(NSString*)st;

@end

@class AntFansModel;

@interface AntFansCell : UITableViewCell

@property(nonatomic,strong)AntFansModel *model;

@property (weak, nonatomic) IBOutlet UIButton *iconV;

- (IBAction)gaunzhuBTN:(UIButton *)btn;

@property (weak, nonatomic) IBOutlet UIImageView *hostlevel;


@property(nonatomic,assign)id<guanzhu>guanzhuDelegate;


@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UIImageView *sexL;
@property (weak, nonatomic) IBOutlet UIImageView *levelL;

@property (weak, nonatomic) IBOutlet UIButton *guanzhubtn;


@property (weak, nonatomic) IBOutlet UILabel *signatureL;





+(AntFansCell *)cellWithTableView:(UITableView *)tv;

@end
