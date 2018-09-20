
#import <UIKit/UIKit.h>

#import "GIFTModell.h"

#import "SpectatorRoomVC.h"


@interface giftCELL : UICollectionViewCell
{
    UIImageView *imageView;
    
    SpectatorRoomVC *player;
}


@property(nonatomic,strong)UIButton *imageVs;

@property(nonatomic,strong)UIButton *duihao;

@property(nonatomic,strong)UIImageView *cellimageV;

@property(nonatomic,strong)UIImageView *kuangimage;

@property(nonatomic,strong)UILabel *priceL;

@property(nonatomic,strong)UILabel *countL;

@property(nonatomic,strong)UIImageView * diamondsImageView;

@property(nonatomic,strong)GIFTModell *model;
@property (nonatomic,strong)UILabel *numLabel;//个数


@end
