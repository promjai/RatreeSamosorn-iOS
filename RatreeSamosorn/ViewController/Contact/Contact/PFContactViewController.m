//
//  PFContactViewController.m
//  RatreeSamosorn
//
//  Created by Pariwat on 7/30/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import "PFContactViewController.h"

@interface PFContactViewController ()

@end

@implementation PFContactViewController

int contactInt;
NSTimer *timmer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.contactOffline = [NSUserDefaults standardUserDefaults];
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
    
    // Navbar setup
    UIColor *firstColor = [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:107.0f/255.0f alpha:1.0f];
    UIColor *secondColor = [UIColor colorWithRed:255.0f/255.0f green:102.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)firstColor.CGColor, (id)secondColor.CGColor, nil];
    
    [self.navBar setBarTintGradientColors:colors];
    
    self.navController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    [[self.navController navigationBar] setTranslucent:YES];
    [self.view addSubview:self.navController.view];
    
    self.RatreeSamosornApi = [[PFRatreeSamosornApi alloc] init];
    self.RatreeSamosornApi.delegate = self;
    
    if (![[self.RatreeSamosornApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Contact Us";
    } else {
        self.navItem.title = @"ติดต่อ";
    }
    
    self.ArrImgs = [[NSMutableArray alloc] init];
    self.arrcontactimg = [[NSMutableArray alloc] init];
    
    CALayer *mapView = [self.mapView layer];
    [mapView setMasksToBounds:YES];
    [mapView setCornerRadius:7.0f];
    
    CALayer *mapImage = [self.mapImage layer];
    [mapImage setMasksToBounds:YES];
    [mapImage setCornerRadius:7.0f];
    
    [self.RatreeSamosornApi getContactGallery];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.imgscrollview addGestureRecognizer:singleTap];
    
    self.current = @"0";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)PagedImageScrollView:(id)sender current:(NSString *)current{
    self.current = current;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    int sum;
    sum = [self.current intValue]/32;
    NSString *num = [NSString stringWithFormat:@"%d",sum];
    [self.delegate PFGalleryViewController:self sum:self.arrcontactimg current:num];
    
}

- (NSArray *)imageToArray:(NSDictionary *)images {
    int countPicture = [[images objectForKey:@"data"] count];
    for (int i = 0; i < countPicture; i++) {
        NSString *urlStr = [[NSString alloc] initWithFormat:@"%@",[[[images objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
        
        NSURL *url = [[NSURL alloc] initWithString:urlStr];
        NSData *data = [NSData dataWithContentsOfURL : url];
        UIImage *image = [UIImage imageWithData: data];
        
        [self.ArrImgs addObject:image];
    }
    return self.ArrImgs;
}

- (void)PFRatreeSamosornApi:(id)sender getContactGalleryResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
        [self.arrcontactimg addObject:[[[response objectForKey:@"data"] objectAtIndex:i] objectForKey:@"url"]];
    }
    
    self.pageScrollView = [[PagedImageScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    self.pageScrollView.delegate = self;
    [self.pageScrollView setScrollViewContents:[self imageToArray:response]];
    self.pageScrollView.pageControlPos = PageControlPositionCenterBottom;
    [self.imgscrollview addSubview:self.pageScrollView];

    [self.RatreeSamosornApi getContact];

}

- (void)PFRatreeSamosornApi:(id)sender getContactGalleryErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.RatreeSamosornApi getContact];
}

- (void)PFRatreeSamosornApi:(id)sender getContactResponse:(NSDictionary *)response {
    self.obj = response;
    //NSLog(@"%@",response);
    
    [self.contactOffline setObject:response forKey:@"contactOffline"];
    [self.contactOffline synchronize];
    
    [self.waitView removeFromSuperview];
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    //Content Label
    self.contentTxt.text = [response objectForKey:@"info"];
    CGRect frame = self.contentTxt.frame;
    frame.size = [self.contentTxt sizeOfMultiLineLabel];
    [self.contentTxt sizeOfMultiLineLabel];
    [self.contentTxt setFrame:frame];
    
    int lines = self.contentTxt.frame.size.height/15;
    self.contentTxt.numberOfLines = lines;
    
    UILabel *descText = [[UILabel alloc] initWithFrame:frame];
    descText.text = self.contentTxt.text;
    descText.numberOfLines = lines;
    [descText setFont:[UIFont systemFontOfSize:15]];
    descText.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    self.contentTxt.alpha = 0;
    [self.contentView addSubview:descText];
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, descText.frame.size.height+18);
    
    self.mapView.frame = CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y+self.contentView.frame.size.height-37, self.mapView.frame.size.width, self.mapView.frame.size.height);
    
    self.buttonView.frame = CGRectMake(self.buttonView.frame.origin.x, self.buttonView.frame.origin.y+self.contentView.frame.size.height-37, self.buttonView.frame.size.width, self.buttonView.frame.size.height);
    
    self.powerbyView.frame = CGRectMake(self.powerbyView.frame.origin.x, self.powerbyView.frame.origin.y+self.contentView.frame.size.height-37, self.powerbyView.frame.size.width, self.powerbyView.frame.size.height);
    
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.contentView.frame.size.height-37);
    
    NSString *urlmap = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"http://maps.googleapis.com/maps/api/staticmap?center=",[[response objectForKey:@"location"] objectForKey:@"lat"],@",",[[response objectForKey:@"location"] objectForKey:@"lng"],@"&zoom=16&size=560x240&sensor=false&markers=color:red%7Clabel:Satit%7C",[[response objectForKey:@"location"] objectForKey:@"lat"],@",",[[response objectForKey:@"location"] objectForKey:@"lng"]];
    
    [DLImageLoader loadImageFromURL:urlmap
                          completed:^(NSError *error, NSData *imgData) {
                              self.mapImage.image = [UIImage imageWithData:imgData];
                          }];
    
    self.locationTxt.text = @"12/21 หมู่ 4 ถ.เชียงใหม่ - ลำปาง ต.ท่าศาลา อ.เมือง จ.เชียงใหม่ 50000";
    
    self.phoneTxt.text = [response objectForKey:@"phone"];
    self.websiteTxt.text = [response objectForKey:@"website"];
    self.emailTxt.text = [response objectForKey:@"email"];
    
    self.tableView.tableHeaderView = self.headerView;
    
}

- (void)PFRatreeSamosornApi:(id)sender getContactErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
    
    [self.waitView removeFromSuperview];
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 64, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    contactInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    self.obj = [self.contactOffline objectForKey:@"contactOffline"];
    
    //Content Label
    self.contentTxt.text = [[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"info"];
    CGRect frame = self.contentTxt.frame;
    frame.size = [self.contentTxt sizeOfMultiLineLabel];
    [self.contentTxt sizeOfMultiLineLabel];
    [self.contentTxt setFrame:frame];
    int lines = self.contentTxt.frame.size.height/15;
    self.contentTxt.numberOfLines = lines;
    UILabel *descText = [[UILabel alloc] initWithFrame:frame];
    descText.text = self.contentTxt.text;
    descText.numberOfLines = lines;
    [descText setFont:[UIFont systemFontOfSize:15]];
    descText.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
    self.contentTxt.alpha = 0;
    [self.contentView addSubview:descText];
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, descText.frame.size.height+18);
    
    self.mapView.frame = CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y+self.contentView.frame.size.height-37, self.mapView.frame.size.width, self.mapView.frame.size.height);
    
    self.buttonView.frame = CGRectMake(self.buttonView.frame.origin.x, self.buttonView.frame.origin.y+self.contentView.frame.size.height-37, self.buttonView.frame.size.width, self.buttonView.frame.size.height);
    
    self.powerbyView.frame = CGRectMake(self.powerbyView.frame.origin.x, self.powerbyView.frame.origin.y+self.contentView.frame.size.height-37, self.powerbyView.frame.size.width, self.powerbyView.frame.size.height);
    
    self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height+self.contentView.frame.size.height-37);
    
    NSString *urlmap = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"http://maps.googleapis.com/maps/api/staticmap?center=",[[[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"location"] objectForKey:@"lat"],@",",[[[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"location"] objectForKey:@"lng"],@"&zoom=16&size=560x240&sensor=false&markers=color:red%7Clabel:Satit%7C",[[[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"location"] objectForKey:@"lat"],@",",[[[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"location"] objectForKey:@"lng"]];
    
    [DLImageLoader loadImageFromURL:urlmap
                          completed:^(NSError *error, NSData *imgData) {
                              self.mapImage.image = [UIImage imageWithData:imgData];
                          }];
    
    self.locationTxt.text = @"12/21 หมู่ 4 ถ.เชียงใหม่ - ลำปาง ต.ท่าศาลา อ.เมือง จ.เชียงใหม่ 50000";
    
    self.phoneTxt.text = [[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"phone"];
    self.websiteTxt.text = [[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"website"];
    self.emailTxt.text = [[self.contactOffline objectForKey:@"contactOffline"] objectForKey:@"email"];
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)countDown {
    contactInt -= 1;
    if (contactInt == 0) {
        [self.NoInternetView removeFromSuperview];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (IBAction)mapTapped:(id)sender{
    
    self.navItem.title = @" ";
    
    [self.delegate HideTabbar];
    
    PFMapViewController *mapView = [[PFMapViewController alloc] init];
    if(IS_WIDESCREEN) {
        mapView = [[PFMapViewController alloc] initWithNibName:@"PFMapViewController_Wide" bundle:nil];
    } else {
        mapView = [[PFMapViewController alloc] initWithNibName:@"PFMapViewController" bundle:nil];
    }
    mapView.delegate = self;
    mapView.lat = [[self.obj objectForKey:@"location"] objectForKey:@"lat"];
    mapView.lng = [[self.obj objectForKey:@"location"] objectForKey:@"lng"];
    [self.navController pushViewController:mapView animated:YES];
}

- (IBAction)phoneTapped:(id)sender{
    if (![self.phoneTxt.text isEqualToString:@""]) {
        NSString *phone = [[NSString alloc] initWithFormat:@"telprompt://%@",self.phoneTxt.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }
}

- (IBAction)websiteTapped:(id)sender{
    NSString *website = [[NSString alloc] initWithFormat:@"%@",self.websiteTxt.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:website]];
}

- (IBAction)emailTapped:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Select Menu"
                                  delegate:self
                                  cancelButtonTitle:@"cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Send Email", nil];
    [actionSheet showInView:[[[[UIApplication sharedApplication] keyWindow] subviews] lastObject]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Send Email"]) {
        [self.delegate HideTabbar];
        NSLog(@"Send Email");
        // Email Subject
        NSString *emailTitle = @"ราตรีสโมสร";
        // Email Content
        NSString *messageBody = @"ราตรีสโมสร!";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:self.emailTxt.text];
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:255.0f/255.0f green:102.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
        
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        
        [mc.navigationBar setTintColor:[UIColor whiteColor]];
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
        
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel");
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //[self reloadView];
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.delegate ShowTabbar];
}

- (IBAction)powerbyTapped:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://pla2fusion.com/"]];
}

- (void)PFMapViewControllerBack {
    [self.delegate ShowTabbar];
    if (![[self.RatreeSamosornApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Contact Us";
    } else {
        self.navItem.title = @"ติดต่อ";
    }
}

@end
