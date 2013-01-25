
#import "LoginInfo.h"
#import "LoginProcessor.h"
#import "TFHpple.h"
#import "QuickDialogController+Navigation.h"

@interface LoginController : QuickDialogController <QuickDialogStyleProvider, QuickDialogEntryElementDelegate> {
}

+ (QRootElement *) createDetailsForm;
+ (id) getSchools;
+ (id) getdeProccesor;
-(void) loginCompleted:(LoginProcessor *)processor;

@property(strong) LoginInfo *info;

@end
