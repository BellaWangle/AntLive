//
//  searchVC.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/2/17.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "searchVC.h"
#import "HXSearchBar.h"
#import "AntFansModel.h"
#import "AntFansCell.h"
#import "AntPersonMsg.h"

@interface searchVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,guanzhu>
{
    UIImageView *imageView;
    HXSearchBar *searchBars;

}
@property (strong, nonatomic)UITableView *tableView;
@property(nonatomic,strong)NSArray *models;
@property(nonatomic,strong)NSArray *allArray;
@end

@implementation searchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60 + statusbarHeight, _window_width, _window_height-60 -statusbarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellStyleDefault;
    [self.view addSubview:_tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.3 * _window_width, 0.25 * _window_height, 0.4 * _window_width,  0.4 * _window_width)];
    imageView.image = [UIImage imageNamed:getImagename(@"搜索无")];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.hidden = YES;
    [self.view addSubview:imageView];
    self.allArray = [NSArray array];
    [self addSearchBar];
}
//添加搜索条
- (void)addSearchBar {
    //加上 搜索栏
    searchBars = [[HXSearchBar alloc] initWithFrame:CGRectMake(10,10 + statusbarHeight, self.view.frame.size.width -20,60)];
    searchBars.backgroundColor = [UIColor clearColor];
    searchBars.delegate = self;
    //输入框提示
    searchBars.placeholder = YZMsg(@"请输入您要搜索的昵称或ID");
    //光标颜色
    searchBars.cursorColor = normalColors;
    //TextField
    searchBars.searchBarTextField.layer.cornerRadius = 16;
    searchBars.searchBarTextField.layer.masksToBounds = YES;
//    searchBars.searchBarTextField.layer.borderColor = [UIColor grayColor].CGColor;
//    searchBars.searchBarTextField.layer.borderWidth = 1.0;
    searchBars.searchBarTextField.backgroundColor = RGB(241, 241, 241);
    //清除按钮图标
    //searchBar.clearButtonImage = [UIImage imageNamed:@"demand_delete"];
    //去掉取消按钮灰色背景
    searchBars.hideSearchBarBackgroundImage = YES;
    [searchBars becomeFirstResponder];
    [self.view addSubview:searchBars];
}
//已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    HXSearchBar *sear = (HXSearchBar *)searchBar;
    //取消按钮
    sear.cancleButton.backgroundColor = [UIColor clearColor];
    [sear.cancleButton setTitle:YZMsg(@"取消") forState:UIControlStateNormal];
    [sear.cancleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    sear.cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
}
//搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    self.allArray = nil;
    [self.tableView reloadData];
    [self getIN];
    [searchBar resignFirstResponder];

}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    self.allArray = nil;
    [self.tableView reloadData];
    [self getIN];
}
//取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSArray *)models{
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.allArray) {
        AntFansModel *model  = [AntFansModel modelWithDic:dic];
        [array addObject:model];
    }
    _models = array;
    return _models;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    AntFansCell *cell = [AntFansCell cellWithTableView:tableView];
    AntFansModel *model = self.models[indexPath.row];
    cell.model = model;
    cell.guanzhuDelegate = self;
    if (cell.model.uid ==[Config getOwnID] || [cell.model.uid isEqualToString:[Config getOwnID]])
    {
        cell.guanzhubtn.hidden = YES;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    AntPersonMsg *person = [[AntPersonMsg alloc]init];
    person.userID = [self.models[indexPath.row] valueForKey:@"uid"];
    //[self presentViewController:person animated:YES completion:nil];
    [self.navigationController pushViewController:person animated:YES];
}
-(void)getIN{
    
     AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
     NSString *url = [purl stringByAppendingFormat:@"service=Home.search&key=%@&uid=%@&token=%@",searchBars.text,[Config getOwnID],[Config getOwnToken]];
     url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
     NSNumber *ret = [responseObject valueForKey:@"ret"];
     if ([ret isEqualToNumber:[NSNumber numberWithInt:200]]) {
     NSArray *data = [responseObject valueForKey:@"data"];
     NSNumber *code = [data valueForKey:@"code"] ;
     if([code isEqualToNumber:[NSNumber numberWithInt:0]])
     {
     NSArray *info = [data valueForKey:@"info"];
     self.allArray = info;
     [self.tableView reloadData];
     imageView.hidden = YES;
     if (self.allArray.count == 0) {
     imageView.hidden = NO;
     }
     }
     else
     {
     imageView.hidden = NO;
     }
     }
     }
     failure:^(NSURLSessionDataTask *task, NSError *error)
     {
     
         imageView.hidden = NO;
     }];
     
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)doGuanzhu:(NSString *)st{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.setAttent"];
    
    NSDictionary *subdic = @{@"uid":[Config getOwnID],
                             @"touid":st
                             };
    
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        [self getIN];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
@end
