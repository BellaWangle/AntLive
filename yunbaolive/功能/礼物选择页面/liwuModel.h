
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




@interface liwuModel : NSObject



@property(nonatomic,assign)int duihaiOK;


@property(nonatomic,copy)NSString *imagePath;

@property(nonatomic,copy)NSString *price;

@property(nonatomic,copy)NSString *num;

@property(nonatomic,copy)NSString *type;

@property(nonatomic,copy)NSString *giftname;

@property(nonatomic,copy)NSString *ID;


@property(nonatomic,copy)NSString *giftid;

@property(nonatomic,copy)NSString *giftnum;



@property(nonatomic,assign)CGRect imageVR;

@property(nonatomic,assign)CGRect numR;

@property(nonatomic,assign)CGRect priceR;

@property(nonatomic,assign)CGRect countR;

-(instancetype)initWithDic:(NSDictionary *)dic;

+(instancetype)modelWithDic:(NSDictionary *)dic;


@end
