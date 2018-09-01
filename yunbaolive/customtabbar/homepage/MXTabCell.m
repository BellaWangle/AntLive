#import "MXTabCell.h"
@interface MXTabCell ()
@property (nonatomic, weak) UILabel *titleLabel;
@end
@implementation MXTabCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addTabTitleLabel];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addTabTitleLabel];
    }
    return self;
}

- (void)addTabTitleLabel
{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = HexColor(@"FFC700");
    view.layer.cornerRadius = 15;
    view.alpha = 0;
    [self.contentView addSubview:view];
    _titleBgView = view;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont fontWithName:@"Microsoft YaHei" size:10];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:titleLabel];
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.cornerRadius = 15;
    _titleLabel = titleLabel;
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = self.contentView.bounds;
    
    _titleBgView.mj_size = CGSizeMake(62, 30);
    _titleBgView.center = self.contentView.center;
}

@end
