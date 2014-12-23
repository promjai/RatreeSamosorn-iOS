//
//  PFFoodAndDrinkDetailViewController.h
//  RatreeSamosorn
//
//  Created by Pariwat on 9/2/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import "DLImageLoader.h"
#import "ScrollView.h"
#import "AsyncImageView.h"
#import "UILabel+UILabelDynamicHeight.h"

#import "PFRatreeSamosornApi.h"

#import "PFOrderViewController.h"

@protocol PFFoodAndDrinkDetailViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFImageViewController:(id)sender viewPicture:(NSString *)link;
- (void)PFFoodAndDrinkDetailViewControllerBack;

@end

@interface PFFoodAndDrinkDetailViewController : UIViewController < UIScrollViewDelegate > {
    
    IBOutlet ScrollView *scrollView;
    IBOutlet AsyncImageView *imageView;
    NSMutableArray *images;
    NSArray *imagesName;
    
}

@property (assign, nonatomic) id delegate;
@property (strong, nonatomic) PFRatreeSamosornApi *RatreeSamosornApi;
@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSDictionary *obj;

@property NSUserDefaults *DetailOffline;

@property (strong, nonatomic) IBOutlet UIView *waitView;
@property (strong, nonatomic) IBOutlet UIView *popupwaitView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *headerImgView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) NSMutableArray *arrgalleryimg;
@property (strong, nonatomic) NSString *current;

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *baht;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detail;

@property (strong, nonatomic) IBOutlet AsyncImageView *imageView1;
@property (strong, nonatomic) IBOutlet UILabel *name1;
@property (strong, nonatomic) IBOutlet UILabel *price1;
@property (strong, nonatomic) IBOutlet UILabel *baht1;
@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detail1;

@property (strong, nonatomic) IBOutlet UILabel *order;
@property (strong, nonatomic) IBOutlet UIButton *orderButton;

-(void)ShowDetailView:(UIImageView *)imgView;

- (IBAction)fullimgTapped:(id)sender;
- (IBAction)fullimgalbumTapped:(id)sender;
- (IBAction)orderTapped:(id)sender;

@end
