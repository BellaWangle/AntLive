#import "AntHotCell.h"
#import "AnthotModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+Util.h"
@implementation AntHotCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:237/255.0 green:245/255.0 blue:244/255.0 alpha:1];
        self.myView = [[UIView alloc]initWithFrame:CGRectMake(0,0,_window_width,64)];
        self.myView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.myView];
        //创建主播头像button
        self.IconBTN = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 44, 44)];
        self.IconBTN.layer.masksToBounds = YES;
        self.IconBTN.layer.cornerRadius = 22;
        [self.myView addSubview:self.IconBTN];
        
        _level_anchormage = [[UIImageView alloc]init];
        _level_anchormage.layer.masksToBounds = YES;
        _level_anchormage.layer.cornerRadius = 10;
        _level_anchormage.layer.borderWidth = 2;
        _level_anchormage.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.myView addSubview:_level_anchormage];
        [_level_anchormage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_IconBTN.mas_trailing).offset(-16);
            make.top.mas_equalTo(_IconBTN.mas_bottom).offset(-16);
            make.width.height.mas_equalTo(18);
        }];
        
        //在线人数
        self.peopleCountL = [[UILabel alloc]initWithFont:17 textColor:Default_Gray];
        self.peopleCountL.textAlignment = NSTextAlignmentRight;
        [self.myView addSubview:self.peopleCountL];
        [_peopleCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.mas_equalTo(-DEFAULT_MARGIN_ENDS);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_greaterThanOrEqualTo(0);
        }];
        
        //创建名字          Heiti SC
        self.nameL = [[UILabel alloc]initWithFont:17 textColor:Default_Black];
        [self.myView addSubview:self.nameL];
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_IconBTN);
            make.leading.mas_equalTo(_IconBTN.mas_trailing).offset(10);
            make.trailing.mas_equalTo(_peopleCountL.mas_leading).offset(-10);
            make.height.mas_equalTo(24);
        }];
        
        self.placeL = [[UILabel alloc]initWithFont:13 textColor:Default_Gray];
        self.placeL.font = [UIFont fontWithName:@"Heiti SC" size:13];
        self.placeL.textColor = [UIColor lightGrayColor];
        self.placeL.userInteractionEnabled = NO;
        [self.myView addSubview:self.placeL];
        [_placeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_IconBTN);
            make.leading.mas_equalTo(_IconBTN.mas_trailing).offset(10);
            make.width.mas_greaterThanOrEqualTo(0);
            make.height.mas_equalTo(20);
        }];
        
        UIImageView *imaghevIEW = [[UIImageView alloc]init];
        imaghevIEW.image = [UIImage imageNamed:@"icon_live_location_active.png"];
        imaghevIEW.contentMode = UIViewContentModeScaleAspectFit;
        [self.myView addSubview:imaghevIEW];
        [imaghevIEW mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(_placeL.mas_trailing).offset(5);
            make.centerY.mas_equalTo(_placeL);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(10);
        }];
        
        //创建显示大图
        self.imageV = [[UIImageView alloc]init];
        [self.imageV setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"无结果"]]];
        [self.contentView addSubview:self.imageV];
        [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_myView.mas_bottom);
            make.leading.trailing.mas_equalTo(0);
            make.height.mas_equalTo(_imageV.mas_width);
        }];
        
        
        
        self.typeView = [[LiveTypeView alloc]initWithBig];
        self.typeView.layer.cornerRadius = 11;
        [self.imageV addSubview:_typeView];
        [_typeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.mas_equalTo(DEFAULT_MARGIN_ENDS);
            make.height.mas_equalTo(22);
            make.width.mas_greaterThanOrEqualTo(0);
        }];
        
        //直播状态
        self.statusView = [[LiveStateView alloc]initWithFocus];
        self.statusView.layer.cornerRadius = 11;
        [self.imageV addSubview:self.statusView];
        [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(DEFAULT_MARGIN_ENDS);
            make.trailing.mas_equalTo(-DEFAULT_MARGIN_ENDS);
            make.height.mas_equalTo(22);
            make.width.mas_greaterThanOrEqualTo(0);
        }];
    
        _titleBgGradientView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        [_titleBgGradientView gradientWithColors:@[[[UIColor blackColor]colorWithAlphaComponent:0], [[UIColor blackColor]colorWithAlphaComponent:0.3]] starPoint:CGPointMake(1, 0) endPoint:CGPointMake(1, 1)];
        [self.imageV addSubview:_titleBgGradientView];
        [_titleBgGradientView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(0);
            make.height.mas_equalTo(80);
        }];
        
        self.titleLabel = [[UILabel alloc]initWithFont:17 textColor:[UIColor whiteColor]];
        [_titleBgGradientView addSubview:self.titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(DEFAULT_MARGIN_ENDS);
            make.trailing.mas_equalTo(-DEFAULT_MARGIN_ENDS);
            make.bottom.mas_equalTo(-10);
            make.height.mas_equalTo(24);
        }];
        
    }
    return self;
}
-(void)setModel:(AnthotModel *)model{
    _model = model;
    self.nameL.text = _model.zhuboName;
    if (IsEmptyStr(_model.title)) {
        self.titleBgGradientView.hidden = YES;
    }else{
        self.titleBgGradientView.hidden = NO;
        self.titleLabel.text = [NSString stringWithFormat:@"%@",_model.title];
    }
    NSString *imagePath = [_model.zhuboIcon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.IconBTN sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"default_head"]];
    NSString *thumb = [NSString stringWithFormat:@"%@",_model.zhuboImage];
    if (thumb) {
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:thumb] placeholderImage:[UIImage imageNamed:@"无结果"]];
    }
    [_level_anchormage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"host_%@",_model.level_anchor]]];
    self.placeL.text = [NSString stringWithFormat:@"%@%@",@" ",_model.zhuboPlace];
    self.peopleCountL.text = [NSString stringWithFormat:@"%@%@",_model.onlineCount,YZMsg(@"在看")];
    self.statusView.frame = _model.statusR;
    NSInteger type = [minstr(_model.type) integerValue];
    
    _typeView.liveType = type;

}
+(AntHotCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *CellIdentifier = @"HOTCell";

    AntHotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[AntHotCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}
@end
