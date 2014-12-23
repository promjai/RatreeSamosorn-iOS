//
//  PFNotificationViewController.h
//  RatreeSamosorn
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "PFNotificationCell.h"

#import "PFRatreeSamosornApi.h"

#import "PFDetailViewController.h"
#import "PFActivityDetailViewController.h"

@protocol PFNotificationViewControllerDelegate <NSObject>

- (void)PFNotificationViewController:(id)sender viewPicture:(NSString *)link;
- (void)PFNotificationViewControllerBack;

@end

@interface PFNotificationViewController : UIViewController

@property AFHTTPRequestOperationManager *manager;
@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFRatreeSamosornApi *RatreeSamosornApi;

@property NSUserDefaults *notifyOffline;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) NSMutableArray *arrObj;

@property (retain, nonatomic) NSString *paging;
@property (strong, nonatomic) NSString *checkinternet;

@end
