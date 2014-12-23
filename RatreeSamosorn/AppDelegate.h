//
//  AppDelegate.h
//  RatreeSamosorn
//
//  Created by Pariwat on 7/30/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFTabBarViewController.h"

#import "PFUpdateViewController.h"
#import "PFMenuViewController.h"
#import "PFMemberViewController.h"
#import "PFContactViewController.h"

#import "PFRatreeSamosornApi.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import "SDImageCache.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PFRatreeSamosornApi *RatreeSamosornApi;

@property (strong, nonatomic) PFTabBarViewController *tabBarViewController;

@property (strong, nonatomic) PFUpdateViewController *update;
@property (strong, nonatomic) PFMenuViewController *menu;
@property (strong, nonatomic) PFMemberViewController *member;
@property (strong, nonatomic) PFContactViewController *contact;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end
