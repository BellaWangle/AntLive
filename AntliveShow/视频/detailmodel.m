//
//  detailmodel.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/6.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "detailmodel.h"
@implementation detailmodel
-(instancetype)initWithDic:(NSDictionary *)subdic{
    self = [super init];
    if (self) {
    _avatar_thumb = [NSString stringWithFormat:@"%@",[[subdic valueForKey:@"userinfo"] valueForKey:@"avatar"]];
    _user_nicename = [NSString stringWithFormat:@"%@",[[subdic valueForKey:@"userinfo"] valueForKey:@"user_nicename"]];
    _ID = [NSString stringWithFormat:@"%@",[[subdic valueForKey:@"userinfo"] valueForKey:@"id"]];
    _content = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"content"]];
    _datetime = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"datetime"]];
    _likes = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"likes"]];
    _islike = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"islike"]];
    _touid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"touid"]];
    _touserinfo = [subdic valueForKey:@"touserinfo"];
    _tocommentinfo = [subdic valueForKey:@"tocommentinfo"];
    _parentid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
    }
    return self;
}
-(void)setmyframe:(detailmodel *)model{
    //判断是不是回复的回复
    int touid = [_touid intValue];    
    if (touid>0) {
    NSString *reply1 = [NSString stringWithFormat:@"回复%@:%@",[_touserinfo valueForKey:@"user_nicename"],_content];
    CGSize size = [reply1 boundingRectWithSize:CGSizeMake(_window_width - 120, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    _contentRect = CGRectMake(60,75, size.width+20, size.height);
    NSString *reply = [NSString stringWithFormat:@"%@:%@",[_touserinfo valueForKey:@"user_nicename"],[_tocommentinfo valueForKey:@"content"]];
     CGSize size2 = [reply boundingRectWithSize:CGSizeMake(_window_width - 120, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    _ReplyRect = CGRectMake(65, _contentRect.origin.y + _contentRect.size.height + 15, size2.width+20, size2.height);
    _rowH = MAX(0, CGRectGetMaxY(_ReplyRect)) + 15;
    }
    else{
        CGSize size = [_content boundingRectWithSize:CGSizeMake(_window_width - 120, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        _contentRect = CGRectMake(60,70, size.width, size.height);
        _ReplyRect = CGRectMake(0, 0, 0, 0);
        _rowH = MAX(0, CGRectGetMaxY(_contentRect)) + 15;
    }
}
+(instancetype)modelWithDic:(NSDictionary *)subdic{
    detailmodel *model = [[detailmodel alloc]initWithDic:subdic];
    return model;
}
@end
