//
//  myVideoV.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/8/4.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "myVideoV.h"
#import <MJRefresh/MJRefresh.h>
#import "videocell.h"
#import "LookVideo.h"
#import "NearbyVideoModel.h"
#import "VideoCollectionCell.h"
@interface myVideoV ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSMutableArray *allArray;
@property(nonatomic,strong)NSArray *modelrray;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UILabel *titleLab;
@end
@implementation myVideoV
{
    UIImageView *_noVideoImage;
    MJRefreshAutoNormalFooter *footer;
    NSInteger _page;
}
-(NSArray *)modelrray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *subdic in _allArray) {
        NearbyVideoModel *model = [[NearbyVideoModel alloc]initWithDic:subdic];
        [array addObject:model];
    }
    _modelrray = array;
    return _modelrray;
}
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64)];
    navtion.backgroundColor = navigationBGColor;
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.text = YZMsg(@"视频");
    [self.titleLab setFont:navtionTitleFont];
    self.titleLab.textColor = navtionTitleColor;
    self.titleLab.frame = CGRectMake(0, 0,_window_width,84);
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:self.titleLab];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    returnBtn.tintColor = [UIColor whiteColor];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _window_width/2, 64)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(10,30,30,20);[returnBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
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
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _modelrray = [NSArray array];
    _page = 1;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.allArray = [NSMutableArray array];
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.itemSize = CGSizeMake(_window_width/2, _window_width/2 * 1.6);
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height - 114-statusbarHeight) collectionViewLayout:flow];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"VideoCollectionCell"];
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    self.collectionView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullInternetforNewDown)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getDataByFooterup)];
    [footer setTitle:YZMsg(@"正在加载更多的数据...") forState:MJRefreshStateRefreshing];
    [footer setTitle:YZMsg(@"已经全部加载完毕") forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = [UIFont systemFontOfSize:15.0f];
    footer.automaticallyHidden = YES;
    self.collectionView.mj_footer = footer;
    
    [self.view addSubview:self.collectionView];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(refreshNear) userInfo:nil repeats:YES];
    if (_ismyvideo == 1) {
        self.collectionView.frame = CGRectMake(0,40, _window_width, _window_height - 40);
        [self navtion];
    }
    _noVideoImage = [[UIImageView alloc] initWithFrame:CGRectMake(_window_width / 3, self.view.center.y - 64 - _window_width / 6, _window_width / 3, _window_width / 3)];
    _noVideoImage.image = [UIImage imageNamed:getImagename(@"bg_no_video_2")];
    _noVideoImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.collectionView addSubview:_noVideoImage];
    _noVideoImage.hidden = YES;
    [self pullInternetforNew:1];
    //因为列表不可以每次 都重新刷新，影响用户体验，也浪费流量
    //在视频页面输出视频后返回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLiveList:) name:@"delete" object:nil];
    //发布视频成功之后返回首页刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullInternetforNewDown) name:@"reloadlist" object:nil];
    
    
}
//在视频页面删除视频回来后删除
-(void)getLiveList:(NSNotification *)nsnitofition{
    NSString *videoid = [NSString stringWithFormat:@"%@",[[nsnitofition userInfo] valueForKey:@"videoid"]];
    NSDictionary *deletedic = [NSDictionary dictionary];
    for (NSDictionary *subdic in self.allArray) {
        NSString *videoids = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
        if ([videoid isEqual:videoids]) {
            deletedic = subdic;
            break;
        }
    }
    if (deletedic) {
        [self.allArray removeObject:deletedic];
        [self.collectionView reloadData];
    }
}
-(void)refreshNear{
}
//down
-(void)pullInternetforNewDown{
    self.allArray = [NSMutableArray array];
    _page = 1;
    [self pullInternetforNew:_page];
}
-(void)getDataByFooterup{
    _page ++;
     [self pullInternetforNew:_page];
}
-(void)pullInternetforNew:(NSInteger)pages{
    [footer setTitle:YZMsg(@"点击或上拉加载更多") forState:MJRefreshStateIdle];

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.getVideoList&uid=%@&p=%ld",[Config getOwnID],(long)pages];
    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSArray *info = [data valueForKey:@"info"];
                [self.allArray addObjectsFromArray:info];
                //加载成功 停止刷新
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView reloadData];
                if (self.allArray.count > 0) {
                    _noVideoImage.hidden = YES;
                }
                else{
                    _noVideoImage.hidden = NO;
                }
                
                if (info.count == 0) {
                    [footer setTitle:YZMsg(@"已经全部加载完毕") forState:MJRefreshStateIdle];
                    
                }
            }
            else{
                if (self.allArray) {
                    [self.allArray removeAllObjects];
                }
                [self.collectionView reloadData];
                _noVideoImage.hidden = NO;
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.allArray) {
            [self.allArray removeAllObjects];
        }
        [self.collectionView reloadData];
        _noVideoImage.hidden = NO;
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
    
}
#pragma mark - Table view data source
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((_window_width - 3)/2,(_window_width - 3)/2 * 1.4);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelrray.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1,1,1,1);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *subdic = _allArray[indexPath.row];
    LookVideo *video = [[LookVideo alloc]init];
    video.hostdic = subdic;
    [[MXBADelegate sharedAppDelegate] pushViewController:video animated:YES];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoCollectionCell *cell = (VideoCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCollectionCell" forIndexPath:indexPath];
    NSDictionary *subdic = _allArray[indexPath.row];
    cell.isList = @"1";
    cell.model = [[NearbyVideoModel alloc] initWithDic:subdic];
    cell.model = _modelrray[indexPath.row];
    return cell;
}
@end
