//
//  active_resourceAppDelegate.m
//  active_resource
//
//  Created by vickeryj on 8/21/08.
//  Copyright Joshua Vickery 2008. All rights reserved.
//

#import "objective_resourceAppDelegate.h"
#import "ObjectiveResource.h"
#import "CustomUITabBarController.h"
#import "UsersViewController.h"




@implementation UINavigationBar (UINavigationBarCategory)

- (void)drawRect:(CGRect)rect {
    // Drawing code	
	
	
	UIImage *img = [UIImage imageNamed: @"background.png"];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawImage(context, CGRectMake(0, 0, 320, self.frame.size.height), img.CGImage);
	UIColor *color = [UIColor colorWithRed:0.0 green:0.0 blue:0.7 alpha:1.0];
	//UIColor *color = HEXCOLOR(0xFFCC00); //[UIColor redColor];
	//CGContextSetFillColor(context, CGColorGetComponents( [color CGColor]));
	//CGContextFillRect(context, rect);
	self.tintColor = color;
	
}
@end



@implementation objective_resourceAppDelegate

@synthesize window,toolbar, activityIndicator,lblStatus,tabBarController,tab1NavController;
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0];


- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	
	
	//Configure ObjectiveResource
	//[ObjectiveResourceConfig setSite:@"http://192.168.0.111:82/"];
	//[ObjectiveResourceConfig setSite:@"http://192.168.0.27:3000/"];
	[ObjectiveResourceConfig setSite:@"http://127.0.0.1:3000/"];
	
	[ObjectiveResourceConfig setUser:@"redash"];
    [ObjectiveResourceConfig setPassword:@"jdp1234"];
	// use json
	//[ObjectiveResourceConfig setResponseType:JSONResponse];
	// use xml
	[ObjectiveResourceConfig setResponseType:XmlResponse];
	
	 tabBarController = [[UITabBarController alloc] init];
	
	
    
	UsersViewController *usersVC = [[UsersViewController  alloc] init];
	tab1NavController = [[UINavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
	[tab1NavController setNavigationBarHidden:NO];
	[tab1NavController pushViewController:usersVC animated:NO];
	//[window addSubview:tab1NavController.view];
	
	
	
	// TODO Clean this up.
	UIViewController *libraryController = [[UIViewController alloc] init];
	
	
	
    UIViewController *reviewController = [[UIViewController alloc] init];
    reviewController.title = @"";
	
	
    UIViewController *meController = [[UIViewController alloc] init];
    meController.title = @"";
	
    
    // Add them as children of the tab bar controller
    tabBarController.viewControllers = [NSArray arrayWithObjects:tab1NavController,libraryController, reviewController, meController,nil];
	
	
	
	// Override point for customization after app launch
	[window addSubview:tabBarController.view];
	
	[window makeKeyAndVisible];
	
	
    // Don't forget memory management
	
    [usersVC release];
    [libraryController release];
    [reviewController release];
    [meController release];
	
}



- (void) debug_clicked:(id)sender {
	
	/*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TO DO." message:@"add debug messages."
 												   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[alert show];
	[alert release];*/
	
	
	//dController = [[[DebugViewController alloc ] initWithStyle:UITableViewStyleGrouped ] autorelease];
	//aController.user = [[User alloc] init];
	//dController.delegate = self;
	//[navigationController pushViewController:dController animated:YES];
	
	
	//@try {
	
    //tabController = [[UITabBarController alloc] init];

    /*[tabController setViewControllers:
     [NSArray arrayWithObjects:
      [[[UINavigationController alloc] initWithRootViewController:[[[TableImageTestController alloc] init] autorelease]] autorelease],
      [[[UINavigationController alloc] initWithRootViewController:[[[TableImageTestController alloc] init] autorelease]] autorelease],
      nil]];
    
    [window addSubview:[tabController view]];

	[window makeKeyAndVisible];*/
		
	/*tableImageTestController =[[[TableImageTestController alloc] init] autorelease];
	[navigationController pushViewController:tableImageTestController animated:YES];
		
	}
	@catch (NSException * e) {
		//NSLog(@"exception: %@",e);
		NSLog(@"Go to Project Settings, go to 'Other Linker Flags' under the 'Linker' section, and add '-ObjC' and '-all_load' to the list of flags.)");
	}*/

	
}



/*
-(NSMutableArray*) getGlobalMessages{
    if (globalMessages!=nil) {
        return globalMessages;
    }
    NSMutableArray *newArray=[[NSMutableArray alloc] initWithCapacity:1]; 
    self.globalMessages=newArray;
    [newArray release];
    return globalMessages;
}*/

- (void) onSaveUser:(NSArray *)array{
	NSLog(@"onSaveUser called...");

	[self.activityIndicator stopAnimating];
	[self.lblStatus setText:@""];

}


- (void)dealloc {

	[lblStatus release];
	[activityIndicator release];
	[toolbar release];
	[window release];
	[super dealloc];
}


@end
