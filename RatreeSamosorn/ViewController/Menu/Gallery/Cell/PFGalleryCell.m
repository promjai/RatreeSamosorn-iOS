//
//  PFGalleryCell.m
//  RatreeSamosorn
//
//  Created by Pariwat on 8/2/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import "PFGalleryCell.h"

@implementation PFGalleryCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    CALayer *bgView = [self.bgView layer];
    [bgView setMasksToBounds:YES];
    [bgView setCornerRadius:5.0f];
}

@end
