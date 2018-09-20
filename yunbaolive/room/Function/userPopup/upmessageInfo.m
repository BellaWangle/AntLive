#import "upmessageInfo.h"
#import "UIButton+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "CSActionSheet.h"
#import "CSActionPicker.h"
#import "UIView+Additions.h"
#import "AntButton.h"
@interface upmessageInfo ()<UIAlertViewDelegate,UIActionSheetDelegate,UIActionSheetDelegate>
{
    CSActionSheet *_myActionSheet;
    UIActionSheet *actionSheet;//管理弹窗
    CGFloat userW;
    NSString *userName;
    MASConstraint *cons;//重载约束
    MASConstraint *consHomeBtn;//重载约束
    UIView * _bgView;//重载约束
}
@end
@implementation upmessageInfo
-(instancetype)initWithFrame:(CGRect)frame andPlayer:(NSString *)playerstate{
    self = [super initWithFrame:frame];
    if (self) {
        _playstate = playerstate;
        [self upMessage];
    }
    return self;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex== 0) {
        return;
    }else{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Live.setReport"];
        NSDictionary *subdic = @{
                                 @"uid":[Config getOwnID],
                                 @"touid":self.userID,
                                 @"token":[Config getOwnToken],
                                 @"content":YZMsg(@"涉嫌传播淫秽色情信息")
                                 };
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //NSLog(@"%@",responseObject);
            NSNumber *number = [responseObject valueForKey:@"ret"] ;
            if([number isEqualToNumber:[NSNumber numberWithInt:200]])
            {
                NSArray *data = [responseObject valueForKey:@"data"];
                NSNumber *code = [data valueForKey:@"code"];
                if([code isEqualToNumber:[NSNumber numberWithInt:0]])
                {
                    [MBProgressHUD showSuccess:YZMsg(@"举报成功")];
                }
                
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}
-(void)doReport{
    UIAlertView *customAlertView = [[UIAlertView alloc] initWithTitle:YZMsg(@"提示") message:YZMsg(@"确定举报？") delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确认"), nil];
    customAlertView.tag = 1035;
    customAlertView.delegate = self;
    [customAlertView show];
    
}
-(void)closeDetailView{
  [self.upmessageDelegate doupCancle];
}
//用户列表弹窗
-(void)upMessage{
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    //*********************************添加用户列表弹窗**********************************//
    _contentBgView = [[UIView alloc]init];
    [self addSubview:_contentBgView];
    [_contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.height.mas_equalTo(378);
    }];
    
    _contentBgView.top = _window_height;
    
    _bgView = [[UIView alloc]init];
    _bgView.layer.cornerRadius = 8;
    _bgView.backgroundColor = [UIColor whiteColor];
    [_contentBgView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.height.mas_equalTo(328);
    }];
    
    //关闭按钮
    AntButton * closeBTN = [[AntButton alloc]init];
    closeBTN.image = [UIImage imageNamed:@"close"];
    closeBTN.buttonImageWidth = 18;
    [closeBTN addTarget:self action:@selector(closeDetailView) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:closeBTN];//添加关闭按钮
    [closeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.mas_equalTo(0);
        make.width.height.mas_equalTo(54);
    }];
    
    _jubaoBTNnew = [UIButton buttonWithType:UIButtonTypeCustom];
    [_jubaoBTNnew setTitle:YZMsg(@"举报") forState:UIControlStateNormal];
    _jubaoBTNnew.titleLabel.font = fontThin(15);
    [_jubaoBTNnew setTitleColor:UIColorFromRGB(0xff9216) forState:UIControlStateNormal];
    _jubaoBTNnew.frame =CGRectMake(5,0,70,54);
    [_jubaoBTNnew addTarget:self action:@selector(doReport) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_jubaoBTNnew];
    
    _guanliBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [_guanliBTN setImage:[UIImage imageNamed:@"管理system"] forState:UIControlStateNormal];
    [_guanliBTN setTitleColor:UIColorFromRGB(0xff9216) forState:UIControlStateNormal];
    _guanliBTN.frame =CGRectMake(20,15,20,20);
    [_guanliBTN addTarget:self action:@selector(doGuanLi) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_guanliBTN];
    
    _iconImageView = [[UIImageView alloc]init];
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = 50;
    [_contentBgView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(100);
    }];
    
    _levelhostview = [[UIImageView alloc]init];
    _levelhostview.layer.masksToBounds = YES;
    _levelhostview.layer.cornerRadius = 10;
    _levelhostview.layer.borderColor = [UIColor whiteColor].CGColor;
    _levelhostview.layer.borderWidth = 2;
    [_contentBgView addSubview:_levelhostview];
    [_levelhostview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.mas_equalTo(_iconImageView).offset(-5);
        make.width.height.mas_equalTo(20);
    }];
    
    _nameLabel = [[UILabel alloc]initWithFont:22];
    [_bgView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_lessThanOrEqualTo(-41);
        make.width.mas_greaterThanOrEqualTo(0);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(_iconImageView.mas_bottom).offset(16);
    }];
    
    _sexIcon = [[UIImageView alloc]init];
    [_bgView addSubview:_sexIcon];
    [_sexIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_nameLabel.mas_trailing).offset(5);
        make.centerY.mas_equalTo(_nameLabel);
        make.width.height.mas_equalTo(18);
    }];
    
    _levelView = [[UIImageView alloc]init];
    _levelView.layer.cornerRadius = 9;
    _levelView.clipsToBounds = YES;
    [_bgView addSubview:_levelView];
    [_levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_sexIcon.mas_trailing).offset(5);
        make.centerY.mas_equalTo(_nameLabel);
        make.width.height.mas_equalTo(18);
    }];
    
    UIView * idCityBgView = [[UIView alloc]init];
    [_bgView addSubview:idCityBgView];
    [idCityBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(3);
        make.centerX.mas_equalTo(0);
        make.width.mas_greaterThanOrEqualTo(0);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH - 60);
    }];
    
    _IDLabel = [[UILabel alloc]initWithTextColor:Default_Gray font:15 textAliahment:NSTextAlignmentLeft text:nil];
    [idCityBgView addSubview:_IDLabel];
    [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.mas_equalTo(0);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _mapIcon = [[UIImageView alloc]init];
    _mapIcon.image = [UIImage imageNamed:@"Location_yellow"];
    [idCityBgView addSubview:_mapIcon];
    [_mapIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(idCityBgView);
        make.leading.mas_equalTo(_IDLabel.mas_trailing).offset(23);
        make.width.mas_equalTo(11);
        make.height.mas_equalTo(13);
    }];
    
    _cityLabel = [[UILabel alloc]initWithTextColor:Default_Gray font:15 textAliahment:NSTextAlignmentLeft text:nil];
    [idCityBgView addSubview:_cityLabel];
    [_cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(_mapIcon.mas_trailing).offset(6);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_greaterThanOrEqualTo(0);
        make.trailing.mas_equalTo(0);
    }];
    
    _forceView = [[UpmessageInfoNumView alloc]initWithTitle:YZMsg(@"关注")];
    [_bgView addSubview:_forceView];
    [_forceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cityLabel.mas_bottom).offset(25);
        make.leading.mas_equalTo(25);
        make.height.mas_equalTo(36);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _fansView = [[UpmessageInfoNumView alloc]initWithTitle:YZMsg(@"粉丝")];
    [_bgView addSubview:_fansView];
    [_fansView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(_forceView);
        make.trailing.mas_equalTo(-25);
        make.leading.mas_equalTo(_forceView.mas_trailing).offset(35);
        make.width.mas_equalTo(_forceView);
    }];
    
    _payView = [[UpmessageInfoNumView alloc]initWithTitle:YZMsg(@"送出")];
    [_bgView addSubview:_payView];
    [_payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_forceView.mas_bottom).offset(20);
        make.leading.height.mas_equalTo(_forceView);
        make.width.mas_greaterThanOrEqualTo(0);
    }];
    
    _incomeView = [[UpmessageInfoNumView alloc]initWithTitle:YZMsg(@"收入")];
    [_bgView addSubview:_incomeView];
    [_incomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(_payView);
        make.trailing.mas_equalTo(_fansView);
        make.leading.mas_equalTo(_payView.mas_trailing).offset(35);
        make.width.mas_equalTo(_payView);
    }];
    
    _homeBtn = [[AntButton alloc]initConfirmButtonWithTitle:YZMsg(@"主页") cornerRadius:20];
    _homeBtn.selected = YES;
    [_homeBtn addTarget:self action:@selector(homeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_homeBtn];
    [_homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(190);
        make.bottom.mas_equalTo(-20);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    _guanliBTN.hidden   = YES;
    _jubaoBTNnew.hidden = YES;
    
    userW = self.frame.size.width;
    
    [self layoutIfNeeded];
    
//    [self setUpLayout];
}
//MARK:-布局UI
//-(void)setUpLayout
//{
//    [self.systemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(15);
//        make.top.equalTo(self.mas_top).offset(5);
//    }];
//    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-10);
//        make.top.equalTo(self.systemBtn.mas_top);
//    }];
//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(50);
//        make.centerX.equalTo(self.mas_centerX);
//        make.width.height.mas_equalTo(90);
//    }];
//    [self.levelhostview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.iconImageView.mas_right).offset(-20);
//        make.top.equalTo(self.iconImageView.mas_bottom).offset(-20);
//        make.width.mas_equalTo(18);
//        make.height.mas_equalTo(18);
//    }];
//
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        cons = make.centerX.equalTo(self.mas_centerX);
//        make.top.equalTo(self.iconImageView.mas_bottom).offset(18);
//        make.height.mas_equalTo(18);
//    }];
//    [self.sexIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nameLabel.mas_top);
//        make.left.equalTo(self.nameLabel.mas_right).offset(3);
//        make.width.height.mas_equalTo(18);
//    }];
//    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.sexIcon.mas_right).offset(3);
//        make.top.equalTo(self.sexIcon.mas_top);
//        make.width.mas_equalTo(18);
//        make.height.mas_equalTo(18);
//    }];
//    [self.mapIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.sexIcon.mas_bottom).offset(12);
//        make.centerX.mas_equalTo(self.mas_centerX).offset(7);
//        make.height.mas_equalTo(13);
//        make.width.mas_equalTo(14);
//    }];
//    [self.IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mapIcon.mas_top);
//        make.height.equalTo(self.mapIcon);
//        make.right.equalTo(self.mapIcon.mas_left).offset(-5);
//    }];
//    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.height.equalTo(self.mapIcon);
//        make.left.equalTo(self.mapIcon.mas_right).offset(3);
//    }];
//    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mapIcon.mas_bottom).offset(40);
//        make.height.mas_equalTo(20);
//        make.width.mas_equalTo(1);
//        make.centerX.equalTo(self.mas_centerX);
//    }];
//    [self.forceView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView1.mas_top).offset(0);
//        make.left.equalTo(self.mas_left).offset(50);
//    }];
//    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.forceView.mas_top);
//        make.left.equalTo(self.lineView1).offset(40);
//    }];
//    [self.lineView2   mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView1.mas_bottom).offset(10);
//        make.centerX.equalTo(self.mas_centerX);
//        make.width.mas_equalTo(1);
//        make.height.equalTo(self.lineView1.mas_height);
//    }];
//    [self.payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView2.mas_top);
//        make.left.equalTo(self.forceView.mas_left);
//    }];
//    [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView2.mas_top);
//        make.left.equalTo(self.fansLabel.mas_left);
//    }];
//    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView2.mas_bottom).offset(25);
//        make.left.equalTo(self.mas_left).offset(25);
//        make.right.equalTo(self.mas_right).offset(-25);
//        make.height.mas_equalTo(1);
//    }];
//    [self.forceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView3.mas_bottom);
//        make.bottom.equalTo(self.mas_bottom);
//        make.width.mas_equalTo(self.frame.size.width/3);
//        make.left.equalTo(self.mas_left);
//    }];
//    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self.forceBtn);
//        make.width.mas_equalTo(self.frame.size.width/3);
//        make.left.equalTo(self.forceBtn.mas_right);
//    }];
//    [self.homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self.forceBtn);
//        make.width.mas_equalTo(self.frame.size.width/3);
//        make.left.equalTo(self.messageBtn.mas_right);
//        consHomeBtn =   make.left.equalTo(self.forceBtn.mas_right);
//    }];
//}
////MARK:-model
////MARK:-SetUI
//-(UIButton *)systemBtn
//{
//    if (!_systemBtn) {
//        _systemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_systemBtn setTitle:@"" forState:UIControlStateNormal];
//        _systemBtn.hidden = YES;
//        [_systemBtn setTitleColor:UIColorFromRGB(0x2298f9) forState:UIControlStateNormal];
//        _systemBtn.titleLabel.font = fontThin(8);
//        self.systemBtn = _systemBtn;
//        [_bgView addSubview:_systemBtn];
//        [_systemBtn addTarget:self action:@selector(doReport) forControlEvents:UIControlEventTouchUpInside];
//
//    }
//    return _systemBtn;
//}
//- (UIButton *)closeBtn
//{
//    if (!_closeBtn) {
//        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _closeBtn.hidden = YES;
//        _closeBtn.titleLabel.font = fontThin(12);
//        [_closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
//        [_closeBtn setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
//        _closeBtn.adjustsImageWhenHighlighted = NO;
//        [_closeBtn setTitleColor:UIColorFromRGB(0x2298f9) forState:UIControlStateNormal];
//        [_closeBtn addTarget:self action:@selector(closeDetailView) forControlEvents:UIControlEventTouchUpInside];
//        self.closeBtn = _closeBtn;
//        [_bgView addSubview:_closeBtn];
//    }
//    return _closeBtn;
//}
//-(UIImageView *)iconImageView
//{
//    if (!_iconImageView) {
//        _iconImageView = [[UIImageView alloc]init];
//        [_iconImageView setClipsToBounds:YES];
//        _iconImageView.layer.masksToBounds = YES;
//        _iconImageView.layer.cornerRadius = 45;
//        _iconImageView.layer.borderWidth = 1.5;
//        _iconImageView.layer.borderColor =UIColorFromRGB(0xff9216).CGColor;
//        [_iconImageView sizeToFit];
//        self.iconImageView = _iconImageView;
//        [self addSubview:_iconImageView];
//    }
//    return _iconImageView;
//}
//-(UIImageView *)sexIcon
//{
//    if (!_sexIcon) {
//        _sexIcon = [[UIImageView alloc]init];
//        _sexIcon.backgroundColor = [UIColor whiteColor];
//        [_sexIcon setContentMode:UIViewContentModeScaleAspectFit];
//        self.sexIcon = _sexIcon;
//        [_bgView addSubview:_sexIcon];
//    }
//    return _sexIcon;
//}
////名字label
//-(UILabel *)nameLabel
//{
//    if (!_nameLabel) {
//        _nameLabel = [[UILabel alloc]init];
//        _nameLabel.textColor = UIColorFromRGB(0x4f4f4f);
//        _nameLabel.font = fontThin(15);
//        self.nameLabel = _nameLabel;
//        _nameLabel.text = @" ";
//        [_bgView addSubview:_nameLabel];}
//    return _nameLabel;
//}
//-(UIImageView *)levelView
//{
//    if (!_levelView) {
//        _levelView = [[UIImageView alloc]init];
//        _levelView.backgroundColor = [UIColor whiteColor];
//        self.levelView = _levelView;
//        [_bgView addSubview:_levelView];
//    }
//    return _levelView;
//}
//-(UIImageView *)levelhostview
//{     if (!_levelhostview) {
//        _levelhostview = [[UIImageView alloc]init];
//        _levelhostview.layer.masksToBounds = YES;
//        _levelhostview.layer.cornerRadius = 9;
//        self.levelhostview = _levelhostview;
//        [_bgView addSubview:_levelhostview];
//    }
//    return _levelhostview;
//}
//-(UILabel *)IDLabel
//{
//    if (!_IDLabel)
//    {
//        _IDLabel = [[UILabel alloc]init];
//        _IDLabel.textColor = UIColorFromRGB(0xb0b0b0);
//        _IDLabel.font = fontThin(14);
//        self.IDLabel = _IDLabel;
//        _IDLabel.text = @" ";
//        [_bgView addSubview:_IDLabel];
//    }
//    return _IDLabel;
//}
//-(UIImageView *)mapIcon
//{
//    if (!_mapIcon) {
//        _mapIcon = [[UIImageView alloc]init];
//        _mapIcon.backgroundColor = [UIColor whiteColor];
//        _mapIcon.image = [UIImage imageNamed:@"Location_yellow"];
//        self.mapIcon = _mapIcon;
//        [_bgView addSubview:_mapIcon];
//    }
//    return _mapIcon;
//}
//-(UILabel *)cityLabel
//{
//    if (!_cityLabel) {
//        _cityLabel = [[UILabel alloc]init];
//        _cityLabel.textColor = UIColorFromRGB(0xb0b0b0);
//        _cityLabel.font = fontThin(14);;
//        _cityLabel.text = @"";
//        self.cityLabel = _cityLabel;
//        [_bgView addSubview:_cityLabel];}
//    return _cityLabel;
//}
//-(UIImageView *)lineView1
//{
//    if (!_lineView1) {
//        _lineView1 = [[UIImageView alloc]init];
//        _lineView1.backgroundColor = [UIColor grayColor];
//        _lineView1.image = [UIImage imageNamed:@"line.png"];
//        self.lineView1 = _lineView1;
//        [self addSubview:_lineView1];
//    }
//    return _lineView1;
//}
//-(UILabel *)forceView
//{
//    if (!_forceView) {
//        _forceView = [[UILabel alloc]init];
//        _forceView.textColor = UIColorFromRGB(0xaaaaaa);
//        _forceLabel.font = fontThin(13);
//        _forceLabel.text = [NSString stringWithFormat:@"%@： ",YZMsg(@"关注")];
//        self.forceView = _forceView;
//        [_bgView addSubview:_forceView];}
//    return _forceView;
//}
//-(UILabel *)fansLabel
//{
//    if (!_fansLabel) {
//        _fansLabel = [[UILabel alloc]init];
//        _fansLabel.textColor = UIColorFromRGB(0xaaaaaa);
//        _fansLabel.font = fontThin(13);
//        _fansLabel.text = [NSString stringWithFormat:@"%@： ",YZMsg(@"粉丝")];
//        self.fansLabel = _fansLabel;
//        [_bgView addSubview:_fansLabel];}
//    return _fansLabel;
//}
//-(UIImageView *)lineView2
//{
//    if (!_lineView2) {
//        _lineView2 = [[UIImageView alloc]init];
//        _lineView2.backgroundColor = [UIColor grayColor];
//        _lineView2.image = [UIImage imageNamed:@"line.png"];
//        self.lineView2 = _lineView2;
//        [self addSubview:_lineView2];
//    }
//    return _lineView2;
//}
//-(UILabel *)payLabel
//{
//    if (!_payLabel) {
//        _payLabel = [[UILabel alloc]init];
//        _payLabel.textColor = normalColors;
//        _payLabel.font = fontThin(13);
//        _payLabel.text = [NSString stringWithFormat:@"%@： ",YZMsg(@"送出")];
//        self.payLabel = _payLabel;
//        [self addSubview:_payLabel];}
//    return _payLabel;
//}
//-(UILabel *)incomeLabel
//{
//    if (!_incomeLabel) {
//        _incomeLabel = [[UILabel alloc]init];
//        _incomeLabel.textColor = normalColors;
//        _incomeLabel.font = fontThin(13);
//        _incomeLabel.text = [NSString stringWithFormat:@"%@： ",YZMsg(@"收入")];
//        self.incomeLabel = _incomeLabel;
//        [self addSubview:_incomeLabel];}
//    return _incomeLabel;
//}
//-(UIImageView *)lineView3
//{
//    if (!_lineView3) {
//        _lineView3 = [[UIImageView alloc]init];
//        _lineView3.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        self.lineView3 = _lineView3;
//        [self addSubview:_lineView3];
//    }
//    return _lineView3;
//}
//-(UIButton *)forceBtn
//{
//    _forceBtn = [self YBBottomButton:_forceBtn title:YZMsg(@"关注") titleFont:13];
//    [_forceBtn addTarget:self action:@selector(forceBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [_forceBtn setTitleColor:UIColorFromRGB(0xff9216) forState:UIControlStateNormal];
//    self.forceBtn = _forceBtn;
//    return _forceBtn;
//}
//-(UIButton *)messageBtn
//{
//    _messageBtn = [self YBBottomButton:_messageBtn title:YZMsg(@"私信") titleFont:13];
//    [_messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [_messageBtn setTitleColor:UIColorFromRGB(0xff9216) forState:UIControlStateNormal];
//    self.messageBtn = _messageBtn;
//    return  _messageBtn;
//}
//-(UIButton *)homeBtn
//{
//    _homeBtn =  [self YBBottomButton:_homeBtn title:YZMsg(@"主页") titleFont:13];
//    [_homeBtn addTarget:self action:@selector(homeBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [_homeBtn setTitleColor:UIColorFromRGB(0xff9216) forState:UIControlStateNormal];
//    self.homeBtn = _homeBtn;
//    return _homeBtn;
//}
//- (UIButton *)YBBottomButton:(UIButton *)button  title:(NSString *)title titleFont:(CGFloat)titleFont  {
//    if (!button) {
//        button = [[UIButton alloc]init];
//        [button setTitle:title forState:UIControlStateNormal];
//        [button setTitleColor:UIColorFromRGB(0x2298f9) forState:UIControlStateNormal];
//        button.titleLabel.font = fontThin(titleFont);
//        button.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [_bgView addSubview:button];
//    }
//    return button;
//}
-(void)getUpmessgeinfo:(NSDictionary *)userDic andzhuboDic:(NSDictionary *)zhuboDic{
    self.zhuboDic = zhuboDic;
    self.userID = [NSString stringWithFormat:@"%@",[userDic valueForKey:@"id"]];
//    //如果点开的是自己
//    NSString *userID = [NSString stringWithFormat:@"%@",[userDic valueForKey:@"id"]];
//    if ([userID isEqual:[Config getOwnID]]) {
//        _forceBtn.hidden = YES;
//        _messageBtn.hidden = YES;
//        [consHomeBtn uninstall];
//        [self.homeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            consHomeBtn =  make.left.equalTo(self.forceBtn.mas_right);
//        }];
//    }
//    else
//    {
//        _forceBtn.hidden = NO;
//        _messageBtn.hidden = NO;
//        [consHomeBtn uninstall];
//        [self.homeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//            consHomeBtn =  make.left.equalTo(self.messageBtn.mas_right);
//        }];
//    }
    [self getinfomessage2:[userDic valueForKey:@"id"]];
}
-(void)getinfomessage2:(NSString *)selectedID{
    _guanliArrays = [NSArray array];
    AFHTTPSessionManager *session2 = [AFHTTPSessionManager manager];
    NSString *url2 = [purl stringByAppendingFormat:@"service=Live.getPop"];
    NSDictionary *getPop = @{
                             @"uid":[Config getOwnID],
                             @"touid":selectedID,
                             @"liveuid":[self.zhuboDic valueForKey:@"uid"]
                             };
    [session2 POST:url2 parameters:getPop progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSArray *singleUserArray = [[data valueForKey:@"info"] firstObject];
                //头像
                [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[singleUserArray valueForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"default_head"]];
                //ID
                
                NSString *liangname = [NSString stringWithFormat:@"%@",[[singleUserArray valueForKey:@"liang"] valueForKey:@"name"]];
                if ([liangname isEqual:@"0"]) {
                     _IDLabel.text = [NSString stringWithFormat:@"ID:%@",[singleUserArray valueForKey:@"id"]];
                    
                }else{
                     _IDLabel.text = [NSString stringWithFormat:@"%@:%@",YZMsg(@"靓"),liangname];
                }
                //姓名
                userName = [singleUserArray valueForKey:@"user_nicename"];
                _nameLabel.text = [NSString stringWithFormat:@"%@%@",[singleUserArray valueForKey:@"user_nicename"],@"  "];
                _seleIcon = [singleUserArray valueForKey:@"avatar"];
                _seleID = [singleUserArray valueForKey:@"id"];
                _selename = [singleUserArray valueForKey:@"user_nicename"];
                CGFloat rightViewWidth = (_sexIcon.width+_levelView.width + 3 + 3)/2;
                [cons uninstall];
                [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    {
                        make.centerX.mas_equalTo(self.mas_centerX).offset(-rightViewWidth);
                    }
                }];
                //数据信息
                _payView.contentLabel.text = [NSString stringWithFormat:@"%@",[singleUserArray valueForKey:@"consumption"]];
                _fansView.contentLabel.text = [NSString stringWithFormat:@"%@",[singleUserArray valueForKey:@"fans"]];
                _incomeView.contentLabel.text = [NSString stringWithFormat:@"%@",[singleUserArray valueForKey:@"votestotal"]];
                _forceView.contentLabel.text = [NSString stringWithFormat:@"%@",[singleUserArray valueForKey:@"follows"]];
                //性别
                NSString *sex = [NSString stringWithFormat:@"%@",[singleUserArray valueForKey:@"sex"]];
                if ([sex isEqual:@"1"]) {
                    _sexIcon.image = [UIImage imageNamed:@"choice_sex_nanren"];
                }
                else{
                    _sexIcon.image = [UIImage imageNamed:@"choice_sex_nvren"];//性别
                }
                //等级
            _levelView.image = [UIImage imageNamed:[NSString stringWithFormat:@"leve%@.png",[NSString stringWithFormat:@"%@",[singleUserArray valueForKey:@"level"]]]];
            _levelhostview.image = [UIImage imageNamed:[NSString stringWithFormat:@"host_%@.png",[NSString stringWithFormat:@"%@",[singleUserArray valueForKey:@"level_anchor"]]]];
            NSString *cityfu = [NSString stringWithFormat:@"%@",[singleUserArray valueForKey:@"city"]];
                //位置
                if ([[singleUserArray valueForKey:@"city"] isEqual:[NSNull null]] || [[singleUserArray valueForKey:@"city"] isEqual:@"null"] || [[singleUserArray valueForKey:@"city"] isEqual:@"(null)"] || [singleUserArray valueForKey:@"city"] == NULL || [singleUserArray valueForKey:@"city"] == nil) {
                    _cityLabel.text = YZMsg(@"好像在火星");
                }
                else if (cityfu.length == 0){
                    _cityLabel.text = YZMsg(@"好像在火星");
                }
                else{
                    _cityLabel.text = [NSString stringWithFormat:@"%@",[singleUserArray valueForKey:@"city"]];//地址
                }
                NSString *isattention = [NSString stringWithFormat:@"%@",[singleUserArray valueForKey:@"isattention"]];
                //判断关注
                if ([isattention isEqual:@"0"]) {
                    [_forceBtn setTitle:YZMsg(@"关注") forState:UIControlStateNormal];
                    [_forceBtn setTitleColor:UIColorFromRGB(0xff9216) forState:UIControlStateNormal];
                     _forceBtn.enabled = YES;
                }
                else{
                    [_forceBtn setTitle:YZMsg(@"已关注") forState:UIControlStateNormal];
                    [_forceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    _forceBtn.enabled = NO;
                }
                //判断管理 操作显示，0表示自己，30表示普通用户，40表示管理员，501表示主播设置管理员，502表示主播取消管理员，60表示超管管理主播
                NSString *action = [NSString stringWithFormat:@"%@",[singleUserArray valueForKey:@"action"]];

                if ([action isEqual:@"0"]) {
                    _guanliBTN.hidden = YES;
                    _jubaoBTNnew.hidden = YES;
                    //自己
                }else if ([action isEqual:@"30"]){
                    _guanliBTN.hidden = YES;
                    _jubaoBTNnew.hidden = NO;
                    //普通用户
                }else if ([action isEqual:@"40"]){
                    _guanliBTN.hidden = NO;
                    _jubaoBTNnew.hidden = YES;
                    _guanliArrays = @[YZMsg(@"踢人"),YZMsg(@"禁言")];
                    //管理员
                }else if ([action isEqual:@"501"]){
                    _guanliBTN.hidden = NO;
                    _jubaoBTNnew.hidden = YES;
                    _guanliArrays = @[YZMsg(@"踢人"),YZMsg(@"禁言"),YZMsg(@"设为管理"),YZMsg(@"管理员列表")];
                   //主播设置管理员
                }else if ([action isEqual:@"502"]){
                    _guanliBTN.hidden = NO;
                    _jubaoBTNnew.hidden = YES;
                    _guanliArrays = @[YZMsg(@"踢人"),YZMsg(@"禁言"),YZMsg(@"取消管理"),YZMsg(@"管理员列表")];
                    //主播取消管理员
                }else if ([action isEqual:@"60"]){
                    //超管管理主播
                    _guanliBTN.hidden = NO;
                    _jubaoBTNnew.hidden = YES;
                    _guanliArrays = @[YZMsg(@"关闭直播"),YZMsg(@"禁用直播")];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//这是弹窗的事件
-(void)doGuanLi{
    if (_myActionSheet) {
        [_myActionSheet removeFromSuperview];
        _myActionSheet = nil;
    }
    CGSize winsize = [UIScreen mainScreen].bounds.size;
    CGFloat x;
    x = 0;
    _myActionSheet = [[CSActionSheet alloc] initWithFrame:CGRectMake(x,0, winsize.width, winsize.height) titles:_guanliArrays cancal:YZMsg(@"取消") normal_color:[UIColor whiteColor] highlighted_color:[UIColor whiteColor] tips:nil tipsColor:[UIColor whiteColor] cellBgColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8] cellLineColor:[UIColor lightGrayColor]];
    
    [self.superview addSubview:_myActionSheet];
    
    [_myActionSheet showView:^(int index, id sender) {
    if (index == 1)
    {
        if ([[_guanliArrays firstObject] isEqual:YZMsg(@"关闭直播")]) {
            [self superStopRoom];
        }else{
            [self kickuser];
        }
    }
    if (index == 2)
    {
        if ([[_guanliArrays objectAtIndex:1] isEqual:YZMsg(@"禁用直播")]) {
            [self superCloseRoom];
        }else{
            [self jinyan];
        }
    }
    if (index == 3)
    {
        [self setAdmin];;
    }
    if (index == 4)
    {
        [self adminLIst];
    }
        CSActionSheet *view1 = (CSActionSheet*)sender;
        [view1 hideView];
    }
        close:^(id sender) {
        CSActionSheet *view1 = (CSActionSheet*)sender;
        if (view1) {
            [view1 removeFromSuperview];
            view1 = nil;
        }
    }];
}
//超管管理主播
-(void)superStopRoom{
    //关闭当前直播
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Live.superStopRoom"];
    NSDictionary *setadmin = @{
                               @"uid":[Config getOwnID],
                               @"liveuid":[self.zhuboDic valueForKey:@"uid"],
                               @"type":@"0",
                               @"token":[Config getOwnToken]
                               };
    
    [session POST:url parameters:setadmin progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [data valueForKey:@"code"];
            if([code isEqual:@0])
            {
                NSArray *info = [data valueForKey:@"info"];
                
                [MBProgressHUD showSuccess:[[info firstObject] valueForKey:@"msg"]];
                [self.upmessageDelegate superAdmin:@"0"];
                
            }
            else{
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
            }
            [self.upmessageDelegate doupCancle];
        }
        else{
            
            
            [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
    }];
}
-(void)superCloseRoom{
    //关闭当前直播
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Live.superStopRoom"];
    NSDictionary *setadmin = @{
                               @"uid":[Config getOwnID],
                               @"liveuid":[self.zhuboDic valueForKey:@"uid"],
                               @"type":@"1",
                               @"token":[Config getOwnToken]
                               };
    [session POST:url parameters:setadmin progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [data valueForKey:@"code"];
            if([code isEqual:@0])
            {
                NSArray *info = [data valueForKey:@"info"];
                [MBProgressHUD showSuccess:[[info firstObject] valueForKey:@"msg"]];
                 [self.upmessageDelegate superAdmin:@"1"];
            }
            else{
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
            }
            
            [self.upmessageDelegate doupCancle];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)adminLIst{
    [self.upmessageDelegate adminList];
}
-(void)setAdmin{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Live.setAdmin"];
    
    NSDictionary *setadmin = @{
                             @"uid":[Config getOwnID],
                             @"liveuid":[self.zhuboDic valueForKey:@"uid"],
                             @"touid":self.userID,
                             @"token":[Config getOwnToken]
                             };
    [session POST:url parameters:setadmin progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [data valueForKey:@"code"];
            if([code isEqual:@0])
            {
                NSArray *info = [data valueForKey:@"info"];
                NSString *isadmin = [NSString stringWithFormat:@"%@",[[info firstObject] valueForKey:@"isadmin"]];                
                [self.upmessageDelegate setAdminSuccess:isadmin];
                
            }
            else{
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
            }
            
            [self.upmessageDelegate doupCancle];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
//踢人
-(void)kickuser{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Live.kicking"];
    NSDictionary *kickuser = @{
                             @"uid":[Config getOwnID],
                             @"liveuid":[self.zhuboDic valueForKey:@"uid"],
                             @"touid":self.userID,
                             @"token":[Config getOwnToken]
                             };
    
    [session POST:url parameters:kickuser progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [data valueForKey:@"code"];
            if([code isEqual:@0])
            {
                
                if ([self.upmessageDelegate respondsToSelector:@selector(socketkickuser:andID:)]) {
                    [self.upmessageDelegate socketkickuser:userName andID:self.userID];
                }
                
                [MBProgressHUD showSuccess:[[[data valueForKey:@"info"] firstObject] valueForKey:@"msg"]];
                
            }
            else{
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//禁言
-(void)jinyan{
    //  User.setShutUp
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=Live.setShutUp"];
    
    NSDictionary *shutup = @{
                             @"uid":[Config getOwnID],
                             @"liveuid":[self.zhuboDic valueForKey:@"uid"],
                             @"touid":self.userID,
                             @"token":[Config getOwnToken]
                             };
    
    
    
    [session POST:url parameters:shutup progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [data valueForKey:@"code"];
            if([code isEqual:@0])
            {
                
                if ([self.upmessageDelegate respondsToSelector:@selector(socketkickuser:andID:)]) {
                    [self.upmessageDelegate socketShutUp:userName andID:self.userID];
                }
            }
            else{
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//设置取消关注
-(void)forceBtnClick{
    
    // User.setAttentionAnchor
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"service=User.setAttent"];
    NSDictionary *attent = @{
                             @"uid":[Config getOwnID],
                             @"touid":self.userID
                             };
    [session POST:url parameters:attent progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                [self.upmessageDelegate doUpMessageGuanZhu];
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)homeBtnClick{
    [self.upmessageDelegate pushZhuYe:self.userID];
}
-(void)messageBtnClick{
    
    
    [self.upmessageDelegate siXin:_seleIcon andName:_selename andID:_seleID];
}
@end


@implementation UpmessageInfoNumView

-(instancetype)initWithTitle:(NSString *)title{
    self = [super init];
    if (self) {
        _titleLabel = [[UILabel alloc]initWithTextColor:Default_Gray font:15 textAliahment:NSTextAlignmentLeft text:title];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.bottom.mas_equalTo(0);
            make.width.mas_greaterThanOrEqualTo(0);
        }];
        
        _contentLabel = [[UILabel alloc]initWithFont:15 textAliahment:NSTextAlignmentRight text:nil];
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.bottom.mas_equalTo(0);
            make.leading.mas_equalTo(_titleLabel.mas_trailing).offset(5);
        }];
        
        UILabel * line = [[UILabel alloc]initLineColor:nil];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.6);
        }];
    }
    return self;
}

@end
