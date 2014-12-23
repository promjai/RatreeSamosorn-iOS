//
//  PFHistoryViewController.h
//  RatreeSamosorn
//
//  Created by Pariwat on 8/1/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+UILabelDynamicHeight.h"

#import "PFRatreeSamosornApi.h"

#import "PFHistoryCell.h"

@protocol PFHistoryViewControllerDelegate <NSObject>

- (void)PFHistoryViewControllerBack;

@end

@interface PFHistoryViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFRatreeSamosornApi *RatreeSamosornApi;
@property (strong, nonatomic) NSMutableArray *arrObj;

@property NSUserDefaults *historyOffline;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *historyView;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *conditionnomember;
@property (strong, nonatomic) IBOutlet UILabel *title_history;

@property (strong, nonatomic) NSString *detailhistory;


@end
