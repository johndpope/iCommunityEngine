#import "ViewUserController.h"

#import "User.h"

@implementation ViewUserController
@synthesize user;


- (void)viewDidLoad {
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
																																												 target:self action:@selector(editUserButtonWasPressed)]; 
}

- (void)viewWillAppear:(BOOL)animated {
	self.title = user.displayName;
	[super viewWillAppear:animated];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"User";
	
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
  
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
  
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = user.displayName;
			break;
		case 1:
			cell.textLabel.text = user.userId;
			break;

	}
	// Configure the cell
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  	return [[NSArray arrayWithObjects:@"User's Name",@"Model Id",@"Booklists",nil] 
						objectAtIndex:section];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 2) {
		return indexPath;
	}
	return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


}



- (void)dealloc {
    [super dealloc];
}


@end

