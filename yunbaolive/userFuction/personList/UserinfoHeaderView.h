//
//  UserinfoHeaderView.h
//  AntLive
//
//  Created by 毅力起 on 2018/8/31.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBPersonTableViewModel.h"

@protocol UserinfoHeaderViewDelegate <NSObject>

-(void)pushEditView;
-(void)pushLiveNodeList;
-(void)pushAttentionList;
-(void)pushFansList;

@end

@interface UserinfoHeaderView : UIView

@property (nonatomic, strong) YBPersonTableViewModel * model;

@property(nonatomic,assign)id<UserinfoHeaderViewDelegate>delegate;

@end
