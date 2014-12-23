//
//  PFProfileViewController.h
//  RatreeSamosorn
//
//  Created by Pariwat on 6/30/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "SDImageCache.h"

#import "PFRatreeSamosornApi.h"

#import "PFEditViewController.h"

@protocol PFProfileViewControllerDelegate <NSObject>

- (void)PFAccountViewController:(id)sender viewPicture:(NSString *)link;
- (void)PFProfileViewControllerBack;

@end

@interface PFProfileViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFRatreeSamosornApi *RatreeSamosornApi;

@property NSUserDefaults *meOffline;
@property NSUserDefaults *settingOffline;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) NSDictionary *objAccount;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *bgprofileView;
@property (strong, nonatomic) IBOutlet UIView *bgfacebookView;
@property (strong, nonatomic) IBOutlet UIView *bgemailView;
@property (strong, nonatomic) IBOutlet UIView *bgwebsiteView;
@property (strong, nonatomic) IBOutlet UIView *bgphoneView;
@property (strong, nonatomic) IBOutlet UIView *bggenderView;
@property (strong, nonatomic) IBOutlet UIView *bgbirthdayView;

@property (strong, nonatomic) IBOutlet UITextField *display_name;

@property (strong, nonatomic) IBOutlet UIImageView *thumUser;

@property (strong, nonatomic) IBOutlet UITextField *facebook;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *website;
@property (strong, nonatomic) IBOutlet UITextField *tel;
@property (strong, nonatomic) IBOutlet UITextField *gender;
@property (strong, nonatomic) IBOutlet UITextField *birthday;

@property (strong, nonatomic) NSString *facebookSetting;
@property (strong, nonatomic) NSString *emailSetting;
@property (strong, nonatomic) NSString *websiteSetting;
@property (strong, nonatomic) NSString *telSetting;
@property (strong, nonatomic) NSString *genderSetting;
@property (strong, nonatomic) NSString *birthdaySetting;

@property (strong, nonatomic) IBOutlet UIButton *edit_bt;

@property (strong, nonatomic) IBOutlet UIButton *facebook_bt;
@property (strong, nonatomic) IBOutlet UIButton *email_bt;
@property (strong, nonatomic) IBOutlet UIButton *website_bt;
@property (strong, nonatomic) IBOutlet UIButton *tel_bt;
@property (strong, nonatomic) IBOutlet UIButton *gender_bt;
@property (strong, nonatomic) IBOutlet UIButton *birthday_bt;

- (IBAction)fullimgTapped:(id)sender;

- (IBAction)editTapped:(id)sender;

- (IBAction)facebookTapped:(id)sender;
- (IBAction)emailTapped:(id)sender;
- (IBAction)websiteTapped:(id)sender;
- (IBAction)telTapped:(id)sender;
- (IBAction)genderTapped:(id)sender;
- (IBAction)birthdayTapped:(id)sender;

@end
