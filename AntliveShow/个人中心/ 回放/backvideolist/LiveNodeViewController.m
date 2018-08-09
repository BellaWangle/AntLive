//
//  LiveNodeViewController.m
//  AntliveShow
//
//  Created by cat on 16/4/6.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "LiveNodeViewController.h"
#import "LiveNodeModel.h"
#import "LiveNodeTableViewCell.h"
#import "hietoryPlay.h"
@interface LiveNodeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int setvisssss;
    UIView *_nothingView;
    UIActivityIndicatorView *testActivityIndicator;//菊花
    UIImageView *NoInternetImageV;
}
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong)NSArray *models;
@property(nonatomic,strong)NSArray *allArray;
@end
@implementation LiveNodeViewController
-(NSArray *)models{
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.allArray) {
        LiveNodeModel *model = [LiveNodeModel modelWithDic:dic];
        [array addObject:model];
    }
    _models = array;
    return _models;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    setvisssss = 1;

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvisssss = 0;
   
}
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    UILabel *label = [[UILabel alloc]init];
    label.text = YZMsg(@"直播记录");
    [label setFont:navtionTitleFont];
    label.textColor = navtionTitleColor;
    label.frame = CGRectMake(0, statusbarHeight,_window_width,84);
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor whiteColor];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, statusbarHeight, _window_width/2, 64)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(10,30 + statusbarHeight,30,20);[returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    returnBtn.tintColor = [UIColor blackColor];
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,64);
    [navtion addSubview:btnttttt];
    navtion.backgroundColor = navigationBGColor;
    [self.view addSubview:navtion];
}
-(void)doReturn{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64 + statusbarHeight, _window_width, _window_height-64 - statusbarHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self navtion];
    [self createView];
    _nothingView.hidden = YES;
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = self.view.center;
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
    
    
    NoInternetImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0.3 * _window_width, 0.3 * _window_height, 0.4 * _window_width, 0.4 * _window_width)];
     NoInternetImageV.contentMode = UIViewContentModeScaleAspectFit;
    NoInternetImageV.image = [UIImage imageNamed:@"shibai"];
    [self.view addSubview:NoInternetImageV];
    NoInternetImageV.hidden = YES;
    
    [self getLiveList];
}
-(void)getLiveList{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.getLiverecord"];
    NSDictionary *subdic = @{
                             @"touid":[Config getOwnID],
                             @"p":@"1"
                             };
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSArray *info = [data valueForKey:@"info"];
                self.allArray = info;
                [self.tableView reloadData];
                if (self.allArray.count == 0) {
                    [self.tableView removeFromSuperview];
                    _nothingView.hidden = NO;
                }
                [testActivityIndicator stopAnimating]; // 结束旋转
                [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
            }
            else{
                _nothingView.hidden = NO;
                [testActivityIndicator stopAnimating]; // 结束旋转
                [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
            }
        }
        else{
            _nothingView.hidden = NO;
            [testActivityIndicator stopAnimating]; // 结束旋转
            [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
            
            
        }
        NoInternetImageV.hidden = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _nothingView.hidden = YES;
        
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        if (self.allArray.count == 0) {
            NoInternetImageV.hidden = NO;
        }
    }];

}
-(void)createView{
    _nothingView = [[UIView alloc] initWithFrame:CGRectMake(0.2 * _window_width, 0.2 * _window_height, 0.6 * _window_width, 0.5 * _window_height)];
    _nothingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_nothingView];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0.15 * _window_width, 0.1 * _window_height, 0.3 * _window_width, 0.3 * _window_width)];
    imageV.image = [UIImage imageNamed:getImagename(@"关注无")];
    [_nothingView addSubview:imageV];
    _nothingView.hidden = YES;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveNodeTableViewCell *cell = [LiveNodeTableViewCell cellWithTV:tableView];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    LiveNodeModel *model = self.models[indexPath.row];
    cell.model = model;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *subdics = self.allArray[indexPath.row];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *string  = [NSString stringWithFormat:@"service=User.getAliCdnRecord&id=%@",[subdics valueForKey:@"id"]];
    string = [purl stringByAppendingFormat:@"%@",string];
    
    [session POST:string parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                
                hietoryPlay *history = [[hietoryPlay alloc]init];
                history.url = [[[data valueForKey:@"info"] firstObject] valueForKey:@"url"];
                [self presentViewController:history animated:YES completion:nil];
            }
            else{
               
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
                
            }
        }
  
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
    }];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}
@end
