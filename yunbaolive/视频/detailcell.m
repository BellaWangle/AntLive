//
//  detailcell.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/6.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "detailcell.h"
@implementation detailcell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
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
        
        //回复内容
        _contentL = [[mylabels alloc]init];
        _contentL.lineBreakMode = NSLineBreakByCharWrapping;
        _contentL.textAlignment = NSTextAlignmentLeft;
        _contentL.textColor = RGB(72, 72, 72);
        _contentL.font = [UIFont systemFontOfSize:14];
        _contentL.numberOfLines = 0;
        [self addSubview:_contentL];
        
        
        //回复的回复
        _ReplyContentL = [[mylabels alloc]init];
        _ReplyContentL.lineBreakMode = NSLineBreakByCharWrapping;
        _ReplyContentL.textAlignment = NSTextAlignmentLeft;
        _ReplyContentL.textColor = RGB(72, 72, 72);
        _ReplyContentL.font = [UIFont systemFontOfSize:14];
        _ReplyContentL.numberOfLines = 0;
        _ReplyContentL.hidden = YES;
        [self addSubview:_ReplyContentL];
        
        
        //cell分割线
        _lineL = [[UILabel alloc]init];
        _lineL.backgroundColor = RGB(230, 230, 230);
        [self addSubview:_lineL];
        self.backgroundColor = RGB(248, 248, 248);

        
        //回复的回复前面的红线
        _replyLine = [[UILabel alloc]init];
        _replyLine.backgroundColor = [UIColor redColor];
        _replyLine.hidden = YES;
        [self addSubview:_replyLine];
        [self addSubview:_bigbtn];
        
    }
    return self;
}
//点赞
-(void)makeLike{
    
    if ([_model.ID isEqual:[Config getOwnID]]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:YZMsg(@"不能给自己的回复点赞") delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
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
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}
-(void)setModel:(detailmodel *)model{
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
    _ReplyContentL.frame = _model.ReplyRect;
    //如果touid大于0 则说明 这条回复有回复
    int touid = [_model.touid intValue];
    if (touid>0) {
    NSString *path1 = [NSString stringWithFormat:@"%@%@:%@%@",YZMsg(@"回复"), [_model.touserinfo valueForKey:@"user_nicename"],@" ",_model.content];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:path1];
    NSRange redRange = NSMakeRange(2, [[noteStr string] rangeOfString:@":"].location);
    [noteStr addAttribute:NSForegroundColorAttributeName value:RGB(111,111,163) range:redRange];
    _contentL.attributedText = noteStr;
    
    NSString *path2 = [NSString stringWithFormat:@"%@:%@%@",[_model.touserinfo valueForKey:@"user_nicename"],@" ",[_model.tocommentinfo valueForKey:@"content"]];
    NSMutableAttributedString *noteStr2 = [[NSMutableAttributedString alloc] initWithString:path2];
    NSRange redRange2 = NSMakeRange(0, [[noteStr string] rangeOfString:@":"].location);
    [noteStr2 addAttribute:NSForegroundColorAttributeName value:RGB(111,111,163) range:redRange2];
    _ReplyContentL.attributedText = noteStr2;
    //设置回复的回复红线坐标
    _replyLine.frame = CGRectMake(60, _model.ReplyRect.origin.y, 2, _model.ReplyRect.size.height);
    _ReplyContentL.hidden = NO;
    _replyLine.hidden = NO;
    _lineL.frame = CGRectMake(60,_model.ReplyRect.origin.y + _model.ReplyRect.size.height + 13, _window_width - 60,0.8);
        
    }
    else{
    _replyLine.hidden = YES;
    _ReplyContentL.hidden = YES;
    _lineL.frame = CGRectMake(60,_model.contentRect.origin.y + _model.contentRect.size.height + 13, _window_width - 60,0.8);
    }
}
+(detailcell *)cellWithtableView:(UITableView *)tableView{
    detailcell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailcell"];
    if (!cell) {
        cell = [[detailcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailcell"];
    }
    return cell;
}
@end
