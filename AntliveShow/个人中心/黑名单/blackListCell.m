

#import "blackListCell.h"

#import "fansModel.h"


#import "SDWebImage/UIButton+WebCache.h"


@implementation blackListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        
        
        
    }
    return self;
}

-(void)setModel:(fansModel *)model{
    
    _model = model;
    
    
    _name.text = _model.name;
    
    _signal.text = _model.signature;
    
    //性别 1男 2女 默认女
    if ([_model.sex isEqual:@"2"]) {
        self.sexI.image = [UIImage imageNamed:@"global_female"];
    }
    else if ([[_model valueForKey:@"sex"] isEqual:@"1"])
    {
        self.sexI.image = [UIImage imageNamed:@"global_male"];
    }
    else
    {
        self.sexI.image = [UIImage imageNamed:@"global_female"];
    }
    
    //级别
    self.levelI.image = [UIImage imageNamed:[NSString stringWithFormat:@"leve%@",_model.level]];
    
    //头像
    [self.icon sd_setBackgroundImageWithURL:[NSURL URLWithString:_model.icon] forState:UIControlStateNormal];
    
    self.icon.layer.cornerRadius = 20;
    self.icon.layer.masksToBounds = YES;
    
    
    
}

+(blackListCell *)cellWithTableView:(UITableView *)tableView{
    
    blackListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"blackListCell" owner:self options:nil].lastObject;
    }
    return cell;
    
}

@end
