#import "personMessage.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "fansViewController.h"
#import "attrViewController.h"
#import "ZFModalTransitionAnimator.h"
#import "LiveNodeViewController.h"
#import "LiveNodeModel.h"
#import "LiveNodeTableViewCell.h"
#import "chatController.h"
#import "hietoryPlay.h"
#import "LivePlay.h"
#import "personList.h"
#import "Livebroadcast.h"
#import "PersonalVideoCell.h"
#import "NearbyVideoModel.h"
#import "LookVideo.h"
#import <MJRefresh/MJRefresh.h>
@interface personMessage ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *singleUserArray;
    UILabel *xianLabel;
    UILabel *xianLabel2;
    CGFloat w;
    NSArray *gongxian3;
    UIButton *laheiBTN;
    fansViewController *fansC;
    attrViewController *attrC;
    UIButton *guanzhuBTN;
    UIImageView *imageV;
    UILabel *label1;
    UILabel *label2;
    UILabel *line1;
    UILabel *line2;
    NSString *chatNmae;
    NSDictionary *movieDic;
    UIAlertView *coastAlert;
    UIAlertView *secretAlert;
    UICollectionView *_videoCollection;
    NSMutableArray *_videoArray;
    
    UIImageView *_noVideoImage;
    NSInteger _page;
    MJRefreshAutoNormalFooter *footer;
    NSString *type_val;//
    NSString *livetype;//
}
@property (weak, nonatomic) IBOutlet UIImageView *hostlevel;
@property (weak, nonatomic) IBOutlet UILabel *IDLES;
- (IBAction)pushLiveVC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *liveBtn;
- (IBAction)segmentttttt:(id)sender;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property(nonatomic,strong)NSArray *models;
@property(nonatomic,strong)NSArray *aArray;
@property(nonatomic,strong)NSString *MD5;
- (IBAction)doback:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *laheinib;
@property (weak, nonatomic) IBOutlet UIButton *guanzhunib;
@property (weak, nonatomic) IBOutlet UIView *dibuview;
- (IBAction)guanzhuBTNnib:(id)sender;
- (IBAction)sixinNibBtn:(id)sender;
- (IBAction)laheiBtnNib:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIButton *sixinBtn;

@end
@implementation personMessage
-(NSArray *)models{
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.aArray) {
        LiveNodeModel *model = [LiveNodeModel modelWithDic:dic];
        [array addObject:model];
    }
    _models = array;
    return _models;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    if ([self.userID isEqualToString:[Config getOwnID]]) {
        self.dibuview.hidden = YES;
    }
    else{
        self.dibuview.hidden = NO;
    }
    [self setBTN];
    
    self.touxiangBTN.layer.borderWidth = 1;
    self.touxiangBTN.layer.borderColor = [UIColor whiteColor].CGColor;
    [self forInternet];//获取信息
}
-(void)setBTN{
    UIView *myview = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height-44, _window_width, 44)];
    myview.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gongxianbang)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.yingpiaoView addGestureRecognizer:tap];
}
//贡献榜
-(void)gongxianbang{
    //跳往魅力值界面
    personList *jumpC = [[personList alloc] init];
    jumpC.userID = _userID;
    [self presentViewController:jumpC animated:YES completion:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.bottomHeight.constant<50) {
        self.bottomHeight.constant += statusbarHeight;
    }
    type_val = @"0";
    livetype = @"0";
    _page = 1;
    _videoArray = [NSMutableArray array];
    _voteLabel.text = [NSString stringWithFormat:@"%@%@",[common name_votes],YZMsg(@"贡献榜")];
    _liveBtn.hidden = YES;
    _signLabel.text = YZMsg(@"个性签名");
    self.fensi2.text = YZMsg(@"关注");
    self.guanzhu2.text = YZMsg(@"粉丝");
    [self.sixinBtn setTitle:YZMsg(@"私信") forState:0];

    [_liveBtn setTitle:@"Living" forState:0]; self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.hostlevel.layer.masksToBounds = YES;
    self.hostlevel.layer.cornerRadius = 10;
    self.scrollView.contentSize = CGSizeMake(0, _window_height*2);
    UITapGestureRecognizer *fansiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doFensi)];
    UITapGestureRecognizer *fansiTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doFensi)];
    self.fensi2.userInteractionEnabled = YES;
    self.fensiL.userInteractionEnabled = YES;
    [self.fensi2 addGestureRecognizer:fansiTap2];
    [self.fensiL addGestureRecognizer:fansiTap];
    UITapGestureRecognizer *guanzhuTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agunzhutap)];
    UITapGestureRecognizer *guanzhuTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agunzhutap)];
    self.guanzhuL.userInteractionEnabled = YES;
    self.guanzhu2.userInteractionEnabled = YES;
    [self.guanzhu2 addGestureRecognizer:guanzhuTap2];
    [self.guanzhuL addGestureRecognizer:guanzhuTap];
    //获取数据
    [self.segment setTitle:YZMsg(@"主页") forSegmentAtIndex:0];
    [self.segment setTitle:YZMsg(@"直播") forSegmentAtIndex:1];
    [self.segment setTitle:YZMsg(@"视频") forSegmentAtIndex:2];

    self.segment.selectedSegmentIndex = 0;
    self.segment.tintColor  = [UIColor clearColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor blackColor], NSForegroundColorAttributeName, nil];
    [self.segment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,normalColors, NSForegroundColorAttributeName, nil];
    [self.segment setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    w = self.segment.frame.size.width;
    line1 = [[UILabel alloc]initWithFrame:CGRectMake(0,self.segment.frame.size.height,_window_width/2,2)];
    line1.backgroundColor = normalColors;
    [self.segment addSubview:line1];
    line2 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2,self.segment.frame.size.height, _window_width/2,2)];
    line2.backgroundColor = normalColors;
    [self.segment addSubview:line2];
    line2.hidden = YES;
    self.zhiboView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //因为列表不可以每次 都重新刷新，影响用户体验，也浪费流量
    //在视频页面输出视频后返回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLiveList:) name:@"delete" object:nil];
    
}
//在视频页面删除视频回来后删除
-(void)getLiveList:(NSNotification *)nsnitofition{
    NSString *videoid = [NSString stringWithFormat:@"%@",[[nsnitofition userInfo] valueForKey:@"videoid"]];
    NSDictionary *deletedic;
    for (NSDictionary  *subdic in _videoArray) {
        NSString *videoids = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
        if ([videoid isEqual:videoids]) {
            deletedic = subdic;
            break;
        }
    }
    if (deletedic) {
        [_videoArray removeObject:deletedic];
        [_videoCollection reloadData];
        if (_videoArray.count > 0) {
            _noVideoImage.hidden = YES;
        }
        else{
            _noVideoImage.hidden = NO;
        }
        
    }
}
-(void)doFensi{
    //跳关注页面
    attrC = [[attrViewController alloc]init];
    attrC.guanzhuUID = self.userID;
    [self.navigationController pushViewController:attrC animated:YES];
}
-(void)agunzhutap{
    //跳粉丝页面
    fansC = [[fansViewController alloc]init];
    fansC.fensiUid = self.userID;
    [self.navigationController pushViewController:fansC animated:YES];
}
-(void)forInternet{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.getUserHome&uid=%@&touid=%@",[Config getOwnID],self.userID];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                singleUserArray = [[data valueForKey:@"info"] firstObject];
                NSString *laingname = minstr([[singleUserArray valueForKey:@"liang"] valueForKey:@"name"]);
                
                if ([laingname isEqual:@"0"]) {
                    self.yingkeNumL.text = [singleUserArray valueForKey:@"id"];
                    self.IDLES.text = @"ID";
                }
                else{
                    self.yingkeNumL.text = laingname;
                    self.IDLES.text = YZMsg(@"靓");
                    
                }
                
                [self.hostlevel setImage:[UIImage imageNamed:[NSString stringWithFormat:@"host_%@",minstr([singleUserArray valueForKey:@"level_anchor"])]]];
                NSString *islive = [NSString stringWithFormat:@"%@",[singleUserArray valueForKey:@"islive"]];
                if ([islive isEqual:@"0"]) {
                    _liveBtn.hidden = YES;
                }else{
                    _liveBtn.hidden = NO;
                }
                if ([self.userID isEqual:[Config getOwnID]]) {
                    _liveBtn.hidden = YES;
                }
                
                movieDic = [singleUserArray valueForKey:@"liveinfo"];
                //数据信息
                self.aArray = [singleUserArray valueForKey:@"liverecord"];
                if ([[singleUserArray valueForKey:@"isblack"] isEqual:@"1"]) {
                    [self.laheinib setTitle:[NSString stringWithFormat:@" %@",YZMsg(@"已拉黑")] forState:UIControlStateNormal];
                }
                else{
                    [self.laheinib setTitle:[NSString stringWithFormat:@" %@",YZMsg(@"拉黑")] forState:UIControlStateNormal];
                }
                [self.touxiangBTN sd_setBackgroundImageWithURL:[NSURL URLWithString:[singleUserArray valueForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head"]];
                self.icon = [singleUserArray valueForKey:@"avatar"];
                //姓名
                self.nameL.text = [singleUserArray valueForKey:@"user_nicename"];
                self.chatname = [singleUserArray valueForKey:@"user_nicename"];
                //性别
                if ([[singleUserArray valueForKey:@"sex"] isEqual:@"1"]) {
                    self.sexIm.image = [UIImage imageNamed:@"choice_sex_nanren"];
                }
                else
                {
                    self.sexIm.image = [UIImage imageNamed:@"choice_sex_nvren"];
                }
                //级别
                NSString *level = [NSString stringWithFormat:@"leve%@",[singleUserArray valueForKey:@"level"]];
                self.levelIM.image = [UIImage imageNamed:level];
                //关注
                self.fensiL.text = [NSString stringWithFormat:@"%@",[singleUserArray valueForKey:@"follows"]];
                //粉丝
                self.guanzhuL.text = [NSString stringWithFormat:@"%@",[singleUserArray valueForKey:@"fans"]];
                //签名
                self.signnature.text = [singleUserArray valueForKey:@"signature"];
                //songchu
                self.songchul.text = [singleUserArray valueForKey:@"consumption"];
                //贡献前三位
                gongxian3 = [singleUserArray valueForKey:@"contribute"];
                self.signatureL.text = [singleUserArray valueForKey:@"signature"];
                if ([[singleUserArray valueForKey:@"isattention"] isEqual:@"0"]) {
                    [self.guanzhunib setTitle:[NSString stringWithFormat:@" %@",YZMsg(@"关注")] forState:UIControlStateNormal];
                }
                else{
                    [self.guanzhunib setTitle:[NSString stringWithFormat:@" %@",YZMsg(@"已关注")] forState:UIControlStateNormal];
                }
                CGFloat x=_window_width - _window_height/11 - 30;
                CGFloat widt = _window_height/12 - 10;
                if (gongxian3.count >=3 ) {
                    for (int i =0; i<3; i++) {
                        NSDictionary *dic = gongxian3[i];
                        NSString *path = [dic valueForKey:@"avatar"];
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        [btn sd_setImageWithURL:[NSURL URLWithString:path] forState:UIControlStateNormal];
                        if (i==0) {
                            btn.frame = CGRectMake(x,0,widt,widt);
                        }
                        else{
                            btn.frame = CGRectMake(x,0,widt,widt);
                            
                        }
                        btn.backgroundColor = [UIColor clearColor];
                        btn.layer.masksToBounds = YES;
                        btn.layer.borderColor = [UIColor whiteColor].CGColor;
                        btn.layer.borderWidth = 1;
                        btn.layer.cornerRadius = widt/2;
                        x-=widt;
                        [self.yingpiaoView addSubview:btn];
                    }
                }
                else{
                    for (int i =0; i<gongxian3.count; i++) {
                        NSDictionary *dic = gongxian3[i];
                        NSString *path = [dic valueForKey:@"avatar"];
                        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        btn.backgroundColor = [UIColor clearColor];
                        [btn sd_setImageWithURL:[NSURL URLWithString:path] forState:UIControlStateNormal];
                        if (i==0) {
                            btn.frame = CGRectMake(x,0, widt,widt);
                        }
                        else{
                            btn.frame = CGRectMake(x,0, widt,widt);
                        }
                        btn.layer.masksToBounds = YES;
                        btn.layer.borderColor = [UIColor whiteColor].CGColor;
                        btn.layer.borderWidth = 1;
                        btn.layer.cornerRadius = widt/2;
                        x-=widt;
                        [self.yingpiaoView addSubview:btn];
                    }
                }
            }
        }
        
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
     }];
}
- (IBAction)segmentttttt:(id)sender {
    if (self.segment.selectedSegmentIndex == 0) {
        self.zhiboView.hidden = YES;
        line2.hidden = YES;
        line1.hidden = NO;
    }
    else if (self.segment.selectedSegmentIndex == 1){
        self.zhiboView.hidden = NO;
        line1.hidden = YES;
        line2.hidden = NO;
        if (!self.tableView) {
            [self dozhiboView];
        }
        [self setZhibo];
        self.tableView.hidden = NO;
        _videoCollection.hidden = YES;
    }
    else if (self.segment.selectedSegmentIndex == 2){
        self.zhiboView.hidden = NO;
        self.tableView.hidden = YES;
        imageV.hidden = YES;
        label1.hidden = YES;
        label2.hidden = YES;
        if (!_videoCollection) {
            [self videoList];
        }
        _videoCollection.hidden = NO;
        if (_videoArray.count > 0) {
            _noVideoImage.hidden = YES;
        }
        else{
            _noVideoImage.hidden = NO;
        }
        _videoArray = [NSMutableArray array];
        _page = 1;
        [self getDataWithPage:_page];
    }
}
- (void)videoList{
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.itemSize = CGSizeMake(_window_width/2, _window_width/2 * 1.6);
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    //避免是自己主页下面三个按钮隐藏的时候底部会有空白
    CGFloat collectionViewHeight = _window_height*0.51;
    if ([self.userID isEqual:[Config getOwnID]]) {
        //是自己的主页
        if (IS_IPHONE_5) {
            collectionViewHeight = _window_height * 0.49;
        }
        else if (IS_IPHONE_6){
            collectionViewHeight = _window_height * 0.51;
        }
        else{
            collectionViewHeight = _window_height * 0.52;
        }
    }
    else{
        //不是自己主页
        if (IS_IPHONE_5) {
            collectionViewHeight = _window_height * 0.49 - 44;
        }
        else if (IS_IPHONE_6){
            collectionViewHeight = _window_height * 0.51 - 44;
        }
        else{
            collectionViewHeight = _window_height * 0.52 - 44;
        }
    }
    _videoCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, _window_width,collectionViewHeight) collectionViewLayout:flow];
    [_videoCollection registerNib:[UINib nibWithNibName:@"PersonalVideoCell" bundle:nil] forCellWithReuseIdentifier:@"PersonalVideoCell"];
    _videoCollection.delegate =self;
    _videoCollection.dataSource = self;
    _videoCollection.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.zhiboView addSubview:_videoCollection];
    footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreVideo)];
    [footer setTitle:YZMsg(@"正在加载更多...") forState:MJRefreshStateRefreshing];
    [footer setTitle:YZMsg(@"暂无更多") forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:15.0f];
    footer.automaticallyHidden = YES;
    _videoCollection.mj_footer = footer;
    _noVideoImage = [[UIImageView alloc] initWithFrame:CGRectMake(_videoCollection.width / 2 - _window_width / 6, _videoCollection.center.y - _window_width / 6, _window_width / 3 , _window_width / 3)];
    _noVideoImage.image = [UIImage imageNamed:@"没有视频数据"];
    [_videoCollection addSubview:_noVideoImage];
    _noVideoImage.hidden = YES;
}
- (void)getMoreVideo{
    _page ++;
    [self getDataWithPage:_page];
}
-(void)getDataWithPage:(NSInteger)page{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.getHomeVideo&uid=%@&touid=%@&p=%ld",[Config getOwnID],self.userID,(long)page];
    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSArray *info = [data valueForKey:@"info"];
                [_videoArray addObjectsFromArray:info];
                //加载成功 停止刷新
                [_videoCollection.mj_footer endRefreshing];
                [_videoCollection reloadData];
                if (_videoArray.count > 0) {
                    _noVideoImage.hidden = YES;
                }
                else{
                    _noVideoImage.hidden = NO;
                }
            }
            else{
                [_videoCollection.mj_footer endRefreshing];
                if (_videoArray) {
                    [_videoArray removeAllObjects];
                }
                [_videoCollection reloadData];
                _noVideoImage.hidden = NO;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_videoCollection.mj_footer endRefreshing];
        if (_videoArray) {
            [_videoArray removeAllObjects];
        }
        [_videoCollection reloadData];
        _noVideoImage.hidden = NO;
    }];
}
-(void)setZhibo{
    if (self.aArray.count >0) {
        imageV.hidden = YES;
        label1.hidden = YES;
        label2.hidden = YES;
        self.tableView.hidden = NO;
    }
    else
    {
        imageV.hidden = NO;
        label1.hidden = NO;
        label2.hidden = YES;
        self.tableView.hidden = YES;
    }
    // [self.tableView reloadData];
}
-(void)dozhiboView{
    //避免是自己主页下面三个按钮隐藏的时候底部会有空白
    CGFloat collectionViewHeight = _window_height*0.51;
    if ([self.userID isEqual:[Config getOwnID]]) {
        //是自己的主页
        if (IS_IPHONE_5) {
            collectionViewHeight = _window_height * 0.49;
        }
        else if (IS_IPHONE_6){
            collectionViewHeight = _window_height * 0.51;
        }
        else{
            collectionViewHeight = _window_height * 0.52;
        }
    }
    else{
        //不是自己主页
        if (IS_IPHONE_5) {
            collectionViewHeight = _window_height * 0.49 - 44;
        }
        else if (IS_IPHONE_6){
            collectionViewHeight = _window_height * 0.51 - 44;
        }
        else{
            collectionViewHeight = _window_height * 0.52 - 44;
        }
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, _window_width,collectionViewHeight)];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.zhiboView addSubview:self.tableView];
    imageV = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width/3,10,_window_width/3, 150)];
    imageV.image = [UIImage imageNamed:@"nothing.png"];
    imageV.contentMode =  UIViewContentModeScaleAspectFit;
    imageV.hidden = YES;
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, imageV.frame.origin.y + imageV.frame.size.height + 5, _window_width, 50)];
    label1.text = YZMsg(@"现在还没有直播记录");
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont fontWithName:@"Heiti SC" size:16];
    label1.backgroundColor = [UIColor clearColor];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.hidden = YES;
    [self.zhiboView addSubview:label1];
    
    label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, imageV.frame.origin.y + imageV.frame.size.height + 50, _window_width, 50)];
    label2.text = YZMsg(@"快快开启你的直播吧");
    label2.textColor = [UIColor darkGrayColor];
    label2.font = [UIFont fontWithName:@"Heiti SC" size:13];
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label1.hidden = YES;
    [self.zhiboView addSubview:label2];
    label2.hidden = YES;
    [self.zhiboView addSubview:imageV];
    [self setZhibo];
}
- (IBAction)doback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveNodeTableViewCell *cell = [LiveNodeTableViewCell cellWithTV:tableView];
    LiveNodeModel *model = self.models[indexPath.row];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *subdics = self.aArray[indexPath.row];
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
                
                [HUDHelper myalert:[data valueForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (IBAction)guanzhuBTNnib:(id)sender {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.setAttent&uid=%@&touid=%@",[Config getOwnID],self.userID];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                NSString *isattent = [NSString stringWithFormat:@"%@",[info valueForKey:@"isattent"]];
                if ([isattent isEqual:@"1"]) {
                    [_guanzhunib setTitle:[NSString stringWithFormat:@" %@",YZMsg(@"已关注")] forState:UIControlStateNormal];
                    NSLog(@"关注成功");
                }
                else
                {
                    [_guanzhunib setTitle:[NSString stringWithFormat:@" %@",YZMsg(@"关注")] forState:UIControlStateNormal];
                    NSLog(@"取消关注成功");
                }
                [self forInternet];
            }
        }
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
         
     }];
}
- (IBAction)sixinNibBtn:(id)sender {
    //创建会话
    [JMSGConversation createSingleConversationWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,self.userID]
                                         completionHandler:^(id resultObject, NSError *error) {
                                             if (error == nil) {
                                                 chatController *chat = [[chatController alloc]init];
                                                 chat.msgConversation = resultObject;
                                                 [chat.msgConversation clearUnreadCount];
                                                 chat.chatID = self.userID;
                                                 chat.avatar = self.icon;
                                                 chat.chatname = self.chatname;
                                                 [self presentViewController:chat animated:YES completion:nil];
                                             }else{
                                                 [MBProgressHUD showError:error.localizedDescription];
                                             }
                                         }];
}
- (IBAction)laheiBtnNib:(id)sender {
    [self blackaction];
}
-(void)blackaction{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.setBlack&uid=%@&touid=%@",[Config getOwnID],self.userID];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                if ([_laheinib.titleLabel.text isEqual:[NSString stringWithFormat:@" %@",YZMsg(@"拉黑")]]) {
                    [_laheinib setTitle:[NSString stringWithFormat:@" %@",YZMsg(@"已拉黑")] forState:UIControlStateNormal];
                    [HUDHelper myalert:[NSString stringWithFormat:@"%@",YZMsg(@"已拉黑")]];
                }
                else{
                    [_laheinib setTitle:[NSString stringWithFormat:@" %@",YZMsg(@"拉黑")] forState:UIControlStateNormal];
                    [HUDHelper myalert:YZMsg(@"已解除拉黑")];
                }
                [self forInternet];
            }
        }
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
         
     }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == coastAlert) {
        if (buttonIndex == 0) {
            return;
        }else if (buttonIndex == 1){
            [self doCoast];
        }
    }
    else  if (alertView == secretAlert) {
        if (buttonIndex == 0) {
            return;
        }
        else if (buttonIndex == 1){
            UITextField *field = [alertView textFieldAtIndex:0];
            
            NSString *MD5s = [self stringToMD5:field.text];
            if ([MD5s isEqual:_MD5]) {
                
                [self pushMovieVC];
            }else{
                [HUDHelper myalert:YZMsg(@"密码错误")];
            }
            
        }
    }
}
- (IBAction)pushLiveVC:(id)sender {
    BOOL isLivePlay = NO;
    UIViewController *temp;
    for (UIViewController *tempVc in self.navigationController.viewControllers) {
        if ([tempVc isKindOfClass:[Livebroadcast class]]) {
            [HUDHelper myalert:YZMsg(@"请先退出直播在观看")];
            return;
        }
    }
    for (UIViewController *tempVc in self.navigationController.viewControllers) {
        if ([tempVc isKindOfClass:[moviePlay class]]) {
            isLivePlay = YES;
            temp = tempVc;
        }
    }
    if (isLivePlay) {
        [self.navigationController popToViewController:temp animated:YES];
    }
    else{
        [self checklive];
    }
}
-(void)checklive{
    NSString *url = [purl stringByAppendingFormat:@"service=Live.checkLive"];
    NSDictionary *check = @{
                            @"uid":[Config getOwnID],
                            @"token":[Config getOwnToken],
                            @"liveuid":[movieDic valueForKey:@"uid"],
                            @"stream":[movieDic valueForKey:@"stream"]
                            };
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:url parameters:check progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"];
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"])
            {
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                NSString *type = [NSString stringWithFormat:@"%@",[info valueForKey:@"type"]];
                
                type_val =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type_val"]];
                livetype =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type"]];
                
                if ([type isEqual:@"0"]) {
                    [self pushMovieVC];
                }
                else if ([type isEqual:@"1"]){
                    //密码
                    secretAlert = [[UIAlertView alloc]initWithTitle:YZMsg(@"请填写密码") message:nil delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确认"), nil];
                    secretAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    UITextField *field = [secretAlert textFieldAtIndex:0];
                    field.keyboardType = UIKeyboardTypeNumberPad;
                    [secretAlert show];
                    _MD5 = [NSString stringWithFormat:@"%@",[info valueForKey:@"type_msg"]];
                }else if ([type isEqual:@"2"] || [type isEqual:@"3"]){
                    //收费
                    NSString *type_msg = [NSString stringWithFormat:@"%@",[info valueForKey:@"type_msg"]];
                    coastAlert = [[UIAlertView alloc]initWithTitle:type_msg message:nil delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确认"), nil];
                    [coastAlert show];
                }
            }
            else{
                NSString *msg = [NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]];
                [HUDHelper myalert:msg];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}
-(void)pushMovieVC{
    moviePlay *pl = [[moviePlay alloc]init];
    pl.playDoc = movieDic;
    pl.isJpush = @"1";
    pl.type_val = type_val;
    pl.livetype = livetype;
    [self.navigationController pushViewController:pl animated:YES];
}
- (NSString *)stringToMD5:(NSString *)str
{
    
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}
//执行扣费
-(void)doCoast{
    NSString *url = [purl stringByAppendingFormat:@"service=Live.roomCharge"];
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken],
                             @"liveuid":[movieDic valueForKey:@"uid"],
                             @"stream":[movieDic valueForKey:@"stream"]
                             };
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"];
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"])
            {
                [self pushMovieVC];
            }
            else{
                [HUDHelper myalert:[data valueForKey:@"msg"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}
#pragma mark - collection view data source
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((_window_width - 3)/2,(_window_width - 3)/2);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _videoArray.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1,1,1,1);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *subdic = _videoArray[indexPath.row];
    LookVideo *video = [[LookVideo alloc]init];
    video.hostdic = subdic;
    [[MXBADelegate sharedAppDelegate] pushViewController:video animated:YES];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PersonalVideoCell *cell = (PersonalVideoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PersonalVideoCell" forIndexPath:indexPath];
    NSDictionary *subdic = _videoArray[indexPath.row];
    cell.model = [[NearbyVideoModel alloc] initWithDic:subdic];
    return cell;
}
@end
