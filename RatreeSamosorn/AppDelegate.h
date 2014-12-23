//
//  AppDelegate.h
//  RatreeSamosorn
//
//  Created by Pariwat Promjai on 12/23/2557 BE.
//  Copyright (c) 2557 Pariwat Promjai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFRatreeSamosornApi.h"

#import "TabBarViewController.h"

#import "PFUpdateViewController.h"
#import "PFMenuViewController.h"
#import "PFMemberViewController.h"
#import "PFContactViewController.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import "SDImageCache.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PFRatreeSamosornApi *RatreeSamosornApi;

@property (strong, nonatomic) TabBarViewController *tabBarViewController;

@property (strong, nonatomic) PFUpdateViewController *update;
@property (strong, nonatomic) PFMenuViewController *menu;
@property (strong, nonatomic) PFMemberViewController *member;
@property (strong, nonatomic) PFContactViewController *contact;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;


@end

