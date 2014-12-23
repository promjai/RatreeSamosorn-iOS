//
//  PFMemberCell.h
//  RatreeSamosorn
//
//  Created by Pariwat on 8/1/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface PFMemberCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bgPoint;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *point;

@property (weak, nonatomic) IBOutlet UILabel *free;
@property (weak, nonatomic) IBOutlet UILabel *points;

@end
