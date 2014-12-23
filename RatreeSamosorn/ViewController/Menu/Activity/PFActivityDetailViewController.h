//
//  PFActivityDetailViewController.h
//  RatreeSamosorn
//
//  Created by Pariwat on 9/5/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"
#import <Social/Social.h>
#import "UILabel+UILabelDynamicHeight.h"

#import "PFRatreeSamosornApi.h"

#import "PFDetailAcCell.h"
#import "PFLoginViewController.h"
#import "PFSeeprofileViewController.h"

@protocol PFActivityDetailViewControllerDelegate <NSObject>

- (void)PFActivityDetailViewController:(id)sender viewPicture:(NSString *)link;
- (void)PFActivityDetailViewControllerBack;

@end

@interface PFActivityDetailViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFRatreeSamosornApi *RatreeSamosornApi;
@property (strong, nonatomic) NSDictionary *obj;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSString *prevString;
@property (strong, nonatomic) NSString *paging;

@property (strong, nonatomic) NSString *internetstatus;

@property (strong, nonatomic) PFLoginViewController *loginView;

@property NSUserDefaults *activityDetailOffline;

@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *titlenews;
@property (weak, nonatomic) IBOutlet UILabel *timenews;
@property (weak, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detailnews;
@property (weak, nonatomic) IBOutlet UIImageView *detailthumb;

@property (strong, nonatomic) IBOutlet UIView *textCommentView;

@property (weak, nonatomic) IBOutlet UIButton *postBut;
@property (weak, nonatomic) IBOutlet UITextView *textComment;

- (IBAction)postCommentTapped:(id)sender;

@end
