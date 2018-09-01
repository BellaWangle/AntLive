//
//  YBBottomView.m
//  TCLVBIMDemo
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 tencent. All rights reserved.
//



#import "AntBottomView.h"
@interface AntBottomView ()
@end
@implementation AntBottomView
-(void)drawRect:(CGRect)rect{
    
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        NSArray *arr= @[@0,@0,@0];
        self.numArr = arr;
        NSArray *nameArr = @[YZMsg(@"直播"),YZMsg(@"关注2"),YZMsg(@"粉丝")];
        self.btnArr = nameArr;
        [self setUI];
    }
    return self;
}
//MARK:-设置button
-(void)setUI
{

    
    self.liveBtn =  [self YBBottomButton:self.liveBtn title:YZMsg(@"直播") titleFont:16  numValue:_numArr[0]];
    self.forceBtn = [self YBBottomButton:self.forceBtn title:YZMsg(@"关注2") titleFont:16 numValue:_numArr[1]];
    self.fanBtn =   [self YBBottomButton:self.forceBtn title:YZMsg(@"粉丝") titleFont:16 numValue:_numArr[2]];

    
    line1 = [[UILabel alloc]init];
    line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:line1];
    line2 = [[UILabel alloc]init];
    line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:line2];
}
//MARK:-layoutSubviews
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(_window_width/self.btnArr.count);
    }];
    [self.forceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.liveBtn.mas_right);
        make.top.width.height.equalTo(self.liveBtn);
    }];
    [self.fanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.forceBtn.mas_right);
        make.top.width.height.equalTo(self.liveBtn);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.liveBtn.mas_right);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(20);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.forceBtn.mas_right);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(20);
    }];
}
-(void)setAgain:(NSArray *)array{
    _numArr = array;
    [self.liveBtn removeFromSuperview];
    [self.forceBtn removeFromSuperview];
    [self.fanBtn removeFromSuperview];
    self.liveBtn =  [self YBBottomButton:self.liveBtn title:YZMsg(@"直播") titleFont:16  numValue:_numArr[0]];
    self.forceBtn = [self YBBottomButton:self.forceBtn title:YZMsg(@"关注2") titleFont:16 numValue:_numArr[1]];
    self.fanBtn =   [self YBBottomButton:self.forceBtn title:YZMsg(@"粉丝") titleFont:16 numValue:_numArr[2]];
}
- (UIButton *)YBBottomButton:(UIButton *)button  title:(NSString *)title titleFont:(CGFloat)titleFont numValue:(NSString *)numValue
{
    button = [[UIButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:RGB(252, 155, 3) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    NSString *btnNameStr1 =   [NSString stringWithFormat:@"%@ %@",title,numValue];
    [button addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:btnNameStr1];
    [AttributedStr1 addAttribute:NSForegroundColorAttributeName
                           value:[UIColor blackColor]
                           range:NSMakeRange(0, title.length)];
    [button setAttributedTitle:AttributedStr1 forState:UIControlStateNormal];
    [self addSubview:button];
    return button;
}
-(void)actionClick:(UIButton *)sender{
    [self.BottpmViewDelegate perform:sender.titleLabel.text];
}
@end
