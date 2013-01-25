
#import "LoginController.h"
#import "AboutController.h"
#import "AppDelegate.h"


@implementation AboutController
{
    LoginProcessor *processor;
}

LoginProcessor *theProcessor;
QRootElement *theRoot;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    self.quickDialogTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor = [[self class] groupTableViewBackgroundColor];
}

-(void)refreshData:(QButtonElement *)buttonElement
{
	[self performSelectorInBackground:@selector(loading:) withObject:self];
	[theProcessor login];
	[theProcessor getGradeData:theProcessor.responseString];
	[self performSelectorInBackground:@selector(loading:) withObject:nil];
	
}


- (void)close {
	self.processor = theProcessor;
    int amountOfPeriods = [self.processor.gradeData[0][1] count];
    [self.root fetchValueUsingBindingsIntoObject:self.processor];
    if(self.processor.periodString == nil)
    {
        
    }
    else if(amountOfPeriods == 6)
    {
        NSArray *sixPeriods = [[NSArray alloc]initWithObjects:@" ",@"First Quarter",@"Second Quarter",@"Semester Exams",@"Third Quarter",@"Fourth Quarter",@"Final Exams", nil];
        if([sixPeriods indexOfObject:self.processor.periodString] != 0)
        {
            self.processor.quarter = [sixPeriods indexOfObject:self.processor.periodString] - 1;
        }
        
    }
    else if (amountOfPeriods == 9)
    {
        NSArray *ninePeriods = [[NSArray alloc]initWithObjects:@" ",@"First Quarter",@"Second Quarter",@"Semester Exams",@"Semester Grades",@"Third Quarter",@"Fourth Quarter",@"Final Exams",@"Second Semester Grades",@"Final Grades", nil];
        
        if([ninePeriods indexOfObject:self.processor.periodString] != 0)
        {
            self.processor.quarter = [ninePeriods indexOfObject:self.processor.periodString] - 1;
        }
    }
    else if (amountOfPeriods == 4)
    {
        NSArray *fourPeriods = [[NSArray alloc]initWithObjects:@" ",@"First Quarter",@"Second Quarter",@"Third Quarter",@"Fourth Quarter", nil];
        
        if([fourPeriods indexOfObject:self.processor.periodString] != 0)
        {
            self.processor.quarter = [fourPeriods indexOfObject:self.processor.periodString] - 1;
        }
    }
    NSLog(@"STRINGPERIOD = %@ /n GRADING PERIOD= %d /n AMOUNT OF PERIODS = %d",self.processor.periodString,self.processor.quarter,amountOfPeriods);
		//[self.processor getGradeData];
    theRoot = [self.superclass createGradeControllerWithHTML:self.processor];
    self.root = theRoot;
    
		//Not proud of this. You can tell I don't really understand delagates and stuff that much...
    UINavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:theRoot];
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController.view.hidden = YES;
    [delegate.window makeKeyAndVisible];
    delegate.window.backgroundColor = [UIColor whiteColor];
    [delegate.window setOpaque:YES];
		//delegate.window.rootViewController = navigation;
    [UIView transitionWithView:delegate.window duration:0.3 options:(UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionAllowAnimatedContent) animations:^{
        delegate.window.rootViewController = navigation;
    } completion:nil];
    [self loading:NO];
    [self dismissModalViewControllerAnimated:YES];
}


- (void)setQuickDialogTableView:(QuickDialogTableView *)quickDialogTableView
{
    [super setQuickDialogTableView:quickDialogTableView];
    self.quickDialogTableView.backgroundView = nil;
    [self.quickDialogTableView setBackgroundColor:[UIColor redColor]];
    self.quickDialogTableView.styleProvider = self;
    NSLog(@"LOLOLOLOL");
}

- (void) displayViewControllerForRoot:(QRootElement *)element
{
    QuickDialogController *newController = [QuickDialogController controllerForRoot:element];
    if (self.splitViewController != nil)
    {
        UINavigationController *navController = [self.splitViewController.viewControllers objectAtIndex:1];
        
        for (QSection *section in self.root.sections)
        {
            for (QElement *current in section.elements)
            {
                if (current == element)
                {
                    self.splitViewController.viewControllers = @[[self.splitViewController.viewControllers objectAtIndex:0], [[UINavigationController alloc] initWithRootViewController:newController]];
                    return;
                }
            }
        }
        
        [navController pushViewController:newController animated:YES];
    }
    else
    {
        [super displayViewController:newController];
    }
}

+(void)setProcessor:(LoginProcessor *)processor
{
    theProcessor = processor;
}

+(void)setRoot:(QRootElement *)root
{
    theRoot = root;
}

+ (UIColor *)groupTableViewBackgroundColor
{
    __strong static UIImage* tableViewBackgroundImage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(7.f, 1.f), NO, 0.0);
        CGContextRef c = UIGraphicsGetCurrentContext();
        [[UIColor colorWithRed:185/255.f green:192/255.f blue:202/255.f alpha:1.f] setFill];
        CGContextFillRect(c, CGRectMake(0, 0, 4, 1));
        [[UIColor  colorWithRed:185/255.f green:193/255.f blue:200/255.f alpha:1.f] setFill];
        CGContextFillRect(c, CGRectMake(4, 0, 1, 1));
        [[UIColor  colorWithRed:192/255.f green:200/255.f blue:207/255.f alpha:1.f] setFill];
        CGContextFillRect(c, CGRectMake(5, 0, 2, 1));
        tableViewBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    return [UIColor  colorWithPatternImage:tableViewBackgroundImage];
}

-(void)logout:(QButtonElement *)buttonElement
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"loginDetails"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"Clarity Login";
    root.grouped = YES;
    root.controllerName = @"LoginController";
    
    QSection *subsection = [[QSection alloc] initWithTitle:@"Login Form"];
    subsection.headerImage = @"logo1.png";
    
    QEntryElement *username = [[QEntryElement alloc] init];
    username.title = @"Username";
    username.placeholder = @"Student ID";
    username.bind = @"textValue:login";
    
    QEntryElement *password = [[QEntryElement alloc] init];
    password.title = @"Password";
    password.placeholder = @"Password";
    password.secureTextEntry = TRUE;
    password.bind = @"textValue:password";
    
    QPickerElement *school = [[QPickerElement alloc] init];
    school.title = @"School";
    NSArray *theSchools = [[[LoginController getSchools]allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    school.items = @[[[[NSArray alloc]initWithObjects:@" ", nil] arrayByAddingObjectsFromArray:theSchools]];
    school.bind = @"textValue:school";
    school.value = @" ";
    
    QBooleanElement *autologin = [[QBooleanElement alloc]init];
    autologin.title = @"Automatically Log In";
    autologin.bind = @"boolValue:autologin";
    
    QSection *subsubsection = [[QSection alloc] initWithTitle:@""];
    
    QButtonElement *loginbutton = [[QButtonElement alloc]init];
    loginbutton.title = @"Log In";
    loginbutton.controllerAction = @"onLogin:";
    
    [root addSection:subsection];
    [root addSection:subsubsection];
    [subsection addElement:username];
    [subsection addElement:password];
    [subsection addElement:school];
    [subsection addElement:autologin];
    [subsubsection addElement:loginbutton];
    
    
    UINavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];

    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController.view.hidden = YES;
    [delegate.window makeKeyAndVisible];
    //delegate.window.backgroundColor = [UIColor whiteColor];
    [delegate.window setOpaque:YES];
    //delegate.window.rootViewController = navigation;
    [UIView transitionWithView:delegate.window duration:0.5 options:(UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionAllowAnimatedContent) animations:^{
        delegate.window.rootViewController = navigation;
    } completion:nil];
    
}
@end