//
//  Connection.m
//  
//
//  Created by Ryan Daigle on 7/30/08.
//  Copyright 2008 yFactorial, LLC. All rights reserved.
//

#import "Connection.h"
#import "GDataHTTPFetcher.h"
#import "Response.h"
#import "NSData+Additions.h"
#import "NSMutableURLRequest+ResponseType.h"
#import "ConnectionDelegate.h"
#import "ObjectiveResourceConfig.h"

#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )






















// THESE METHODS ARE DEPRECATED EXCEPT GDataHTTPFethcer overrides













@implementation Connection

static float timeoutInterval = 5.0;

static NSMutableArray *activeDelegates;


+ (NSMutableArray *)activeDelegates {
	if (nil == activeDelegates) {
		activeDelegates = [NSMutableArray array];
		[activeDelegates retain];
	}
	return activeDelegates;
}

+ (void)setTimeout:(float)timeOut {
	timeoutInterval = timeOut;
}
+ (float)timeout {
	return timeoutInterval;
}

+ (void)logRequest:(NSURLRequest *)request to:(NSString *)url {
	debugLog(@"ConnectionManager.m >%@ -> %@", [request HTTPMethod], url);
	if([request HTTPBody]) {
		debugLog([[[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding] autorelease]);
	}
}

+ (Response *)sendRequest:(NSMutableURLRequest *)request withUser:(NSString *)user andPassword:(NSString *)password {
	
	//lots of servers fail to implement http basic authentication correctly, so we pass the credentials even if they are not asked for
	//TODO make this configurable?
	NSURL *url = [request URL];
	if(user && password) {
		NSString *authString = [[[NSString stringWithFormat:@"%@:%@",user, password] dataUsingEncoding:NSUTF8StringEncoding] base64Encoding];
		[request addValue:[NSString stringWithFormat:@"Basic %@", authString] forHTTPHeaderField:@"Authorization"]; 
		NSString *escapedUser = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
																																								(CFStringRef)user, NULL, (CFStringRef)@"@.:", kCFStringEncodingUTF8);
		NSString *escapedPassword = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
																																										(CFStringRef)password, NULL, (CFStringRef)@"@.:", kCFStringEncodingUTF8);
		NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@://%@:%@@%@",[url scheme],escapedUser,escapedPassword,[url host],nil];
		if([url port]) {
			[urlString appendFormat:@":%@",[url port],nil];
		}
		[urlString appendString:[url path]];
		if([url query]){
			[urlString appendFormat:@"?%@",[url query],nil];
		}
		[request setURL:[NSURL URLWithString:urlString]];
		[escapedUser release];
		[escapedPassword release];
	}


	[self logRequest:request to:[url absoluteString]];
	
	ConnectionDelegate *connectionDelegate = [[[ConnectionDelegate alloc] init] autorelease];

	[[self activeDelegates] addObject:connectionDelegate];
	NSURLConnection *connection = [[[NSURLConnection alloc] initWithRequest:request delegate:connectionDelegate startImmediately:NO] autorelease];
	connectionDelegate.connection = connection;

	
	 // NSURLRequest *request2 = [NSURLRequest requestWithURL:url];
	//GDataHTTPFetcher* myFetcher = [GDataHTTPFetcher httpFetcherWithRequest:request2];
	//
	//  // optional post data
	//  [myFetcher setPostData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
	//
	//  // optional fetch history, for persisting modified-dates and local cookie
	//  // storage
	//  [myFetcher setFetchHistory:myFetchHistory];
	//
	/*  [myFetcher beginFetchWithDelegate:self
	                  didFinishSelector:@selector(myFetcher:finishedWithData:)
	                    didFailSelector:@selector(myFetcher:failedWithError:)];

	*/
	
	[[UIApplication sharedApplication]	setNetworkActivityIndicatorVisible:YES];
	
	//use a custom runloop
	static NSString *runLoopMode = @"com.yfactorial.objectiveresource.connectionLoop";
	[connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:runLoopMode];
	[connection start];
	while (![connectionDelegate isDone]) {
		[[NSRunLoop currentRunLoop] runMode:runLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:.3]];
	}
	Response *resp = [Response responseFrom:(NSHTTPURLResponse *)connectionDelegate.response 
								   withBody:connectionDelegate.data 
								   andError:connectionDelegate.error];
	[resp log];
	[[UIApplication sharedApplication]	setNetworkActivityIndicatorVisible:NO];
	
	
	
	[activeDelegates removeObject:connectionDelegate];
	
	//if there are no more active delegates release the array
	if (0 == [activeDelegates count]) {
		NSMutableArray *tempDelegates = activeDelegates;
		activeDelegates = nil;
		[tempDelegates release];
	}
	//Response *resp =[[Response alloc] init];
	return resp;
}

+ (Response *)sendBy:(NSString *)method withBody:(NSString *)body to:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithUrl:[NSURL URLWithString:url] andMethod:method];
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	return [self sendRequest:request withUser:user andPassword:password];
}



+ (Response *)post:(NSString *)body to:(NSString *)url {
	return [self post:body to:url withUser:@"X" andPassword:@"X"];
}


+ (Response *)post:(NSString *)body to:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password{
	return [self sendBy:@"POST" withBody:body to:url withUser:user andPassword:password];
}



+ (Response *)get:(NSString *)url {
	NSLog(@"Connection.m (Response *)get:(NSString *)url");
	return [self get:url withUser:@"X" andPassword:@"X"];
}

+ (Response *)get:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password {
		NSLog(@"Connection.m ((Response *)get:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password");
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithUrl:[NSURL URLWithString:url] andMethod:@"GET"];


	return [self sendRequest:request withUser:user andPassword:password];
}

+ (Response *)put:(NSString *)body to:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password{
	return [self sendBy:@"PUT" withBody:body to:url withUser:user andPassword:password];
}

+ (Response *)delete:(NSString *)url withUser:(NSString *)user andPassword:(NSString *)password {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithUrl:[NSURL URLWithString:url] andMethod:@"DELETE"];
	return [self sendRequest:request withUser:user andPassword:password];
}



+ (BOOL)beginPut:(NSString *)putString to:(NSString *)url  useAuth:(BOOL)bAuth
		didFinishSelector:(SEL)finishedSEL
		 didFailSelector:(SEL)failedSEL{
	return YES;
}
- (BOOL)beginDelete:(NSString *)url withUser:(NSString *)user useAuth:(BOOL)bAuth
		  didFinishSelector:(SEL)finishedSEL
			didFailSelector:(SEL)failedSEL{
	return YES;
}




+ (void) cancelAllActiveConnections {
	for (ConnectionDelegate *delegate in activeDelegates) {
		[delegate performSelectorOnMainThread:@selector(cancel) withObject:nil waitUntilDone:NO];
	}
}


// over ride the GDataHTTPFetcher
+ (void)myFetcher:(GDataHTTPFetcher *)fetcher finishedWithData:(NSData *)data {
	// got the data; display it in the image view
	//NSString *str = [[[NSString alloc] initWithData:data] autorelease];
	
	//NSLog(@"data:%@ :%@", fetcher, );  
	NSLog(@"data: %.*s", [data length], [data bytes]);
	[[UIApplication sharedApplication]	setNetworkActivityIndicatorVisible:NO];
	
}

+ (void)myFetcher:(GDataHTTPFetcher *)fetcher failedWithError:(NSError *)error {
	NSLog(@"myFetcher:%@ failedWithError:%@", fetcher,  error);      
	[[UIApplication sharedApplication]	setNetworkActivityIndicatorVisible:NO];
}


@end
