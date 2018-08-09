

#import "shaixuanCell.h"
#import "shaixuanModel.h"
@interface shaixuanCell ()

@property (weak, nonatomic) IBOutlet UILabel *city;

@property (weak, nonatomic) IBOutlet UILabel *num;




@end


@implementation shaixuanCell


-(void)setModel:(shaixuanModel *)model{
    _model = model;
    _city.text = _model.city;
    _num.text = [NSString stringWithFormat:@"%@",_model.num];
    
}

+(shaixuanCell *)cellWithTableView:(UITableView *)tableView{
    
    shaixuanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shaixuancell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"shaixuanCell" owner:self options:nil].lastObject;
    }
    
    return cell;
    
}

@end
