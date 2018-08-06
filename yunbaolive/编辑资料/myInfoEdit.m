//
//  myInfoEdit.m
//  yunbaolive
//
//  Created by cat on 16/3/13.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "myInfoEdit.h"
#import "InfoEdit1TableViewCell.h"
#import "InfoEdit2TableViewCell.h"
#import "EditNiceName.h"
#import "EditSignature.h"
#import "iconC.h"
#import "sexCell.h"
#import "sexChange.h"
#import "UIImageView+WebCache.h"

@interface myInfoEdit ()<UITableViewDataSource,UITableViewDelegate>
{
    int setvisinfo;
    UIDatePicker *datapicker;
    NSString *datestring;//保存时间
    UIAlertController *alert;
    UIActivityIndicatorView *testActivityIndicator;//菊花

}

@end

@implementation myInfoEdit


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.view.backgroundColor = [UIColor whiteColor];
    datapicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,0, _window_width*0.8, _window_height*0.3)];
    
    NSDate *currentDate = [NSDate date];
    [datapicker setMaximumDate:currentDate];
    
    NSDateFormatter  * formatter = [[ NSDateFormatter   alloc ] init ];
    
    [formatter  setDateFormat : @"yyyy-MM-dd" ];
    
    NSString  * mindateStr =  @"1950-01-01" ;
    
    NSDate  * mindate = [formatter  dateFromString :mindateStr];
    
    datapicker . minimumDate = mindate;
    
    datapicker.maximumDate=[NSDate date];

    [datapicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged ];
    
    datapicker.datePickerMode = UIDatePickerModeDate;
    //设置为中文
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    datapicker.locale =locale;
    
    
    alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert.view addSubview:datapicker];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:YZMsg(@"确认") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        [self getbirthday];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    
        
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];

    
    
}
//生日
-(void)getbirthday{
    
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = self.view.center;
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
    
    
    if (datestring == nil) {
        
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        datestring = [dateFormatter stringFromDate:currentDate];
        
    }
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[datestring] forKeys:@[@"birthday"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *url = [purl stringByAppendingFormat:@"service=User.updateFields&uid=%@&token=%@&fields=%@",[Config getOwnID],[Config getOwnToken],jsonStr];
    url= [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                LiveUser *user = [[LiveUser alloc] init];
                user.birthday = datestring;
                [Config updateProfile:user];
                [self.tableView reloadData];
                
            }
         
            
        }
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [testActivityIndicator stopAnimating]; // 结束旋转
         [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
     }];

    
}
- (void)oneDatePickerValueChanged:(UIDatePicker *) sender {

    
    NSDate *select = [sender date]; // 获取被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    [selectDateFormatter setDateFormat:@"YYYY-MM-dd"];
    datestring = [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的string类型
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    setvisinfo = 1;
    [self.tableView reloadData];
    [self navtion];
    [self.tableView reloadData];
    self.tableView.frame = CGRectMake(0, 64+statusbarHeight, _window_width, _window_height - 64- statusbarHeight);
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvisinfo = 0;
}
-(void)navtion{
    
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor = navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = YZMsg(@"修改个人资料");
    [label setFont:navtionTitleFont];
    
    label.textColor = navtionTitleColor;
    label.frame = CGRectMake(0, statusbarHeight,_window_width,84);
    // label.center = navtion.center;
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor whiteColor];
    
    returnBtn.frame = CGRectMake(10,30+statusbarHeight,30,20);[returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    returnBtn.tintColor = [UIColor blackColor];
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,64);
    [navtion addSubview:btnttttt];
    
    [self.view addSubview:navtion];
    
    
}
-(void)money{
    
    
}
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //判断返回cell
    LiveUser *users = [Config myProfile];
    if (indexPath.section == 0) {
        InfoEdit1TableViewCell *cell = [InfoEdit1TableViewCell cellWithTableView:tableView];
        cell.imgRight.layer.masksToBounds = YES;
        cell.imgRight.layer.cornerRadius = 25;
        cell.labLeftName.text = YZMsg(@"头像");
        return cell;
    }
    else
    {
        if (indexPath.row == 0) {
            InfoEdit2TableViewCell *cell = [InfoEdit2TableViewCell cellWithTableView:tableView];
            cell.labContrName.text = YZMsg(@"昵称");
            cell.labDetail.text = [Config getOwnNicename];
            return cell;
        }
        else if(indexPath.row == 1)
        {
            InfoEdit2TableViewCell *cell = [InfoEdit2TableViewCell cellWithTableView:tableView];
            cell.labContrName.text =YZMsg(@"签名");
            cell.labDetail.text = [Config getOwnSignature];
            return cell;
        }
        else if (indexPath.row == 2){
            InfoEdit2TableViewCell *cell = [InfoEdit2TableViewCell cellWithTableView:tableView];
            cell.labContrName.text =YZMsg(@"生日");
            cell.labDetail.text = users.birthday;
            return cell;
        }
        else{
            sexCell *cell = [sexCell cellWithTableView:tableView];
            return cell;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 70;
    }
    else
        
        return 50;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //判断当前分区返回分区行数
    if (section == 0 ) {
        return 1;
    }
    else
    {
        return 4;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回分区数
    return 2;
}
- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section
{
    return 6;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger) section
{
    return 1;
}
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //判断返回cell
    
    if (indexPath.section == 0) {
        iconC *icon = [[iconC alloc]initWithNibName:@"iconC" bundle:nil];
        [[MXBADelegate sharedAppDelegate] pushViewController:icon animated:YES];
    }
    else {
        if(indexPath.row == 0)
        {
        EditNiceName *EditNameView = [[EditNiceName alloc] init];
            [[MXBADelegate sharedAppDelegate] pushViewController:EditNameView animated:YES];
        
        }
        else if(indexPath.row == 1){
        EditSignature *EditSignatureView = [[EditSignature alloc] init];
        [[MXBADelegate sharedAppDelegate] pushViewController:EditSignatureView animated:YES];
        }
        else if (indexPath.row == 2){
            
        [self presentViewController:alert animated:YES completion:^{ }];
            
    }
        else{
            
            sexChange *sex = [[sexChange alloc]init];
            [[MXBADelegate sharedAppDelegate] pushViewController:sex animated:YES];
            
        }
    }
    
    
}
@end
