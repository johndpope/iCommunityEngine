/*
     File: ApplicationCell.h
 Abstract: The abstract superclass of the three cell classes used to display the content.
  Version: 1.0
 
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ApplicationCell : UITableViewCell
{
    BOOL useDarkBackground;

    UIImage *icon;
    NSString *publisher;
    NSString *name;
    float rating;
    NSInteger numRatings;
    NSString *price;
}

@property BOOL useDarkBackground;

@property(retain) UIImage *icon;
@property(retain) NSString *publisher;
@property(retain) NSString *name;
@property float rating;
@property NSInteger numRatings;
@property(retain) NSString *price;

@end
