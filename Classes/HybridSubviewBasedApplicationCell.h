/*
     File: HybridSubviewBasedApplicationCell.h
 Abstract: The subclass of ApplicationCell that uses a single view to draw most of the content and a separate label to render the rest of the content.
  Version: 1.0
 

 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import "ApplicationCell.h"


@interface HybridSubviewBasedApplicationCell : ApplicationCell
{
    UIView *cellContentView;
    UILabel *priceLabel;
}

@end
