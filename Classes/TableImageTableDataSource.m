//
//  SearchResultsTableDataSource.m
//
//  Created by Keith Lazuka on 7/23/09.
//  
//

#import "TableImageTableDataSource.h"
//#import "objective_resourceAppDelegate.h"
//#import "common.h"
//#import "User.h"


@implementation TableImageTableDataSource
//@synthesize users;

- (void)tableViewDidLoadModel:(UITableView *)tableView
{
    [super tableViewDidLoadModel:tableView];
    
    //NSLog(@"Removing all objects in the table view.");
    [self.items removeAllObjects];
    //[self loadUsers];

}


////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewDataSource protocol

- (UIImage*)imageForEmpty
{
	return [UIImage imageNamed:@"Three20.bundle/images/empty.png"];
}

- (UIImage*)imageForError:(NSError*)error
{
    return [UIImage imageNamed:@"Three20.bundle/images/error.png"];
}

@end
