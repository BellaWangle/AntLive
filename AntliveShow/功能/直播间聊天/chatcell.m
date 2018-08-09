
#import "chatcell.h"
#import "chatModel.h"
#import "UIImageView+WebCache.h"
#import "Config.h"
#import "mylabels.h"

@interface chatcell()
{
    int eWai;
}
@end

@implementation chatcell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgV = [[UIView alloc]init];
        self.bgV.layer.masksToBounds = YES;
        self.bgV.layer.cornerRadius = 5;
        self.bgV.backgroundColor = [UIColor blackColor];
        self.bgV.alpha = 0.3;
        
        
        self.imageV = [[UIImageView alloc]init];
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        
        self.vip_imagev = [[UIImageView alloc]init];
        self.vip_imagev.contentMode = UIViewContentModeScaleAspectFit;
        
        self.liangimage = [[UIImageView alloc]init];
        self.liangimage.contentMode = UIViewContentModeScaleAspectFit;
        
        self.nameL = [[mylabels alloc]init];
        self.nameL.backgroundColor = [UIColor clearColor];
        self.nameL.lineBreakMode = NSLineBreakByCharWrapping;
        self.nameL.textAlignment = NSTextAlignmentLeft;
        self.nameL.textColor = [UIColor whiteColor];
        self.nameL.layer.masksToBounds = YES;
        
        self.nameL.font = [UIFont fontWithName:@"Microsoft YaHei" size:15];//Arial-ItalicMT
        self.nameL.numberOfLines = 0;
        self.nameL.shadowColor = [UIColor blackColor];
        self.nameL.shadowOffset = CGSizeMake(0,0.5);
        self.nameL.adjustsFontSizeToFitWidth = YES;
        [self.nameL setVerticalAlignment:VerticalAlignmentTop];
        
        
        _shadow = [[NSShadow alloc]init];
        _shadow.shadowBlurRadius = 1.0;
        _shadow.shadowOffset  = CGSizeMake(0.5,0.5);
        _shadow.shadowColor = [UIColor blackColor];
        
        eWai = 0;
        
        [self.contentView addSubview:self.bgV];
        [self.contentView addSubview:self.vip_imagev];
        [self.contentView addSubview:self.liangimage];
        
        [self.contentView addSubview:self.imageV];
        [self.contentView addSubview:self.nameL];
        [self.contentView addSubview:self.button];
        
    }
    return self;
}
-(void)setModel:(chatModel *)model{
    _model = model;
    [self setData];
    //入场消息 开播警告
    if ([_model.titleColor isEqual:@"firstlogin"]) {
        eWai = 0;
        [self setfirstFrame];
        self.nameL.textColor = RGB(82,229,212);
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.nameL.text attributes:@{NSShadowAttributeName:_shadow}];
        NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@":"].location +1);
        [noteStr addAttribute:NSForegroundColorAttributeName value:RGB(255, 255, 255) range:redRange];
        [self.nameL setAttributedText:noteStr];
        
    }else if ([_model.titleColor isEqual:@"userLogin"]){
      //用户进入
        eWai = 0;
        [self setfirstFrame];
        self.nameL.textColor = RGB(82,229,212);
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.nameL.text attributes:@{NSShadowAttributeName:_shadow}];
        NSRange redRange = NSMakeRange(0, _model.userName.length);
        [noteStr addAttribute:NSForegroundColorAttributeName value:RGB(255, 255, 255) range:redRange];
        [self.nameL setAttributedText:noteStr];
    }else
    {
       /*
        0 青蛙
        1 猴子
        2 小红花
        3 小黄花
        4 心
        */
        [self setData];
        eWai = 0;
        self.nameL.textColor = [UIColor whiteColor];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.nameL.text attributes:@{NSShadowAttributeName:_shadow}];
        NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@":"].location +1);
        [noteStr addAttribute:NSForegroundColorAttributeName value:RGB(157, 201, 255) range:redRange];
        //礼物
        if ([_model.titleColor isEqual:@"2"])
        {
            self.nameL.textColor = RGB(240,237,60);//黄色
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.nameL.text];
            NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@":"].location);
            [noteStr addAttribute:NSForegroundColorAttributeName value:RGB(237,166,43) range:redRange];
            
        }
        //点亮
        if ([_model.titleColor containsString:@"light"]) {
            self.nameL.textColor = RGB(176,176,176);//灰色
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.nameL.text];
            NSRange redRange = NSMakeRange(0, [[noteStr string] rangeOfString:@":"].location);
            [noteStr addAttribute:NSForegroundColorAttributeName value:RGB(237,166,43) range:redRange];
        }
         if ([_model.titleColor isEqual:@"light0"])//青蛙
        {
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:@"plane_heart_cyan.png"];
            // 设置图片大小
            attch.bounds = CGRectMake(0,-4,17,17);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [noteStr appendAttributedString:string];
            eWai = 17;
            
        }
        else if ([_model.titleColor isEqual:@"light1"])//猴子
        {
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:@"plane_heart_pink.png"];
            // 设置图片大小
            attch.bounds = CGRectMake(0,-4,17,17);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [noteStr appendAttributedString:string];
            eWai = 17;
        }
        else if ([_model.titleColor isEqual:@"light2"])//小红花
        {
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:@"plane_heart_red.png"];
            // 设置图片大小
            attch.bounds = CGRectMake(0,-4,17,17);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [noteStr appendAttributedString:string];
            eWai = 17;
        }
        else if ([_model.titleColor isEqual:@"light3"])//小黄花
        {
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:@"plane_heart_yellow.png"];
            // 设置图片大小
            attch.bounds = CGRectMake(0,-4, 17, 17);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [noteStr appendAttributedString:string];
            eWai = 17;
        }
        else if ([_model.titleColor isEqual:@"light4"])//心
        {
            // 添加表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            // 表情图片
            attch.image = [UIImage imageNamed:@"plane_heart_heart"];
            // 设置图片大小
            attch.bounds = CGRectMake(0,-4, 17, 17);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [noteStr appendAttributedString:string];
            eWai = 17;
        }
        
       [self setFrame];
       [self.nameL setAttributedText:noteStr];
    }
}
-(void)setData{
    _imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"leve%@.png",_model.levelI]];
    if ([_model.titleColor isEqual:@"userLogin"]) {
        _nameL.text = [NSString stringWithFormat:@"%@%@",_model.userName,_model.contentChat];
    }else{
        _nameL.text = [NSString stringWithFormat:@"%@:%@",_model.userName,_model.contentChat];
    }
    
    //蓝色普通
    if ([_model.vip_type isEqual:@"1"]) {
        [_vip_imagev setImage:[UIImage imageNamed:@"vip图标_1"]];
        _vip_imagev.hidden = NO;
    }//红色至尊s
    else if ([_model.vip_type isEqual:@"2"]) {
        [_vip_imagev setImage:[UIImage imageNamed:@"vip图标_2"]];
        _vip_imagev.hidden = NO;
    } else {
        _vip_imagev.hidden = YES;
    }
    if (![_model.liangname isEqual:@"0"] || ![_model.liangname isEqual:@"(null)"] || _model.liangname !=nil || _model.liangname !=NULL) {
//         [_liangimage setImage:[UIImage imageNamed:@"靓号"]];
        [_liangimage setImage:[UIImage imageNamed:getImagename(@"icon_liang_num")]];

          _liangimage.hidden = NO;
    }
    else{
        [_liangimage setImage:[UIImage imageNamed:@""]];
         _liangimage.hidden = YES;
    }
}
//开播警告语坐标设置
-(void)setfirstFrame{
    _imageV.frame = CGRectMake(0, 0, 0, 0);
    _vip_imagev.frame = CGRectMake(0, 0, 0, 0);
    _liangimage.frame = CGRectMake(0, 0, 0, 0);
    _nameL.frame = _model.NAMER;
    _bgV.frame = CGRectMake(0, 0, CGRectGetMaxX(_model.NAMER)+eWai, _model.NAMER.size.height+7);;
}
-(void)setFrame{
    _liangimage.frame = _model.liangR;
    _vip_imagev.frame =  _model.vipR;
    _imageV.frame = _model.levelR;
    _nameL.frame = CGRectMake(_model.nameR.origin.x, _model.nameR.origin.y, _model.nameR.size.width+eWai, _model.nameR.size.height+7);//_model.nameR;
    _bgV.frame = CGRectMake(0, 0, CGRectGetMaxX(_model.nameR)+eWai, _model.nameR.size.height+7);
    self.button.frame =  _nameL.frame;
}
+(chatcell *)cellWithtableView:(UITableView *)tableView{
    chatcell *cell = [tableView dequeueReusableCellWithIdentifier:@"ccc"];
    if (!cell) {
    cell = [[chatcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ccc"];
    }
    return cell;
    
}
@end
