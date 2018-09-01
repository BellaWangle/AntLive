//
//  ProfitViewC.h
//  yunbaolive
//
//  Created by cat on 16/3/14.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfitViewC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labVotes;
@property (weak, nonatomic) IBOutlet UILabel *canwithdraw;
@property (weak, nonatomic) IBOutlet UILabel *withdraw;
@property (nonatomic,copy) NSString *titleStr;
@end
