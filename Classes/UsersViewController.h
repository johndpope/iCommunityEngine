@class FetchButtonView;
@class objective_resourceAppDelegate;

@interface UsersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

}


@property (nonatomic , retain) objective_resourceAppDelegate* appDelegate;
@property (nonatomic , retain) NSMutableArray* users;
@property (nonatomic , retain) NSMutableArray* pagedArray;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) UIButton *fetchBtn;
@property (nonatomic, retain) UIView *footer;
- (void) onLoadUsers;

@end
