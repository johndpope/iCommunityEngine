/*
     File: ApplicationCell.m 
 Abstract: The abstract superclass of the three cell classes used to display the content. 
  Version: 1.0 
  

  
 Copyright (C) 2010 Apple Inc. All Rights Reserved. 
  
 */

#import "ApplicationCell.h"

@implementation ApplicationCell

@synthesize useDarkBackground, icon, publisher, name, rating, numRatings, price;

- (void)setUseDarkBackground:(BOOL)flag
{
    if (flag != useDarkBackground || !self.backgroundView)
    {
        useDarkBackground = flag;

        NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:useDarkBackground ? @"DarkBackground" : @"LightBackground" ofType:@"png"];
        UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
        self.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.frame = self.bounds;
    }
}

- (void)dealloc
{
    [icon release];
    [publisher release];
    [name release];
    [price release];
    
    [super dealloc];
}

@end
