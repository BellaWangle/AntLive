#import "myView.h"
#import "UIImageView+WebCache.h"
#import "lunbocell.h"
#define  YYIDCell @"cell"
#define YYMaxSections _window_height
@interface myView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIColor *color;
}
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UIPageControl *pageControl;
@property (nonatomic , strong) NSArray *newses;
@property (nonatomic , strong) NSTimer *timer;
@end
@implementation myView
-(void)drawRect:(CGRect)rect{
    color = [UIColor colorWithRed:237/255.0 green:245/255.0 blue:244/255.0 alpha:1];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 10);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextMoveToPoint(ctx, 0, 120);
    CGContextAddLineToPoint(ctx, self.frame.size.width,120);
    CGContextStrokePath(ctx);
}
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)reload:(NSArray *)list{
    _newses = list;
    [self.collectionView reloadData];
    [self addTimer];
    self.pageControl.numberOfPages = _newses.count;
}
- (void)initView{
    CGFloat w =  _window_width;
    self.frame = CGRectMake(0, 0,w,130);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(w,130);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, w,130) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _collectionView=collectionView;
    [self.collectionView registerNib:[UINib nibWithNibName:@"lunbocell" bundle:nil] forCellWithReuseIdentifier:YYIDCell];
#pragma mark -- pageControll
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(w*0.4,110,_window_width,40);
    pageControl.center =CGPointMake(self.center.x, 110);
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = normalColors;
    pageControl.enabled = NO;
    pageControl.numberOfPages = _newses.count;
    _pageControl=pageControl;
    [self addSubview:self.collectionView];
    [self addSubview:pageControl];
    
}
#pragma mark 添加定时器
-(void) addTimer{
    if (self.newses.count >1) {
        if (!self.timer) {
            
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
//        self.timer = timer ;
       }

    }
}
#pragma mark 删除定时器
-(void) removeTimer{
    
    [self.timer invalidate];
    self.timer = nil;
    
}
-(void) nextpage{
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:_window_height/2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    NSInteger nextItem = currentIndexPathReset.item +1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem==self.newses.count) {
        nextItem=0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}
#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return YYMaxSections;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate jumpWebView:[_newses[indexPath.row] valueForKey:@"slide_url"]];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.newses.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    lunbocell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YYIDCell forIndexPath:indexPath];
    [cell.imageviewsss sd_setImageWithURL:[NSURL URLWithString:[self.newses[indexPath.row] valueForKey:@"slide_pic"]] placeholderImage:[UIImage imageNamed:@"mr.png"]];
    cell.contentView.frame = CGRectMake(0, 0, _window_width, 120);
    return cell;
}
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}
#pragma mark 当用户停止的时候调用
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}
#pragma mark 设置页码
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.newses.count;
    self.pageControl.currentPage =page;
}
@end
