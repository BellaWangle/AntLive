
#import "adminCell.h"
#import "fansModel.h"

#import "SDWebImage/UIButton+WebCache.h"


@implementation adminCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        
        
        
    }
    return self;
}

-(void)setModel:(fansModel *)model{
    
    _model = model;
    
    _nameL.text = _model.name;
    
    _signatureL.text = _model.signature;
    
    
    //性别 1男 2女 默认女
    if ([_model.sex isEqual:@"2"]) {
        self.sexL.image = [UIImage imageNamed:@"choice_sex_nvren"];
    }
    else if ([[_model valueForKey:@"sex"] isEqual:@"1"])
    {
        self.sexL.image = [UIImage imageNamed:@"choice_sex_nanren"];
    }
    else
    {
        self.sexL.image = [UIImage imageNamed:@"choice_sex_nvren"];
    }
    
    //级别
    self.levelL.image = [UIImage imageNamed:[NSString stringWithFormat:@"leve%@",_model.level]];
    
    //头像
    [self.iconBTN sd_setBackgroundImageWithURL:[NSURL URLWithString:_model.icon] forState:UIControlStateNormal];
    
    self.iconBTN.layer.cornerRadius = 20;
    self.iconBTN.layer.masksToBounds = YES;

    
    
}
+(adminCell *)cellWithTableView:(UITableView *)tableView{
    
    adminCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"adminCell" owner:self options:nil].lastObject;
    }
    return cell;
    
}

@end
