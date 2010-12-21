/*
     File: CompositeSubviewBasedApplicationCell.h
 Abstract: The subclass of ApplicationCell that uses a single view to draw the content.

 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import <Foundation/Foundation.h>
#import "ApplicationCell.h"

@interface CompositeSubviewBasedApplicationCell : ApplicationCell
{
    UIView *cellContentView;
}

@end
