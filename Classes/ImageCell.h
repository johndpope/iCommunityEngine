//
//  ImageCell.h
//  objective_resource
//
//  Created by JP on 10. 5. 17..
//  Copyright 2010 com.fobikr. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ImageCell : UITableViewCell {
	// adding the 2 labels we want to show in the cell
	UILabel *titleLabel;
	UILabel *urlLabel;
}

// these are the functions we will create in the .m file

// gets the data from another class
-(void)setData:(NSDictionary *)dict;

// internal function to ease setting up label text
-(UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

// you should know what this is for by know
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *urlLabel;

@end