#import "listCell.h"
#import "listModel.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
@implementation listCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,30,30)];
        _imageV.layer.masksToBounds = YES;
        _imageV.layer.cornerRadius = 15;
        _imageV.layer.borderWidth = 1;
        _imageV.layer.borderColor = normalColors.CGColor;
        _imageV.center = self.contentView.center;
        [self.contentView addSubview:_imageV];
        
        _levelimage = [[UIImageView alloc]initWithFrame:CGRectMake(20,23,15,15)];
        _levelimage.layer.masksToBounds = YES;
        _levelimage.layer.cornerRadius = 7.5;
        [self addSubview:_levelimage];
    }
    return self;
}
-(void)setModel:(listModel *)model{
    _model = model;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:_model.iconName] placeholderImage:[UIImage imageNamed:@"bg1"]];
    [_levelimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"leve%@",_model.level]]];
}
+(listCell *)collectionview:(UICollectionView *)collectionview andIndexpath:(NSIndexPath *)indexpath{
    listCell *cell = [collectionview dequeueReusableCellWithReuseIdentifier:@"list" forIndexPath:indexpath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"listCell" owner:self options:nil].lastObject;
    }
    return cell;
}
@end
