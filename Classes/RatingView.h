/*
     File: RatingView.h
 Abstract: The view used by the IndividualSubviewBasedApplicationCell to display the rating.
  Version: 1.0

 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import <UIKit/UIKit.h>

@interface RatingView : UIView
{
    float rating;
    UIImageView *backgroundImageView;
    UIImageView *foregroundImageView;
}

@property float rating;

@end
