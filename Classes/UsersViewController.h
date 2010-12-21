@class FetchButtonView;
@class objective_resourceAppDelegate;

@interface UsersViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {

}


@property (nonatomic , retain) objective_resourceAppDelegate* appDelegate;
@property (nonatomic , retain) NSMutableArray* users;
@property (nonatomic , retain) NSMutableArray* pagedArray;
@property(nonatomic , retain) UITableView *tableView;
@property (nonatomic, retain) UIButton *fetchBtn;
@property (retain, nonatomic) UIView *footer;
- (void) onLoadUsers;

@end
