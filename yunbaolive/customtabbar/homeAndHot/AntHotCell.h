#import <UIKit/UIKit.h>
#import "LiveStateView.h"
@class AnthotModel;
@interface AntHotCell : UITableViewCell
@property(nonatomic,strong)UIImageView *IconBTN;//主播头像
@property(nonatomic,strong)UILabel *nameL;//主播名字
@property(nonatomic,strong)UILabel *placeL;//主播位置
@property(nonatomic,strong)UILabel *peopleCountL;//在线人数
@property(nonatomic,strong)UIImageView *imageV;//显示大图
@property(nonatomic,strong)LiveStateView *statusView;//直播状态
@property(nonatomic,strong)UIView *myView;//地步view
@property(nonatomic,strong)UILabel *titleLabel;//直播标题
@property(nonatomic,strong)UIView *titleBgGradientView;

@property(nonatomic,strong)UIImageView *level_anchormage;//主播等级
@property(nonatomic,strong)LiveTypeView *typeView;//直播类型
@property(nonatomic,strong)AnthotModel *model;
+(AntHotCell *)cellWithTableView:(UITableView *)tableView;
@end
