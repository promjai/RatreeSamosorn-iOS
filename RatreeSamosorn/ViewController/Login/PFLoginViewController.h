//
//  PFLoginViewController.h
//  RatreeSamosorn
//
//  Created by Pariwat on 6/11/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIERealTimeBlurView.h"
#import "UIView+MTAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>

#import "PFRatreeSamosornApi.h"

@protocol PFLoginViewControllerDelegate <NSObject>

- (void)PFMemberViewController:(id)sender;
- (void)PFAccountViewController:(id)sender;
- (void)PFNotifyViewController:(id)sender;

@end

@interface PFLoginViewController : UIViewController <FBLoginViewDelegate,UITextFieldDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFRatreeSamosornApi *RatreeSamosornApi;
@property (strong, nonatomic) IBOutlet UIView *registerView;
@property (strong, nonatomic) IBOutlet UIView *blurView;
@property (strong, nonatomic) IBOutlet UIView *loginView;

@property (strong, nonatomic) IBOutlet UITextField *emailSignIn;
@property (strong, nonatomic) IBOutlet UITextField *passwordSignIn;

@property (strong, nonatomic) IBOutlet UIButton *signin_bt;
@property (strong, nonatomic) IBOutlet UIButton *signup_bt;
@property (strong, nonatomic) IBOutlet UIButton *create_bt;

- (IBAction)bgTapped:(id)sender;
- (IBAction)signinTapped:(id)sender;
- (IBAction)signupTapeed:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *emailSignUp;
@property (strong, nonatomic) IBOutlet UITextField *passwordSignUp;
@property (strong, nonatomic) IBOutlet UITextField *confirmSignUp;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirthSignUp;
@property (strong, nonatomic) IBOutlet UITextField *gender;

- (IBAction)dateBTapped:(id)sender;
- (IBAction)genderTapped:(id)sender;

- (IBAction)closedateTapped:(id)sender;
- (IBAction)closegenderTapped:(id)sender;

@property (strong, nonatomic) UIDatePicker *pick;
@property (strong, nonatomic) UIButton *pickDone;

- (IBAction)sumitTapped:(id)sender;

@property (strong, nonatomic) NSString *menu;

@end
