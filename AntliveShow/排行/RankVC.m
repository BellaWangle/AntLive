//
//  RankVC.m
//  AntliveShow
//
//  Created by YunBao on 2018/2/1.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "RankVC.h"

#import "RankModel.h"
#import "RankCell.h"

@interface RankVC ()<UITableViewDelegate,UITableViewDataSource> {
    UISegmentedControl *segment1;    //收益榜、消费榜榜
    UILabel *line1;                  //收益榜下划线
    UILabel *line2;                  //消费榜榜下划线
    UISegmentedControl *segment2;    //日周月榜
    int paging;
    NSArray *oneArr;                  //收益-消费
    NSArray *twoArr;                  //日-周-月-总
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *models;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation RankVC

-(void)pullData {
    
    NSString *postUrl =oneArr[segment1.selectedSegmentIndex];
    NSDictionary *postDic = @{@"uid":[Config getOwnID],
                              @"type":twoArr[segment2.selectedSegmentIndex],
                              @"p":@(paging)
                              };
    [YBPullData pullWithUrl:postUrl Dic:postDic Suc:^(id data, id code, id msg) {
        if ([code isEqual:@"0"]) {
            NSArray *infoA = [data valueForKey:@"info"];
            if (paging == 1) {
                [_dataArray removeAllObjects];
            }
            if (infoA.count <=0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                [_tableView.mj_header endRefreshing];
            }else {
                [_dataArray addObjectsFromArray:infoA];
            }
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            [_tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }else {
            [MBProgressHUD showError:msg];
        }
        [_tableView.mj_footer endRefreshingWithNoMoreData];
        [_tableView.mj_header endRefreshing];
    } Fail:^(id fail) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
        [_tableView.mj_header endRefreshing];
    }];
}

-(NSArray *)models {
    NSMutableArray *m_arry = [NSMutableArray array];
    for (NSDictionary *dic in _dataArray) {
        RankModel *model = [RankModel modelWithDic:dic];
        [m_arry addObject:model];
    }
    _models = m_arry;
    return _models;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pullData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    self.models = [NSArray array];
    oneArr = @[@"Home.profitList",@"Home.consumeList"];
    twoArr = @[@"day",@"week",@"month",@"total"];
    [self creatNavi];
    
    paging = 1;
    
    NSArray *sgArr2 = [NSArray arrayWithObjects:YZMsg(@"日榜"),YZMsg(@"周榜"),YZMsg(@"月榜"),YZMsg(@"总榜"), nil];
    segment2 = [[UISegmentedControl alloc]initWithItems:sgArr2];
    segment2.frame = CGRectMake(10, 75+statusbarHeight, _window_width-20, 35);
    UIColor *segment2Color = RGB(245, 245, 245);
    segment2.tintColor = segment2Color;
    segment2.layer.borderColor = segment2Color.CGColor;
    segment2.layer.borderWidth = 1.5;
    NSDictionary *nomalC = [NSDictionary dictionaryWithObjectsAndKeys:fontMT(16),NSFontAttributeName,RGB(170, 170, 170), NSForegroundColorAttributeName, nil];
    [segment2 setTitleTextAttributes:nomalC forState:UIControlStateNormal];
    NSDictionary *selC = [NSDictionary dictionaryWithObjectsAndKeys:fontMT(16),NSFontAttributeName,normalColors, NSForegroundColorAttributeName, nil];
    [segment2 setTitleTextAttributes:selC forState:UIControlStateSelected];
    
    [segment2 setBackgroundImage:[self drawBckgroundImage:245 :245 :245] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segment2 setBackgroundImage:[self drawBckgroundImage:255 :255 :255] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [segment2 setDividerImage:[self drawBckgroundImage:255 :255 :255] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    segment2.selectedSegmentIndex = 0;
    [segment2 addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment2];
    
    [self.view addSubview:self.tableView];
}
#pragma mark -
#pragma mark - UISegmentedControl
- (void)segmentChange:(UISegmentedControl *)seg{
    if (segment1.selectedSegmentIndex == 0) {
        line1.hidden = NO;
        line2.hidden = YES;
    }else if (segment1.selectedSegmentIndex == 1){
        line1.hidden = YES;
        line2.hidden = NO;
    }
    
    [self pullData];
}
-(UIImage *)drawBckgroundImage:(CGFloat)r :(CGFloat)g :(CGFloat)b {
    CGSize size = CGSizeMake(2, 35);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, r/255.0, g/255.0, b/255.0, 1);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
#pragma mark -
#pragma mark - 点击事件
-(void)clickFollowBtn:(UIButton *)btn {
    
    if ([btn.titleLabel.text isEqual:YZMsg(@"已关注")]) {
        return;
    }
    btn.enabled = NO;
    RankModel *model = [_models objectAtIndex:btn.tag - 202];
    NSString *postUrl = @"User.setAttent";
    NSDictionary *postDic = @{@"uid":[Config getOwnID],
                              @"touid":model.uidStr
                              };
    [YBPullData pullWithUrl:postUrl Dic:postDic Suc:^(id data, id code, id msg) {
        btn.enabled = YES;
        if ([code isEqual:@"0"]) {
            NSString *isAtt = YBValue([[data valueForKey:@"info"] firstObject], @"isattent");
            NSMutableDictionary *needReloadDic = [NSMutableDictionary dictionaryWithDictionary:_dataArray[btn.tag - 202]];
            [needReloadDic setValue:isAtt forKey:@"isAttention"];
            NSMutableArray *m_arr = [NSMutableArray arrayWithArray:_dataArray];
            [m_arr replaceObjectAtIndex:(btn.tag - 202) withObject:needReloadDic];
            _dataArray = [m_arr mutableCopy];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:(btn.tag - 202) inSection:0];
            [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } Fail:^(id fail) {
        btn.enabled = YES;
    }];
    
}
#pragma mark -
#pragma mark - UITableViewDelegate,UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 ) {
        return 0.01;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return (_window_width*2/3*296/626 + 50);
    }
    return 75;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RankModel *model = _models[indexPath.row];
    RankCell *cell = [RankCell cellWithTab:tableView indexPath:indexPath];
    //收益榜-0 消费榜-1
    if (segment1.selectedSegmentIndex==0) {
        model.type = @"0";
    }else{
        model.type = @"1";
    }
    if (indexPath.row == 0) {
        //什么都不处理
    }else if (indexPath.row == 1){
        cell.kkIV.image = [UIImage imageNamed:@"rank_second"];
        cell.otherMCL.hidden = YES;
    }else if (indexPath.row == 2){
        cell.kkIV.image = [UIImage imageNamed:@"rank_third"];
        cell.otherMCL.hidden = YES;
    }else {
        cell.otherMCL.hidden = NO;
        cell.otherMCL.text = [NSString stringWithFormat:@"NO.%ld",indexPath.row+1];
    }
    cell.model = model;
    
    [cell.followBtn addTarget:self action:@selector(clickFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.followBtn.tag = 202 + indexPath.row;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark - tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, statusbarHeight+110, _window_width, _window_height-49-statusbarHeight-ShowDiff-110) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            paging = 1;
            [self pullData];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            paging +=1;
            [self pullData];
        }];
        
    }
    return _tableView;
}
#pragma mark -
#pragma mark - navi
-(void)creatNavi {
    
    UIView *navi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64+statusbarHeight)];
    navi.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navi];
    
    NSArray *sgArr1 = [NSArray arrayWithObjects:YZMsg(@"收益榜"),YZMsg(@"贡献榜"), nil];
    segment1 = [[UISegmentedControl alloc]initWithItems:sgArr1];
    segment1.frame = CGRectMake(_window_width/2-100, 27+statusbarHeight, 200, 30);
    segment1.tintColor = [UIColor clearColor];
    NSDictionary *nomalC = [NSDictionary dictionaryWithObjectsAndKeys:fontMT(16),NSFontAttributeName,[UIColor blackColor], NSForegroundColorAttributeName, nil];
    [segment1 setTitleTextAttributes:nomalC forState:UIControlStateNormal];
    NSDictionary *selC = [NSDictionary dictionaryWithObjectsAndKeys:fontMT(16),NSFontAttributeName,normalColors, NSForegroundColorAttributeName, nil];
    [segment1 setTitleTextAttributes:selC forState:UIControlStateSelected];
    segment1.selectedSegmentIndex = 0;
    [segment1 addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    [navi addSubview:segment1];
    
    line1 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2-100+35, segment1.bottom, 30, 1.5)];
    line1.backgroundColor = normalColors;
    line1.hidden = NO;
    [navi addSubview:line1];
    line2 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2-100+35+100, segment1.bottom, 30, 1.5)];
    line2.backgroundColor = normalColors;
    line2.hidden = YES;
    [navi addSubview:line2];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
