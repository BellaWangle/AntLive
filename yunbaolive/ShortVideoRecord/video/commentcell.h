//
//  commentcell.h
//  iphoneLive
//
//  Created by 王敏欣 on 2017/8/5.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commentModel.h"
#import "mylabels.h"

@protocol pushCommetnDetails <NSObject>

-(void)pushDetails:(NSDictionary *)commentdic;//跳回复列表

-(void)makeLikeRloadList:(NSString *)commectid andLikes:(NSString *)likes islike:(NSString *)islike;

@end



@interface commentcell : UITableViewCell
@property(nonatomic,assign)id<pushCommetnDetails>delegate;
@property(nonatomic,strong)commentModel *model;

@property(nonatomic,strong)UIButton *avatar_Button;//头像
@property(nonatomic,strong)UIButton *zan_Button;//赞
@property(nonatomic,strong)UILabel *nameL;//名称
@property(nonatomic,strong)mylabels *contentL;//内容
@property(nonatomic,strong)UILabel *timeL;//时间
@property(nonatomic,strong)UILabel *lineL;
@property(nonatomic,strong)UIButton *Reply_Button;//回复
@property(nonatomic,strong)UIButton *bigbtn;

+(commentcell *)cellWithtableView:(UITableView *)tableView;

@end
