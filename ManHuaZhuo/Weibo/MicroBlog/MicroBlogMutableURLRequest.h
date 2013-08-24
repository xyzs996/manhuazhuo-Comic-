

#import <Foundation/Foundation.h>
//#import "ASIFormDataRequest.h"


@interface MicroBlogMutableURLRequest : NSObject {
    
}
//Return a request for http get method
+ (NSMutableURLRequest *)requestGet:(NSString *)aUrl queryString:(NSString *)aQueryString;

//Return a request for http post method
+ (NSMutableURLRequest *)requestPost:(NSString *)aUrl queryString:(NSString *)aQueryString;

//Return a request for http post with multi-part method
+ (NSMutableURLRequest *)requestPostWithFile:(NSDictionary *)files url:(NSString *)aUrl queryString:(NSString *)aQueryString;

+ (NSMutableURLRequest *)phoenixRequestPost:(NSString *)aUrl queryString:(NSString *)aQueryString;

+ (NSMutableURLRequest *)requestPostWithData:(NSData *)data url:(NSString *)aUrl queryString:(NSString *)aQueryString;
+ (NSMutableURLRequest *)requestPostWithImageData:(NSData *)data url:(NSString *)aUrl queryString:(NSString *)aQueryString;
//+ (NSMutableURLRequest *)requestPostWithDataAutoGzip:(NSData *)data url:(NSString *)aUrl queryString:(NSString *)aQueryString;
@end
