//
//  PFHistoryViewController.m
//  RatreeSamosorn
//
//  Created by Pariwat on 8/1/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import "PFHistoryViewController.h"

@interface PFHistoryViewController ()

@end

@implementation PFHistoryViewController

BOOL refreshDataHistory;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.historyOffline = [NSUserDefaults standardUserDefaults];
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
    
    if (![[self.RatreeSamosornApi getLanguage] isEqualToString:@"TH"]) {
        self.navigationItem.title = @"History";
        self.title_history.text = @"History";
    } else {
        self.navigationItem.title = @"ประวัติการใช้งาน";
        self.title_history.text = @"ประวัติการใช้งาน";
    }
    
    self.conditionnomember.text = self.detailhistory;
    
    CGRect frame = self.conditionnomember.frame;
    frame.size = [self.conditionnomember sizeOfMultiLineLabel];
    [self.conditionnomember sizeOfMultiLineLabel];
    [self.conditionnomember setFrame:frame];
    int lines = self.conditionnomember.frame.size.height/15;
    self.conditionnomember.numberOfLines = lines;
    
    UILabel *descText = [[UILabel alloc] initWithFrame:frame];
    descText.text = self.conditionnomember.text;
    descText.numberOfLines = lines;
    [descText setFont:[UIFont systemFontOfSize:15]];
    descText.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.conditionnomember.alpha = 0;
    [self.headerView addSubview:descText];
    
    self.historyView.frame = CGRectMake(self.historyView.frame.origin.x, self.headerView.frame.size.height+descText.frame.size.height-75, self.historyView.frame.size.width, self.historyView.frame.size.height);
    
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+descText.frame.size.height-25);
    
    self.tableView.tableHeaderView = self.headerView;

    [self.RatreeSamosornApi history];
    
    self.arrObj = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)PFRatreeSamosornApi:(id)sender getHistoryResponse:(NSDictionary *)response {
    //NSLog(@"Member History %@",response);
    
    [self.waitView removeFromSuperview];
    
    if (!refreshDataHistory) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.historyOffline setObject:response forKey:@"historyArray"];
    [self.historyOffline synchronize];
    
    [self reloadData:YES];
}

- (void)PFRatreeSamosornApi:(id)sender getHistoryErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    
    if (!refreshDataHistory) {
        for (int i=0; i<[[[self.historyOffline objectForKey:@"historyArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.historyOffline objectForKey:@"historyArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObj removeAllObjects];
        for (int i=0; i<[[[self.historyOffline objectForKey:@"historyArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObj addObject:[[[self.historyOffline objectForKey:@"historyArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self reloadData:YES];
}

- (void)reloadData:(BOOL)animated
{
    [self.tableView reloadData];
    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width,self.tableView.contentSize.height);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrObj count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFHistoryCell"];
    if(cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFHistoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    int check;
    check = indexPath.row % 2;
    
    if (check == 0) {
        cell.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    } else {
        cell.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    
    NSString *history = [[NSString alloc] initWithFormat:@"%@%@%@",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"created_at"],@" : ",[[self.arrObj objectAtIndex:indexPath.row] objectForKey:@"message"]];
    cell.detail.text = history;
    
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        // 'Back' button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        if([self.delegate respondsToSelector:@selector(PFHistoryViewControllerBack)]){
            [self.delegate PFHistoryViewControllerBack];
        }
    }
    
}

@end
