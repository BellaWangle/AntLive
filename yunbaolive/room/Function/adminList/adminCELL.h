

#import <UIKit/UIKit.h>
@class AntFansModel;
@interface adminCELL : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *iconBTN;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *signatureL;
@property (weak, nonatomic) IBOutlet UIImageView *sexL;

@property (weak, nonatomic) IBOutlet UIImageView *levelL;


@property(nonatomic,strong)AntFansModel *model;

+(adminCELL *)cellWithTableView:(UITableView *)tableView;

@end
