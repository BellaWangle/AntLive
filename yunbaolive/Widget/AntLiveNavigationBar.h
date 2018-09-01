//
//  YxtNavigationBar.h
//  YiXueTang
//
//  Created by ylq on 2017/9/12.
//  Copyright © 2017年 artschool. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NAVIGATION_BAR_HEIGHT (64+iPhoneX_Top)

typedef NS_ENUM(NSInteger, navigationBarType){
    NavigationBarTypeWhite,
    NavigationBarTypeBlack,
    NavigationBarTypeGradual
};

@protocol AntLiveNavigationBarDelegate <NSObject>

@optional

-(void)backButtonOnClick;

@end

@interface AntLiveNavigationBar : UIView

@property (nonatomic, strong) UILabel * titleLabel;             //标题
@property (nonatomic, strong) UILabel * bottomline;              //topBanner底部横线
@property (nonatomic, strong) UIButton * backButton;            //左上角按钮
@property (nonatomic, strong) UIButton * rightButton;           //右上角按钮
@property (nonatomic, strong) UIImageView * backImageView;      //返回按钮图片
@property (nonatomic, strong) UIImageView * rightImageView;     //rightButton图片
@property (nonatomic, assign) navigationBarType type;           //type

@property (nonatomic, copy) BOOL(^backButtonClickBlock)();
@property (nonatomic, copy) void(^rightButtonClickBlock)();

@property (nonatomic, assign) id<AntLiveNavigationBarDelegate>delegate;
/**初始化title*/
-(instancetype)initWithTitle:(NSString *)title;
-(instancetype)initWithTitle:(NSString *)title type:(navigationBarType)type;
/**设置title*/
-(void)setTitle:(NSString *)title;
/**设置返回键名称*/
-(void)setBackBtnName:(NSString *)name;
/**设置右上角名称*/
-(void)setRightBtnName:(NSString *)name;
/**设置返回图片*/
-(void)setBackImageName:(NSString *)imageName;
/**设置右上角图片*/
-(void)setRightImageName:(NSString *)imageName;
/**加载中的title*/
-(void)showLoadingTitle:(NSString *)title;
/**结束加载*/
-(void)endLoading;
/**添加底部横线*/
-(void)addBottomLine;



@end
