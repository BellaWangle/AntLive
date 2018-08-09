

#import "liwucell.h"
#import "liwuModel.h"
#import "UIImageView+WebCache.h"


@implementation liwucell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.cellimageV = [[UIImageView alloc]init];
        self.cellimageV.contentMode = UIViewContentModeScaleAspectFit;
        self.priceL = [[UILabel alloc]init];
        self.priceL.backgroundColor = [UIColor clearColor];
        self.priceL.textAlignment = NSTextAlignmentCenter;
        self.priceL.font = [UIFont systemFontOfSize:10];
        self.priceL.textColor = [UIColor grayColor];
        self.countL = [[UILabel alloc]init];
        self.countL.textColor = [UIColor lightGrayColor];
        self.countL.backgroundColor = [UIColor clearColor];
        self.countL.numberOfLines = 0;
        self.countL.font = [UIFont systemFontOfSize:14];
        self.countL.textAlignment = NSTextAlignmentCenter;
        
        self.numLabel = [[UILabel alloc]init];
        self.numLabel.textColor = [UIColor colorWithRed:0.980 green:0.361 blue:0.604 alpha:1.00];
        self.numLabel.backgroundColor = [UIColor clearColor];
        self.numLabel.numberOfLines = 0;
        self.numLabel.textAlignment = NSTextAlignmentRight;
        self.numLabel.font = [UIFont systemFontOfSize:10];

        
        imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"个人中心(钻石)"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageVs = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 20, 4, 15,15)];
        _imageVs.hidden = YES;
        [_imageVs  setImage:[UIImage imageNamed:getImagename(@"icon_gift_lian")] forState:UIControlStateNormal];
        _duihao = [UIButton buttonWithType:UIButtonTypeCustom];
        _duihao.frame = CGRectMake(self.frame.size.width - 20, 4, 15,15);
        [_duihao setImage:[UIImage imageNamed:@"chat_gift_continue_selected.png"] forState:UIControlStateNormal];
        [_duihao setHidden:YES];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(all) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        _kuangimage = [[UIImageView alloc]init];
        [_kuangimage setImage:[UIImage imageNamed:@"选中kuang.png"]];
        _kuangimage.frame = CGRectMake(0,0,self.frame.size.width+2,self.frame.size.width-10);
        _kuangimage.hidden = YES;
        
        [self.contentView addSubview:_imageVs];//连
        [self.contentView addSubview:_duihao];//对号
       // [self.contentView addSubview:imageView];//魅力值
        [self.contentView addSubview:self.cellimageV];//礼物图
        [self.contentView addSubview:self.priceL];//价格
        [self.contentView addSubview:self.countL];//经验值
        [self.contentView addSubview:_kuangimage];
        [self.contentView addSubview:self.numLabel];

        
    }
    return self;
}
-(void)all{
    if (_duihao.hidden == YES) {
        _duihao.hidden = NO;
    }
    else{
        _duihao.hidden = YES;
    }
}
-(void)setModel:(liwuModel *)model{
    _model = model;
    [self setData];
    if ([_model.type isEqualToString:@"1"]) {
        _imageVs.hidden = NO;
    }
}
-(void)setData{
    [self.cellimageV sd_setImageWithURL:[NSURL URLWithString:_model.imagePath] placeholderImage:[UIImage imageNamed:@"mr.png"]];
    _countL.text = _model.giftname;
    _priceL.text = [NSString stringWithFormat:@"%@%@",_model.price,[common name_coin]];;

    self.cellimageV.frame = CGRectMake(10,0,self.frame.size.width-20, self.frame.size.width - 50);
    _priceL.frame = CGRectMake(0,self.frame.size.width - 35,_window_width/4,20);
    _countL.frame = CGRectMake(0,self.frame.size.width - 50,_window_width/4,20);
    imageView.frame = CGRectMake(_model.priceR.size.width+_model.priceR.origin.x, _model.priceR.origin.y, 15, 15);
    self.numLabel.frame = CGRectMake(self.width-30, _priceL.top+5, 25, 15);

}
@end
