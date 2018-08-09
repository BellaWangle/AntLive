
#import <UIKit/UIKit.h>
#import "JMListen.h"
@interface personMessage : JMListen

@property(nonatomic,strong)NSString *userID;

@property(nonatomic,strong)NSString *chatname;

@property(nonatomic,strong)NSString *icon;

@property (weak, nonatomic) IBOutlet UILabel *fensi2;

@property (weak, nonatomic) IBOutlet UILabel *guanzhu2;
@property (weak, nonatomic) IBOutlet UILabel *voteLabel;

@property(nonatomic,assign)int isLIve;//判断是否是从直播间过来的

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *buttomView;


@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *touxiangBTN;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UIImageView *sexIm;

@property (weak, nonatomic) IBOutlet UIImageView *levelIM;

@property (weak, nonatomic) IBOutlet UILabel *fensiL;

@property (weak, nonatomic) IBOutlet UILabel *guanzhuL;

@property (weak, nonatomic) IBOutlet UILabel *signnature;

@property (weak, nonatomic) IBOutlet UILabel *songchul;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

//主页的view
@property (weak, nonatomic) IBOutlet UIView *zhuyeView;

@property (weak, nonatomic) IBOutlet UIView *yingpiaoView;

@property (weak, nonatomic) IBOutlet UILabel *ageL;


@property (weak, nonatomic) IBOutlet UILabel *jobL;

@property (weak, nonatomic) IBOutlet UILabel *yingkeNumL;

@property (weak, nonatomic) IBOutlet UILabel *signatureL;





@property (weak, nonatomic) IBOutlet UIView *zhiboView;


@end
