/*
     File: IndividualSubviewsBasedApplicationCell.m 
 Abstract: The subclass of ApplicationCell that uses individual subviews to display the content. 
  Version: 1.0 

 Copyright (C) 2010 Apple Inc. All Rights Reserved. 
  
 */

#import "IndividualSubviewsBasedApplicationCell.h"


@implementation IndividualSubviewsBasedApplicationCell

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];

    iconView.backgroundColor = backgroundColor;
    publisherLabel.backgroundColor = backgroundColor;
    nameLabel.backgroundColor = backgroundColor;
    ratingView.backgroundColor = backgroundColor;
    numRatingsLabel.backgroundColor = backgroundColor;
    priceLabel.backgroundColor = backgroundColor;
}

- (void)setIcon:(UIImage *)newIcon
{
    [super setIcon:newIcon];
    iconView.image = newIcon;
}

- (void)setPublisher:(NSString *)newPublisher
{
    [super setPublisher:newPublisher];
    publisherLabel.text = newPublisher;
}

- (void)setRating:(float)newRating
{
    [super setRating:newRating];
    ratingView.rating = newRating;
}

- (void)setNumRatings:(NSInteger)newNumRatings
{
    [super setNumRatings:newNumRatings];
    numRatingsLabel.text = [NSString stringWithFormat:@"%d Ratings", newNumRatings];
}

- (void)setName:(NSString *)newName
{
    [super setName:newName];
    nameLabel.text = newName;
}

- (void)setPrice:(NSString *)newPrice
{
    [super setPrice:newPrice];
    priceLabel.text = newPrice;
}

- (void)dealloc
{
    [iconView release];
    [publisherLabel release];
    [nameLabel release];
    [ratingView release];
    [numRatingsLabel release];
    [priceLabel release];

    [super dealloc];
}

@end
