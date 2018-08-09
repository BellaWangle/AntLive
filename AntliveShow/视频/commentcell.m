//
//  commentcell.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/8/5.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "commentcell.h"
@implementation commentcell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    //头像
        _avatar_Button = [UIButton buttonWithType:0];
        [_avatar_Button addTarget:self action:@selector(NOaction) forControlEvents:UIControlEventTouchUpInside];
        _avatar_Button.userInteractionEnabled = NO;
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
        [self addSubview:_zan_Button];
        _zan_Button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_zan_Button setImage:[UIImage imageNamed:@"likecomment"] forState:0];
        [_zan_Button setImageEdgeInsets:UIEdgeInsetsMake(5,60,5,0)];
        [_zan_Button setTitleEdgeInsets:UIEdgeInsetsMake(10,-50,10,0)];
        [_zan_Button addTarget:self action:@selector(makeLike) forControlEvents:UIControlEventTouchUpInside];
        
        _bigbtn = [UIButton buttonWithType:0];
        _bigbtn.frame = CGRectMake(_window_width - 110, 10, 110, 50);
        [_bigbtn addTarget:self action:@selector(makeLike) forControlEvents:UIControlEventTouchUpInside];
    //回复
        _Reply_Button = [UIButton buttonWithType:0];
        _Reply_Button.backgroundColor = [UIColor whiteColor];
        _Reply_Button.titleLabel.textAlignment = NSTextAlignmentLeft;
        _Reply_Button.layer.masksToBounds = YES;
        _Reply_Button.layer.cornerRadius = 5;
        _Reply_Button.hidden = YES;
        [_Reply_Button setTitleEdgeInsets:UIEdgeInsetsMake(0,-120,0,0)];
        if (IS_IPHONE_5) {
        [_Reply_Button setTitleEdgeInsets:UIEdgeInsetsMake(0,-40,0,0)];
        }
        [_Reply_Button setTitleColor:RGB(90, 92, 147) forState:0];
        _Reply_Button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_Reply_Button addTarget:self action:@selector(makeReply) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_Reply_Button];
        
    //内容
        _contentL = [[mylabels alloc]init];
        _contentL.lineBreakMode = NSLineBreakByCharWrapping;
        _contentL.textAlignment = NSTextAlignmentLeft;
        _contentL.textColor = RGB(72, 72, 72);
        _contentL.font = [UIFont systemFontOfSize:14];
        _contentL.numberOfLines = 0;
        [self addSubview:_contentL];
        
        _lineL = [[UILabel alloc]init];
        _lineL.backgroundColor = RGB(230, 230, 230);
        [self addSubview:_lineL];
        self.backgroundColor = RGB(248, 248, 248);
        [self addSubview:_bigbtn];
        
    }
    return self;
}
-(void)NOaction{
    
    
}
//点赞
-(void)makeLike{
    if ([_model.ID isEqual:[Config getOwnID]]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:YZMsg(@"不能给自己的评论点赞") delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
        
        return;
    }
    
    _bigbtn.userInteractionEnabled = NO;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.addCommentLike&uid=%@&commentid=%@",[Config getOwnID],_model.parentid];

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

                [self.delegate makeLikeRloadList:_model.parentid andLikes:likes islike:islike];
              }
            else{
                
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}
//回复
-(void)makeReply{
    
    [self.delegate pushDetails:@{
                                 @"avatar":_model.avatar_thumb,
                                 @"user_nicename":_model.user_nicename,
                                 @"datetime":_model.datetime,
                                 @"content":_model.content,
                                 @"likes":_model.likes,
                                 @"islike":_model.islike,
                                 @"commentid":_model.commentid,
                                 @"parentid":_model.parentid,
                                 @"allcommecnts":_model.replys,
                                 @"ID":_model.ID
                                 }];
    
}
-(void)setModel:(commentModel *)model{
    _model = model;
    [_avatar_Button sd_setImageWithURL:[NSURL URLWithString:_model.avatar_thumb] forState:0];
    _nameL.text = _model.user_nicename;
    _timeL.text = _model.datetime;
    [_zan_Button setTitle:_model.likes forState:0];
    if ([_model.islike intValue] == 0) {
        _zan_Button.userInteractionEnabled = YES;
        _bigbtn.userInteractionEnabled = YES;
      [_zan_Button setTitleColor:RGB(123, 123, 123) forState:0];
      [_zan_Button setTitle:_model.likes forState:0];
    if ([_model.likes isEqual:@"0"]) {
        [_zan_Button setTitle:YZMsg(@"赞") forState:0];
    }
      [_zan_Button setImage:[UIImage imageNamed:@"likecomment"] forState:0];
    }
    else{
        _zan_Button.userInteractionEnabled = NO;
        _bigbtn.userInteractionEnabled = NO;
        [_zan_Button setTitleColor:[UIColor redColor] forState:0];
        [_zan_Button setTitle:_model.likes forState:0];
        [_zan_Button setImage:[UIImage imageNamed:@"likecomment-click"] forState:0];
    }
    _contentL.text = _model.content;
    _contentL.frame = _model.contentRect;
    _Reply_Button.frame = _model.ReplyRect;
    int replys = [_model.replys intValue];
    if (replys>0) {
        _Reply_Button.hidden = NO;
        _lineL.frame = CGRectMake(60,_model.ReplyRect.origin.y + _model.ReplyRect.size.height+13, _window_width - 60,0.8);
    }else{
        _Reply_Button.hidden = YES;
        _lineL.frame = CGRectMake(60,_model.contentRect.origin.y + _model.contentRect.size.height+13, _window_width - 60,0.8);
    }
    [_Reply_Button setTitle:[NSString stringWithFormat:@"%d条%@>",YZMsg(@"查看全部"),replys,YZMsg(@"回复")] forState:0];
}
+(commentcell *)cellWithtableView:(UITableView *)tableView{
    commentcell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentcell"];
    if (!cell) {
        cell = [[commentcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentcell"];
    }
    return cell;
}
@end
