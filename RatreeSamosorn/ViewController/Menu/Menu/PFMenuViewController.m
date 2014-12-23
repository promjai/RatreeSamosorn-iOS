//
//  PFMenuViewController.m
//  RatreeSamosorn
//
//  Created by Pariwat on 7/30/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import "PFMenuViewController.h"

@interface PFMenuViewController ()

@end

@implementation PFMenuViewController

BOOL loadMenu;
BOOL noDataMenu;
BOOL refreshDataMenu;

int menuInt;
NSTimer *timmer;

NSString *totalImg;
NSString *titleText;
NSString *detailText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        self.foodOffline = [NSUserDefaults standardUserDefaults];
        self.drinkOffline = [NSUserDefaults standardUserDefaults];
        self.galleryOffline = [NSUserDefaults standardUserDefaults];
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
        self.navItem.title = @"Menu";
        [self.foodsBt setTitle:@"Foods" forState:UIControlStateNormal];
        [self.foodsBt.titleLabel setTextColor:RGB(255, 255, 255)];
        [self.drinksBt setTitle:@"Drinks" forState:UIControlStateNormal];
        [self.drinksBt.titleLabel setTextColor:RGB(109, 110, 113)];
        [self.activityBt setTitle:@"Activity" forState:UIControlStateNormal];
        [self.activityBt.titleLabel setTextColor:RGB(109, 110, 113)];
        [self.galleryBt setTitle:@"Gallery" forState:UIControlStateNormal];
        [self.galleryBt.titleLabel setTextColor:RGB(109, 110, 113)];
    } else {
        self.navItem.title = @"รายการ";
        [self.foodsBt setTitle:@"อาหาร" forState:UIControlStateNormal];
        [self.foodsBt.titleLabel setTextColor:RGB(255, 255, 255)];
        [self.drinksBt setTitle:@"เครื่องดื่ม" forState:UIControlStateNormal];
        [self.drinksBt.titleLabel setTextColor:RGB(109, 110, 113)];
        [self.activityBt setTitle:@"กิจกรรม" forState:UIControlStateNormal];
        [self.activityBt.titleLabel setTextColor:RGB(109, 110, 113)];
        [self.galleryBt setTitle:@"อัลบั้ม" forState:UIControlStateNormal];
        [self.galleryBt.titleLabel setTextColor:RGB(109, 110, 113)];
    }
    
    UIView *hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    self.tableView.tableHeaderView = hv;
    UIView *fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
    self.tableView.tableFooterView = fv;
    
    self.CalendarView.hidden = YES;
    
    refreshDataMenu = YES;
    
    self.arrObjFood = [[NSMutableArray alloc] init];
    self.arrObjDrink = [[NSMutableArray alloc] init];
    self.arrObjGallery = [[NSMutableArray alloc] init];
    self.arrObjGalleryAlbum = [[NSMutableArray alloc] init];
    self.sum = [[NSMutableArray alloc] init];
    
    self.foodsBt.backgroundColor = [UIColor clearColor];
    [self.foodsBt.titleLabel setTextColor:RGB(255, 255, 255)];
    self.drinksBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
    [self.drinksBt.titleLabel setTextColor:RGB(109, 110, 113)];
    self.activityBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
    [self.activityBt.titleLabel setTextColor:RGB(109, 110, 113)];
    self.galleryBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
    [self.galleryBt.titleLabel setTextColor:RGB(109, 110, 113)];
    self.menu = @"Foods";
    [self.RatreeSamosornApi getFoods];
    
    self.viewController = [PFActivityCalendarViewController new];
    self.viewController.delegate = self;
    [self.CalendarView addSubview:self.viewController.view];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkBar:) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)checkBar:(NSTimer *)timer
{
    if ([self.menu isEqualToString:@"Foods"]) {
        self.foodsBt.backgroundColor = [UIColor clearColor];
        [self.foodsBt.titleLabel setTextColor:RGB(255, 255, 255)];
        self.drinksBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
        [self.drinksBt.titleLabel setTextColor:RGB(109, 110, 113)];
        self.activityBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
        [self.activityBt.titleLabel setTextColor:RGB(109, 110, 113)];
        self.galleryBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
        [self.galleryBt.titleLabel setTextColor:RGB(109, 110, 113)];
    }
    if ([self.menu isEqualToString:@"Drinks"]) {
        self.foodsBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
        [self.foodsBt.titleLabel setTextColor:RGB(109, 110, 113)];
        self.drinksBt.backgroundColor = [UIColor clearColor];
        [self.drinksBt.titleLabel setTextColor:RGB(255, 255, 255)];
        self.activityBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
        [self.activityBt.titleLabel setTextColor:RGB(109, 110, 113)];
        self.galleryBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
        [self.galleryBt.titleLabel setTextColor:RGB(109, 110, 113)];
    }
    if ([self.menu isEqualToString:@"Activity"]) {
        self.foodsBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
        [self.foodsBt.titleLabel setTextColor:RGB(109, 110, 113)];
        self.drinksBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
        [self.drinksBt.titleLabel setTextColor:RGB(109, 110, 113)];
        self.activityBt.backgroundColor = [UIColor clearColor];
        [self.activityBt.titleLabel setTextColor:RGB(255, 255, 255)];
        self.galleryBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
        [self.galleryBt.titleLabel setTextColor:RGB(109, 110, 113)];
    }
    if ([self.menu isEqualToString:@"Gallery"]) {
        self.foodsBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
        [self.foodsBt.titleLabel setTextColor:RGB(109, 110, 113)];
        self.drinksBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
        [self.drinksBt.titleLabel setTextColor:RGB(109, 110, 113)];
        self.activityBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
        [self.activityBt.titleLabel setTextColor:RGB(109, 110, 113)];
        self.galleryBt.backgroundColor = [UIColor clearColor];
        [self.galleryBt.titleLabel setTextColor:RGB(255, 255, 255)];
    }
}

- (void)PFActivityCalendarViewController:(id)sender didRowSelect:(NSDictionary *)dict {

    [self.delegate HideTabbar];
    
    PFActivityDetailViewController *activity = [[PFActivityDetailViewController alloc] init];
    
    if(IS_WIDESCREEN){
        activity = [[PFActivityDetailViewController alloc] initWithNibName:@"PFActivityDetailViewController_Wide" bundle:nil];
    } else {
        activity = [[PFActivityDetailViewController alloc] initWithNibName:@"PFActivityDetailViewController" bundle:nil];
    }
    self.navItem.title = @" ";
    activity.obj = dict;
    activity.delegate = self;
    [self.navController pushViewController:activity animated:YES];

    
}

- (void)PFRatreeSamosornApi:(id)sender getFoodsResponse:(NSDictionary *)response {
    //NSLog(@"food %@",response);
    
    self.menu = @"Foods";
    
    [self.waitView removeFromSuperview];
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    if (!refreshDataMenu) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjFood addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjFood removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjFood addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.foodOffline setObject:response forKey:@"foodArray"];
    [self.foodOffline synchronize];
    
    [self.tableView reloadData];
}

- (void)PFRatreeSamosornApi:(id)sender getFoodsErrorResponse:(NSString *)errorResponse {
    //NSLog(@"%@",errorResponse);
    
    self.menu = @"Foods";
    
    [self.waitView removeFromSuperview];
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 99, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    menuInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    if (!refreshDataMenu) {
        for (int i=0; i<[[[self.foodOffline objectForKey:@"foodArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjFood addObject:[[[self.foodOffline objectForKey:@"foodArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjFood removeAllObjects];
        for (int i=0; i<[[[self.foodOffline objectForKey:@"foodArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjFood addObject:[[[self.foodOffline objectForKey:@"foodArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.tableView reloadData];
}

- (void)PFRatreeSamosornApi:(id)sender getDrinksResponse:(NSDictionary *)response {
    //NSLog(@"drink %@",response);
    
    self.menu = @"Drinks";
    
    [self.waitView removeFromSuperview];
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    if (!refreshDataMenu) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjDrink addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjDrink removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjDrink addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.drinkOffline setObject:response forKey:@"drinkArray"];
    [self.drinkOffline synchronize];
    
    [self.tableView reloadData];
}

- (void)PFRatreeSamosornApi:(id)sender getDrinksErrorResponse:(NSString *)errorResponse {
    //NSLog(@"%@",errorResponse);
    
    self.menu = @"Drinks";
    
    [self.waitView removeFromSuperview];
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 99, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    menuInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    if (!refreshDataMenu) {
        for (int i=0; i<[[[self.drinkOffline objectForKey:@"drinkArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjDrink addObject:[[[self.drinkOffline objectForKey:@"drinkArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjDrink removeAllObjects];
        for (int i=0; i<[[[self.drinkOffline objectForKey:@"drinkArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjDrink addObject:[[[self.drinkOffline objectForKey:@"drinkArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.tableView reloadData];
}

- (void)PFRatreeSamosornApi:(id)sender getGalleryResponse:(NSDictionary *)response {
    //NSLog(@"%@",response);
    
    self.menu = @"Gallery";
    
    [self.waitView removeFromSuperview];
    [self.NoInternetView removeFromSuperview];
    self.checkinternet = @"connect";
    
    if (!refreshDataMenu) {
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjGalleryAlbum addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjGalleryAlbum removeAllObjects];
        for (int i=0; i<[[response objectForKey:@"data"] count]; ++i) {
            [self.arrObjGalleryAlbum addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.galleryOffline setObject:response forKey:@"galleryArray"];
    [self.galleryOffline synchronize];
    
    [self.tableView reloadData];
}

- (void)PFRatreeSamosornApi:(id)sender getGalleryErrorResponse:(NSString *)errorResponse {
    //NSLog(@"%@",errorResponse);
    
    self.menu = @"Gallery";
    
    [self.waitView removeFromSuperview];
    self.checkinternet = @"error";
    self.NoInternetView.frame = CGRectMake(0, 99, self.NoInternetView.frame.size.width, self.NoInternetView.frame.size.height);
    [self.view addSubview:self.NoInternetView];
    
    menuInt = 5;
    timmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    if (!refreshDataMenu) {
        for (int i=0; i<[[[self.galleryOffline objectForKey:@"galleryArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjGalleryAlbum addObject:[[[self.galleryOffline objectForKey:@"galleryArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    } else {
        [self.arrObjGalleryAlbum removeAllObjects];
        for (int i=0; i<[[[self.galleryOffline objectForKey:@"galleryArray"] objectForKey:@"data"] count]; ++i) {
            [self.arrObjGalleryAlbum addObject:[[[self.galleryOffline objectForKey:@"galleryArray"] objectForKey:@"data"] objectAtIndex:i]];
        }
    }
    
    [self.tableView reloadData];
}

- (void)countDown {
    menuInt -= 1;
    if (menuInt == 0) {
        [self.NoInternetView removeFromSuperview];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.menu isEqualToString:@"Foods"]) {
        return [self.arrObjFood count];
    }
    if ([self.menu isEqualToString:@"Drinks"]) {
        return [self.arrObjDrink count];
    }
    if ([self.menu isEqualToString:@"Activity"]) {
        return 0;
    }
    if ([self.menu isEqualToString:@"Gallery"]) {
        return [self.arrObjGalleryAlbum count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.menu isEqualToString:@"Foods"]) {
        return 90;
    }
    if ([self.menu isEqualToString:@"Drinks"]) {
        return 90;
    }
    if ([self.menu isEqualToString:@"Activity"]) {
        return 0;
    }
    if ([self.menu isEqualToString:@"Gallery"]) {
        return 110;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if ([self.menu isEqualToString:@"Foods"]) {
        
        if ([[[self.arrObjFood objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"product"]) {
        
            PFFoldertypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFoldertypeCell"];
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFoldertypeCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.image.layer.masksToBounds = YES;
            cell.image.contentMode = UIViewContentModeScaleAspectFill;
            
            NSString *img = [[[self.arrObjFood objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"];
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",img];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      cell.image.image = [UIImage imageWithData:imgData];
                                  }];
            
            cell.name.text = [[NSString alloc] initWithString:[[self.arrObjFood objectAtIndex:indexPath.row] objectForKey:@"name"]];
            cell.price.text = [[NSString alloc] initWithFormat:@"%@%@",[[self.arrObjFood objectAtIndex:indexPath.row] objectForKey:@"price"],@" ฿"];
            
            cell.detail.text = [[NSString alloc] initWithString:[[self.arrObjFood objectAtIndex:indexPath.row] objectForKey:@"detail"]];
            
            return cell;
            
        } else {
        
            PFFoldertype1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFoldertype1Cell"];
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFoldertype1Cell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.thumbnails.layer.masksToBounds = YES;
            cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
            
            NSString *img = [[[self.arrObjFood objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"];
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",img];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      cell.thumbnails.image = [UIImage imageWithData:imgData];
                                  }];
            
            cell.name.text = [[NSString alloc] initWithString:[[self.arrObjFood objectAtIndex:indexPath.row] objectForKey:@"name"]];
            
            return cell;
            
        }
        
    }
    if ([self.menu isEqualToString:@"Drinks"]) {
        
        if ([[[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"product"]) {
            
            PFFoldertypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFoldertypeCell"];
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFoldertypeCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.image.layer.masksToBounds = YES;
            cell.image.contentMode = UIViewContentModeScaleAspectFill;
            
            NSString *img = [[[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"];
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",img];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      cell.image.image = [UIImage imageWithData:imgData];
                                  }];
            
            cell.name.text = [[NSString alloc] initWithString:[[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"name"]];
            cell.price.text = [[NSString alloc] initWithFormat:@"%@%@",[[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"price"],@" ฿"];
            
            cell.detail.text = [[NSString alloc] initWithString:[[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"detail"]];
            
            return cell;
            
        } else {
            
            PFFoldertype1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFFoldertype1Cell"];
            if(cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFFoldertype1Cell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.thumbnails.layer.masksToBounds = YES;
            cell.thumbnails.contentMode = UIViewContentModeScaleAspectFill;
            
            NSString *img = [[[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"];
            NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",img];
            
            [DLImageLoader loadImageFromURL:urlimg
                                  completed:^(NSError *error, NSData *imgData) {
                                      cell.thumbnails.image = [UIImage imageWithData:imgData];
                                  }];
            
            cell.name.text = [[NSString alloc] initWithString:[[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"name"]];
            
            return cell;
            
        }

    }
    if ([self.menu isEqualToString:@"Gallery"]) {
        PFGalleryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PFGalleryCell"];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PFGalleryCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.image.layer.masksToBounds = YES;
        cell.image.contentMode = UIViewContentModeScaleAspectFill;
        
        NSString *img = [[[self.arrObjGalleryAlbum objectAtIndex:indexPath.row] objectForKey:@"thumb"] objectForKey:@"url"];
        NSString *urlimg = [[NSString alloc] initWithFormat:@"%@",img];
        
        [DLImageLoader loadImageFromURL:urlimg
                              completed:^(NSError *error, NSData *imgData) {
                                  cell.image.image = [UIImage imageWithData:imgData];
                              }];
        
        cell.name.text = [[NSString alloc] initWithString:[[self.arrObjGalleryAlbum objectAtIndex:indexPath.row] objectForKey:@"name"]];
        cell.detail.text = [[NSString alloc] initWithString:[[self.arrObjGalleryAlbum objectAtIndex:indexPath.row] objectForKey:@"detail"]];
        
        return cell;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.NoInternetView removeFromSuperview];
    
    if ([self.menu isEqualToString:@"Foods"]) {
        
        
        if ([[[self.arrObjFood objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"product"]) {
            
            self.navItem.title = @" ";
            [self.delegate HideTabbar];
            
            PFFoodAndDrinkDetailViewController *detailView = [[PFFoodAndDrinkDetailViewController alloc] init];
            if(IS_WIDESCREEN) {
                detailView = [[PFFoodAndDrinkDetailViewController alloc] initWithNibName:@"PFFoodAndDrinkDetailViewController_Wide" bundle:nil];
            } else {
                detailView = [[PFFoodAndDrinkDetailViewController alloc] initWithNibName:@"PFFoodAndDrinkDetailViewController" bundle:nil];
            }
            detailView.obj = [self.arrObjFood objectAtIndex:indexPath.row];
            detailView.delegate = self;
            [self.navController pushViewController:detailView animated:YES];
            
        } else {
            
            NSString *children_length = [[NSString alloc] initWithFormat:@"%@",[[self.arrObjFood objectAtIndex:indexPath.row] objectForKey:@"children_length"]];
            
            if ([children_length isEqualToString:@"0"]) {
                [[[UIAlertView alloc] initWithTitle:@"ราตรีสโมสร"
                                            message:@"Coming soon."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                
            } else {
                
                self.navItem.title = @" ";
                [self.delegate HideTabbar];
            
                PFDetailFoldertypeViewController *foldertypeView = [[PFDetailFoldertypeViewController alloc] init];
                if(IS_WIDESCREEN) {
                    foldertypeView = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController_Wide" bundle:nil];
                } else {
                foldertypeView = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController" bundle:nil];
                }
                foldertypeView.obj = [self.arrObjFood objectAtIndex:indexPath.row];
                foldertypeView.folder_id = [[self.arrObjFood objectAtIndex:indexPath.row] objectForKey:@"id"];
                foldertypeView.delegate = self;
                [self.navController pushViewController:foldertypeView animated:YES];
            }
        }
    }
    if ([self.menu isEqualToString:@"Drinks"]) {
        
        if ([[[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"product"]) {
            
            self.navItem.title = @" ";
            [self.delegate HideTabbar];
            
            PFFoodAndDrinkDetailViewController *detailView = [[PFFoodAndDrinkDetailViewController alloc] init];
            if(IS_WIDESCREEN) {
                detailView = [[PFFoodAndDrinkDetailViewController alloc] initWithNibName:@"PFFoodAndDrinkDetailViewController_Wide" bundle:nil];
            } else {
                detailView = [[PFFoodAndDrinkDetailViewController alloc] initWithNibName:@"PFFoodAndDrinkDetailViewController" bundle:nil];
            }
            detailView.obj = [self.arrObjDrink objectAtIndex:indexPath.row];
            detailView.delegate = self;
            [self.navController pushViewController:detailView animated:YES];
            
        } else {
            
            NSString *children_length = [[NSString alloc] initWithFormat:@"%@",[[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"children_length"]];
            
            if ([children_length isEqualToString:@"0"]) {
                [[[UIAlertView alloc] initWithTitle:@"ราตรีสโมสร"
                                            message:@"Coming soon."
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                
            } else {
                
                self.navItem.title = @" ";
                [self.delegate HideTabbar];
            
                PFDetailFoldertypeViewController *foldertypeView = [[PFDetailFoldertypeViewController alloc] init];
                if(IS_WIDESCREEN) {
                foldertypeView = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController_Wide" bundle:nil];
                } else {
                    foldertypeView = [[PFDetailFoldertypeViewController alloc] initWithNibName:@"PFDetailFoldertypeViewController" bundle:nil];
                }
                foldertypeView.obj = [self.arrObjDrink objectAtIndex:indexPath.row];
                foldertypeView.folder_id = [[self.arrObjDrink objectAtIndex:indexPath.row] objectForKey:@"id"];
                foldertypeView.delegate = self;
                [self.navController pushViewController:foldertypeView animated:YES];
            }
            
        }
        
    }
    if ([self.menu isEqualToString:@"Gallery"]) {
        
        totalImg = [[self.arrObjGalleryAlbum objectAtIndex:indexPath.row] objectForKey:@"picture_length"];
        titleText = [[self.arrObjGalleryAlbum objectAtIndex:indexPath.row] objectForKey:@"name"];
        detailText = [[self.arrObjGalleryAlbum objectAtIndex:indexPath.row] objectForKey:@"detail"];
        
        [self.arrObjGallery removeAllObjects];
        [self.sum removeAllObjects];
        
        [self.RatreeSamosornApi galleryPictureByURL:[[[self.arrObjGalleryAlbum objectAtIndex:indexPath.row] objectForKey:@"node"] objectForKey:@"pictures"]];
        
    }
    
}

- (void)PFRatreeSamosornApi:(id)sender galleryPictureByURLResponse:(NSDictionary *)response {
    
    for (int i = 0; i < [[response objectForKey:@"data"] count]; i++) {
        
        [self.arrObjGallery addObject:[[response objectForKey:@"data"] objectAtIndex:i]];
        
    }
    
    for (int i = 0; i < [[response objectForKey:@"data"] count]; i++) {
        
        [self.sum addObject:[[self.arrObjGallery objectAtIndex:i] objectForKey:@"url"]];
        
    }
    
    self.navItem.title = @" ";
    
    [self.delegate HideTabbar];
    
    PFGalleryViewController *showcaseGallery = [[PFGalleryViewController alloc] init];
    
    if (IS_WIDESCREEN) {
        showcaseGallery = [[PFGalleryViewController alloc] initWithNibName:@"PFGalleryViewController_Wide" bundle:nil];
    } else {
        showcaseGallery = [[PFGalleryViewController alloc] initWithNibName:@"PFGalleryViewController" bundle:nil];
    }
    
    showcaseGallery.delegate = self;
    
    showcaseGallery.arrObj = self.arrObjGallery;
    showcaseGallery.sumimg = self.sum;
    showcaseGallery.totalImg = totalImg;
    showcaseGallery.titleText = titleText;
    showcaseGallery.detailText = detailText;
    
    [self.navController pushViewController:showcaseGallery animated:YES];
    
}

- (void)PFRatreeSamosornApi:(id)sender galleryPictureByURLErrorResponse:(NSString *)errorResponse {
    NSLog(@"%@",errorResponse);
}

//food
- (IBAction)foodsTapped:(id)sender{
    self.tableView.hidden = NO;
    self.CalendarView.hidden = YES;
    self.foodsBt.backgroundColor = [UIColor clearColor];
    [self.foodsBt.titleLabel setTextColor:RGB(255, 255, 255)];
    self.drinksBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
    [self.drinksBt.titleLabel setTextColor:RGB(109, 110, 113)];
    self.activityBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
    [self.activityBt.titleLabel setTextColor:RGB(109, 110, 113)];
    self.galleryBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
    [self.galleryBt.titleLabel setTextColor:RGB(109, 110, 113)];
    self.menu = @"Foods";
    [self.RatreeSamosornApi getFoods];
}

//drink
- (IBAction)drinksTapped:(id)sender{
    self.tableView.hidden = NO;
    self.CalendarView.hidden = YES;
    self.foodsBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
    [self.foodsBt.titleLabel setTextColor:RGB(109, 110, 113)];
    self.drinksBt.backgroundColor = [UIColor clearColor];
    [self.drinksBt.titleLabel setTextColor:RGB(255, 255, 255)];
    self.activityBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
    [self.activityBt.titleLabel setTextColor:RGB(109, 110, 113)];
    self.galleryBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
    [self.galleryBt.titleLabel setTextColor:RGB(109, 110, 113)];
    self.menu = @"Drinks";
    [self.RatreeSamosornApi getDrinks];
}

//activity
- (IBAction)activityTapped:(id)sender{
    self.tableView.hidden = YES;
    self.CalendarView.hidden = NO;
    self.foodsBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
    [self.foodsBt.titleLabel setTextColor:RGB(109, 110, 113)];
    self.drinksBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
    [self.drinksBt.titleLabel setTextColor:RGB(109, 110, 113)];
    self.activityBt.backgroundColor = [UIColor clearColor];
    [self.activityBt.titleLabel setTextColor:RGB(255, 255, 255)];
    self.galleryBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
    [self.galleryBt.titleLabel setTextColor:RGB(109, 110, 113)];
    self.menu = @"Activity";
}

//gallery
- (IBAction)galleryTapped:(id)sender{
    self.tableView.hidden = NO;
    self.CalendarView.hidden = YES;
    self.foodsBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
    [self.foodsBt.titleLabel setTextColor:RGB(109, 110, 113)];
    self.drinksBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
    [self.drinksBt.titleLabel setTextColor:RGB(109, 110, 113)];
    self.activityBt.backgroundColor = [UIColor colorWithRed:242 green:242 blue:242 alpha:1];
    [self.activityBt.titleLabel setTextColor:RGB(109, 110, 113)];
    self.galleryBt.backgroundColor = [UIColor clearColor];
    [self.galleryBt.titleLabel setTextColor:RGB(255, 255, 255)];
    self.menu = @"Gallery";
    [self.RatreeSamosornApi getGallery];
}

- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link{
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current{
    [self.delegate PFGalleryViewController:self sum:sum current:current];
}

- (void)PFActivityDetailViewController:(id)sender viewPicture:(NSString *)link {
    [self.delegate PFImageViewController:self viewPicture:link];
}

- (void)PFDetailFoldertypeViewControllerBack {
    [self.delegate ShowTabbar];
    if (![[self.RatreeSamosornApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Menu";
    } else {
        self.navItem.title = @"รายการ";
    }
}

- (void)PFFoodAndDrinkDetailViewControllerBack {
    [self.delegate ShowTabbar];
    if (![[self.RatreeSamosornApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Menu";
    } else {
        self.navItem.title = @"รายการ";
    }
}

- (void)PFActivityDetailViewControllerBack {
    [self.delegate ShowTabbar];
    if (![[self.RatreeSamosornApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Menu";
    } else {
        self.navItem.title = @"รายการ";
    }
}

- (void)PFGalleryViewControllerBack {
    [self.delegate ShowTabbar];
    if (![[self.RatreeSamosornApi getLanguage] isEqualToString:@"TH"]) {
        self.navItem.title = @"Menu";
    } else {
        self.navItem.title = @"รายการ";
    }
}

@end
