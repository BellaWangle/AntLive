//
//  detailHead.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/7.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "detailHead.h"

@implementation detailHead

-(instancetype)init{
    self = [super init];
    if (self) {
        
    
       self.backgroundColor = [UIColor whiteColor];
    }
    return self;
    
}

-(void)justdoit:(NSDictionary *)dic comment:(commectdetailblock)comment{
    
    self.commentblock = comment;
    //头像
    _avatar_Button = [UIButton buttonWithType:0];
    _avatar_Button.layer.masksToBounds = YES;
    _avatar_Button.layer.cornerRadius = 20;
    _avatar_Button.frame = CGRectMake(10,20,40,40);
    [self addSubview:_avatar_Button];
    
    
    //名称
    _nameL = [[UILabel alloc]init];
    _nameL.textColor = RGB(123, 123, 123);
    _nameL.font = [UIFont systemFontOfSize:14];
    _nameL.frame = CGRectMake(_avatar_Button.right + 10,20,200,20);
    _nameL.numberOfLines = 0;
    [self addSubview:_nameL];
    
    
    //时间
    _timeL = [[UILabel alloc]init];
    _timeL.textColor = RGB(208, 208, 208);
    _timeL.font = [UIFont systemFontOfSize:12];
    _timeL.frame = CGRectMake(_avatar_Button.right + 10, _nameL.bottom, 200, 20);
    [self addSubview:_timeL];
    
    
    //点赞
    _zan_Button = [UIButton buttonWithType:0];
    _zan_Button.frame = CGRectMake(_window_width - 90,20,80,30);
    _zan_Button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_zan_Button setTitleColor:RGB(123, 123, 123) forState:0];
    _zan_Button.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_zan_Button];
    [_zan_Button setImage:[UIImage imageNamed:@"likecomment"] forState:0];
    [_zan_Button setImageEdgeInsets:UIEdgeInsetsMake(5,60,5,0)];
    [_zan_Button setTitleEdgeInsets:UIEdgeInsetsMake(10,-50,10,0)];
    [_zan_Button addTarget:self action:@selector(makeLike) forControlEvents:UIControlEventTouchUpInside];
    
    
    _bigbtn = [UIButton buttonWithType:0];
    _bigbtn.frame = CGRectMake(_window_width - 110, 10, 110, 50);
    [_bigbtn addTarget:self action:@selector(makeLike) forControlEvents:UIControlEventTouchUpInside];
     [self addSubview:_bigbtn];
    
    //回复内容
    _contentL = [[mylabels alloc]init];
    _contentL.lineBreakMode = NSLineBreakByCharWrapping;
    _contentL.textAlignment = NSTextAlignmentLeft;
    _contentL.textColor = RGB(72, 72, 72);
    _contentL.font = [UIFont systemFontOfSize:14];
    _contentL.numberOfLines = 0;
    [self addSubview:_contentL];
    
    
    //回复数量
    _allComments = [[UILabel alloc]init];
    _allComments.textColor = [UIColor blackColor];
    _allComments.backgroundColor = RGB(248, 248, 248);
    _allComments.font = [UIFont systemFontOfSize:18];
    [self addSubview:_allComments];
    
    
    //分割线
    _lineL = [[UILabel alloc]init];
    _lineL.backgroundColor = RGB(230, 230, 230);
    [self addSubview:_lineL];
    
    
    [self setdata:dic];
    self.backgroundColor = [UIColor whiteColor];
    
    
}
-(void)setdata:(NSDictionary *)dic{
    _hostdic = [NSDictionary dictionaryWithDictionary:dic];
    [_avatar_Button sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dic valueForKey:@"userinfo"] valueForKey:@"avatar"]]] forState:0];
    _nameL.text = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"userinfo"] valueForKey:@"user_nicename"]];
    _timeL.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"datetime"]];
    _contentL.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"content"]];
    [_zan_Button setTitle:[NSString stringWithFormat:@"%@",[dic valueForKey:@"likes"]] forState:0];
    if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"likes"]] intValue] == 0) {
        [_zan_Button setTitle:YZMsg(@"赞") forState:0];
    }
    CGSize size = [_contentL.text boundingRectWithSize:CGSizeMake(_window_width - 120, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    _contentRect = CGRectMake(60,70, size.width + 20, size.height);
    _contentL.frame = _contentRect;
    _allComments.frame = CGRectMake(0, _contentRect.origin.y + _contentRect.size.height+10, _window_width,50);
    _lineL.frame =  CGRectMake(0, _allComments.bottom - 1, _window_width, 0.8);
    
    NSString *islike = [NSString stringWithFormat:@"%@",[dic valueForKey:@"islike"]];
    
    if ([islike isEqual:@"1"]) {
        _bigbtn.userInteractionEnabled = NO;
        [_zan_Button setTitleColor:[UIColor redColor] forState:0];
        [_zan_Button setTitle:[NSString stringWithFormat:@"%@",[dic valueForKey:@"likes"]] forState:0];
        [_zan_Button setImage:[UIImage imageNamed:@"likecomment-click"] forState:0];
    }
    else{
        [_zan_Button setTitleColor:RGB(123, 123, 123) forState:0];
        [_zan_Button setImage:[UIImage imageNamed:@"likecomment"] forState:0];
        [_zan_Button setTitle:[NSString stringWithFormat:@"%@",[dic valueForKey:@"likes"]] forState:0];
    }
    
}
//点赞
-(void)makeLike{
    

    if ([[NSString stringWithFormat:@"%@",[_hostdic valueForKey:@"ID"]] isEqual:[Config getOwnID]]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:YZMsg(@"不能给自己的评论点赞") delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
        
        return;
    }
    
    _bigbtn.userInteractionEnabled = NO;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.addCommentLike&uid=%@&commentid=%@",[Config getOwnID],[_hostdic valueForKey:@"parentid"]];
    
    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                NSString *islike = [NSString stringWithFormat:@"%@",[info valueForKey:@"islike"]];
                NSString *likes = [NSString stringWithFormat:@"%@",[info valueForKey:@"likes"]];
                if ([islike isEqual:@"1"]) {
                    _bigbtn.userInteractionEnabled = NO;
                    [_zan_Button setTitleColor:[UIColor redColor] forState:0];
                    [_zan_Button setTitle:[NSString stringWithFormat:@"%@",likes] forState:0];
                    [_zan_Button setImage:[UIImage imageNamed:@"likecomment-click"] forState:0];
                    self.commentblock(likes);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
    
}
@end
