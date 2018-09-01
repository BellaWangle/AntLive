#import "tributeView.h"
#import "Config.h"
#import "giftCELL.h"
#define celll @"cell"
#import "MBProgressHUD.h"
#import "LWLCollectionViewHorizontalLayout.h"

@interface CollectionCellWhite : UICollectionViewCell

@end

@implementation CollectionCellWhite

- (instancetype)initWithFrame:(CGRect)frame andPlayDic:(NSDictionary *)zhuboDic{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

@interface tributeView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSTimer *timer;
    int a;
    NSMutableArray *selectedArray;
    CGFloat moveCount;
    BOOL isRight;
    NSInteger _pageCount;
    int isfree;//是不是背包礼物
    UIView *headerView;
    NSMutableArray *freeArr;
    NSIndexPath *freeIndex;
    NSInteger freeCount;
    NSMutableArray *freeSelectedArray;

}
@end
@implementation tributeView
-(NSArray *)models{
    NSMutableArray *muatb = [NSMutableArray array];
    for (int i=0;i<self.allArray.count;i++) {
        GIFTModell *model = [GIFTModell modelWithDic:self.allArray[i]];
        [muatb addObject:model];
    }
    _models = muatb;
    return _models;
}
-(void)reloadColl{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *string = [purl stringByAppendingString:@"service=Live.getGiftList"];
    NSDictionary *giftlist = @{
                               @"uid":[Config getOwnID],
                               @"token":[Config getOwnToken]
                               };
    [session POST:string parameters:giftlist progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSArray *data = [responseObject valueForKey:@"data"];
                self.allArray = [[[data valueForKey:@"info"] firstObject]valueForKey:@"giftlist"];
                for (int i=0; i<self.allArray.count; i++) {
                    [selectedArray addObject:@"0"];
                }
                _pageCount = self.allArray.count;
                while (_pageCount % 8 != 0) {
                    ++_pageCount;
                    NSLog(@"%zd", _pageCount);
                }
                for (int i=0; i<self.allArray.count; i++) {
                    [selectedArray addObject:@"0"];
                }
                [self.collectionView reloadData];
                LiveUser *user = [Config myProfile];
                NSString *coin = [[[data valueForKey:@"info"] firstObject] valueForKey:@"coin"];
                user.coin = coin;
                [Config updateProfile:user];
                [self chongzhiV:coin];
                if (self.allArray.count > 0) {
                    if ((int)self.allArray.count % 8 == 0) {
                        _pageControl.numberOfPages = self.allArray.count/8;
                    }
                    else{
                        _pageControl.numberOfPages = self.allArray.count/8 + 1;
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
-(void)jumpRechargess{
    [self.giftDelegate pushCoinV];
}
-(instancetype)initWithDic:(NSDictionary *)playdic andMyDic:(NSMutableArray *)myDic{
    self = [super init];
    if (self) {
        moveCount = 0;
        selectedArray = [NSMutableArray array];
        self.models = [NSArray array];
        self.allArray = [NSArray array];
        self.pldic = playdic;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        [self reloadColl];
        [self requestUserGiftList];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestUserGiftList) name:@"zajindanle" object:nil];
        //头部切换按钮
        headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 40)];
        headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"送礼物底图"]];
        headerView.userInteractionEnabled = YES;
        [self addSubview:headerView];

        NSArray *titleArray = @[YZMsg(@"礼物"),YZMsg(@"背包")];
        for (int i = 0; i<2; i++) {
            UIButton *button = [UIButton buttonWithType:0];
            button.frame = CGRectMake((_window_width/2-80)+i*80, 0, 80, 39);
            [button setTitle:titleArray[i] forState:0];
            button.tag = 1000+i;
            [button setTitleColor:normalColors forState:0];
            [button addTarget:self action:@selector(qiehuanbeibao:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = fontThin(14);
            [headerView addSubview:button];
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(button.left, button.bottom, button.width, 1)];
            view.tag = button.tag + 100;
            [headerView addSubview:view];
            if (i==0) {
                view.backgroundColor = normalColors;
            }
        }
        LWLCollectionViewHorizontalLayout *Flowlayout =[[LWLCollectionViewHorizontalLayout alloc]init];
        Flowlayout.itemCountPerRow = 4;
        Flowlayout.rowCount = 2;
        Flowlayout.minimumLineSpacing = 0;
        Flowlayout.minimumInteritemSpacing = 0;
        Flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,40,_window_width, _window_height/3- _window_height/18) collectionViewLayout:Flowlayout];
        Flowlayout.minimumLineSpacing = 0;
        Flowlayout.itemSize = CGSizeMake(_window_width/4, ( _window_height/3- _window_height/18)/2);
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.pagingEnabled = YES;
        
        //注册cell
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[giftCELL class] forCellWithReuseIdentifier:celll];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.multipleTouchEnabled = NO;
        [self.collectionView registerClass:[CollectionCellWhite class]
                forCellWithReuseIdentifier:@"CellWhite"];
        [self addSubview:self.collectionView];
        //底部条
        _buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, _collectionView.bottom, _window_width,_window_height/18)];
        _buttomView.backgroundColor = [UIColor clearColor];
        _push = [UIButton buttonWithType:UIButtonTypeSystem];
        _push.backgroundColor = [UIColor lightGrayColor];
        //充值lable
        _chongzhi = [[UILabel alloc] init];
        LiveUser *user = [Config myProfile];
        _chongzhi.textColor = [UIColor whiteColor];
        _chongzhi.font = [UIFont systemFontOfSize:14];
        int chongzhi_y = _buttomView.frame.size.height/2-7;
        [_buttomView addSubview:_chongzhi];
        //充值上透明按钮
        _jumpRecharge = [[UIButton alloc] initWithFrame:CGRectMake(5,chongzhi_y,250,40)];
        _jumpRecharge.titleLabel.text = @"";
        [_jumpRecharge setBackgroundColor:[UIColor clearColor]];
        [_jumpRecharge addTarget:self action:@selector(jumpRechargess) forControlEvents:UIControlEventTouchUpInside];
        [_buttomView addSubview:_jumpRecharge];
        [_push setTitle:YZMsg(@"赠送") forState:UIControlStateNormal];
        [_push setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_push addTarget:self action:@selector(doLiWu:) forControlEvents:UIControlEventTouchUpInside];
        _push.enabled = NO;
        _push.tag = 6789;
        _push.frame = CGRectMake(_window_width - 75,5,70,_buttomView.frame.size.height - 10);
        _push.layer.masksToBounds = YES;
        _push.layer.cornerRadius = (_buttomView.frame.size.height - 10)/2;
        [_buttomView addSubview:_push];
        [self addSubview:_buttomView];
        UILabel *xianssss = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _window_width, 0.3)];
        xianssss.backgroundColor = RGB(241, 241, 241);
        [_buttomView addSubview:xianssss];
        CGFloat w = 80;
        _continuBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        _continuBTN.frame = CGRectMake(_window_width - 80,_window_height/3 - w - 5,w,w);
        _continuBTN.backgroundColor =  [UIColor colorWithRed:60/255.0 green:139/255.0 blue:126/255.0 alpha:1];
        [_continuBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_continuBTN addTarget:self action:@selector(doLiWu:) forControlEvents:UIControlEventTouchDown];
        _continuBTN.tag = 5678;
        _continuBTN.titleLabel.numberOfLines = 2;
        _continuBTN.layer.masksToBounds = YES;
        _continuBTN.layer.cornerRadius = w/2;
        _continuBTN.hidden = YES;
        [_continuBTN setBackgroundImage:[UIImage imageNamed:@"liwusendcontinue"] forState:UIControlStateNormal];
        [self addSubview:_continuBTN];
        [self chongzhiV:user.coin];
        [self.collectionView reloadData];
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.frame = CGRectMake(_window_width*0.3,_collectionView.bottom-20,_window_width*0.4,20);
        pageControl.center = CGPointMake(0,_collectionView.bottom-10);
        pageControl.pageIndicatorTintColor = [UIColor grayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        pageControl.enabled = NO;
        _pageControl=pageControl;
        [self addSubview:pageControl];
    }
    return self;
}
-(void)setBottomAdd{

    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    //水平滑动时 判断是右滑还是左滑
    if(velocity.x>0){
        //右滑
        NSLog(@"右滑");
        isRight = YES;
    }else{
        //左滑
        NSLog(@"左滑");
        isRight = NO;
    }
    NSLog(@"scrollViewWillEndDragging");
    if (isRight) {
        self.pageControl.currentPage+=1;
    }
    else{
        self.pageControl.currentPage-=1;
    }
}
//发送礼物
-(void)doLiWu:(UIButton *)sender
{
    self.collectionView.userInteractionEnabled = NO;
    NSString *lianfa = @"y";
    _push.enabled = NO;
    _push.backgroundColor = [UIColor lightGrayColor];
    NSLog(@"发送了%@",_selectModel.giftname);
    //判断连发
    if ([_selectModel.type isEqualToString:@"0"]) {
        lianfa = @"n";
        _continuBTN.hidden = YES;
        _push.enabled = YES;
        _push.backgroundColor = normalColors;
        self.collectionView.userInteractionEnabled = YES;
    }
    else{
        _continuBTN.hidden = NO;
        a = 30;
        if(timer == nil)
        {
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(jishiqi) userInfo:nil repeats:YES];
        }
        if(sender == _push)
        {
            [timer setFireDate:[NSDate date]];
        }
    }
    /*******发送礼物开始 **********/
    NSString *giftID = @"";
    if (isfree == 1) {
        giftID = _selectModel.giftid;
        if ([_selectModel.giftnum intValue]<=0) {
            [MBProgressHUD showError:@"没有了，别送了"];
            return;
        }
    }else{
        giftID = _selectModel.ID;
    }
    NSString *url = [purl stringByAppendingFormat:@"service=Live.sendGift"];
    NSDictionary *giftDic = @{
                              @"uid":[Config getOwnID],
                              @"token":[Config getOwnToken],
                              @"liveuid":[self.pldic valueForKey:@"uid"],
                              @"stream":[self.pldic valueForKey:@"stream"],
                              @"giftid":giftID,
                              @"giftcount":@"1",
                              @"isknapsack":[NSString stringWithFormat:@"%d",isfree]
                              };
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:url parameters:giftDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                [self.giftDelegate sendGift:self.mydic andPlayDic:self.pldic andData:data andLianFa:lianfa];
                NSArray *info2 = [[data valueForKey:@"info"] firstObject];
                NSString *coin = [info2 valueForKey:@"coin"];
                LiveUser *liveUser = [Config myProfile];
                liveUser.coin  =  [NSString stringWithFormat:@"%@",coin];
                [Config updateProfile:liveUser];
                [self chongzhiV:coin];
                if (isfree == 1) {
                    giftCELL *cell = (giftCELL *)[_collectionView cellForItemAtIndexPath:freeIndex];
                    _selectModel.giftnum = [NSString stringWithFormat:@"%d", [_selectModel.giftnum intValue] - 1];
                    cell.numLabel.text = _selectModel.giftnum;
                    if ([_selectModel.giftnum intValue] <= 0) {
                        _continuBTN.hidden = YES;
                        [self requestUserGiftList];
                        _selectModel = nil;
                        _push.enabled = NO;
                        _push.backgroundColor = [UIColor lightGrayColor];
                    }
                }
            }
            else
            {
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
                _continuBTN.hidden = YES;
            }
        }
        else
        {
            [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
        /*********************发送礼物结束 ************************/
}
//连发倒计时
-(void)jishiqi{
    [_continuBTN setTitle:[NSString stringWithFormat:@"%@\n  %d",YZMsg(@"连发"),a] forState:UIControlStateNormal];
    a-=1;
    if (a == 0) {
        [timer setFireDate:[NSDate distantFuture]];
        _push.backgroundColor = normalColors;
        _push.enabled = YES;
        _continuBTN.hidden = YES;
        self.collectionView.userInteractionEnabled = YES;
    }
}
-(void)chongzhiV:(NSString *)coins{
    if (_chongzhi) {
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ : %@%@",YZMsg(@"充值"),coins,[common name_coin]]];
    NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@":"].location);
    [noteStr addAttribute:NSForegroundColorAttributeName value:RGB(255, 204, 52) range:redRange];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"箭头gift"];
    attch.bounds = CGRectMake(0,0,10,10);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [noteStr appendAttributedString:string];
    [_chongzhi setAttributedText:noteStr];
    _chongzhi.font = [UIFont systemFontOfSize:14];
    int chongzhi_y = _buttomView.frame.size.height/2-7;
    _chongzhi.frame = CGRectMake(10,chongzhi_y,_window_width/2,20);
}
}
//展示cell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (isfree == 1) {
        return freeCount;
    }else{
        return _pageCount;
    }
}
//定义section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (isfree == 1) {
        if (indexPath.item >= freeArr.count) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellWhite"
                                                                                   forIndexPath:indexPath];
            return cell;
        } else {
            giftCELL *cell = (giftCELL *)[collectionView dequeueReusableCellWithReuseIdentifier:celll forIndexPath:indexPath];

            GIFTModell *model = freeArr[indexPath.item];
            cell.model = model;
            NSString *duihao = [NSString stringWithFormat:@"%@",freeSelectedArray[indexPath.row]];
            if ([duihao isEqual:@"1"]) {
                cell.kuangimage.hidden = NO;
                cell.priceL.textColor = RGB(255, 204, 52);
                cell.countL.textColor = RGB(255, 204, 52);
            }
            else{
                cell.kuangimage.hidden = YES;
                cell.priceL.textColor = [UIColor grayColor];
                cell.countL.textColor = [UIColor lightGrayColor];
            }
            if ([model.type isEqual:@"1"]) {
                cell.imageVs.hidden = NO;
            }
            else{
                cell.imageVs.hidden = YES;
            }
            cell.numLabel.hidden = NO;
            cell.numLabel.text = model.giftnum;

            return cell;
        }
    }else{
        if (indexPath.item >= self.models.count) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellWhite"
                                                                                   forIndexPath:indexPath];
            return cell;
        } else {
            
            giftCELL *cell = (giftCELL *)[collectionView dequeueReusableCellWithReuseIdentifier:celll forIndexPath:indexPath];
            cell.duihao.hidden = YES;
            GIFTModell *model = self.models[indexPath.item];
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            cell.model = model;
            NSString *duihao = [NSString stringWithFormat:@"%@",selectedArray[indexPath.row]];
            if ([duihao isEqual:@"1"]) {
                cell.kuangimage.hidden = NO;
                cell.priceL.textColor = RGB(255, 204, 52);
                cell.countL.textColor = RGB(255, 204, 52);
            }
            else{
                cell.kuangimage.hidden = YES;
                cell.priceL.textColor = [UIColor grayColor];
                cell.countL.textColor = [UIColor lightGrayColor];
            }
            if ([model.type isEqual:@"1"]) {
                cell.imageVs.hidden = NO;
            }
            else{
                cell.imageVs.hidden = YES;
            }
            cell.numLabel.hidden = YES;

            return cell;
        
    }
    
    }
    
}
-(void)reloadPushState{
    for (NSString *type in selectedArray) {
        if ([type isEqual:@"1"]) {
            _push.backgroundColor = normalColors;
            _push.enabled = YES;
            break;
        }
    }
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isfree == 0) {

        if (indexPath.row>=self.models.count) {
            return;
        }
        selectedArray = nil;
        selectedArray = [NSMutableArray array];
        for (int i=0; i<self.allArray.count; i++) {
            [selectedArray addObject:@"0"];
        }
        [selectedArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        _selectModel = self.models[indexPath.item];

    }else{
        if (indexPath.row>=freeArr.count) {
            return;
        }
        
        freeSelectedArray = nil;
        freeSelectedArray = [NSMutableArray array];
        for (int i=0; i<freeArr.count; i++) {
            [freeSelectedArray addObject:@"0"];
        }
        [freeSelectedArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        _selectModel = freeArr[indexPath.item];
        freeIndex = indexPath;

    }
    
    _push.enabled = YES;
    _push.backgroundColor =normalColors;
    [self.collectionView reloadData];
}
//每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    int cellWidth = _window_width/4;
    int cellHeight = ( _window_height/3- _window_height/18)/2;
    return CGSizeMake(cellWidth ,cellHeight);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
        return UIEdgeInsetsMake(0,0,0,0);
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


- (void)qiehuanbeibao:(UIButton *)btn{
    UIView *view = [headerView viewWithTag:btn.tag+100];
    view.backgroundColor = normalColors;
    _selectModel = nil;
    _push.enabled = NO;
    _push.backgroundColor = [UIColor lightGrayColor];
    _continuBTN.hidden = YES;
    _collectionView.userInteractionEnabled = YES;
    if (btn.tag == 1000) {
        UIView *view = [headerView viewWithTag:1101];
        view.backgroundColor = [UIColor clearColor];
        isfree = 0;
        if (self.allArray.count > 0) {
            if ((int)self.allArray.count % 8 == 0) {
                _pageControl.numberOfPages = self.allArray.count/8;
            }
            else{
                _pageControl.numberOfPages = self.allArray.count/8 + 1;
            }
            if (_pageControl.numberOfPages == 1) {
                _pageControl.hidden = YES;
            }else{
                _pageControl.hidden = NO;
            }
        }
        [selectedArray removeAllObjects];
        for (int i = 0; i<self.allArray.count; i++) {
            [selectedArray addObject:@"0"];
        }
    }else{
        UIView *view = [headerView viewWithTag:1100];
        view.backgroundColor = [UIColor clearColor];
        isfree = 1;
        if (freeArr.count > 0) {
            if ((int)freeArr.count % 8 == 0) {
                _pageControl.numberOfPages = freeArr.count/8;
            }
            else{
                _pageControl.numberOfPages = freeArr.count/8 + 1;
            }
            if (_pageControl.numberOfPages == 1) {
                _pageControl.hidden = YES;
            }else{
                _pageControl.hidden = NO;
            }
        }
        [freeSelectedArray removeAllObjects];
        for (int i = 0; i<freeArr.count; i++) {
            [freeSelectedArray addObject:@"0"];
        }

    }
    _push.enabled = NO;
    _push.backgroundColor = [UIColor lightGrayColor];
    [self.collectionView reloadData];
    
}
- (void)requestUserGiftList{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Goldeneggs.getUserGiftList"];
    
    NSDictionary *parameterDic = @{
                                   @"uid":[Config getOwnID]
                                   };
    
    [session POST:url parameters:parameterDic
         progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
             NSNumber *number = [responseObject valueForKey:@"ret"] ;
             if([number isEqualToNumber:[NSNumber numberWithInt:200]])
             {
                 NSArray *data = [responseObject valueForKey:@"data"];
                 NSNumber *code = [data valueForKey:@"code"];
                 if([code isEqualToNumber:[NSNumber numberWithInt:0]])
                 {
                     freeArr = [NSMutableArray array];
                     NSArray *info = [data valueForKey:@"info"];
                     for (NSDictionary *dic in info) {
                         GIFTModell *model = [GIFTModell modelWithDic:dic];
                         [freeArr addObject:model];
                     }
                     [freeSelectedArray removeAllObjects];

                     for (int i=0; i<info.count; i++) {
                         [freeSelectedArray addObject:@"0"];
                     }
                     freeCount = info.count;
                     while (freeCount % 8 != 0) {
                         ++freeCount;
                         NSLog(@"%zd", freeCount);
                     }
                     [self.collectionView reloadData];
                     
                     if (isfree == 1) {
                         [_collectionView reloadData];
                     }
                 }
             }
             
         }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [MBProgressHUD showError:@"无网络"];
         
     }];
    
    
}
@end
