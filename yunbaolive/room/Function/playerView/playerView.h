#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "GrounderSuperView.h"
@protocol frontviewDelegate <NSObject>
-(void)zhezhaoBTNdelegate;
-(void)gongxianbang;//跳贡献榜
-(void)zhubomessage;//点击主播弹窗
-(void)guanzhuZhuBo;//关注zhubo
@end
@interface playerView : UIView
{
    UILabel *labell;
}

@property(nonatomic,assign)CGSize yingpiaoSize;
@property(nonatomic,assign)id<frontviewDelegate>frontviewDelegate;
@property(nonatomic,strong)UIButton *newattention;
@property(nonatomic,strong)UIButton *ZheZhaoBTN;//遮罩层
@property(nonatomic,strong)UIImageView *bigAvatarImageView;//背景图片
@property(nonatomic,strong)UIView *leftView;//左上角信息
@property(nonatomic,strong)UIButton *IconBTN;//左上角主播头像
@property(nonatomic,strong)UILabel *onlineLabel;//在线人数
@property(nonatomic,strong)UILabel *roomID;//房间ID
@property(nonatomic,assign)CGSize roomsize;
@property(nonatomic,strong)UILabel *yingpiaoLabel;//房间影票
@property(nonatomic,strong)UIView *imagebackImage;//映票
@property(nonatomic,strong)UIImageView *imageVh;//映票小箭
@property(nonatomic,strong)UIImageView *levelimage;//主播等级

-(instancetype)initWithDic:(NSDictionary *)playDic;
@property(nonatomic,strong)NSDictionary *zhuboDic;
-(void)changeState:(NSString *)texts andID:(NSString *)ID;//改变映票适应坐标
@end
