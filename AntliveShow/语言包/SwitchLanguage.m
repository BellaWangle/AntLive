//
//  SwitchLanguage.m
//  iphoneLive
//
//  Created by Boom on 2017/9/8.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "SwitchLanguage.h"
#import "SetCell.h"
@interface SwitchLanguage ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *arr;
}

@end

@implementation SwitchLanguage

-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64+statusbarHeight)];
    navtion.backgroundColor = navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"%@",YZMsg(@"切换语言")];
    [label setFont:navtionTitleFont];
    label.textColor = navtionTitleColor;
    label.frame = CGRectMake(0, 0+statusbarHeight,_window_width,64);
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor whiteColor];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0+statusbarHeight, _window_width/2, 64)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(10,30+statusbarHeight,30,20);[returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    returnBtn.tintColor = [UIColor blackColor];
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0+statusbarHeight,100,64);
    [navtion addSubview:btnttttt];
    [self.view addSubview:navtion];
}
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self navtion];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    arr = @[@"中文",@"English",@"កម្ពុជា"];
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-64-statusbarHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [UIColor whiteColor];
    table.separatorStyle = 0;
    table.tableFooterView = nil;
    [self.view addSubview:table];
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setCELL"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SetCell" owner:self options:nil].lastObject;
    }
    cell.titleLabel.text = arr[indexPath.row];
    cell.imgView.hidden = YES;
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:CurrentLanguage];
    if ([str isEqualToString:EN]) {
        if (indexPath.row == 1) {
            cell.imgView.hidden = NO;
            cell.titleLabel.textColor = normalColors;
        }else{
            cell.imgView.hidden = YES;
            cell.titleLabel.textColor = [UIColor darkTextColor];
        }
    }else if ([str isEqualToString:KH]) {
        if (indexPath.row == 2) {
            cell.imgView.hidden = NO;
            cell.titleLabel.textColor = normalColors;
        }else{
            cell.imgView.hidden = YES;
            cell.titleLabel.textColor = [UIColor darkTextColor];
        }
    }else{
        if (indexPath.row == 0) {
            cell.imgView.hidden = NO;
            cell.titleLabel.textColor = normalColors;
        }else{
            cell.imgView.hidden = YES;
            cell.titleLabel.textColor = [UIColor darkTextColor];
        }
    }
    cell.imgView.image = [UIImage imageNamed:@"tw_duihao"];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //判断当前分区返回分区行数
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回分区数
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger) section
{
    return 1;
}
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = nil;
    NSString *pchStr = nil;
    if (indexPath.row == 0) {
        str = @"zh-Hans";
        pchStr = ZW;
    }else if (indexPath.row == 1){
        str = @"en";
        pchStr = EN;
    }else{
        str = @"fr";
        pchStr = KH;

    }
    UIAlertController *alertc = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",arr[indexPath.row]] preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"确认") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setObject:pchStr forKey:CurrentLanguage];
        [[RookieTools shareInstance] resetLanguage:str withFrom:nil];
    }];
    
    [alertc addAction:sureAction];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertc addAction:cancleAction];
    [self presentViewController:alertc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
