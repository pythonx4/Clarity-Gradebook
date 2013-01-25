#import "GradeController.h"
#import "AboutController.h"

@interface GradeController ()

@end

@implementation GradeController

LoginProcessor *theProcessor;
QRootElement *theRoot;

+ (QRootElement *) createGradeControllerWithHTML:(LoginProcessor *)processor
{
	
    GradeController *grade = [[GradeController alloc]init];
    [grade loading:YES];
    theProcessor = processor;
    QSection *section = [[QSection alloc]init];
    QRootElement *root = [[QRootElement alloc]init];
    root.controllerName = @"GradeController";
    root.title = @"Grades";
	
	
    int count = 0;
    while (count < processor.gradeData.count)
    {
        QLabelElement *label = [[QLabelElement alloc]initWithTitle:processor.gradeData[count][0] Value:processor.gradeData[count][1][processor.quarter]];
		label.controllerAction = @"lol:";
		[section addElement:label];
        section.title = processor.periodString;
        count++;
    }

    [root addSection:section];
    theRoot = root;
    [grade loading:NO];
    return root;
}


- (void) lol:(QLabelElement *)label
{
	[self performSelectorInBackground:@selector(loading:) withObject:self];
	int count;
	self.processor = theProcessor;
    //[self.processor login];
    NSLog(@"%@",self.processor.AuthKey);
    
	NSLog(@"%@",theProcessor.gradeData);
    for(id array in self.processor.gradeData)
	{
		NSLog(@"%@",array);
		if (array[0]==label.title) {
			count = [self.processor.gradeData indexOfObject:array];
		}
	}
	
	NSLog(@"%d",count);
    [self.processor getClassData:[NSNumber numberWithInt:count]];
	
	QSection *newSection = [[QSection alloc]init];
	NSArray *individualGrades = [self.processor.classData objectForKey:[NSNumber numberWithInteger:count]];
	NSLog(@"%@",individualGrades);
	int amountOfAssignments = [individualGrades count];
	for(int i = 0; i < amountOfAssignments;i++)
	{
		
		NSString *gradeTitle = [[individualGrades[i]allKeys]lastObject];
		NSString *totalScore = [NSMutableString stringWithFormat:@"%d",[[individualGrades[i]valueForKey:gradeTitle][1]intValue]];
		NSString *gradeScore = [NSMutableString stringWithFormat:@"%@/%@(%@)",[individualGrades[i] valueForKey:gradeTitle][0],totalScore,[individualGrades[i] valueForKey:gradeTitle][2]];
		
		QLabelElement *newLabel = [[QLabelElement alloc]initWithTitle:gradeTitle Value:gradeScore];
		[newSection addElement:newLabel];
	}
	
    [[label sections]removeAllObjects];//makes it so it does not duplicat grades.
    [label addSection:newSection];	
	[self loading:NO];
	[self performSelectorInBackground:@selector(loading:) withObject:nil];
	
}



- (void) setQuickDialogTableView:(QuickDialogTableView *)aQuickDialogTableView
{
    [super setQuickDialogTableView:aQuickDialogTableView];

    self.quickDialogTableView.backgroundView = nil;
    self.quickDialogTableView.bounces = NO;
    self.quickDialogTableView.styleProvider = self;

    ( (QEntryElement *)[self.root elementWithKey:@"login"] ).delegate = self;
}



- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStylePlain target:self action:@selector(onAbout)];
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self removeFromParentViewController];
    self.navigationController.navigationBar.tintColor = nil;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //[self removeFromParentViewController];
}

- (void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{
    //cell.backgroundColor = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];

    if ([element isKindOfClass:[QEntryElement class]] || [element isKindOfClass:[QButtonElement class]])
    {
        //cell.textLabel.textColor = [UIColor colorWithRed:0.6033 green:0.2323 blue:0.0000 alpha:1.0000];
    }
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

- (void)onAbout {
    QRootElement *details = [[self class] createDetailsForm:theProcessor];
    [self dismissModalViewControllerAnimated:YES];
    [self displayViewControllerForRoot:details];
}


+ (QRootElement *)createDetailsForm:(LoginProcessor *)processor{
    QRootElement *details = [[QRootElement alloc] init];
    details.presentationMode = QPresentationModeModalForm;
    details.title = @"Options";
    details.controllerName = @"AboutController";
    [AboutController setProcessor:processor];
    [AboutController setRoot:theRoot];
    details.grouped = YES;
    QSection *newsection = [[QSection alloc] initWithTitle:@"Options"];
    QPickerElement *period = [[QPickerElement alloc] init];
    period.title = @"Grading Period";
    int amountOfPeriods = [processor.gradeData[0][1] count];
    NSLog(@"PERIODS AMOUNT === %d", amountOfPeriods);
    if(amountOfPeriods == 9)
    {
        period.items = @[@[@"First Quarter",@"Second Quarter",@"Semester Exams",@"Semester Grades",@"Third Quarter",@"Fourth Quarter",@"Final Exams",@"Second Semester Grades",@"Final Grades"]];
        
    }
    else if (amountOfPeriods == 6)
    {
        period.items = @[@[@"First Quarter",@"Second Quarter",@"Semester Exams",@"Third Quarter",@"Fourth Quarter",@"Final Exams"]];
    }
    else if (amountOfPeriods == 4)
    {
        period.items = @[@[@"First Quarter",@"Second Quarter",@"Third Quarter",@"Fourth Quarter"]];
    }
    period.bind = @"textValue:periodString";
    period.value = [period.items[0] objectAtIndex:processor.quarter];
    [newsection addElement:period];
	
	QButtonElement* refresh = [[QButtonElement alloc]initWithTitle:@"Refresh Grade Data"];
    refresh.controllerAction = @"refreshData:";
    
    QSection *section = [[QSection alloc]init];
    
    QButtonElement* logout = [[QButtonElement alloc]initWithTitle:@"Logout"];
    logout.controllerAction = @"logout:";
    
    section.footer = @"Note: Logging out will turn off the automatic inputting of login information.";
    
    [section addElement:logout];
	[newsection addElement:refresh];
    [details addSection:newsection];
    [details addSection:section];
    
    
    return details;
}


@end
