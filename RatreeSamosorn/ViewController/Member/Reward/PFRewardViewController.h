//
//  PFRewardViewController.h
//  RatreeSamosorn
//
//  Created by Pariwat on 8/1/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFRatreeSamosornApi.h"

@protocol PFRewardViewControllerDelegate <NSObject>

- (void)PFRewardViewControllerBack;

@end

@interface PFRewardViewController : UIViewController

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFRatreeSamosornApi *RatreeSamosornApi;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) IBOutlet UIView *NoInternetView;

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *reward_id;
@property (strong, nonatomic) NSString *user_id;

@end
