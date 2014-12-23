//
//  RecipeCollectionHeaderView.h
//  CollectionViewDemo
//
//  Created by Simon on 22/1/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+UILabelDynamicHeight.h"

@protocol HeaderViewDelegate <NSObject>

- (void)header;

@end

@interface HeaderView : UICollectionReusableView

@property (assign, nonatomic) id <HeaderViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel_UILabelDynamicHeight *detail;
- (IBAction)headerTapped:(id)sender;

@end
