#import "User.h"
#import "ObjectiveResource.h"

@implementation User
@synthesize createdAt, updatedAt;
@synthesize userId,timeZone,description,displayName,countryId,lastLoginAt,gender,imgUrl;


// handle pluralization 
+ (NSString *)getRemoteCollectionName {
	return @"users";
}



// this will go to the url http://localhost:3000/users/<id>/booklists
// and return the array of booklists
/*-(NSArray *) findAllBooklists {
	return [Booklist findRemote:[NSString stringWithFormat:@"%@/%@",userId,@"booklists",nil]];
}

-(NSArray *) findAllBooklistsWithResponse:(NSError **)aError {
	return [Booklist findRemote:[NSString stringWithFormat:@"%@/%@",userId,@"booklists",nil] withResponse:aError];
}
*/
- (void) dealloc
{
  [createdAt release];
  [updatedAt release];
  [userId release];
  [description release];	
  [timeZone release];
  [displayName release];
  [countryId  release];
  [lastLoginAt  release];
  [gender release];
  [imgUrl release];
  [super dealloc];
}

@end
