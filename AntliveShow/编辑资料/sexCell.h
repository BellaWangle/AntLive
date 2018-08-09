
#import <UIKit/UIKit.h>

@interface sexCell : UITableViewCell




@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

+(sexCell *)cellWithTableView:(UITableView *)tableView;

@end
