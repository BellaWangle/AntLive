#import "common.h"
NSString *const  share_title = @"share_title";
NSString *const  share_des = @"share_des";
NSString *const  wx_siteurl = @"wx_siteurl";
NSString *const  ipa_ver = @"ipa_ver";
NSString *const  app_ios = @"app_ios";
NSString *const  ios_shelves = @"ios_shelves";
NSString *const  name_coin = @"name_coin";
NSString *const  name_votes = @"name_votes";
NSString *const  enter_tip_level = @"enter_tip_level";

NSString *const  maintain_switch = @"maintain_switch";
NSString *const  maintain_tips = @"maintain_tips";
NSString *const  live_cha_switch = @"live_cha_switch";
NSString *const  live_pri_switch = @"live_pri_switch";
NSString *const  live_time_coin = @"live_time_coin";
NSString *const  live_time_switch = @"live_time_switch";
NSString *const  live_type = @"live_type";
NSString *const  share_type = @"share_type";
NSString *const  video_share_title = @"video_share_title";
NSString *const  video_share_des = @"video_share_des";


NSString *const  agorakitid = @"agorakitid";

NSString *const  personc = @"personc";

@implementation common
+ (void)saveProfile:(liveCommon *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:user.share_title forKey:share_title];
    [userDefaults setObject:user.share_des forKey:share_des];
    [userDefaults setObject:user.wx_siteurl forKey:wx_siteurl];
    [userDefaults setObject:user.ipa_ver forKey:ipa_ver];
    [userDefaults setObject:user.app_ios forKey:app_ios];
    [userDefaults setObject:user.ios_shelves forKey:ios_shelves];
    [userDefaults setObject:user.name_coin forKey:name_coin];
    [userDefaults setObject:user.name_votes forKey:name_votes];
    [userDefaults setObject:user.enter_tip_level forKey:enter_tip_level];
    
    [userDefaults setObject:user.maintain_switch forKey:maintain_switch];
    [userDefaults setObject:user.maintain_tips forKey:maintain_tips];
    [userDefaults setObject:user.live_cha_switch forKey:live_cha_switch];
    [userDefaults setObject:user.live_pri_switch forKey:live_pri_switch];
    [userDefaults setObject:user.live_time_coin forKey:live_time_coin];
    [userDefaults setObject:user.live_time_switch forKey:live_time_switch];
    [userDefaults setObject:user.live_type forKey:live_type];
    [userDefaults setObject:user.share_type forKey:share_type];
    [userDefaults setObject:user.video_share_title forKey:video_share_title];
    [userDefaults setObject:user.video_share_des forKey:video_share_des];

    [userDefaults synchronize];
}
+ (void)clearProfile{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:share_title];
    [userDefaults setObject:nil forKey:share_des];
    [userDefaults setObject:nil forKey:wx_siteurl];
    [userDefaults setObject:nil forKey:ipa_ver];
    [userDefaults setObject:nil forKey:app_ios];
    [userDefaults setObject:nil forKey:ios_shelves];
    [userDefaults setObject:nil forKey:name_coin];
    [userDefaults setObject:nil forKey:name_votes];
    [userDefaults setObject:nil forKey:enter_tip_level];
    
    [userDefaults setObject:nil forKey:maintain_tips];
    [userDefaults setObject:nil forKey:maintain_switch];
    [userDefaults setObject:nil forKey:live_pri_switch];
    [userDefaults setObject:nil forKey:live_cha_switch];
    [userDefaults setObject:nil forKey:live_time_coin];
    [userDefaults setObject:nil forKey:live_time_switch];
    [userDefaults setObject:nil forKey:live_type];
    [userDefaults setObject:nil forKey:share_type];
    [userDefaults setObject:nil forKey:video_share_title];
    [userDefaults setObject:nil forKey:video_share_des];

    [userDefaults synchronize];
}
+ (liveCommon *)myProfile{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    liveCommon *user = [[liveCommon alloc] init];
    user.live_time_coin = [userDefaults objectForKey:live_time_coin];
    user.live_time_switch = [userDefaults objectForKey:live_time_switch];
    
    user.share_title = [userDefaults objectForKey:share_title];
    user.share_des = [userDefaults objectForKey:share_des];
    user.wx_siteurl = [userDefaults objectForKey:wx_siteurl];
    user.ipa_ver = [userDefaults objectForKey:ipa_ver];
    user.app_ios = [userDefaults objectForKey:app_ios];
    user.ios_shelves = [userDefaults objectForKey:ios_shelves];
    user.name_coin = [userDefaults objectForKey:name_coin];
    user.name_votes = [userDefaults objectForKey:name_votes];
    user.enter_tip_level = [userDefaults objectForKey:enter_tip_level];
    
    user.maintain_switch = [userDefaults objectForKey:maintain_switch];
    user.maintain_tips = [userDefaults objectForKey:maintain_tips];
    user.live_cha_switch = [userDefaults objectForKey:live_cha_switch];
    user.live_pri_switch = [userDefaults objectForKey:live_pri_switch];
    user.live_type = [userDefaults objectForKey:live_type];
    user.share_type = [userDefaults objectForKey:share_type];
    user.video_share_title = [userDefaults objectForKey:video_share_title];
    user.video_share_des = [userDefaults objectForKey:video_share_des];

    return user;
}
+(NSString *)name_coin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* name_coinss = [userDefaults objectForKey: name_coin];
    return name_coinss;
}
+(NSString *)name_votes{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* name_votesss = [userDefaults objectForKey: name_votes];
    return name_votesss;
}
+(NSString *)enter_tip_level{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* enter_tip_levelss = [userDefaults objectForKey: enter_tip_level];
    return enter_tip_levelss;
}
+(NSString *)share_title{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* share_titles = [userDefaults objectForKey: share_title];
    return share_titles;
}
+(NSString *)share_des{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* share_dess = [userDefaults objectForKey: share_des];
    return share_dess;
}
+(NSString *)wx_siteurl{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* wx_siteurls = [userDefaults objectForKey: wx_siteurl];
    return wx_siteurls;
}
+(NSString *)ipa_ver{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* ipa_vers = [userDefaults objectForKey: ipa_ver];
    return ipa_vers;
}
+(NSString *)app_ios{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* app_ioss = [userDefaults objectForKey: app_ios];
    return app_ioss;
}
+(NSString *)ios_shelves{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* ios_shelvess = [userDefaults objectForKey: ios_shelves];
    return ios_shelvess;
}

+(NSString *)maintain_tips {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *maintain_tipss = [userDefaults objectForKey: maintain_tips];
    
    return maintain_tipss;
}
+(NSString *)maintain_switch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *maintain_switchs = [userDefaults objectForKey:maintain_switch];
    
    return maintain_switchs;
}
+(NSString *)live_pri_switch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *live_pri_switchs = [userDefaults objectForKey:live_pri_switch];
    return live_pri_switchs;
}
+(NSString *)live_cha_switch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *live_cha_switchs = [userDefaults objectForKey:live_cha_switch];
    return live_cha_switchs;
}
+(NSString *)live_time_switch{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *live_time_switchs = [userDefaults objectForKey:live_time_switch];
    return live_time_switchs;
    
}
+(NSArray *)live_time_coin{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *live_cha_switchs = [userDefaults objectForKey:live_time_coin];
    return live_cha_switchs;
}
+(NSArray  *)live_type{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *livetypes = [userDefaults objectForKey:live_type];
    return livetypes;
    
}
+(NSArray  *)share_type{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *share_typess = [userDefaults objectForKey:share_type];
    return share_typess;
    
}



//保存声网
+(void)saveagorakitid:(NSString *)agorakitids{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:agorakitids forKey:agorakitid];
    [userDefaults synchronize];
}
+(NSString  *)agorakitid{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *agorakitidss = [userDefaults objectForKey:agorakitid];
    return agorakitidss;
    
}
//保存个人中心选项缓存
+(void)savepersoncontroller:(NSArray *)arrays{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:arrays forKey:personc];
    [userDefaults synchronize];
}
+(NSArray *)getpersonc{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *personcs = [userDefaults objectForKey:personc];
    return personcs;
    
}
+(NSString *)video_share_des{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init ];
    NSString* share_titles = [userDefaults objectForKey:video_share_des];
    return share_titles;
}
+(NSString *)video_share_title{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init ];
    NSString* share_titles = [userDefaults objectForKey:video_share_title];
    return share_titles;
}

@end
