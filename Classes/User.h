#import "ObjectiveResource.h"

@interface User : NSObject {
	
	
  NSString *timeZone,*displayName,*description,*countryId,*lastLoginAt,*gender,*imgUrl;
	
	
  NSString *userId;
  NSDate   *updatedAt;
  NSDate   *createdAt;
  
}

@property (nonatomic , retain) NSDate * createdAt;
@property (nonatomic , retain) NSDate * updatedAt;
@property (nonatomic , retain)  NSString  *userId;
@property (nonatomic , retain)  NSString *timeZone,*description,*displayName,*countryId,*lastLoginAt,*gender,*imgUrl;



//-(NSArray *) findAllBooklists;
//-(NSArray *) findAllBooklistsWithResponse:(NSError **)aError;
@end
