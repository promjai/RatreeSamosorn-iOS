//
//  MyCell.h
//  TestCollectionViewWithXIB
//
//  Created by Quy Sang Le on 2/3/13.
//  Copyright (c) 2013 Quy Sang Le. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface MyCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet AsyncImageView *img;

@end
