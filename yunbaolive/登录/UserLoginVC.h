//
//  UserLoginVC.h
//  yunbaolive
//
//  Created by YunBao on 2018/2/2.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserLoginVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *otherviews;

@property (weak, nonatomic) IBOutlet UIView *platformview;
@property (weak, nonatomic) IBOutlet UIButton *phoneLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *privateBtn;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;

- (IBAction)clickPhoneLoginBtn:(UIButton *)sender;
- (IBAction)clickPrivateBtn:(UIButton *)sender;

@end
