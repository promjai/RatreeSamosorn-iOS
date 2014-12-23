//
//  PFMenuViewController.h
//  RatreeSamosorn
//
//  Created by Pariwat on 7/30/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"
#import "CRGradientNavigationBar.h"

#import "PFRatreeSamosornApi.h"

#import "PFFoldertypeCell.h"
#import "PFFoldertype1Cell.h"
#import "PFGalleryCell.h"
#import "PFActivityCalendarViewController.h"

#import "PFDetailFoldertypeViewController.h"
#import "PFFoodAndDrinkDetailViewController.h"
#import "PFGalleryViewController.h"

@protocol PFMenuViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link;
- (void)HideTabbar;
- (void)ShowTabbar;

@end

@interface PFMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PFActivityCalendarViewControllerDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFRatreeSamosornApi *RatreeSamosornApi;

@property (strong, nonatomic) PFActivityCalendarViewController *viewController;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) IBOutlet UIView *NoInternetView;
@property (strong, nonatomic) NSString *checkinternet;

@property (strong, nonatomic) IBOutlet UINavigationController *navController;
@property (strong, nonatomic) IBOutlet CRGradientNavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *CalendarView;

@property NSUserDefaults *foodOffline;
@property NSUserDefaults *drinkOffline;
@property NSUserDefaults *galleryOffline;

@property (strong, nonatomic) IBOutlet UIButton *foodsBt;
@property (strong, nonatomic) IBOutlet UIButton *drinksBt;
@property (strong, nonatomic) IBOutlet UIButton *activityBt;
@property (strong, nonatomic) IBOutlet UIButton *galleryBt;

@property (strong, nonatomic) NSMutableArray *arrObjFood;
@property (strong, nonatomic) NSMutableArray *arrObjDrink;
@property (strong, nonatomic) NSMutableArray *arrObjGallery;
@property (retain, nonatomic) NSMutableArray *arrObjGalleryAlbum;
@property (retain, nonatomic) NSMutableArray *sum;

@property (strong, nonatomic) NSString *menu;

- (IBAction)foodsTapped:(id)sender;
- (IBAction)drinksTapped:(id)sender;
- (IBAction)activityTapped:(id)sender;
- (IBAction)galleryTapped:(id)sender;

@end
