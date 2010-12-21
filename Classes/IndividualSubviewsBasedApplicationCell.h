/*
     File: IndividualSubviewsBasedApplicationCell.h
 Abstract: The subclass of ApplicationCell that uses individual subviews to display the content.
  Version: 1.0

 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import <Foundation/Foundation.h>
#import "ApplicationCell.h"
#import "RatingView.h"

@interface IndividualSubviewsBasedApplicationCell : ApplicationCell
{
    IBOutlet UIImageView *iconView;
    IBOutlet UILabel *publisherLabel;
    IBOutlet UILabel *nameLabel;
    IBOutlet RatingView *ratingView;
    IBOutlet UILabel *numRatingsLabel;
    IBOutlet UILabel *priceLabel;
}

@end
