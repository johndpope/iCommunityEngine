#import <UIKit/UIKit.h>

@class User;
@interface ViewUserController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {

	User *user;

}

@property (nonatomic , retain) User *user;
-(void) editUserButtonWasPressed;


@end
