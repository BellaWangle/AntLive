//
//  videocell.h
//  iphoneLive
//
//  Created by 王敏欣 on 2017/8/4.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface videocell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverimage;

@property (weak, nonatomic) IBOutlet UIImageView *iconimage;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *numslabel;

@end
