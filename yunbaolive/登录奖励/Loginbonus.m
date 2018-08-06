//
//  Loginbonus.m
//  yunbaolive
//
//  Created by Rookie on 2017/4/1.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "Loginbonus.h"
#import "LogFirstCell.h"
#import "LogFirstCell2.h"

static NSString* IDENTIFIER = @"collectionCell";

static NSString *IDENTIFIER2 = @"collectionCell2";

@interface Loginbonus ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    CADisplayLink *_link;
    LogFirstCell *selectCell;
    LogFirstCell2 *selectCell2;
    UIImageView *sevendayimageview;
    
    NSString *logDay;
    NSArray *numArr ;
    
}
@property (nonatomic,assign) NSArray *arrays;

@end

@implementation Loginbonus

/******************  登录奖励 ->  ********************/

-(instancetype)initWithFrame:(CGRect)frame AndNSArray:(NSArray *)arrays AndDay:(NSString *)day{
    
    self = [super initWithFrame:frame];
    if (self) {
        _arrays = arrays;
        logDay = day;
        [self firstLog:frame];
    }
    return self;
    
}

-(void)firstLog:(CGRect)frame {
    
    CGFloat fcX = 0;
    CGFloat fcY = 0;
    CGFloat fcW = self.frame.size.width;
    CGFloat fcH = self.frame.size.height;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _firstCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(fcX, fcY, fcW, fcH) collectionViewLayout:layout];
    
    _firstCollection.dataSource = self;
    _firstCollection.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"LogFirstCell" bundle:nil];
    [_firstCollection registerNib:nib forCellWithReuseIdentifier:IDENTIFIER];
    UINib *nib2 = [UINib nibWithNibName:@"LogFirstCell2" bundle:nil];
    [_firstCollection registerNib:nib2 forCellWithReuseIdentifier:IDENTIFIER2];
    
    [_firstCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [_firstCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    _firstCollection.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_firstCollection];
    
    
    
}
-(void)clickReceiveBtn {
    CGRect originFrame;
    if ([logDay integerValue] == 7) {
        originFrame = [self  convertRect:sevendayimageview.frame fromView:sevendayimageview];
        originFrame.origin.x = originFrame.origin.x-originFrame.size.width;
        
    }else {
        originFrame = [self  convertRect:selectCell.imageIV.frame fromView:selectCell];
    }
    CGFloat x = originFrame.origin.x;
    CGFloat y = originFrame.origin.y;
    CGFloat w = originFrame.size.width;
    CGFloat h = originFrame.size.height;
    
    NSDictionary *dic = @{
                          @"x":@(x),
                          @"y":@(y),
                          @"w":@(w),
                          @"h":@(h),
                          @"image":[logDay intValue]<7?selectCell.imageIV.image:sevendayimageview.image
                          };
    
    if ([_delegate respondsToSelector:@selector(removeView:)]) {
        [_delegate removeView:dic];
    }

}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arrays.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    
    if (indexPath.row  == 6) {
        LogFirstCell2 *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER2 forIndexPath:indexPath];
        
        cell2.bgIV.image = [UIImage imageNamed:@"777"];
        cell2.titleL.text = YZMsg(@"第七天");
        cell2.titleL.textColor = [UIColor whiteColor];
        if ([logDay intValue] == 7) {
            cell2.bgIV.image = [UIImage imageNamed:@"777sel"];
            cell2.imageIV.image = [UIImage imageNamed:@"star4"];
            //cell2.bgIV2.image = [UIImage imageNamed:@"sel"];
            selectCell2 = cell2;
        }
        
        sevendayimageview = cell2.imageIV;
        cell = cell2;
        
    } else {
        
        LogFirstCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER forIndexPath:indexPath];
        
        cell1.backgroundColor = [UIColor brownColor];
        //cell.bgIV.image = [UIImage imageNamed:@"bgi"];
        cell1.bgIV.backgroundColor = [UIColor colorWithRed:107/255.0 green:112/255.0 blue:207/255.0 alpha:1];
        cell1.imageIV.image = [UIImage imageNamed:@"star3"];
        cell1.layer.cornerRadius = 3;
        cell1.layer.masksToBounds = YES;
        NSDictionary *subdic = _arrays[indexPath.row];
        int day = [minstr([subdic valueForKey:@"day"]) intValue];
        if (day == 1) {
            cell1.titleL.text = YZMsg(@"第一天");
        }else if (day == 2) {
            cell1.titleL.text = YZMsg(@"第二天");
        }else if (day == 3) {
            cell1.titleL.text = YZMsg(@"第三天");
        }else if (day == 4) {
            cell1.titleL.text = YZMsg(@"第四天");
        }else if (day == 5) {
            cell1.titleL.text = YZMsg(@"第五天");
        }else if (day == 6) {
            cell1.titleL.text = YZMsg(@"第六天");
        }else if (day == 7) {
            cell1.titleL.text = YZMsg(@"第七天");
        }
        cell1.titleL.textColor = [UIColor whiteColor];
        cell1.numL.text = [subdic valueForKey:@"coin"];
        cell1.numL.textColor = [UIColor whiteColor];
        cell1.numL.font = [UIFont systemFontOfSize:15.0];
        
        if (indexPath.item < [logDay integerValue]-1) {
            cell1.imageIV.image = [UIImage imageNamed:getImagename(@"icon_login_reward_get")];
            cell1.bgIV.backgroundColor = [UIColor lightGrayColor];
        }
        //判断第几天
        if (indexPath.item == [logDay integerValue]-1) {
            //动画
            cell1.bgIV2.image = [UIImage imageNamed:@"sel"];
            selectCell = cell1;
            if (nil == _link) {
                // 实例化计时器
                _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(keepRatate)];
                // 添加到当前运行循环中
                [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            } else {
                // 如果不为空，就关闭暂停
                _link.paused = NO;
            }
        }
        cell = cell1;
    }
    return cell;
}

- (void)keepRatate {
    if ([logDay integerValue] == 7) {
        selectCell2.bgIV2.transform = CGAffineTransformRotate(selectCell2.bgIV2.transform, M_PI_4 * 0.02);
    }else {
        selectCell.bgIV2.transform = CGAffineTransformRotate(selectCell.bgIV2.transform, M_PI_4 * 0.02);
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 6) {
        
        CGFloat W = (self.frame.size.width - 10);
        CGFloat H = (self.frame.size.height - 80)/3;
        return CGSizeMake(W, H);
    }else {
        CGFloat W = (self.frame.size.width - 21)/3;
        CGFloat H = (self.frame.size.height - 80)/3;
        return CGSizeMake(W, H);
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(self.frame.size.width*0.8, 25);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(self.frame.size.width*0.8, 35);
}
-(UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        view.backgroundColor = [UIColor colorWithRed:255/255.0 green:199/255.0 blue:18/255.0 alpha:1];
        UILabel *title = [[UILabel alloc]initWithFrame:view.frame];
        title.text = @"欢迎回来！";
        title.textColor = [UIColor whiteColor];
        title.textAlignment = NSTextAlignmentCenter;
        [view addSubview:title];
        
    }else{
        
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        //view.backgroundColor =[UIColor grayColor];
        UIButton *receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnW = self.frame.size.width/4;
        CGFloat btnH = view.size.height-5;
        CGFloat btnX = self.frame.size.width*3/8;
        CGFloat btnY = 0;
        receiveBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        receiveBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:190/255.0 blue:18/255.0 alpha:1];
        [receiveBtn addTarget:self action:@selector(clickReceiveBtn) forControlEvents:UIControlEventTouchUpInside];
        [receiveBtn setTitle:YZMsg(@"领取") forState:UIControlStateNormal];
        receiveBtn.titleLabel.textColor = [UIColor whiteColor];
        receiveBtn.layer.cornerRadius = 5;
        receiveBtn.layer.masksToBounds = YES;
        [view addSubview:receiveBtn];
        
    }
    return view;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%zi",indexPath.item);
}
/******************  <- 登录奖励  ********************/




@end
