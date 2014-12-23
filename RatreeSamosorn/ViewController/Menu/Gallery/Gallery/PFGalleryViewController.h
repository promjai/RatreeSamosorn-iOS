//
//  ViewController.h
//  TestCollectionViewWithXIB
//
//  Created by Quy Sang Le on 2/3/13.
//  Copyright (c) 2013 Quy Sang Le. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLImageLoader.h"
#import "MyCell.h"

#import "PFRatreeSamosornApi.h"

@protocol PFGalleryViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFGalleryViewControllerBack;

@end

@interface PFGalleryViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (assign, nonatomic) id < PFGalleryViewControllerDelegate > delegate;
@property (strong, nonatomic) PFRatreeSamosornApi *RatreeSamosornApi;

@property (strong, nonatomic) NSMutableArray *arrObj;
@property (strong, nonatomic) NSMutableArray *sumimg;

@property (nonatomic, strong) NSString *galleryId;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *detailText;
@property (nonatomic, strong) NSString *totalImg;

@end
