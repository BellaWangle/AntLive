
#import <UIKit/UIKit.h>

#import "fansModel.h"

@interface blackListCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIButton *icon;


@property (weak, nonatomic) IBOutlet UILabel *name;


@property (weak, nonatomic) IBOutlet UIImageView *sexI;

@property (weak, nonatomic) IBOutlet UIImageView *levelI;


@property (weak, nonatomic) IBOutlet UILabel *signal;






@property(nonatomic,strong)fansModel *model;


+(blackListCell *)cellWithTableView:(UITableView *)tableView;

@end
