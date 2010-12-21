//
//  active_resourceAppDelegate.h
//  active_resource
//
//  Created by vickeryj on 8/21/08.
//  Copyright Joshua Vickery 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DebugViewController;
@class CustomUITabBarController; 

@interface objective_resourceAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UILabel *lblStatus;
@property (nonatomic, retain) CustomUITabBarController *tabBarController;
@property (nonatomic, retain)  UINavigationController *tab1NavController;
/*@property (nonatomic, retain) DebugViewController *dController;
@property (nonatomic, retain) UITabBarController *tabController;
@property (nonatomic, retain) UITabBarController *tTListDataSource;
@property (nonatomic, retain) NSMutableArray *globalMessages;
*/



@end

