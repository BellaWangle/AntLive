//
//  commentModel.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/6.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "commentModel.h"

@implementation commentModel
-(instancetype)initWithDic:(NSDictionary *)subdic{
    self = [super init];
    if (self) {
        
        _avatar_thumb = [NSString stringWithFormat:@"%@",[[subdic valueForKey:@"userinfo"] valueForKey:@"avatar"]];
        _user_nicename = [NSString stringWithFormat:@"%@",[[subdic valueForKey:@"userinfo"] valueForKey:@"user_nicename"]];
        _content = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"content"]];
        _datetime = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"datetime"]];
        _likes = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"likes"]];
        _islike = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"islike"]];
        _replys = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"replys"]];
        _commentid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"commentid"]];
        _parentid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
        _ID = [NSString stringWithFormat:@"%@",[[subdic valueForKey:@"userinfo"] valueForKey:@"id"]];
        
        
    }
    return self;
}
-(void)setmyframe:(commentModel *)model{
    
    CGSize size = [_content boundingRectWithSize:CGSizeMake(_window_width - 120, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    _contentRect = CGRectMake(60,70, size.width, size.height);
    
    int replys = [_replys intValue];
    
    if (replys >0) {
        _ReplyRect = CGRectMake(60, _contentRect.origin.y + _contentRect.size.height + 10, _window_width - 120,30);
         _rowH = MAX(0, CGRectGetMaxY(_ReplyRect)) + 10;
    }
    else{
        _ReplyRect = CGRectMake(0, 0, 0, 0);
        _rowH = MAX(0, CGRectGetMaxY(_contentRect)) + 15;
    }
}
+(instancetype)modelWithDic:(NSDictionary *)subdic{
    commentModel *model = [[commentModel alloc]initWithDic:subdic];
    return model;
}
@end
