//
//  PFSeeprofileViewController.h
//  RatreeSamosorn
//
//  Created by Pariwat on 8/1/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DLImageLoader.h"

#import "PFRatreeSamosornApi.h"

#import "PFAccountCell.h"

@protocol PFSeeprofileViewControllerDelegate <NSObject>

- (void)PFSeeprofileViewController:(id)sender viewPicture:(NSString *)link;
- (void)PFSeeprofileViewControllerBack;

@end

@interface PFSeeprofileViewController : UIViewController < MFMailComposeViewControllerDelegate >

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFRatreeSamosornApi *RatreeSamosornApi;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *bgheaderView;

@property (strong, nonatomic) NSString *user_id;

@property (strong, nonatomic) NSDictionary *obj;
@property (strong, nonatomic) NSDictionary *objUsersetting;

@property (strong, nonatomic) NSString *rowCount;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) IBOutlet UIImageView *thumUser;
@property (strong, nonatomic) IBOutlet UITextField *display_name;

- (IBAction)fullimgTapped:(id)sender;

@end
