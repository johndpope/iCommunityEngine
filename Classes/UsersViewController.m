#import "UsersViewController.h"
#import "ViewUserController.h"
#import "User.h"
#import "objective_resourceAppDelegate.h"
#import "common.h"
#import "ApplicationCell.h"
#import "CompositeSubviewBasedApplicationCell.h"
#import "FetchButtonView.h"

@interface UsersViewController (Private)
- (void) loadUsers;
- (void) addFetchButton;
@end



@implementation UsersViewController
@synthesize users , tableView,pagedArray;
@synthesize fetchBtn;
@synthesize footer;
@synthesize appDelegate;




- (id)init
{
	if (self = [super init]) {
		appDelegate = GET_APP_DELEGATE();
		pagedArray = [[NSMutableArray alloc]initWithCapacity:0];
		users = [[NSMutableArray alloc]initWithCapacity:0];


		[self.tableView setDelegate:self];
		[self.tableView setDataSource:self];
		[self.tableView setBackgroundColor:[UIColor clearColor]];
		[self.navigationItem setTitle:@"Community Engine Users"];
		[self.navigationItem setHidesBackButton:YES];
		[self.navigationItem.rightBarButtonItem = [UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonWasPressed)];
		
		[self addFetchButton];
		
		[self loadUsers];
		[self setHeader];
	}
	
	return self;
}


- (void)setHeader {
	UIView *containerView =	[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 23)] autorelease];
	UIImageView *headerBg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"library_titbg.png"]] autorelease];
	[headerBg setFrame:CGRectMake(0, 0, 320, 23)];
	[containerView addSubview:headerBg];
	UILabel *headerLabel =	[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 23)] ;
	headerLabel.text = [NSString stringWithFormat:@"Header"];
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.shadowColor = [UIColor blackColor];
	headerLabel.shadowOffset = CGSizeMake(0, -1);
	headerLabel.font = [UIFont boldSystemFontOfSize:18];
	headerLabel.backgroundColor = [UIColor clearColor];
	[containerView addSubview:headerLabel];
	self.tableView.tableHeaderView = containerView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Configure the table view.
    self.tableView.backgroundColor = DARK_BACKGROUND;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    switch (toInterfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return YES;
        default:
            return NO;
    }
}

static int page = 1;
- (void) loadUsers {
	
	self.users = [NSMutableArray arrayWithArray:[User findAllRemote]];
	
	//[self.tableView reloadData];
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	
	/*if ([users count] == 0)
	{
		page = page + 1;
	}*/
	
	NSString *strPage = [NSString stringWithFormat: @"%d", page];

	
	[User findRemoteWithCallback:@selector(onLoadUsers:) delegate:self params:[NSString stringWithFormat:@"?page=%@",strPage]];
	[appDelegate.lblStatus setText:@"loading users"];
	[appDelegate.activityIndicator startAnimating];
	[pool release];
	
	
}

- (void) onLoadUsers:(NSArray *)array{
	
	NSLog(@"page %d",page);
	NSMutableArray *objectsToAdd =   [[NSMutableArray alloc]initWithCapacity:0];
	objectsToAdd = [NSMutableArray arrayWithArray:array];
	NSLog(@"onLoadUsers called objectsToAdd... %@",objectsToAdd);
	
	[self.pagedArray  addObjectsFromArray:objectsToAdd];
	NSLog(@"onLoadUsers called pagedArray... %@",pagedArray);
	
	[self.users  addObjectsFromArray:pagedArray];
	NSLog(@"users called users... %@",users);
	NSLog(@"self.users  count %d",[users count]);	
	
	[appDelegate.activityIndicator stopAnimating];
	
	
	if ([users count] >= PAGINATION_COUNT)
	{
		[self addFetchButton];
	}
	
	[self.tableView reloadData];
		
	
}


-(IBAction) refreshButtonWasPressed {
	[appDelegate.activityIndicator startAnimating];
	[self loadUsers];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [users count];
}



- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
	
    ApplicationCell *cell = (ApplicationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
    {
        cell = [[[CompositeSubviewBasedApplicationCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                            reuseIdentifier:CellIdentifier] autorelease];

    }
    
	// Display dark and light background in alternate rows -- see tableView:willDisplayCell:forRowAtIndexPath:.
    cell.useDarkBackground = (indexPath.row % 2 == 0);
	
	// Configure the data for the cell.
	
    //NSDictionary *dataItem = [data objectAtIndex:indexPath.row];
    //cell.icon = [UIImage imageNamed:[dataItem objectForKey:@"Icon"]];
    cell.publisher = ((User *)[users objectAtIndex:indexPath.row]).description;
    cell.name = ((User *)[users objectAtIndex:indexPath.row]).displayName;
    //cell.numRatings = [[dataItem objectForKey:@"NumRatings"] intValue];
    //cell.rating = [[dataItem objectForKey:@"Rating"] floatValue];
    //cell.price = [dataItem objectForKey:@"Price"];
	
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ViewUserController *aController = [[[ViewUserController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
	aController.user = (User *)[users objectAtIndex:indexPath.row];
	
	 [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.navigationController pushViewController:aController animated:YES];
	
}

- (void)tableView:(UITableView *)aTableView  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath { 
  [aTableView beginUpdates]; 
  if (editingStyle == UITableViewCellEditingStyleDelete) { 
		
    [aTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES]; 
		
    // Deletes the object on the resource
    [(User *)[users objectAtIndex:indexPath.row] destroyRemote];
    [users removeObjectAtIndex:indexPath.row];
  } 
  [aTableView endUpdates];   
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = ((ApplicationCell *)cell).useDarkBackground ? DARK_BACKGROUND : LIGHT_BACKGROUND;
}

- (CGFloat)tableView:(UITableView *)reviewTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	return 110;
}


- (void)fetchHandler {
//    [fetchBtn startAnimating];
    [self performSelectorInBackground:@selector(loadUsers) withObject:nil];
}



#pragma mark Table view methods

- (void)addFetchButton {
    CGRect frame = CGRectMake(0, 0, 320, 100);
	
    fetchBtn = [[FetchButtonView alloc] initWithFrame:frame];
    [fetchBtn addTarget:self action:@selector(fetchHandler) forControlEvents:UIControlEventTouchUpInside];
	
    //
    // Create a header view. Wrap it in a container to allow us to position
    // it better.
    //
    UIView *containerView =	[[[UIView alloc]	  initWithFrame:CGRectMake(0, 0, 300, 60)]	 autorelease];
    UILabel *headerLabel =	[[[UILabel alloc]	  initWithFrame:CGRectMake(10, 20, 300, 40)]	 autorelease];
    headerLabel.text = NSLocalizedString(@"Header for the table", @"");
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
    headerLabel.font = [UIFont boldSystemFontOfSize:22];
    headerLabel.backgroundColor = [UIColor clearColor];
    [containerView addSubview:headerLabel];
	
	self.tableView.tableFooterView = fetchBtn;
	
	NSLog(@"fetchbutton");
    //[commentsTableView.tableHeaderView addSubview:];
}



- (void)dealloc {
	[users release];
	[pagedArray release];
  [super dealloc];
}


@end

