//
//  MicroBlogSyncHttp.h
//  NetEaseMicroBlog
//
//  Created by wuzhikun on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MicroBlogSyncHttp : NSObject {
    
}
//Do http get method and return the data received.
- (NSString *)httpGet:(NSString *)aUrl queryString:(NSString *)aQueryString;

//Do http post method and return the data received.
- (NSString *)httpPost:(NSString *)aUrl queryString:(NSString *)aQueryString;

//do http multi-part method and return the data received.
- (NSString *)httpPostWithFile:(NSDictionary *)files url:(NSString *)aUrl queryString:(NSString *)aQueryString;

- (NSString *)phoenixHttpPost:(NSString *)aUrl queryString:(NSString *)aQueryString;

@end
