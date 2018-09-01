//
//  MyVideoListVC.m
//  iphoneLive
//
//  Created by YangBiao on 2017/9/7.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "MyVideoList.h"
#import "showVideo.h"
#import "PersonalVideoCell.h"
#import <MJRefresh/MJRefresh.h>
@interface MyVideoList () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSMutableArray *allArray;
@property(nonatomic,strong)UICollectionView *videocollectionView;
@property(nonatomic,strong)UILabel *titleLab;
@end
@implementation MyVideoList
{
    UIImageView *_noVideoImage;
    MJRefreshAutoNormalFooter *footer;
    NSInteger _page;
}
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64+statusbarHeight)];
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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.allArray = [NSMutableArray array];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.itemSize = CGSizeMake(_window_width/2, _window_width/2 * 1.6);
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    self.videocollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64+statusbarHeight, _window_width, _window_height - 64-statusbarHeight) collectionViewLayout:flow];
    [self.videocollectionView registerNib:[UINib nibWithNibName:@"PersonalVideoCell" bundle:nil] forCellWithReuseIdentifier:@"PersonalVideoCell"];
    self.videocollectionView.delegate =self;
    self.videocollectionView.dataSource = self;
    self.videocollectionView.mj_header = ({
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getNewVideoList)];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        header;
    });
    footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreVideoList)];
    [footer setTitle:YZMsg(@"正在加载更多的数据...") forState:MJRefreshStateRefreshing];
    [footer setTitle:YZMsg(@"已经全部加载完毕") forState:MJRefreshStateNoMoreData];
    
    footer.stateLabel.font = [UIFont systemFontOfSize:15.0f];
    footer.automaticallyHidden = YES;
    self.videocollectionView.mj_footer = footer;
    [self.view addSubview:self.videocollectionView];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.videocollectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _noVideoImage = [[UIImageView alloc] initWithFrame:CGRectMake(_window_width / 3, self.videocollectionView.center.y - 64 - _window_width / 6, _window_width / 3, _window_width / 3)];
    _noVideoImage.image = [UIImage imageNamed:getImagename(@"bg_no_video")];
    _noVideoImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.videocollectionView addSubview:_noVideoImage];
    _noVideoImage.hidden = YES;
    [self navtion];
    _page = 1;
    [self antLitegetDataWithPage:1];
    
    //在视频页面删除视频回来后删除
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLiveList:) name:@"delete" object:nil];
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
        if (self.allArray.count > 0) {
            _noVideoImage.hidden = YES;
        }
        else{
            _noVideoImage.hidden = NO;
        }
        [self.videocollectionView reloadData];
    }
}
- (void)getMoreVideoList{
    _page ++;
    [self antLitegetDataWithPage:_page];
}
- (void)getNewVideoList{
    self.allArray = [NSMutableArray array];
    _page = 1;
    [self antLitegetDataWithPage:_page];
}
-(void)antLitegetDataWithPage:(NSInteger)page{
    [footer setTitle:YZMsg(@"点击或上拉加载更多") forState:MJRefreshStateIdle];

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Video.getMyVideo&uid=%@&token=%@&p=%ld",[Config getOwnID],[Config getOwnToken],(long)page];
    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"])
            {
                NSArray *info = [data valueForKey:@"info"];
                [self.allArray addObjectsFromArray:info];
                //加载成功 停止刷新
                [self.videocollectionView.mj_header endRefreshing];
                [self.videocollectionView.mj_footer endRefreshing];
                [self.videocollectionView reloadData];
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
                [self.videocollectionView.mj_header endRefreshing];
                [self.videocollectionView.mj_footer endRefreshing];
                if (self.allArray) {
                    [self.allArray removeAllObjects];
                }
                [self.videocollectionView reloadData];
                _noVideoImage.hidden = NO;
            }
        }
        [self.videocollectionView.mj_header endRefreshing];
        [self.videocollectionView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.videocollectionView.mj_header endRefreshing];
        [self.videocollectionView.mj_footer endRefreshing];
        if (self.allArray) {
            [self.allArray removeAllObjects];
        }
        [self.videocollectionView reloadData];
        _noVideoImage.hidden = NO;
    }];
}
#pragma mark - Table view data source
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((_window_width - 3)/2,(_window_width - 3)/2);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allArray.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1,1,1,1);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *subdic = _allArray[indexPath.row];
    showVideo *video = [[showVideo alloc]init];
    video.hostdic = subdic;
    [[MXBADelegate sharedAppDelegate] pushViewController:video animated:YES];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PersonalVideoCell *cell = (PersonalVideoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PersonalVideoCell" forIndexPath:indexPath];
    NSDictionary *subdic = _allArray[indexPath.row];
    cell.model = [[NearbyVideoModel alloc] initWithDic:subdic];
    return cell;
}
@end
