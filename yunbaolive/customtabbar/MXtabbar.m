//
//  ZYPathButton.m
//  ZYPathButton
//
//  Created by tang dixi on 30/7/14.
//  Copyright (c) 2014 Tangdxi. All rights reserved.
//

#import "MXtabbar.h"
#import <sys/utsname.h>
@interface MXtabbar ()<ZYPathItemButtonDelegate>

#pragma mark - Private Property


@property (strong, nonatomic) UIImage *centerImage;
@property (strong, nonatomic) UIImage *centerHighlightedImage;

@property (assign, nonatomic) CGSize bloomSize;
@property (assign, nonatomic) CGSize foldedSize;

@property (assign, nonatomic) CGPoint folZYenter;
@property (assign, nonatomic) CGPoint bloomCenter;
@property (assign, nonatomic) CGPoint expanZYenter;
@property (assign, nonatomic) CGPoint pathCenterButtonBloomCenter;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *pathCenterButton;
@property (strong, nonatomic) NSMutableArray *itemButtons;

@property (assign, nonatomic) SystemSoundID foldSound;
@property (assign, nonatomic) SystemSoundID bloomSound;
@property (assign, nonatomic) SystemSoundID selectedSound;

@property (assign, nonatomic, getter = isBloom) BOOL bloom;

@end

@implementation MXtabbar

#pragma mark - Initialization


- (instancetype)initWithCenterImage:(UIImage *)centerImage
                   highlightedImage:(UIImage *)centerHighlightedImage {
    return [self initWithButtonFrame:CGRectZero
                         centerImage:centerImage
                    highlightedImage:centerHighlightedImage];
}
- (instancetype)initWithButtonFrame:(CGRect)centerButtonFrame
                        centerImage:(UIImage *)centerImage
                   highlightedImage:(UIImage *)centerHighlightedImage {
    if (self = [super init]) {
        // Configure center and high light center image
        //
        self.centerImage = centerImage;
        self.centerHighlightedImage = centerHighlightedImage;
        // Init button and image array
        //
        self.itemButtons = [[NSMutableArray alloc]init];
        // Configure views layout
        //
        if (centerButtonFrame.size.width == 0 && centerButtonFrame.size.height == 0) {
            [self configureViewsLayoutWithButtonSize:self.centerImage.size];
        }
        else {
            [self configureViewsLayoutWithButtonSize:centerButtonFrame.size];
            self.ZYButtonCenter = centerButtonFrame.origin;
        }
        // Configure the bloom direction
        //
        // _bloomDirection = kZYPathButtonBloomDirectionTop;
        // Configure sounds
        //
        _bloomSoundPath = [[NSBundle bundleForClass:[self class]]pathForResource:@"bloom" ofType:@"caf"];
        _foldSoundPath = [[NSBundle bundleForClass:[self class]]pathForResource:@"fold" ofType:@"caf"];
        _itemSoundPath = [[NSBundle bundleForClass:[self class]]pathForResource:@"selected" ofType:@"caf"];
        _allowSounds = YES;
        _bottomViewColor = [UIColor blackColor];
        _allowSubItemRotation = YES;
        _basicDuration = 0.3f;
    }
    return self;
}
- (void)configureViewsLayoutWithButtonSize:(CGSize)centerButtonSize {
    // Init some property only once
    self.foldedSize = centerButtonSize;
    self.bloomSize = [UIScreen mainScreen].bounds.size;
    self.bloom = NO;
    self.bloomRadius = 105.0f;
    self.bloomAngel = 120.0f;
    // Configure the view's center, it will change after the frame folded or bloomed
    //
    if ([[self iphoneType] isEqualToString:@"iPhone X"]) {
        
        self.folZYenter = CGPointMake(self.bloomSize.width / 2, self.bloomSize.height - 25.5f-34);
    }else{
        self.folZYenter = CGPointMake(self.bloomSize.width / 2, self.bloomSize.height - 25.5f);
    }
    self.bloomCenter = CGPointMake(self.bloomSize.width / 2, self.bloomSize.height / 2);
    // Configure the ZYPathButton's origin frame
    //
    self.frame = CGRectMake(0,0,self.foldedSize.width / 2, self.foldedSize.height / 2);//1.5
    // Default set the folZYenter as the ZYPathButton's center
    //
    self.center = self.folZYenter;
    // Configure center button
    //设置中间按钮
    _pathCenterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
    [_pathCenterButton setImage:self.centerImage forState:UIControlStateNormal];
    [_pathCenterButton addTarget:self action:@selector(centerButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    _pathCenterButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 10);
    
    [self addSubview:_pathCenterButton];
}
#pragma mark - Configure Bottom View Color
#pragma mark - Center Button Delegate
//点击中间按钮
- (void)centerButtonTapped {
    [self.delegate pathButton:_pathCenterButton clickItemButtonAtIndex:0];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0) {
    return YES;
}
- (NSString*)iphoneType {
    
    //需要导入头文件：#import <sys/utsname.h>
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])  return@"iPhone X";//return@"iPhone Simulator"; iPhone X
    
    return platform;
    
}


@end

