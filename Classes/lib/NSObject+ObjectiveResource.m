//
//  NSObject+ObjectiveResource.m
//  objectivesync
//
//  Created by vickeryj on 1/29/09.
//  Copyright 2009 Joshua Vickery. All rights reserved.
//

#import "NSObject+ObjectiveResource.h"
#import "Connection.h"
#import "Response.h"
#import "CoreSupport.h"
#import "XMLSerializableSupport.h"
#import "JSONSerializableSupport.h"
#import "GDataHTTPFetcher.h"
//#import "GDataHTTPFetcherLogging.h"
#import "ObjectiveResourceConfig.h"



//JP
static NSString *_activeResourceSite = nil;
static NSString *_activeResourceUser = nil;
static NSString *_activeResourcePassword = nil;
static SEL _activeResourceParseDataMethod = nil;
static SEL _activeResourceSerializeMethod = nil;
static NSString *_activeResourceProtocolExtension = @".xml";
static ORSResponseFormat _format;
static NSString *_activeResourcePrefix = nil;
static NSString* const kFetcherFinishedSelectorKey = @"_finishedSelector";
static NSString* const kFetcherFinishedDelegateKey = @"_finishedDelegate";




@implementation NSObject (ObjectiveResource)

#pragma mark configuration methods
+ (NSString *)getRemoteSite {
	return _activeResourceSite;
}

+ (void)setRemoteSite:(NSString *)siteURL {
	if (_activeResourceSite != siteURL) {
		[_activeResourceSite autorelease];
		_activeResourceSite = [siteURL copy];
	}
}

+ (NSString *)getRemoteUser {
	return _activeResourceUser;
}

+ (void)setRemoteUser:(NSString *)user {
	if (_activeResourceUser != user) {
		[_activeResourceUser autorelease];
		_activeResourceUser = [user copy];
	}
}

+ (NSString *)getRemotePassword {
	return _activeResourcePassword;
}

+ (void)setRemotePassword:(NSString *)password {
	if (_activeResourcePassword != password) {
		[_activeResourcePassword autorelease];
		_activeResourcePassword = [password copy];
	}
}

+ (void)setRemoteResponseType:(ORSResponseFormat) format {
	_format = format;
	switch (format) {
		case JSONResponse:
			[[self class] setRemoteProtocolExtension:@".json"];
			[[self class] setRemoteParseDataMethod:@selector(fromJSONData:)];
			[[self class] setRemoteSerializeMethod:@selector(toJSONExcluding:)];
			break;
		default:
			[[self class] setRemoteProtocolExtension:@".xml"];
			[[self class] setRemoteParseDataMethod:@selector(fromXMLData:)];
			[[self class] setRemoteSerializeMethod:@selector(toXMLElementExcluding:)];
			break;
	}
}

+ (ORSResponseFormat)getRemoteResponseType {
	return _format;
}

+ (SEL)getRemoteParseDataMethod {
	NSLog(@"getRemoteParseDataMethod");
	return (nil == _activeResourceParseDataMethod) ? @selector(fromXMLData:) : _activeResourceParseDataMethod;
}

+ (void)setRemoteParseDataMethod:(SEL)parseMethod {
	_activeResourceParseDataMethod = parseMethod;
}

+ (SEL) getRemoteSerializeMethod {
	return (nil == _activeResourceSerializeMethod) ? @selector(toXMLElementExcluding:) : _activeResourceSerializeMethod;
}

+ (void) setRemoteSerializeMethod:(SEL)serializeMethod {
	_activeResourceSerializeMethod = serializeMethod;
}

+ (NSString *)getRemoteProtocolExtension {
	return _activeResourceProtocolExtension;
}

+ (void)setRemoteProtocolExtension:(NSString *)protocolExtension {
	if (_activeResourceProtocolExtension != protocolExtension) {
		[_activeResourceProtocolExtension autorelease];
		_activeResourceProtocolExtension = [protocolExtension copy];
	}
}

// Prefix additions
+ (NSString *)getLocalClassesPrefix {
	return _activeResourcePrefix;
}

+ (void)setLocalClassesPrefix:(NSString *)prefix {
	if (prefix != _activeResourcePrefix) {
		[_activeResourcePrefix autorelease];
		_activeResourcePrefix = [prefix copy];
	}
}





// Find all items 
+ (NSArray *)findAllRemoteWithResponse:(NSError **)aError {
	Response *res = [Connection get:[self getRemoteCollectionPath] withUser:[[self class] getRemoteUser] andPassword:[[self class]  getRemotePassword]];
	if([res isError] && aError) {
		*aError = res.error;
		return nil;
	}
	else {
		return [self performSelector:[self getRemoteParseDataMethod] withObject:res.body];
	}
}

+ (NSArray *)findAllRemote {
	NSError *aError;
	return [self findAllRemoteWithResponse:&aError];
}

+ (id)findRemote:(NSString *)elementId withResponse:(NSError **)aError {
	NSLog(@"elementId  %s", elementId);
	Response *res = [Connection get:[self getRemoteElementPath:elementId] withUser:[[self class] getRemoteUser] andPassword:[[self class]  getRemotePassword]];
	if([res isError] && aError) {
		*aError = res.error;
	}
	return [self performSelector:[self getRemoteParseDataMethod] withObject:res.body];
}



+ (id)findRemote:(NSString *)elementId {
	NSError *aError;
	return [self findRemote:elementId withResponse:&aError];
}

+ (NSString *)getRemoteElementName {
	NSString * remoteElementName = NSStringFromClass([self class]);
	if (_activeResourcePrefix != nil) {
		remoteElementName = [remoteElementName substringFromIndex:[_activeResourcePrefix length]];
	}
	return [[remoteElementName stringByReplacingCharactersInRange:NSMakeRange(0, 1) 
													   withString:[[remoteElementName substringWithRange:NSMakeRange(0, 1)] 
																   lowercaseString]] 
			underscore];
}

+ (NSString *)getRemoteCollectionName {
	return [[self getRemoteElementName] stringByAppendingString:@"s"];
}

+ (NSString *)getRemoteElementPath:(NSString *)elementId {
	return [NSString stringWithFormat:@"%@%@/%@%@", [self getRemoteSite], [self getRemoteCollectionName], elementId, [self getRemoteProtocolExtension]];
}

+ (NSString *)getRemoteCollectionPath {
	
	
	return [[[self getRemoteSite] stringByAppendingString:[self getRemoteCollectionName]] stringByAppendingString:[self getRemoteProtocolExtension]];
}

+ (NSString *)getRemoteCollectionPathWithParameters:(NSDictionary *)parameters {
	return [self populateRemotePath:[self getRemoteCollectionPath] withParameters:parameters];
}	

+ (NSString *)populateRemotePath:(NSString *)path withParameters:(NSDictionary *)parameters {
	
	// Translate each key to have a preceeding ":" for proper URL param notiation
	NSMutableDictionary *parameterized = [NSMutableDictionary dictionaryWithCapacity:[parameters count]];
	for (NSString *key in parameters) {
		[parameterized setObject:[parameters objectForKey:key] forKey:[NSString stringWithFormat:@":%@", key]];
	}
	return [path gsub:parameterized];
}

- (NSString *)getRemoteCollectionPath {
	return [[self class] getRemoteCollectionPath];
}

// Converts the object to the data format expected by the server
- (NSString *)convertToRemoteExpectedType {	  
	return [self performSelector:[[self class] getRemoteSerializeMethod] withObject:[self excludedPropertyNames]];
}


#pragma mark default equals methods for id and class based equality
- (BOOL)isEqualToRemote:(id)anObject {
	return 	[NSStringFromClass([self class]) isEqualToString:NSStringFromClass([anObject class])] &&
	[anObject respondsToSelector:@selector(getRemoteId)] && [[anObject getRemoteId]isEqualToString:[self getRemoteId]];
}
- (NSUInteger)hashForRemote {
	return [[self getRemoteId] intValue] + [NSStringFromClass([self class]) hash];
}

#pragma mark Instance-specific methods
- (id)getRemoteId {
	id result = nil;
	SEL idMethodSelector = NSSelectorFromString([self getRemoteClassIdName]);
	if ([self respondsToSelector:idMethodSelector]) {
		result = [self performSelector:idMethodSelector];
		if ([result respondsToSelector:@selector(stringValue)]) {
			result = [result stringValue];
		}
	}
	return result;
}
- (void)setRemoteId:(id)orsId {
	SEL setter = NSSelectorFromString([NSString stringWithFormat:@"set%@Id:",[self className]]);
	if ([self respondsToSelector:setter]) {
		[self performSelector:setter withObject:orsId];
	}
}


- (NSString *)getRemoteClassIdName {
	NSString * remoteElementName = NSStringFromClass([self class]);
	if (_activeResourcePrefix != nil) {
		remoteElementName = [remoteElementName substringFromIndex:[_activeResourcePrefix length]];
	}
	return [NSString stringWithFormat:@"%@Id", 
			[remoteElementName stringByReplacingCharactersInRange:NSMakeRange(0, 1) 
													   withString:[[remoteElementName substringWithRange:NSMakeRange(0,1)] lowercaseString]]];
}

- (BOOL)createRemoteAtPath:(NSString *)path withResponse:(NSError **)aError {
	NSLog(@"createRemoteAtPath: %@",path);
	Response *res = [Connection post:[self convertToRemoteExpectedType] to:path withUser:[[self class]  getRemoteUser] andPassword:[[self class]  getRemotePassword]];
	if([res isError] && aError) {
		*aError = res.error;
	}
	if ([res isSuccess]) {
		NSDictionary *newProperties = [[[self class] performSelector:[[self class] getRemoteParseDataMethod] withObject:res.body] properties];
		[self setProperties:newProperties];
		return YES;
	}
	else {
		return NO;
	}
}

-(BOOL)updateRemoteAtPath:(NSString *)path withResponse:(NSError **)aError {	
	Response *res = [Connection put:[self convertToRemoteExpectedType] to:path 
						   withUser:[[self class]  getRemoteUser] andPassword:[[self class]  getRemotePassword]];
	if([res isError] && aError) {
		*aError = res.error;
	}
	if ([res isSuccess]) {
		if([(NSString *)[res.headers objectForKey:@"Content-Length"] intValue] > 1) {
			NSDictionary *newProperties = [[[self class] performSelector:[[self class] getRemoteParseDataMethod] withObject:res.body] properties];
			[self setProperties:newProperties];
		}
		return YES;
	}
	else {
		return NO;
	}

}

- (BOOL)destroyRemoteAtPath:(NSString *)path withResponse:(NSError **)aError {
	Response *res = [Connection delete:path withUser:[[self class]  getRemoteUser] andPassword:[[self class]  getRemotePassword]];
	if([res isError] && aError) {
		*aError = res.error;
	}
	return [res	isSuccess];
}

- (BOOL)createRemoteWithResponse:(NSError **)aError {
	return [self createRemoteAtPath:[self getRemoteCollectionPath] withResponse:aError];	
}

- (BOOL)createRemote {
	NSError *error;
	return [self createRemoteWithResponse:&error];
}

- (BOOL)createRemoteWithParameters:(NSDictionary *)parameters andResponse:(NSError **)aError {
	return [self createRemoteAtPath:[[self class] getRemoteCollectionPathWithParameters:parameters] withResponse:aError];
}

- (BOOL)createRemoteWithParameters:(NSDictionary *)parameters {
	NSError *error;
	return [self createRemoteWithParameters:parameters andResponse:&error];
}


- (BOOL)destroyRemoteWithResponse:(NSError **)aError {
	id myId = [self getRemoteId];
	if (nil != myId) {
		return [self destroyRemoteAtPath:[[self class] getRemoteElementPath:myId] withResponse:aError];
	}
	else {
		// this should return a error
		return NO;
	}
}

- (BOOL)destroyRemote {
	NSError *error;
	return [self destroyRemoteWithResponse:&error];
}

- (BOOL)updateRemoteWithResponse:(NSError **)aError {
	id myId = [self getRemoteId];
	if (nil != myId) {
		return [self updateRemoteAtPath:[[self class] getRemoteElementPath:myId] withResponse:aError];
	}
	else {
		// this should return an error
		return NO;
	}
}

- (BOOL)updateRemote {
	NSError *error;
	return [self updateRemoteWithResponse:&error];
}

- (BOOL)saveRemoteWithResponse:(NSError **)aError {
	id myId = [self getRemoteId];
	if (nil == myId) {
		return [self createRemoteWithResponse:aError];
	}
	else {
		return [self updateRemoteWithResponse:aError];
	}
}

- (BOOL)saveRemote {
	NSError *error;
	return [self saveRemoteWithResponse:&error];
}


















// G O O G L E    S T Y L E    C A L L B A C K

NSString *warningString  = @"FATAL: use the instance of model not static class. eg. [user findRemoteWithCallback .... ] NOT [User...] ";

- (void)findRemoteWithCallback:(SEL)finishedSelector  delegate:(id)finishedDelegate {
	[[self class] findRemoteWithCallback:finishedSelector  delegate:finishedDelegate];
}

- (void)findRemoteWithCallback:(SEL)finishedSelector  delegate:(id)finishedDelegate params:(NSString *)strPage{
	[[self class] findRemoteWithCallback:finishedSelector  delegate:finishedDelegate params:strPage ];
}


+ (void)createRemoteWithCallback:(SEL)finishedSelector  delegate:(id)finishedDelegate {
	NSLog(warningString);
}
+ (void)saveRemoteWithCallback:(SEL)finishedSelector  delegate:(id)finishedDelegate {
	NSLog(warningString);
}
+ (void)updateRemoteWithCallback:(SEL)finishedSelector  delegate:(id)finishedDelegate {

}
+ (void)destroyRemoteWithCallback:(SEL)finishedSelector  delegate:(id)finishedDelegate  path:(NSString *)path {
	NSLog(warningString);
}

	 
	 
-(GDataHTTPFetcher*)addAuthenticationToFetcher:(GDataHTTPFetcher *)fetcher {
 NSString *username = [ObjectiveResourceConfig getUser];
 NSString *password = [ObjectiveResourceConfig getPassword];
 
 if ([username length] > 0 && [password length] > 0) {
	 // We're avoiding +[NSURCredential credentialWithUser:password:persistence:]
	 // because it fails to autorelease itself on OS X 10.4 .. 10.5.x
	 // rdar://5596278
	 
	 NSURLCredential *cred;
	 cred = [[[NSURLCredential alloc] initWithUser:username
										  password:password
									   persistence:NSURLCredentialPersistenceForSession] autorelease];
	 [fetcher setCredential:cred];
	 return fetcher;
 }
	 return fetcher;
}

// allow user to call this from static method eg. [User findRemoteWithCallback..]
+(void)findRemoteWithCallback:(SEL)finishedSelector  delegate:(id)finishedDelegate params:(NSString*)p{
	
	NSLog(@"getRemoteCollectionPath  %@", [NSString stringWithFormat:@"%@",[self getRemoteCollectionPath]]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[self getRemoteCollectionPath],p]] andMethod:@"GET"];
	GDataHTTPFetcher* myFetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
	
	myFetcher = [self addAuthenticationToFetcher:myFetcher];
	[myFetcher setProperty:NSStringFromSelector(finishedSelector)
					forKey:kFetcherFinishedSelectorKey];
	[myFetcher setProperty:finishedDelegate
					forKey:kFetcherFinishedDelegateKey];
	NSLog(@"finishedDelegate %@",finishedDelegate);
	[myFetcher setShouldCacheDatedData:YES];
	//[myFetcher setIsLoggingEnabled:YES]; // TURN OFF LATER
	
	[myFetcher beginFetchWithDelegate:self
					didFinishSelector:@selector(myFetcher:finishedWithData:)
					  didFailSelector:@selector(myFetcher:failedWithError:)];
	
}


-(void)saveRemoteWithCallback:(SEL)finishedSelector  delegate:(id)finishedDelegate {
	
	
	id myId = [self getRemoteId];
	if (nil == myId) {
		[self createRemoteWithCallback:finishedSelector delegate:finishedDelegate];
	}
	else {
		[self  updateRemoteWithCallback:finishedSelector delegate:finishedDelegate];
	}
	
}
// don't fully understand why rootElementPath is not responding sometimes. 
// remoteElementPath http://192.168.0.15/users/1/booklists.xml
-(void)createRemoteWithCallback:(SEL)finishedSelector  delegate:(id)finishedDelegate {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[self getRemoteCollectionPath]]];
	

	NSLog(@"createRemoteWithCallBack  %@", [NSString stringWithFormat:@"%@",[self getRemoteCollectionPath]]);

	
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithUrl:url andMethod:@"POST"];
	GDataHTTPFetcher* myFetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
	myFetcher = [self addAuthenticationToFetcher:myFetcher];
	NSString *xmlString = [self convertToRemoteExpectedType];
	NSData *xmlBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
	[myFetcher setPostData:xmlBody];
	

	[myFetcher setProperty:NSStringFromSelector(finishedSelector)
					forKey:kFetcherFinishedSelectorKey];
	[myFetcher setProperty:finishedDelegate
					forKey:kFetcherFinishedDelegateKey];
	NSLog(@"finishedDelegate %@",finishedDelegate);
	
	
	[myFetcher beginFetchWithDelegate:self
				 didFinishSelector:@selector(myFetcher:finishedWithData:)
				 didFailSelector:@selector(myFetcher:failedWithError:)];
		
}
-(void)updateRemoteWithCallback:(SEL)finishedSelector  delegate:(id)finishedDelegate {
	
	NSLog(@"updateRemoteWithCallBack  %@", [NSString stringWithFormat:@"%@",[self getRemoteCollectionPath]]);
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self getRemoteCollectionPath]]] andMethod:@"PUT"];
	GDataHTTPFetcher* myFetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
	NSString *xmlString = [self convertToRemoteExpectedType];
	NSData *xmlBody = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
	[myFetcher setPostData:xmlBody];
	 myFetcher = [self addAuthenticationToFetcher:myFetcher];

	
	[myFetcher setProperty:NSStringFromSelector(finishedSelector)
					forKey:kFetcherFinishedSelectorKey];
	[myFetcher setProperty:finishedDelegate
					forKey:kFetcherFinishedDelegateKey];
	NSLog(@"finishedDelegate %@",finishedDelegate);
	
	
	[myFetcher beginFetchWithDelegate:self
					didFinishSelector:@selector(myFetcher:finishedWithData:)
					didFailSelector:@selector(myFetcher:failedWithError:)];
	
}
- (void)destroyRemoteWithCallback:(SEL)finishedSelector  delegate:(id)finishedDelegate  {
	NSLog(@"destroyRemoteWithCallback  %@", [NSString stringWithFormat:@"%@",[self getRemoteCollectionPath]]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self getRemoteCollectionPath]]] andMethod:@"DELETE"];
	
	GDataHTTPFetcher* myFetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
	 myFetcher = [self addAuthenticationToFetcher:myFetcher];
	
	
	[myFetcher setProperty:NSStringFromSelector(finishedSelector)
					forKey:kFetcherFinishedSelectorKey];
	[myFetcher setProperty:finishedDelegate
					forKey:kFetcherFinishedDelegateKey];
	NSLog(@"finishedDelegate %@",finishedDelegate);
	
	
	[myFetcher beginFetchWithDelegate:self
					didFinishSelector:@selector(myFetcher:finishedWithData:)
					  didFailSelector:@selector(myFetcher:failedWithError:)];
	
}





-(void)myFetcher:(GDataHTTPFetcher *)fetcher finishedWithData:(NSData *)data {
	
		
	
	//NSLog(@"data: %.*s", [data length], [data bytes]);
	[[UIApplication sharedApplication]	setNetworkActivityIndicatorVisible:NO];
	//[fetcher response]
	//unpack selectors / delegates
	NSString *finishedSelectorStr = [fetcher propertyForKey:kFetcherFinishedSelectorKey];
	SEL finishedSelector = finishedSelectorStr ? NSSelectorFromString(finishedSelectorStr) : NULL;
	id finishedDelegate = [fetcher propertyForKey:kFetcherFinishedDelegateKey];
	NSLog(@"finishedSelector: %@", NSStringFromSelector(finishedSelector));
	NSLog(@"finishedDelegate: %@", finishedDelegate);
	
	NSArray *results = [self performSelector:[self getRemoteParseDataMethod] withObject:data];
	

	if ([results count] == 0) 
	{
		NSLog(@"couldn't process data:  %.*s", [data length], [data bytes]);
	}else {
		NSLog(@"array: %.*s", [data length], [data bytes]);
		[finishedDelegate performSelector:finishedSelector withObject:results];
	}



	
}



- (void)myFetcher:(GDataHTTPFetcher *)fetcher failedWithError:(NSError *)error {
	NSLog(@"myFetcher:%@ failedWithError:%@", fetcher,  error);      
	//[[UIApplication sharedApplication]	setNetworkActivityIndicatorVisible:NO];
	//NSArray *results = [self performSelector:[self getRemoteParseDataMethod] withObject:[fetcher response]];
	//NSLog(@"error data: %@", results);
	NSLog(@"error data: %@", [fetcher response] );
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"oops something went wrong." message:[error localizedDescription]
 												   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[alert show];
	[alert release];
	
	
}




/*
 Override this in your model class to extend or replace the excluded properties
 eg.
 - (NSArray *)excludedPropertyNames
 {
 NSArray *exclusions = [NSArray arrayWithObjects:@"extraPropertyToExclude", nil];
 return [[super excludedPropertyNames] arrayByAddingObjectsFromArray:exclusions];
 }
 */

- (NSArray *)excludedPropertyNames
{
	// exclude id , created_at , updated_at
	return [NSArray arrayWithObjects:[self getRemoteClassIdName],@"createdAt",@"updatedAt",nil]; 
}


@end
