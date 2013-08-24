//
//  MicroBlogSyncHttp.m
//  NetEaseMicroBlog
//
//  Created by wuzhikun on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MicroBlogSyncHttp.h"
#import "MicroBlogMutableURLRequest.h"

@implementation MicroBlogSyncHttp
#pragma mark -
#pragma mark private methods

- (NSString *)getResponseWithRequest:(NSURLRequest *)request {
	
	NSURLResponse *response = nil;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	NSString *retString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	//NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	
	//NSLog(@"response code:%d string:%@", httpResponse.statusCode, retString);
	
	return retString;
}

#pragma mark -
#pragma mark instance methods

- (NSString *)httpGet:(NSString *)aUrl queryString:(NSString *)aQueryString {
	
	NSMutableURLRequest *request = [MicroBlogMutableURLRequest requestGet:aUrl queryString:aQueryString];
	return [self getResponseWithRequest:request];
}

- (NSString *)phoenixHttpPost:(NSString *)aUrl queryString:(NSString *)aQueryString {
    NSMutableURLRequest *request = [MicroBlogMutableURLRequest phoenixRequestPost:aUrl queryString:aQueryString];
	return [self getResponseWithRequest:request];
}

- (NSString *)httpPost:(NSString *)aUrl queryString:(NSString *)aQueryString {
	
	NSMutableURLRequest *request = [MicroBlogMutableURLRequest requestPost:aUrl queryString:aQueryString];
	return [self getResponseWithRequest:request];
}

- (NSString *)httpPostWithFile:(NSDictionary *)files url:(NSString *)aUrl queryString:(NSString *)aQueryString {
	
	NSMutableURLRequest *request = [MicroBlogMutableURLRequest requestPostWithFile:files url:aUrl queryString:aQueryString];
	return [self getResponseWithRequest:request];
}

@end
