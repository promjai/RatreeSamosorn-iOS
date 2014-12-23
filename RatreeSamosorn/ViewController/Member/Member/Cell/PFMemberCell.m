//
//  PFMemberCell.m
//  RatreeSamosorn
//
//  Created by Pariwat on 8/1/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import "PFMemberCell.h"

@implementation PFMemberCell

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
    [bgView setCornerRadius:7.0f];
}

@end
