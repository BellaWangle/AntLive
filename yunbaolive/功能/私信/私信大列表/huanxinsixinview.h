//
//  huanxinsixinview.h
//  yunbaolive
//
//  Created by zqm on 16/8/3.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMListen.h"
#import "chatsmallview.h"
@interface huanxinsixinview : JMListen<UITableViewDataSource,UITableViewDelegate>
{
    UISegmentedControl *segmentC;
    UILabel *xianLabel;//下划线
    UILabel *xianLabel2;
    CGFloat w;//segment一个item的宽
    NSString *lastMessage;//获取最后一条消息
    UILabel *label1;//获取会话所有的未读消息数 关注
    UILabel *label2;//未关注
    UILabel *line1;
    UILabel *line2;
    chatsmallview *chatView;
    NSString *idStrings;
}
@property(nonatomic,strong)NSArray *models;
@property(nonatomic,strong)NSMutableArray *UNfollowArray;//未关注好友
@property(nonatomic,strong)NSMutableArray *followArray;//关注好友
@property(nonatomic,strong)NSMutableArray *JIMallArray;//所有
@property(nonatomic,strong)UITableView *tableView;
-(void)forMessage;

@end
