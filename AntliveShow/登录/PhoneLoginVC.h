#import <UIKit/UIKit.h>
@interface PhoneLoginVC : UIViewController
@property (nonatomic,assign) BOOL isEmail;
@property (weak, nonatomic) IBOutlet UITextField *phoneT;
@property (weak, nonatomic) IBOutlet UITextField *passWordT;
@property (weak, nonatomic) IBOutlet UIButton *doLoginBtn;

- (IBAction)mobileLogin:(id)sender;
- (IBAction)regist:(id)sender;
- (IBAction)forgetPass:(id)sender;
- (IBAction)clickBackBtn:(UIButton *)sender;


@end
