

#import <Foundation/Foundation.h>

@interface MicroBlogAsyncHttp : NSObject {
    
}
//Start a connection fro http get method and return it to delegate.
- (NSURLConnection *)httpGet:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare;

//Start a connection fro http post method and return it to delegate.
- (NSURLConnection *)httpPost:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare;

//Start a connection fro http multi-part method and return it to delegate.
- (NSURLConnection *)httpPostWithFile:(NSDictionary *)files url:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare;

+ (NSURLConnection *)httpPostWithData:(NSData *)data url:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare;
+ (NSURLConnection *)httpPostWithImageData:(NSData *)imageData url:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare;
/*
+ (NSURLConnection *)httpPostWithDataAutoGzip:(NSData *)data url:(NSString *)aUrl queryString:(NSString *)aQueryString delegate:(id)aDelegare;
 */
@end
