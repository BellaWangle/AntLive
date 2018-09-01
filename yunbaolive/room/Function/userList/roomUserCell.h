
#import <UIKit/UIKit.h>

@class listModel;

@interface roomUserCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *imageV;

@property(nonatomic,strong)UIImageView *levelimage;

@property(nonatomic,strong)listModel *model;


+(roomUserCell *)collectionview:(UICollectionView *)collectionview andIndexpath:(NSIndexPath *)indexpath;


@end
