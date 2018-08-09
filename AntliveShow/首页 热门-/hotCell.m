#import "hotCell.h"
#import "hotModel.h"
#import "UIImageView+WebCache.h"
@implementation hotCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:237/255.0 green:245/255.0 blue:244/255.0 alpha:1];
        self.myView = [[UIView alloc]init];
        self.myView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.myView];
        [self.myView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.mas_equalTo(0);
            make.height.mas_equalTo(64);
        }];
        
        //创建主播头像button
        self.IconBTN = [[UIImageView alloc]init];
        self.IconBTN.layer.masksToBounds = YES;
        self.IconBTN.layer.cornerRadius = 22;
        [self.myView addSubview:self.IconBTN];
        [self.IconBTN mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(15);
            make.centerY.mas_equalTo(_myView);
            make.width.height.mas_equalTo(44);
        }];
        
        UIView * levelBgView = [[UIView alloc]init];
        levelBgView.backgroundColor = [UIColor whiteColor];
        levelBgView.layer.cornerRadius = 10;
        [self.myView addSubview:levelBgView];
        [levelBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_IconBTN.mas_leading).offset(29);
            make.bottom.mas_equalTo(_IconBTN);
            make.width.height.mas_equalTo(20);
        }];
        
        _level_anchormage = [[UIImageView alloc]initWithFrame:CGRectMake(38,38, 16, 16)];
        _level_anchormage.layer.masksToBounds = YES;
        _level_anchormage.layer.cornerRadius = 8;
        [levelBgView addSubview:_level_anchormage];
        [_level_anchormage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(levelBgView);
            make.width.height.mas_equalTo(16);
        }];
        
        
        
        //创建名字          Heiti SC
        self.nameL = [[UILabel alloc]init];
        self.nameL.textColor = Default_Black;
        self.nameL.font = [UIFont fontWithName:@"Heiti SC" size:17];
        //位置(uitextfield)
        [self.myView addSubview:self.nameL];
        [self.nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_IconBTN);
            make.leading.mas_equalTo(_IconBTN.mas_trailing).offset(10);
            make.height.mas_equalTo(24);
            make.width.mas_greaterThanOrEqualTo(0);
        }];
        
        self.placeL = [[UILabel alloc]init];
        self.placeL.font = [UIFont fontWithName:@"Heiti SC" size:13];
        self.placeL.textColor = Default_Gray;
        self.placeL.userInteractionEnabled = NO;
        [self.myView addSubview:self.placeL];
        [self.placeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_IconBTN);
            make.leading.mas_equalTo(_nameL);
            make.height.mas_equalTo(18);
            make.width.mas_greaterThanOrEqualTo(0);
        }];
        
        UIImageView *imaghevIEW = [[UIImageView alloc]initWithFrame:CGRectMake(70,34,8,10)];
        imaghevIEW.image = [UIImage imageNamed:@"icon_live_location_active.png"];
        imaghevIEW.contentMode = UIViewContentModeScaleAspectFit;
        [self.myView addSubview:imaghevIEW];
        [imaghevIEW mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_placeL);
            make.leading.mas_equalTo(_placeL.mas_trailing).offset(5);
            make.height.mas_equalTo(10);
            make.width.mas_equalTo(8);
        }];
        
        //在线人数
        self.peopleCountL = [[UILabel alloc]init];
        self.peopleCountL.font = [UIFont fontWithName:@"Heiti SC" size:16];
        self.peopleCountL.textAlignment = NSTextAlignmentRight;
        self.peopleCountL.textColor = [UIColor lightGrayColor];
        [self.myView addSubview:_peopleCountL];
        [_peopleCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_myView);
            make.trailing.mas_equalTo(-15);
            make.height.width.mas_greaterThanOrEqualTo(0);
        }];
        
        //创建显示大图
        self.imageV = [[UIImageView alloc]init];
        [self.imageV setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"无结果"]]];
        [self.contentView addSubview:self.imageV];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_myView.mas_bottom);
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(_imageV.mas_width);
        }];
        
        //直播状态
        self.statusimage = [[UIImageView alloc]init];
        self.statusimage.image = [UIImage imageNamed:getImagename(@"直播live")];
        self.statusimage.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageV addSubview:self.statusimage];
        [self.statusimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.trailing.mas_equalTo(-15);
            make.width.mas_equalTo(78);
            make.height.mas_equalTo(30);
        }];
        
        //开播类型
        _typeimagevc = [[UIImageView alloc]initWithFrame:CGRectMake(15,20,60,60)];
        _typeimagevc.contentMode = UIViewContentModeScaleAspectFit;
        [_typeimagevc setImage:[UIImage imageNamed:getImagename(@"icon_live_type_normal")]];
        _typeimagevc.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageV addSubview:_typeimagevc];
        
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.backgroundColor =  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
        self.titleLabel.font = fontThin(14);
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        
        
        }
    return self;
}
-(void)setModel:(hotModel *)model{
    _model = model;
    self.nameL.text = _model.zhuboName;
    if (_model.title == NULL || _model.title == nil || _model.title.length == 0) {
        self.titleLabel.hidden = YES;
    }
    else{
        self.titleLabel.hidden = NO;
        self.titleLabel.text = [NSString stringWithFormat:@"   %@",_model.title];
    }
    NSString *imagePath = [_model.zhuboIcon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.IconBTN sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"bg1"]];
    NSString *thumb = [NSString stringWithFormat:@"%@",_model.zhuboImage];
    if (thumb) {
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:thumb] placeholderImage:[UIImage imageNamed:@"无结果"]];
    }
    [_level_anchormage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"host_%@",_model.level_anchor]]];
    self.placeL.text = [NSString stringWithFormat:@"%@%@",@" ",_model.zhuboPlace];
    self.peopleCountL.text = [NSString stringWithFormat:@"%@%@",_model.onlineCount,YZMsg(@"在看")];
    
    int type = [minstr(_model.type) intValue];
    //0是一般直播，1是私密直播，2是收费直播，3是计时直播
    switch (type) {
        case 0:
            [_typeimagevc setImage:[UIImage imageNamed:getImagename(@"icon_live_type_normal")]];
            break;
        case 1:
            [_typeimagevc setImage:[UIImage imageNamed:getImagename(@"icon_live_type_pwd")]];
            break;
        case 2:
            [_typeimagevc setImage:[UIImage imageNamed:getImagename(@"icon_live_type_charge")]];
            break;
        case 3:
            [_typeimagevc setImage:[UIImage imageNamed:getImagename(@"icon_live_type_time_charge")]];
            break;
        default:
            break;
    }
}
+(hotCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *CellIdentifier = @"HOTCell";

    hotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[hotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}
@end
