//
//  main.m
//  active_resource
//
//  Created by vickeryj on 8/21/08.
//  Copyright Joshua Vickery 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	
	// Swizzle the nslog
    //Method customLog = class_getInstanceMethod([UIKit class], @selector(NSLog:));
    //Method drawRect = class_getInstanceMethod([UINavigationBar class], @selector(drawRect:));
    //method_exchangeImplementations(drawRect, drawRectCustomBackground);
	//NSString *logPath = @"/temp/file.log"; 
	//NSLog(@"file redirection to /temp/file.log /main.m" );
	//freopen([logPath fileSystemRepresentation], "a", stderr);

	int retVal = UIApplicationMain(argc, argv, nil, nil);
	[pool release];
	return retVal;
}
