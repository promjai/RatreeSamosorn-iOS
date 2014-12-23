//
//  PEActivityCalendarViewController.m
//  ราตรีสโมสร
//
//  Created by Pariwat on 7/30/14.
//  Copyright (c) 2557 Platwo fusion. All rights reserved.
//

#import "PFActivityCalendarViewController.h"

@interface PFActivityCalendarViewController ()

@end

@implementation PFActivityCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.calendarOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.dateStart = [[NSDate alloc]init];
    self.dateEnd = [[NSDate alloc] init];
    self.dataArray = [NSMutableArray array];
    self.actArray = [NSMutableArray array];
    self.allDataArray = [NSMutableArray array];
    self.dataDictionary = [NSMutableDictionary dictionary];
    self.actDictionary = [NSMutableDictionary dictionary];
    self.stuDictionary = [NSMutableDictionary dictionary];
    self.title = NSLocalizedString(@"Calendar", @"");
	[self.monthView selectDate:[NSDate date]];
    [self performSelector:@selector(CalenLoading) withObject:self afterDelay:0];
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSUInteger) supportedInterfaceOrientations{
	return  UIInterfaceOrientationMaskPortrait;
}

- (void)CalenLoading {
    [self.monthView setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Bangkok"]];
}

#pragma mark MonthView Delegate & DataSource
- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
    self.dataArray = nil;
	[self testItem:startDate endDate:lastDate];
	return self.dataArray;
}

- (void) calendarMonthView:(TKCalendarMonthView*)monthView didSelectDate:(NSDate*)date{
	NSLog(@"Date Selected: %@",date);
	[self.tableView reloadData];
}

- (void) calendarMonthView:(TKCalendarMonthView*)mv monthDidChange:(NSDate*)d animated:(BOOL)animated{
    [super calendarMonthView:mv monthDidChange:d animated:animated];
	[self.tableView reloadData];
}

#pragma mark UITableView Delegate & DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *ar = self.dataDictionary[[self.monthView dateSelected]];
	if(ar == nil) return 0;
	return [ar count];
}

- (UITableViewCell *) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    monthCell *cell = [tv dequeueReusableCellWithIdentifier:@"monthCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"monthCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
	NSArray *ar = self.dataDictionary[[self.monthView dateSelected]];
    
    cell.nameLabel.text = [ar[indexPath.row] objectForKey:@"name"];
    
    NSString *contentOffSet = [ar[indexPath.row] objectForKey:@"datetime"];
    NSString *newStr = [contentOffSet substringWithRange:NSMakeRange(contentOffSet.length -8, 5)];
    cell.timeLabel.text =  newStr;

    return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *ar = self.dataDictionary[[self.monthView dateSelected]];
    [self.delegate PFActivityCalendarViewController:self didRowSelect:ar[indexPath.row]];
    
}

- (void)testItem:(NSDate*)start endDate:(NSDate*)end{

    self.dataArray = [[NSMutableArray alloc] init];
    
    //
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    date.dateFormat = @"yyyy-MM-dd";
    
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [date setLocale:enUSPOSIXLocale];
    
    NSArray *temp = [[NSString stringWithFormat:@"%@",[date stringFromDate:start]] componentsSeparatedByString:@""];
    NSString *dateString = [[NSString alloc] init];
    dateString = [[NSString alloc] initWithString:[temp objectAtIndex:0]];
    
    NSArray *temp1 = [[NSString stringWithFormat:@"%@",[date stringFromDate:end]] componentsSeparatedByString:@""];
    NSString *dateString1 = [[NSString alloc] init];
    dateString1 = [[NSString alloc] initWithString:[temp1 objectAtIndex:0]];

    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [date dateFromString:dateString];
    
    NSDate *dateFromString1 = [[NSDate alloc] init];
    dateFromString1 = [date dateFromString:dateString1];
    
    self.dateStart = dateFromString;
    self.dateEnd = dateFromString1;

    NSString *urlStr = [[NSString alloc] initWithFormat:@"%@calendar?start_date=%@&end_date=%@",API_URL,dateString,dateString1];
    
    // create the URL we'd like to query
    NSURL *myURL = [[NSURL alloc]initWithString:urlStr];
    
    // we'll receive raw data so we'll create an NSData Object with it
    NSData *myData = [[NSData alloc]initWithContentsOfURL:myURL];
    
    if (myData.length != 0) {
        // now we'll parse our data using NSJSONSerialization
        id myJSON = [NSJSONSerialization JSONObjectWithData:myData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:myJSON];
        
        [self.calendarOffline setObject:dict forKey:@"calendarOffline"];
        [self.calendarOffline synchronize];
    }
    
    NSDate *d = dateFromString;
    int i = 0;
    while (YES) {
        
        NSDateComponents *info = [d dateComponentsWithTimeZone:self.monthView.timeZone];
        
        if ( [[[[[self.calendarOffline objectForKey:@"calendarOffline"] objectForKey:@"data"] objectAtIndex:i] objectForKey:@"has_data"] isEqualToString:@"no"]) {
            [self.dataArray addObject:@NO];
        } else {
            (self.dataDictionary)[d] = [[[[self.calendarOffline objectForKey:@"calendarOffline"] objectForKey:@"data"] objectAtIndex:i]objectForKey:@"data"];
            [self.dataArray addObject:@YES];
        }
        
        i++;
        info.day++;
        d = [NSDate dateWithDateComponents:info];
        if([d compare:dateFromString1]==NSOrderedDescending) break;
    }
    
}

- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end{
	// this function sets up dataArray & dataDictionary
	// dataArray: has boolean markers for each day to pass to the calendar view (via the delegate function)
	// dataDictionary: has items that are associated with date keys (for tableview)
	
	NSLog(@"Delegate Range: %@ %@ %@",start,end,@([start daysBetweenDate:end]));
	
	self.dataArray = [NSMutableArray array];
	self.dataDictionary = [NSMutableDictionary dictionary];
	
	NSDate *d = start;
	while(YES){
		
		NSInteger r = arc4random();
		if(r % 3==1){
			(self.dataDictionary)[d] = @[@"Item one",@"Item two"];
			[self.dataArray addObject:@YES];
			
		}else if(r%4==1){
			(self.dataDictionary)[d] = @[@"Item one"];
			[self.dataArray addObject:@YES];
			
		}else
			[self.dataArray addObject:@NO];
		
		
		NSDateComponents *info = [d dateComponentsWithTimeZone:self.monthView.timeZone];
		info.day++;
		d = [NSDate dateWithDateComponents:info];
		if([d compare:end]==NSOrderedDescending) break;
	}
	
}

@end
