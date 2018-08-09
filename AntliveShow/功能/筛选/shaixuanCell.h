
#import <UIKit/UIKit.h>

@class shaixuanModel;

@interface shaixuanCell : UITableViewCell


@property(nonatomic,strong)shaixuanModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *image;


+(shaixuanCell *)cellWithTableView:(UITableView *)tableView;



@end
