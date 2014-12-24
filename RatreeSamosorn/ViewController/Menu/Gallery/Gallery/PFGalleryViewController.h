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

@protocol PFGalleryViewControllerDelegate <NSObject>

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current;
- (void)PFGalleryViewControllerBack;

@end

@interface PFGalleryViewController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (assign, nonatomic) id < PFGalleryViewControllerDelegate > delegate;

@property (retain, nonatomic) NSMutableArray *arrObj;
@property (retain, nonatomic) NSMutableArray *sumimg;

@property (nonatomic, weak ) NSString *galleryId;
@property (nonatomic, weak ) NSString *titleText;
@property (nonatomic, weak ) NSString *detailText;
@property (nonatomic, weak ) NSString *totalImg;

@end
