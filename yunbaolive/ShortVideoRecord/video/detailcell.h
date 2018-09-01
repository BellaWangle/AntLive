//
//  detailcell.h
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/6.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailmodel.h"
#import "mylabels.h"

#import "commentcell.h"


@interface detailcell : UITableViewCell

@property(nonatomic,assign)id<pushCommetnDetails>delegate;
@property(nonatomic,strong)detailmodel *model;
@property(nonatomic,strong)UIButton *avatar_Button;//头像
@property(nonatomic,strong)UIButton *zan_Button;//赞
@property(nonatomic,strong)UILabel *nameL;//名称
@property(nonatomic,strong)mylabels *contentL;//回复的内容
@property(nonatomic,strong)mylabels *ReplyContentL;//回复的回复
@property(nonatomic,strong)UILabel *timeL;//时间
@property(nonatomic,strong)UILabel *lineL;
@property(nonatomic,strong)UILabel *replyLine;//回复的回复前面的红线
@property(nonatomic,strong)UIButton *Reply_Button;//回复
@property(nonatomic,strong)UIButton *bigbtn;

+(detailcell *)cellWithtableView:(UITableView *)tableView;

@end
