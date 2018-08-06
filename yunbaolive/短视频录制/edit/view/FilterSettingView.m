//
//  FilterSettingView.m
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/11.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "FilterSettingView.h"

#import "V8HorizontalPickerView.h"
#import "UIView+Additions.h"
#import "ColorMacro.h"



typedef NS_ENUM(NSInteger,TCLVFilterType) {
    FilterType_None 		= 0,
    FilterType_white        ,   //美白滤镜
    FilterType_langman 		,   //浪漫滤镜
    FilterType_qingxin 		,   //清新滤镜
    FilterType_weimei 		,   //唯美滤镜
    FilterType_fennen 		,   //粉嫩滤镜
    FilterType_huaijiu 		,   //怀旧滤镜
    FilterType_landiao 		,   //蓝调滤镜
    FilterType_qingliang 	,   //清凉滤镜
    FilterType_rixi 		,   //日系滤镜
};

@interface FilterSettingView ()<V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>
{
    V8HorizontalPickerView *        _filterPickerView;
    NSMutableArray *                _filterArray;       //滤镜列表数据
    NSInteger                       _filterIndex;
    /*美颜功能，需要再打开*/
//    UIButton*     _beautyBtn;
//    UIView*       _beautyView;
//    UILabel*      _beautyLabel;
//    UISlider*     _beautySlider;
//    UILabel*      _whiteLabel;
//    UISlider*     _whiteSlider;
}


@end

@implementation FilterSettingView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _filterIndex = 0;
        _filterArray = [NSMutableArray new];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = YZMsg(@"原图");
            v.face = [UIImage imageNamed:getImagename(@"orginal")];
            v;
        })];
        
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = YZMsg(@"美白");
            v.face = [UIImage imageNamed:getImagename(@"fwhite")];
            v;
        })];
        
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = YZMsg(@"浪漫");
            v.face = [UIImage imageNamed:getImagename(@"langman")];
            v;
        })];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = YZMsg(@"清新");
            v.face = [UIImage imageNamed:getImagename(@"qingxin")];
            v;
        })];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = YZMsg(@"唯美");
            v.face = [UIImage imageNamed:getImagename(@"weimei")];
            v;
        })];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = YZMsg(@"粉嫩");
            v.face = [UIImage imageNamed:getImagename(@"fennen")];
            v;
        })];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = YZMsg(@"怀旧");
            v.face = [UIImage imageNamed:getImagename(@"huaijiu")];
            v;
        })];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = YZMsg(@"蓝调");
            v.face = [UIImage imageNamed:getImagename(@"landiao")];
            v;
        })];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = YZMsg(@"清凉");
            v.face = [UIImage imageNamed:getImagename(@"qingliang")];
            v;
        })];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = YZMsg(@"日系");
            v.face = [UIImage imageNamed:getImagename(@"rixi")];
            v;
        })];
        
        [self initUI];
    }
    
    return self;
}

- (void)initUI
{
    _filterPickerView = [[V8HorizontalPickerView alloc] init];
    _filterPickerView.textColor = [UIColor grayColor];
    _filterPickerView.elementFont = [UIFont fontWithName:@"" size:14];
    _filterPickerView.delegate = self;
    _filterPickerView.dataSource = self;
    _filterPickerView.selectedMaskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_selected"]];
    [self addSubview:_filterPickerView];
    
    
//    _beautyBtn = [UIButton new];
//    [_beautyBtn setImage:[UIImage imageNamed:@"beauty"] forState:UIControlStateNormal];
//    _beautyBtn.backgroundColor = UIColorFromRGB(0x777777);
//    
//    [_beautyBtn setTitle:@"美颜" forState:UIControlStateNormal];
//    _beautyBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [_beautyBtn setTitleColor:UIColor.darkTextColor forState:UIControlStateNormal];
//    _beautyBtn.imageEdgeInsets = UIEdgeInsetsMake(- (_beautyBtn.titleLabel.intrinsicContentSize.height + 5), 0, 0, -_beautyBtn.titleLabel.intrinsicContentSize.width);
//    _beautyBtn.titleEdgeInsets = UIEdgeInsetsMake(_beautyBtn.currentImage.size.height + 10, -_beautyBtn.currentImage.size.width, 0, 0);
//    [_beautyBtn addTarget:self action:@selector(onBeautyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_beautyBtn];
//    
//    _beautyView = [UIView new];
//    _beautyView.backgroundColor = UIColor.whiteColor;
//    _beautyView.hidden = YES;
//    
//    _whiteLabel = [UILabel new];
//    _whiteLabel.text = @"美白效果";
//    _whiteLabel.textAlignment = NSTextAlignmentCenter;
//    [_beautyView addSubview:_whiteLabel];
//    
//    _whiteSlider = [UISlider new];
//    _whiteSlider.minimumValue = 0.f;
//    _whiteSlider.maximumValue = 9.f;
//    _whiteSlider.tag = 1;
//    _whiteSlider.tintColor = UIColor.blackColor;
//    [_whiteSlider setThumbImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
//    [_whiteSlider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
//    [_beautyView addSubview:_whiteSlider];
//    
//    
//    _beautyLabel = [UILabel new];
//    _beautyLabel.text = @"美颜效果";
//    _beautyLabel.textColor = UIColor.darkTextColor;
//    _beautyLabel.textAlignment = NSTextAlignmentCenter;
//    [_beautyView addSubview:_beautyLabel];
//    
//    _beautySlider = [UISlider new];
//    _beautySlider.minimumValue = 0.f;
//    _beautySlider.maximumValue = 9.f;
//    _beautySlider.tag = 2;
//    _beautySlider.tintColor = UIColor.darkTextColor;
//    [_beautySlider setThumbImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
//    [_beautySlider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
//    [_beautyView addSubview:_beautySlider];
//    
//    [self addSubview:_beautyView];
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    _beautyBtn.frame = CGRectMake(5, _titleLabel.bottom + 50 * kScaleY, 82, 120);
    
    _filterPickerView.frame = CGRectMake( 5, 50 * kScaleY, self.width - 10, 120 * kScaleY);
    [_filterPickerView scrollToElement:_filterIndex animated:NO];
    
//    _beautyView.frame = _filterPickerView.frame;
//    _whiteLabel.frame = CGRectMake(0, 10, _beautyView.width, 20);
//    _whiteSlider.frame = CGRectMake(5, _whiteLabel.bottom, _beautyView.width - 10, 20);
//    _beautyLabel.frame = CGRectMake(0, _whiteSlider.bottom + 20 , _whiteLabel.width, 20);
//    _beautySlider.frame = CGRectMake(5, _beautyLabel.bottom, _whiteSlider.width, 20);
}


- (void)dealloc
{
    NSLog(@"FilterSettingView dealloc");
}

#pragma mark - HorizontalPickerView DataSource
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
    return [_filterArray count];
}

#pragma mark - HorizontalPickerView Delegate Methods
- (UIView *)horizontalPickerView:(V8HorizontalPickerView *)picker viewForElementAtIndex:(NSInteger)index {
    V8LabelNode *v = [_filterArray objectAtIndex:index];
    return [[UIImageView alloc] initWithImage:v.face];
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
    return 90;
}

//选中
- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index
{
    _filterIndex = index;
    [self setFilter:_filterIndex];
}

- (void)setFilter:(NSInteger)index
{
    NSString* lookupFileName = @"";
    
    switch (index) {
        case FilterType_None:
            break;
        case FilterType_white:
            lookupFileName = @"white.png";
            break;
        case FilterType_langman:
            lookupFileName = @"langman.png";
            break;
        case FilterType_qingxin:
            lookupFileName = @"qingxin.png";
            break;
        case FilterType_weimei:
            lookupFileName = @"weimei.png";
            break;
        case FilterType_fennen:
            lookupFileName = @"fennen.png";
            break;
        case FilterType_huaijiu:
            lookupFileName = @"huaijiu.png";
            break;
        case FilterType_landiao:
            lookupFileName = @"landiao.png";
            break;
        case FilterType_qingliang:
            lookupFileName = @"qingliang.png";
            break;
        case FilterType_rixi:
            lookupFileName = @"rixi.png";
            break;
        default:
            break;
    }
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"FilterResource" ofType:@"bundle"];
    
    UIImage* image;
    if (path != nil && index != FilterType_None) {
        path = [path stringByAppendingPathComponent:lookupFileName];
        image = [UIImage imageWithContentsOfFile:path];
        
    } else {
        image = nil;
    }
    
    [self.delegate onSetFilterWithImage:image];
}


#pragma mark - UI event handle
//- (void)onBeautyBtnClicked:(UIButton*)sender
//{
//    _beautyView.hidden = !_beautyView.hidden;
//}
//
//- (void)onSliderValueChanged:(UISlider*)slider
//{
//    [self.delegate onSetBeautyDepth:_beautySlider.value WhiteningDepth:_whiteSlider.value];
//}

@end
