//
//  PFDetailFoldertype1ViewController.h
//  DeLanna
//
//  Created by Pariwat on 8/8/14.
//  Copyright (c) 2014 Platwo fusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"

#import "PFRatreeSamosornApi.h"

#import "PFFoldertypeCell.h"
#import "PFFoldertype1Cell.h"
#import "PFDetailFoldertypeViewController.h"
#import "PFFoodAndDrinkDetailViewController.h"

@protocol PFDetailFoldertype1ViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link;
- (void)PFDetailFoldertype1ViewControllerBack;

@end

@interface PFDetailFoldertype1ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFRatreeSamosornApi *RatreeSamosornApi;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *foldertype1Offline;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSString *titlename;
@property (strong, nonatomic) NSString *folder_id;

@end
