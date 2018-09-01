

#import "MXTabBtnPagC.h"

@interface MXTabBtnPagC ()
@property (nonatomic, assign) CGFloat selectFontScale;
@end

#define kUnderLineViewHeight 3

@implementation MXTabBtnPagC
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configureTabButtonPropertys];
    }
    return self;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        [self configureTabButtonPropertys];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.delegate) {
        self.delegate = self;
    }
    if (!self.dataSource) {
        self.dataSource = self;
    }
    _selectFontScale = self.normalTextFont.pointSize/self.selectedTextFont.pointSize;
    [self configureSubViews];
}
- (void)configureSubViews
{
    
   //progress
    self.progressView.backgroundColor = _progressColor;
   //self.progressView.layer.cornerRadius = 20;
   //self.progressView.layer.masksToBounds = YES;
    // tabBar
    self.pagerBarView.backgroundColor = _pagerBarColor;
    self.collectionViewBar.backgroundColor = _collectionViewBarColor;
    
}
- (void)configureTabButtonPropertys
{
    self.cellSpacing = 2;
    self.cellEdging = 3;
    self.barStyle = TYPagerBarStyleProgressView;
    
    _normalTextColor = [UIColor blackColor];
    
    _selectedTextColor = normalColors;
    _selectedbackcolor = normalColors;
    
    _normalbackcolor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:245/255.0 alpha:1.0];
    
    _pagerBarColor = [UIColor whiteColor];
    _collectionViewBarColor = [UIColor whiteColor];
    
    //_progressRadius = self.progressHeight/2;
    [self registerCellClass:[MXTabCell class] isContainXib:NO];
    
}
- (void)setBarStyle:(TYPagerBarStyle)barStyle
{
    [super setBarStyle:barStyle];
    
    switch (barStyle) {
        case TYPagerBarStyleProgressView:
            self.progressWidth = 0;
            self.progressHeight = kUnderLineViewHeight;
            self.progressEdging = 3;
            break;
        case TYPagerBarStyleProgressBounceView:
            self.progressHeight = kUnderLineViewHeight;
            self.progressWidth = 20;
            break;
        case TYPagerBarStyleCoverView:
            self.progressWidth = 3;
            self.progressHeight = self.contentTopEdging-8;
            self.progressEdging = -self.progressHeight/4;
            break;
        default:
            break;
    }
    
    if (barStyle == TYPagerBarStyleCoverView) {
        self.progressColor = [UIColor lightGrayColor];
    }else {
        self.progressColor = normalColors;
    }
    self.progressRadius = self.progressHeight/2;
}
#pragma mark - private
- (void)transitionFromCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)toCell
{
    if (fromCell) {
        MXTabCell * cell1 = (MXTabCell *)fromCell;
        cell1.titleBgView.alpha = 0;
        fromCell.titleLabel.textColor = [UIColor whiteColor];
    }
    
    if (toCell) {
        MXTabCell * cell2 = (MXTabCell *)toCell;
        cell2.titleBgView.alpha = 1;
        toCell.titleLabel.textColor = [UIColor whiteColor];
    }
}
- (void)transitionFromCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)toCell progress:(CGFloat)progress
{
    MXTabCell * cell1 = (MXTabCell *)fromCell;
    MXTabCell * cell2 = (MXTabCell *)toCell;
    
    cell1.titleBgView.alpha = 1.0-progress;
    cell2.titleBgView.alpha = progress;
}
#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController
{
    NSAssert(NO, @"you must impletement method numberOfControllersInPagerController");
    return 0;
}
- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index
{
    NSAssert(NO, @"you must impletement method pagerController:controllerForIndex:");
    return nil;
}
#pragma mark - TYTabPagerControllerDelegate
- (void)pagerController:(TYTabPagerController *)pagerController configreCell:(MXTabCell *)cell forItemTitle:(NSString *)title atIndexPath:(NSIndexPath *)indexPath
{
    MXTabCell *titleCell = (MXTabCell *)cell;
    titleCell.titleLabel.text = title;
    titleCell.titleLabel.font = self.selectedTextFont;
}
- (void)pagerController:(TYTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)toCell animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:self.animateDuration animations:^{
            [self transitionFromCell:(MXTabCell *)fromCell toCell:(MXTabCell *)toCell];
        }];
    }else{
        [self transitionFromCell:fromCell toCell:toCell];
    }
}
- (void)pagerController:(TYTabPagerController *)pagerController transitionFromeCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)fromCell toCell:(UICollectionViewCell<TYTabTitleCellProtocol> *)toCell progress:(CGFloat)progress
{
    [self transitionFromCell:fromCell toCell:toCell progress:progress];
}
@end
