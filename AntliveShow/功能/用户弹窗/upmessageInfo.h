
#import <UIKit/UIKit.h>
@protocol upmessageKickAndShutUp <NSObject>
-(void)socketShutUp:(NSString *)name andID:(NSString *)ID;
-(void)socketkickuser:(NSString *)name andID:(NSString *)ID;
-(void)pushZhuYe:(NSString *)IDS;
-(void)doUpMessageGuanZhu;
-(void)siXin:(NSString *)icon andName:(NSString *)name andID:(NSString *)ID;
-(void)doupCancle;
-(void)setAdminSuccess:(NSString *)isadmin;
-(void)adminList;
-(void)superAdmin:(NSString *)state;
@end

@interface upmessageInfo : UIView

@property(nonatomic,assign)id<upmessageKickAndShutUp>upmessageDelegate;
@property(nonatomic,strong)UIButton *zhezhao; //弹窗遮罩
@property(nonatomic,strong)NSArray *guanliArrays;
@property(nonatomic,strong)UIButton *jubaoBTNnew;
@property(nonatomic,strong)UIButton *guanliBTN;
@property(nonatomic,copy)NSString *userID;
@property(nonatomic,copy)NSString *playstate;

//左上角button
@property (nonatomic, strong) UIButton *systemBtn;
//右上角关闭Button
@property (nonatomic, strong) UIButton *closeBtn;
//头像image
@property (nonatomic, strong) UIImageView *iconImageView;

/**
 装饰
 */
@property (nonatomic, strong) UIImageView *iconBackView;
//名字label
@property (nonatomic, strong) UILabel *nameLabel;
//性别icon
@property (nonatomic, strong) UIImageView *sexIcon;
//levelView
@property (nonatomic, strong) UIImageView *levelView;

@property (nonatomic, strong) UIImageView *levelhostview;
//IDLabel
@property (nonatomic, strong) UILabel *IDLabel;
//地图icon
@property (nonatomic, strong) UIImageView *mapIcon;
//城市label
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UIImageView *lineView1;
//关注Label
@property (nonatomic, strong) UILabel *forceLabel;
//粉丝Label
@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UIImageView *lineView2;
//送出Label
@property (nonatomic, strong) UILabel *payLabel;
//收入Label
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UIImageView *lineView3;
//关注Btn
@property (nonatomic, strong) UIButton *forceBtn;
//私信Btn
@property (nonatomic, strong) UIButton *messageBtn;
//主页Btn
@property (nonatomic, strong) UIButton *homeBtn;

@property (nonatomic, copy) NSString *seleIcon;
@property (nonatomic, copy) NSString *seleID;
@property (nonatomic, copy) NSString *selename;


-(instancetype)initWithFrame:(CGRect)frame andPlayer:(NSString *)playerstate;

@property(nonatomic,strong)NSDictionary *zhuboDic;
-(void)getUpmessgeinfo:(NSDictionary *)userDic andzhuboDic:(NSDictionary *)zhuboDic;

@end
