
#import "LoginController.h"
#import "LoginProcessor.h"
#import "GradeController.h"
// Subclassing from LoginController in order to inherit the quickDialogTableview style settings.
@interface AboutController : GradeController {
  
}

+ (void) setProcessor:(LoginProcessor *)processor;
+ (void) setRoot:(QRootElement *)root;
+ (UIColor *)groupTableViewBackgroundColor;


@end
