//
//  PFUpdateViewController.m
//  RatreeSamosorn
//
//  Created by Pariwat on 7/30/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import "PFUpdateViewController.h"

@interface PFUpdateViewController ()

@end

@implementation PFUpdateViewController

BOOL loadUpdate;
BOOL noDataUpdate;
BOOL refreshDataUpdate;

int updateInt;
NSTimer *timmer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.feedOffline = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.waitView];
    
    CALayer *popup = [self.popupwaitView layer];
    [popup setMasksToBounds:YES];
    [popup setCornerRadius:7.0f];
    
    self.RatreeSamosornApi = [[PFRatreeSamosornApi alloc] init];
    self.RatreeSamosornApi.delegate = self;
    
    // Navbar setup
    UIColor *firstColor = [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:107.0f/255.0f alpha:1.0f];
    UIColor *secondColor = [UIColor colorWithRed:255.0f/255.0f green:102.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
    
    [self.navBar setBarTintGradientColors:colors];
    
    self.navController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    [[self.navController navigationBar] setTranslucent:YES];
    [self.view addSubview:self.navController.view];
    
    if ([self.RatreeSamosornApi checkLogin] == false){
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Setting_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(account)];
        
        //notification if (noti = 0) else
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Notification_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(notify)];
        
        self.navItem.leftBarButtonItem = leftButton;
        self.navItem.rightBarButtonItem = rightButton;
        
    }else{
        [self.RatreeSamosornApi checkBadge];
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkN:) userInfo:nil repeats:YES];
    }
    
    if (![[self.RatreeSamosornApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Update";
    } else {
        self.navItem.title = @"ข่าวสาร";
    }
    
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
    self.tableView.tableFooterView = fv;
    
    loadUpdate = NO;
    noDataUpdate = NO;
    refreshDataUpdate = NO;
    
    self.arrObj = [[NSMutableArray alloc] init];
    
    [self.RatreeSamosornApi getFeeds:@"15" link:@"NO"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)checkN:(NSTimer *)timer
{
    if ([self.RatreeSamosornApi checkLogin] == 1){
        [self.RatreeSamosornApi checkBadge];
    }
}

- (void)PFRatreeSamosornApi:(id)sender checkBadgeResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    NSLog(@"%@",[response objectForKey:@"length"]);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[response objectForKey:@"length"] forKey:@"badge"];
    [defaults synchronize];
    [self BarButtonItem];

}
- (void)PFRatreeSamosornApi:(id)sender checkBadgeErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"badge"];
    [defaults synchronize];
    [self BarButtonItem];
}

-(void)BarButtonItem {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Setting_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(account)];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *badge = [[NSString alloc] initWithFormat:@"%@",[def objectForKey:@"badge"]];
    
    //notification if (noti = 0) else
    if ([[def objectForKey:@"badge"] intValue] == 0) {
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Notification_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(notify)];
        self.navItem.rightBarButtonItem = rightButton;
        
    } else {
        
        UIButton *toggleKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        toggleKeyboardButton.bounds = CGRectMake( 0, 0, 21, 21 );
        [toggleKeyboardButton setTitle:badge forState:UIControlStateNormal];
        [toggleKeyboardButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
        [toggleKeyboardButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        toggleKeyboardButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [toggleKeyboardButton setBackgroundColor:[UIColor clearColor]];
        [toggleKeyboardButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        [toggleKeyboardButton.layer setBorderWidth: 1.0];
        [toggleKeyboardButton.layer setCornerRadius:10.0f];
        [toggleKeyboardButton addTarget:self action:@selector(notify) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:toggleKeyboardButton];
        self.navItem.rightBarButtonItem = rightButton;
        
    }
    
    self.navItem.leftBarButtonItem = leftButton;
}

- (void)account {
    if ([self.RatreeSamosornApi checkLogin] == false){
        
        self.loginView = [PFLoginViewController alloc];
        self.loginView.menu = @"account";
        self.loginView.delegate = self;
        [self.view addSubview:self.loginView.view];
        
    }else{
        
        self.navItem.title = @" ";
        [self.delegate HideTabbar];
        
        PFAccountViewController *account = [[PFAccountViewController alloc] init];
        
        if(IS_WIDESCREEN) {
            account = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController_Wide" bundle:nil];
        } else {
            account = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController" bundle:nil];
        }
        
        account.delegate = self;
        [self.navController pushViewController:account animated:YES];
    }
}

- (void)notify {
    if ([self.RatreeSamosornApi checkLogin] == false){
        
        self.loginView = [PFLoginViewController alloc];
        self.loginView.menu = @"notify";
        self.loginView.delegate = self;
        [self.view addSubview:self.loginView.view];
        
    }else{
        
        self.navItem.title = @" ";
        [self.delegate HideTabbar];
        
        PFNotificationViewController *notify = [[PFNotificationViewController alloc] init];
        
        if(IS_WIDESCREEN) {
            notify = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController_Wide" bundle:nil];
        } else {
            notify = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController" bundle:nil];
        }
        
        notify.delegate = self;
        [self.navController pushViewController:notify animated:YES];
    }
}

- (void)PFAccountViewController:(id)sender{
    
    self.navItem.title = @" ";
    [self.delegate HideTabbar];
    
    PFAccountViewController *account = [[PFAccountViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        account = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController_Wide" bundle:nil];
    } else {
        account = [[PFAccountViewController alloc] initWithNibName:@"PFAccountViewController" bundle:nil];
    }
    
    account.delegate = self;
    [self.navController pushViewController:account animated:YES];
    
}

- (void)PFNotifyViewController:(id)sender{
    
    self.navItem.title = @" ";
    [self.delegate HideTabbar];
    
    PFNotificationViewController *notify = [[PFNotificationViewController alloc] init];
    
    if(IS_WIDESCREEN) {
        notify = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController_Wide" bundle:nil];
    } else {
        notify = [[PFNotificationViewController alloc] initWithNibName:@"PFNotificationViewController" bundle:nil];
    }
    
    notify.delegate = self;
    [self.navController pushViewController:notify animated:YES];
    
}

- (void)PFRatreeSamosornApi:(id)sender getFeedsResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    self.obj = response;
    
    [self.waitView removeFromSuperview];
    
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    if (!refreshDataUpdate) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    if ( [[response objectForKey:@"paging"] objectForKey:@"next"] == nil ) {
        noDataUpdate = YES;
    } else {
        noDataUpdate = NO;
        self.paging = [[response objectForKey:@"paging"] objectForKey:@"next"];
    }
    
    [self.feedOffline setObject:response forKey:@"feedArray"];
    [self.feedOffline synchronize];
    
    [self.tableView reloadData];
}

- (void)PFRatreeSamosornApi:(id)sender getFeedsErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    updateInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    if (!refreshDataUpdate) {
        for (int i=0; i<[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.feedOffline objectForKey:@"feedArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.tableView reloadData];
}

- (void)countDown {
    updateInt -= 1;
    if (updateInt == 0) {
        [self.NoInternetView removeFromSuperview];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 306;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFUpdateCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFUpdateCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.thumbnails.layer.masksToBounds = YES;
    cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *img = [[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"];
    NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",img];
    
    [DLImageLoader loadImageFromURL:urlimg
                          completed:^(NSError *error, NSData *imgData) {
                              cell.thumbnails.image = [UIImage imageWithData:imgData];
                          }];
    
    cell.titleNews.text = [[NSString alloc] initWithString:[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"name"]];
    cell.detailNews.text = [[NSString alloc] initWithString:[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"detail"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.NoInternetView removeFromSuperview];
    
    if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"news"]) {
        
        [self.delegate HideTabbar];
        
        PFDetailViewController *detail = [[PFDetailViewController alloc] init];
        
        if(IS_WIDESCREEN){
            detail = [[PFDetailViewController alloc] initWithNibName:@"PFDetailViewController_Wide" bundle:nil];
        } else {
            detail = [[PFDetailViewController alloc] initWithNibName:@"PFDetailViewController" bundle:nil];
        }
        self.navItem.title = @" ";
        detail.obj = [self.arrObj objectAtIndex:indexPath.row];
        detail.delegate = self;
        [self.navController pushViewController:detail animated:YES];
    
    } else if ([[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"activity"]) {
        
        [self.delegate HideTabbar];
        
        PFActivityDetailViewController *activity = [[PFActivityDetailViewController alloc] init];
        
        if(IS_WIDESCREEN){
            activity = [[PFActivityDetailViewController alloc] initWithNibName:@"PFActivityDetailViewController_Wide" bundle:nil];
        } else {
            activity = [[PFActivityDetailViewController alloc] initWithNibName:@"PFActivityDetailViewController" bundle:nil];
        }
        self.navItem.title = @" ";
        activity.obj = [self.arrObj objectAtIndex:indexPath.row];
        activity.delegate = self;
        [self.navController pushViewController:activity animated:YES];
        
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	//NSLog(@"%f",scrollView.contentOffset.y);
	//[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ( scrollView.contentOffset.y < 0.0f ) {
        //NSLog(@"refreshData < 0.0f");
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        self.loadLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:[NSDate date]]];
        self.act.alpha =1;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    //NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y < -60.0f ) {
        refreshDataUpdate = YES;
        
        self.RatreeSamosornApi = [[PFRatreeSamosornApi alloc] init];
        self.RatreeSamosornApi.delegate = self;
        
        [self.RatreeSamosornApi getFeeds:@"15" link:@"NO"];
        
        if ([[self.obj objectForKey:@"total"] intValue] == 0) {
            [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            self.loadLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:[NSDate date]]];
            self.act.alpha =1;
        }
    } else {
        self.loadLabel.text = @"";
        self.act.alpha = 0;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if ( scrollView.contentOffset.y < -100.0f ) {
        [UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
        self.tableView.frame = CGRectMake(0, 50, 320, self.tableView.frame.size.height);
		[UIView commitAnimations];
        [self performSelector:@selector(resizeTable) withObject:nil afterDelay:2];
        
        if ([[self.obj objectForKey:@"total"] intValue] == 0) {
            [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            self.loadLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [dateFormatter stringFromDate:[NSDate date]]];
            self.act.alpha =1;
        }
    } else {
        self.loadLabel.text = @"";
        self.act.alpha = 0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    if (offset >= 0 && offset <= 5) {
        if (!noDataUpdate) {
            refreshDataUpdate = NO;
            
            self.RatreeSamosornApi = [[PFRatreeSamosornApi alloc] init];
            self.RatreeSamosornApi.delegate = self;
            
            if ([self.checkinternet isEqualToString:@"connect"]) {
                [self.RatreeSamosornApi getFeeds:@"NO" link:self.paging];
            }
        }
    }
}

- (void)resizeTable {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.tableView.frame = CGRectMake(0, 0, 320, self.tableView.frame.size.height);
    [UIView commitAnimations];
}

- (void)PFAccountViewController:(id)sender viewPicture:(NSString *)link{
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFUpdateDetailViewController:(id)sender viewPicture:(NSString *)link {
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFActivityDetailViewController:(id)sender viewPicture:(NSString *)link {
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFNotificationViewController:(id)sender viewPicture:(NSString *)link {
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFDetailViewControllerBack {
    [self.delegate ShowTabbar];
    if (![[self.RatreeSamosornApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Update";
    } else {
        self.navItem.title = @"ข่าวสาร";
    }
}

- (void)PFActivityDetailViewControllerBack {
    [self.delegate ShowTabbar];
    if (![[self.RatreeSamosornApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Update";
    } else {
        self.navItem.title = @"ข่าวสาร";
    }
}

- (void)PFAccountViewControllerBack {
    [self.delegate ShowTabbar];
    if (![[self.RatreeSamosornApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Update";
    } else {
        self.navItem.title = @"ข่าวสาร";
    }
    
    [self viewDidLoad];
    
    if ([[self.RatreeSamosornApi getReset] isEqualToString:@"YES"]) {
        [self.delegate resetApp];
    }
}

- (void)PFNotificationViewControllerBack {
    [self.delegate ShowTabbar];
    if (![[self.RatreeSamosornApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Update";
    } else {
        self.navItem.title = @"ข่าวสาร";
    }
}

@end
