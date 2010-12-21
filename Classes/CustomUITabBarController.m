#import "CustomUITabBarController.h"
@implementation CustomUITabBarController



@synthesize tabBar1;
- (void)viewDidLoad {
	[super viewDidLoad];

	
	CGRect frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 40);
    UIView *v = [[UIView alloc] initWithFrame:frame];
    [v setBackgroundColor:[UIColor greenColor]];
    [v setAlpha:1];
    [[self tabBar] addSubview:v];
    [v release];
}
@end