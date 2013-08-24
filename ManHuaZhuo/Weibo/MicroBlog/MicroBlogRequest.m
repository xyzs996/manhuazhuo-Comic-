//
//  MicroBlogRequest.m
//  NetEaseMicroBlog
//
//  Created by wuzhikun on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MicroBlogRequest.h"
#import "MicroBlogOauth.h"
#import "MicroBlogOauthKey.h"
#import "MicroBlogSyncHttp.h"
#import "MicroBlogAsyncHttp.h"

@implementation MicroBlogRequest
#pragma mark -
#pragma mark instance methods


+ (NSString *)syncRequestWithUrl:(NSString *)aUrl 
					  httpMethod:(NSString *)aHttpMethod 
						oauthKey:(MicroBlogOauthKey *)aOauthKey 
					  parameters:(NSDictionary *)aParameters 
						   files:(NSDictionary *)aFiles {
	
	if (!aUrl || [aUrl isEqualToString:@""] || !aHttpMethod || [aHttpMethod isEqualToString:@""]) {
		return	nil;
	}
	
	MicroBlogOauth *oauth = [[MicroBlogOauth alloc] init];
	
	NSString *queryString = nil;
	NSString *oauthUrl = [oauth	getOauthUrl:aUrl 
								 httpMethod:aHttpMethod 
								consumerKey:aOauthKey.consumerKey 
							 consumerSecret:aOauthKey.consumerSecret 
								   tokenKey:aOauthKey.tokenKey 
								tokenSecret:aOauthKey.tokenSecret 
									 verify:aOauthKey.verify 
								callbackUrl:aOauthKey.callbackUrl 
								 parameters:aParameters 
								queryString:&queryString];
    
	MicroBlogSyncHttp *http = [[MicroBlogSyncHttp alloc] init];
	NSString *retString = nil;
	if ([aHttpMethod isEqualToString:@"GET"]) {
		retString = [http httpGet:oauthUrl queryString:queryString];
	} else if (!aFiles || [aFiles count] == 0) {
		retString = [http httpPost:oauthUrl queryString:queryString];
	} else {
		retString = [http httpPostWithFile:aFiles url:oauthUrl queryString:queryString];
	}
	
	[oauth release];
	[http release];
	return retString;
}

+ (NSURLConnection *)asyncRequestWithUrl:(NSString *)aUrl 
							  httpMethod:(NSString *)aHttpMethod 
								oauthKey:(MicroBlogOauthKey *)aOauthKey 
							  parameters:(NSDictionary *)aParameters 
								   files:(NSDictionary *)aFiles 
								delegate:(id)aDelegate {
	
	if (!aUrl || [aUrl isEqualToString:@""] || !aHttpMethod || [aHttpMethod isEqualToString:@""]) {
		return	nil;
	}
	
	MicroBlogOauth *oauth = [[MicroBlogOauth alloc] init];
	
	NSString *queryString = nil;
	NSString *oauthUrl = [oauth	getOauthUrl:aUrl 
								 httpMethod:aHttpMethod 
								consumerKey:aOauthKey.consumerKey 
							 consumerSecret:aOauthKey.consumerSecret 
								   tokenKey:aOauthKey.tokenKey 
								tokenSecret:aOauthKey.tokenSecret 
									 verify:aOauthKey.verify 
								callbackUrl:aOauthKey.callbackUrl 
								 parameters:aParameters 
								queryString:&queryString];
    //NSLog(@"%@", queryString);
	MicroBlogAsyncHttp *http = [[MicroBlogAsyncHttp alloc] init];
	NSURLConnection *connection;
	if ([aHttpMethod isEqualToString:@"GET"]) {
		connection = [http httpGet:oauthUrl queryString:queryString delegate:aDelegate];
	} else if (!aFiles || [aFiles count] == 0) {
		connection = [http httpPost:oauthUrl queryString:queryString delegate:aDelegate];
	} else {
		connection = [http httpPostWithFile:aFiles url:oauthUrl queryString:queryString delegate:aDelegate];
	}
	
	[oauth release];
	[http release];
	
	return connection;
}





@end
