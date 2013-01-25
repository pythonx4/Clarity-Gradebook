
#import "LoginController.h"
#import "GradeController.h"
#import "AboutController.h"
#import "AppDelegate.h"

@interface LoginController ()
- (void) onLogin:(QButtonElement *)buttonElement;
- (void) onAbout;

@end

@implementation LoginController

LoginProcessor *myProcessor;

- (void) setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView
{
    [super setQuickDialogTableView:aQuickDialogTableView];

    self.quickDialogTableView.backgroundView = nil;
    //self.quickDialogTableView.backgroundColor = [UIColor colorWithHue:0.1174 saturation:0.7131 brightness:0.8618 alpha:1.0000];
    self.quickDialogTableView.bounces = NO;
    self.quickDialogTableView.styleProvider = self;

    ( (QEntryElement *)[self.root elementWithKey:@"login"] ).delegate = self;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Sself.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.view.backgroundColor = [AboutController groupTableViewBackgroundColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(onAbout)];
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = nil;
}

+ (LoginProcessor *)getdeProccesor
{
    return myProcessor;
}


- (void) loginCompleted:(LoginProcessor *)processor
{
    [self performSelectorInBackground:@selector(loading:) withObject:self];
    [self.root fetchValueUsingBindingsIntoObject:processor];
    NSString *schoolName = processor.school;
    if([[[self class] getSchools] objectForKey:processor.school] != nil)
        processor.school = [[[self class] getSchools] objectForKey:processor.school];
    if ([processor login])
    {
        [processor getGradeData:processor.responseString];
        myProcessor = processor;
        
        if(processor.autologin)
        {
            NSUserDefaults *autologin = [NSUserDefaults standardUserDefaults];
            [autologin setObject:@[processor.username,processor.password,schoolName] forKey:@"loginDetails"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"loginDetails"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        QRootElement *root = [GradeController createGradeControllerWithHTML:processor];
		UINavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];
		AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
		
		delegate.window.rootViewController.view.hidden = YES;
		[delegate.window makeKeyAndVisible];
		delegate.window.backgroundColor = [UIColor whiteColor];
		[delegate.window setOpaque:YES];
			//delegate.window.rootViewController = navigation;
		[UIView transitionWithView:delegate.window duration:.3 options:(UIViewAnimationOptionCurveEaseIn  | UIViewAnimationOptionAllowAnimatedContent) animations:^{
			delegate.window.rootViewController = navigation;
		} completion:nil];
		
		[self loading:NO];
		[self dismissModalViewControllerAnimated:YES];
	}
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                                        message:@"Login Information Was Incorrect"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    }
    [self loading:NO];
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


+ (id) getSchools
{
    NSString *googleString = @"https://loudoun.gradebook.net/Pinnacle/Mobile/Logon.aspx";
    NSURL *googleURL = [NSURL URLWithString:googleString];
    NSMutableDictionary *returnValues = [[NSMutableDictionary alloc]init];
    NSError *error;
    int x = 2;
    NSString *googlePage = [NSString stringWithContentsOfURL:googleURL
                                                    encoding:NSASCIIStringEncoding
                                                       error:&error];
    TFHpple *xpath = [[TFHpple alloc] initWithHTMLData:[googlePage dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *schoolElements = [xpath searchWithXPathQuery:@"//*[@id='School']//option[1]"];

    while ([schoolElements lastObject] != nil )
    {
        [returnValues setObject:[[schoolElements objectAtIndex:0] objectForKey:@"value"] forKey:[[[schoolElements objectAtIndex:0] firstChild] content]];
        NSString *path = [NSString stringWithFormat:@"//*[@id='School']//option[%i]",x];
        schoolElements = [xpath searchWithXPathQuery:path];
        x++;
    }

    return returnValues;
}


- (void) onLogin:(QButtonElement *)buttonElement
{
    LoginProcessor* processor = [[LoginProcessor alloc]init];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    //[self loading:YES];
    [self performSelector:@selector(loginCompleted:) withObject:processor afterDelay:0];
}


- (void) onAbout
{
    QRootElement *details = [LoginController createDetailsForm];
    [self displayViewControllerForRoot:details];
}


- (void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{
    //cell.backgroundColor = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];

    if ([element isKindOfClass:[QEntryElement class]] || [element isKindOfClass:[QButtonElement class]])
    {
        //cell.textLabel.textColor = [UIColor colorWithRed:0.6033 green:0.2323 blue:0.0000 alpha:1.0000];
    }
}


+ (QRootElement *) createDetailsForm
{
    QRootElement *details = [[QRootElement alloc] init];
    details.presentationMode = QPresentationModeModalForm;
    details.title = @"About";
    details.grouped = YES;
    QSection *section = [[QSection alloc] initWithTitle:@""];
    section.footer = @"App made by T.J. Corley. \n\n Open Source Librares Used: \n-QuickDialog\n-HPPLE\n-ASIHTTP\n\n Source available at: https://github.com/Fire30/";
    [details addSection:section];
    return details;
}


- (BOOL) QEntryShouldChangeCharactersInRangeForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell
{
    NSLog(@"Should change characters");
    return YES;
}


- (void) QEntryEditingChangedForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell
{
    NSLog(@"Editing changed");
}


- (void) QEntryMustReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell
{
    NSLog(@"Must return");
}


@end
