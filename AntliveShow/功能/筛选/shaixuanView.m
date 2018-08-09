
#import "shaixuanView.h"
#import "shaixuanCell.h"
#import "shaixuanModel.h"

#import "Hotpage.h"


@interface shaixuanView ()<UITableViewDataSource,UITableViewDelegate>
{
    int setvisshanxuan;
}
- (IBAction)womanBTN:(id)sender;

- (IBAction)womanNUM:(id)sender;

- (IBAction)allBTNA:(id)sender;

- (IBAction)ALLnum:(id)sender;

- (IBAction)manBTN:(id)sender;

- (IBAction)manNum:(id)sender;

@property(nonatomic,copy)NSString *sex;

@property(nonatomic,copy)NSString *city;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *woman1;

@property (weak, nonatomic) IBOutlet UIButton *woman2;
@property (weak, nonatomic) IBOutlet UIButton *allBTN;

@property (weak, nonatomic) IBOutlet UIButton *allBTN2;

@property (weak, nonatomic) IBOutlet UIButton *manbtn1;

@property (weak, nonatomic) IBOutlet UIButton *manbtn2;

@property(nonatomic,strong)NSArray *models;

@property(nonatomic,strong)NSArray *allArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)back:(id)sender;

@end

@implementation shaixuanView

-(NSArray *)models{
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.allArray) {
    shaixuanModel *model = [shaixuanModel modelWithDic:dic];
    [array addObject:model];
   }
    _models = array;
    return _models;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    setvisshanxuan = 1;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvisshanxuan = 0;
}
    - (void)viewDidLoad {
            [super viewDidLoad];
             self.view.backgroundColor = [UIColor whiteColor];
    self.sex = [NSString stringWithFormat:@"%d",0];
    self.navigationController.navigationBarHidden = YES;
    self.allArray  = [NSArray array];
    self.tableView.bounces = NO;
    self.tableView.multipleTouchEnabled = NO;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSString *url = [purl stringByAppendingFormat:@"service=User.getArea&token=%@",[Config getOwnToken]];
    
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSLog(@"%@",[responseObject valueForKey:@"msg"]);
        NSNumber *ret = [responseObject valueForKey:@"ret"];
        if ([ret isEqualToNumber:[NSNumber numberWithInt:200]]) {
            NSArray *data = [responseObject valueForKey:@"data"];
            
            NSNumber *code = [data valueForKey:@"code"] ;
            
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSArray *info = [data valueForKey:@"info"];
                self.allArray = info;
                [self.tableView reloadData];
            }
            else
                
            {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, _window_width, _window_height-44)];
                imageView.image = [UIImage imageNamed:@"default_search.png"];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [self.view addSubview:imageView];
            }
        }
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
     }];

    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    shaixuanCell *cell = [shaixuanCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    shaixuanModel *model = self.models[indexPath.row];
    if ([model.city isEqualToString:self.cityname]|| [model.city isEqualToString:@""] ||model.city == nil) {
        cell.image.hidden = NO;
    }
    cell.model = model;
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    shaixuanCell *cell = (shaixuanCell *)[tableView cellForRowAtIndexPath:indexPath];
    shaixuanModel *model = self.models[indexPath.row];
    self.cityname = nil;
    self.cityname = [NSString string];
    self.cityname = model.city;
    
   //[tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    if(cell.image.hidden == YES){
        cell.image.hidden = NO;
    }
    else{
        cell.image.hidden = YES;
    }
    //注册通知 改变筛选条件
    NSDictionary *dicc = [NSDictionary dictionaryWithObject:model.city forKey:@"biaoti"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pageviewbiaoti" object:self userInfo:dicc];
    NSDictionary *shaixuanDic = [NSDictionary dictionaryWithObjects:@[model.city,self.sex] forKeys:@[@"province",@"sex"]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"shaixuan" object:nil userInfo:shaixuanDic];
     [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       // [self dismissViewControllerAnimated:YES completion:nil];
    });
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    shaixuanCell *cell = (shaixuanCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.image.hidden = YES;
}
- (IBAction)womanBTN:(id)sender {
    
    self.sex = @"2";
    
    [self.woman1 setImage:[UIImage imageNamed:@"choice_sex_nvren"] forState:UIControlStateNormal];
    
    [self.manbtn1 setImage:[UIImage imageNamed:@"choice_sex_un_male"] forState:UIControlStateNormal];
    [self.allBTN setImage:[UIImage imageNamed:@"choice_sex_un_all"] forState:UIControlStateNormal];

}
- (IBAction)womanNUM:(id)sender {
    
    self.sex = @"2";
    [self.woman1 setImage:[UIImage imageNamed:@"choice_sex_nvren"] forState:UIControlStateNormal];
    [self.manbtn1 setImage:[UIImage imageNamed:@"choice_sex_un_male"] forState:UIControlStateNormal];
    [self.allBTN setImage:[UIImage imageNamed:@"choice_sex_un_all"] forState:UIControlStateNormal];
    
}
- (IBAction)allBTNA:(id)sender {
    
    
    self.sex = @"0";

    [self.allBTN setImage:[UIImage imageNamed:@"choice_sex_all"] forState:UIControlStateNormal];
    
    [self.woman1 setImage:[UIImage imageNamed:@"choice_sex_un_femal"] forState:UIControlStateNormal];
    [self.manbtn1 setImage:[UIImage imageNamed:@"choice_sex_un_male"] forState:UIControlStateNormal];
    
}
- (IBAction)ALLnum:(id)sender {
    self.sex = @"0";

    [self.allBTN setImage:[UIImage imageNamed:@"choice_sex_all"] forState:UIControlStateNormal];

    
    [self.woman1 setImage:[UIImage imageNamed:@"choice_sex_un_femal"] forState:UIControlStateNormal];
    [self.manbtn1 setImage:[UIImage imageNamed:@"choice_sex_un_male"] forState:UIControlStateNormal];
    
}
- (IBAction)manBTN:(id)sender {
    self.sex = @"1";

    [self.manbtn1 setImage:[UIImage imageNamed:@"choice_sex_nanren"] forState:UIControlStateNormal];

    
    
    [self.woman1 setImage:[UIImage imageNamed:@"choice_sex_un_femal"] forState:UIControlStateNormal];
    [self.allBTN setImage:[UIImage imageNamed:@"choice_sex_un_all"] forState:UIControlStateNormal];

    
}
- (IBAction)manNum:(id)sender {
    self.sex = @"1";

    [self.manbtn1 setImage:[UIImage imageNamed:@"choice_sex_nanren"] forState:UIControlStateNormal];

    
    [self.woman1 setImage:[UIImage imageNamed:@"choice_sex_un_femal"] forState:UIControlStateNormal];
    [self.allBTN setImage:[UIImage imageNamed:@"choice_sex_un_all"] forState:UIControlStateNormal];
    
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSDictionary *shaixuanDic = [NSDictionary dictionaryWithObjects:@[self.cityname,self.sex] forKeys:@[@"province",@"sex"]];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"shaixuan" object:nil userInfo:shaixuanDic];
}
@end
