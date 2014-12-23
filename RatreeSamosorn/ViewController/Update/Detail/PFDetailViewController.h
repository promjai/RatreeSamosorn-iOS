//
//  PFDetailViewController.h
//  RatreeSamosorn
//
//  Created by Pariwat on 8/1/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"
#import <Social/Social.h>
#import "UILabel+UILabelDynamicHeight.h"

#import "PFRatreeSamosornApi.h"

#import "PFDetailCell.h"
#import "PFLoginViewController.h"
#import "PFSeeprofileViewController.h"

@protocol PFDetailViewControllerDelegate <NSObject>

- (void)PFUpdateDetailViewController:(id)sender viewPicture:(NSString *)link;
- (void)PFDetailViewControllerBack;

@end

@interface PFDetailViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFRatreeSamosornApi *RatreeSamosornApi;
@property (strong, nonatomic) NSDictionary *obj;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSString *prevString;
@property (strong, nonatomic) NSString *paging;

@property (strong, nonatomic) NSString *internetstatus;

@property (strong, nonatomic) PFLoginViewController *loginView;

@property NSUserDefaults *feedDetailOffline;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *detailView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *titlenews;
@property (weak, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detailnews;
@property (weak, nonatomic) IBOutlet UIImageView *detailthumb;

@property (strong, nonatomic) IBOutlet UIView *textCommentView;

@property (weak, nonatomic) IBOutlet UIButton *postBut;
@property (weak, nonatomic) IBOutlet UITextView *textComment;

- (IBAction)postCommentTapped:(id)sender;

@end
