

#import "MicroBlogAsyncHttp.h"
#import "MicroBlogMutableURLRequest.h"

@implementation MicroBlogAsyncHttp
- (NSURLConnection *)httpGet:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
	
	NSMutableURLRequest *request = [MicroBlogMutableURLRequest requestGet:aUrl queryString:aQueryString];
	return [NSURLConnection connectionWithRequest:request delegate:aDelegare]; 
	
}

- (NSURLConnection *)httpPost:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
	
	NSMutableURLRequest *request = [MicroBlogMutableURLRequest requestPost:aUrl queryString:aQueryString];
	return [NSURLConnection connectionWithRequest:request delegate:aDelegare];
}

- (NSURLConnection *)httpPostWithFile:(NSDictionary *)files url:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
	
	NSMutableURLRequest *request = [MicroBlogMutableURLRequest requestPostWithFile:files url:aUrl queryString:aQueryString];
	return [NSURLConnection connectionWithRequest:request delegate:aDelegare];
}

+ (NSURLConnection *)httpPostWithData:(NSData *)data url:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
	
	NSMutableURLRequest *request = [MicroBlogMutableURLRequest requestPostWithData:data url:aUrl queryString:aQueryString];
	return [NSURLConnection connectionWithRequest:request delegate:aDelegare];
}

+ (NSURLConnection *)httpPostWithImageData:(NSData *)imageData url:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare {
	
	NSMutableURLRequest *request = [MicroBlogMutableURLRequest requestPostWithImageData:imageData url:aUrl queryString:aQueryString];
	return [NSURLConnection connectionWithRequest:request delegate:aDelegare];
}

/*
+ (NSURLConnection *)httpPostWithDataAutoGzip:(NSData *)data url:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare
{
    NSMutableURLRequest *request = [MicroBlogMutableURLRequest requestPostWithDataAutoGzip:data url:aUrl queryString:aQueryString];
	return [NSURLConnection connectionWithRequest:request delegate:aDelegare];
}
*/
@end
