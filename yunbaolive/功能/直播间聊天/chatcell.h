

#import <UIKit/UIKit.h>
#import "chatModel.h"
#import "mylabels.h"
@interface chatcell : UITableViewCell
@property(nonatomic,strong)chatModel *model;
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UIImageView *vip_imagev;
@property(nonatomic,strong)UIImageView *liangimage;
@property(nonatomic,strong)mylabels *nameL;
@property(nonatomic,strong)UILabel *contentL;
@property (nonatomic,strong) UIView *bgV;
@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)NSShadow *shadow;

+(chatcell *)cellWithtableView:(UITableView *)tableView;
@end
