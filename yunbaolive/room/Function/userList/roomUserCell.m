#import "roomUserCell.h"
#import "listModel.h"
#import "SDWebImage/UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
@implementation roomUserCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,30,30)];
        _imageV.layer.masksToBounds = YES;
        _imageV.layer.cornerRadius = 15;
        _imageV.center = self.contentView.center;
        [self.contentView addSubview:_imageV];
        
        _levelimage = [[UIImageView alloc]initWithFrame:CGRectMake(20,23,15,15)];
        _levelimage.layer.masksToBounds = YES;
        _levelimage.layer.cornerRadius = 7.5;
        _levelimage.layer.borderWidth = 1;
        _levelimage.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:_levelimage];
    }
    return self;
}
-(void)setModel:(listModel *)model{
    _model = model;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:_model.iconName] placeholderImage:[UIImage imageNamed:@"default_head"]];
    [_levelimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"leve%@",_model.level]]];
}
+(roomUserCell *)collectionview:(UICollectionView *)collectionview andIndexpath:(NSIndexPath *)indexpath{
    roomUserCell *cell = [collectionview dequeueReusableCellWithReuseIdentifier:@"list" forIndexPath:indexpath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"roomUserCell" owner:self options:nil].lastObject;
    }
    return cell;
}
@end
