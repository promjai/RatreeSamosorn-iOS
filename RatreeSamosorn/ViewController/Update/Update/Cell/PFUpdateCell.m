//
//  PFUpdateCell.m
//  ราตรีสโมสร
//
//  Created by Pariwat on 7/30/14.
//  Copyright (c) 2014 platwofusion. All rights reserved.
//

#import "PFUpdateCell.h"

@implementation PFUpdateCell

- (void)awakeFromNib
{
    // Initialization code
    CALayer *detailNewsView = [self.detailNewsView layer];
    [detailNewsView setMasksToBounds:YES];
    [detailNewsView setCornerRadius:7.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
