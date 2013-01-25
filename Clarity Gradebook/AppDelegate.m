//
//  AppDelegate.m
//  Clarity Gradebook
//
//  Created by tj on 12/22/12.
//  Copyright (c) 2012 Fire30. All rights reserved.
//

#import "AppDelegate.h"
#import "TFHpple.h"
#import "PeriodPickerValueParser.h"
#import "LoginController.h"
#import "GradeController.h"

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
        
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
    NSArray *theSchools = [[[self getSchools]allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    school.items = @[[[[NSArray alloc]initWithObjects:@" ", nil] arrayByAddingObjectsFromArray:theSchools]];
    school.bind = @"textValue:school";
    school.value = @" ";

    QBooleanElement *autologin = [[QBooleanElement alloc]init];
    autologin.title = @"Remember Login Info";
    autologin.bind = @"boolValue:autologin";

    QSection *subsubsection = [[QSection alloc] initWithTitle:@""];

    QButtonElement *loginbutton = [[QButtonElement alloc]init];
    loginbutton.title = @"Log In";
    loginbutton.controllerAction = @"onLogin:";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults arrayForKey:@"loginDetails"] != nil)
    {
        username.textValue = [defaults arrayForKey:@"loginDetails"][0];
        password.textValue = [defaults arrayForKey:@"loginDetails"][1];
        school.value = [defaults arrayForKey:@"loginDetails"][2];
        school.textValue = [defaults arrayForKey:@"loginDetails"][2];
        
        
    }

    

    [root addSection:subsection];
    [root addSection:subsubsection];
    [subsection addElement:username];
    [subsection addElement:password];
    [subsection addElement:school];
    [subsection addElement:autologin];
    [subsubsection addElement:loginbutton];

    UINavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
    return YES;
    
    /*
     UINavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:theRoot];
     AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
     delegate.window.rootViewController = navigation;
     [delegate.window makeKeyAndVisible];
     delegate.window.backgroundColor = [UIColor whiteColor];
     */
}


- (void) applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}


- (void) applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void) applicationWillEnterForeground:(UIApplication *)application
{
    
    
}
- (void) applicationDidBecomeActive:(UIApplication *)application
{

}


- (id) getSchools
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


- (void) applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
