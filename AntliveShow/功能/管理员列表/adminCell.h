

#import <UIKit/UIKit.h>
@class fansModel;
@interface adminCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *iconBTN;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *signatureL;
@property (weak, nonatomic) IBOutlet UIImageView *sexL;

@property (weak, nonatomic) IBOutlet UIImageView *levelL;


@property(nonatomic,strong)fansModel *model;

+(adminCell *)cellWithTableView:(UITableView *)tableView;

@end
