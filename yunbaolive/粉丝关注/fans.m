//
//  fans.m
//  yunbaolive
//
//  Created by cat on 16/4/1.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "fans.h"
#import "fansModel.h"
#import "fansViewController.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

#import "Config.h"
@implementation fans

-(void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx,1);
    CGContextSetStrokeColorWithColor(ctx,[UIColor groupTableViewBackgroundColor].CGColor);
    CGContextMoveToPoint(ctx,0,self.frame.size.height);
    CGContextAddLineToPoint(ctx,(self.frame.size.width),self.frame.size.height);
    CGContextStrokePath(ctx);
}

-(void)setModel:(fansModel *)model{
    _model = model;
    _nameL.text = _model.name;
    _signatureL.text = _model.signature;
    //性别 1男
     if ([[_model valueForKey:@"sex"] isEqual:@"1"])
    {
        self.sexL.image = [UIImage imageNamed:@"choice_sex_nanren"];
    }
    else
    {
        self.sexL.image = [UIImage imageNamed:@"choice_sex_nvren"];
    }
    //级别
    self.levelL.image = [UIImage imageNamed:[NSString stringWithFormat:@"host_%@",_model.level_anchor]];
    self.hostlevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"leve%@",_model.level]];
    //头像
    [self.iconV sd_setBackgroundImageWithURL:[NSURL URLWithString:_model.icon]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bg1"]];
    self.iconV.layer.cornerRadius = 20;
    self.iconV.layer.masksToBounds = YES;
    //关注
//    [self.guanzhubtn setImage:[UIImage imageNamed:@"me_following(1)"] forState:UIControlStateSelected];
//    [self.guanzhubtn setImage:[UIImage imageNamed:@"me_follow(1)"] forState:UIControlStateNormal];
    [self.guanzhubtn setTitle:YZMsg(@"已关注") forState:UIControlStateSelected];
    [self.guanzhubtn setTitle:YZMsg(@"关注") forState:UIControlStateNormal];
    self.guanzhubtn.layer.cornerRadius = 5;
    self.guanzhubtn.layer.masksToBounds = YES;
    if ([_model.isattention isEqual:@"0"]) {
        self.guanzhubtn.selected = NO;
        [self.guanzhubtn setBackgroundColor:normalColors];
    }
    else
    {
        self.guanzhubtn.selected = YES;
        [self.guanzhubtn setBackgroundColor:[UIColor grayColor]];
    }
}

+(fans *)cellWithTableView:(UITableView *)tv{
    fans *cell = [tv dequeueReusableCellWithIdentifier:@"a"];
    if (!cell) {
       cell = [[NSBundle mainBundle]loadNibNamed:@"fans" owner:self options:nil].lastObject;
    }
    return cell;
    
}
- (IBAction)gaunzhuBTN:(UIButton *)btn{
    if ([[Config getOwnID] isEqual:_model.uid]) {
        [MBProgressHUD showError:YZMsg(@"不能关注自己")];
            return;
    }
    if(btn.selected == YES)
    {
        btn.selected = NO;
        [self.guanzhubtn setBackgroundColor:[UIColor grayColor]];

    }
    else
    {
        btn.selected = YES;
        [self.guanzhubtn setBackgroundColor:normalColors];

    }
    [self.guanzhuDelegate doGuanzhu:_model.uid];
}


@end
