//
//  MicroBlogOauthKey.m
//  NetEaseMicroBlog
//
//  Created by wuzhikun on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MicroBlogOauthKey.h"


@implementation MicroBlogOauthKey
@synthesize consumerKey;
@synthesize consumerSecret;
@synthesize tokenKey;
@synthesize tokenSecret;
@synthesize verify;
@synthesize callbackUrl;

- (void)dealloc
{
    [consumerKey release];
    [consumerSecret release];
    [tokenKey release];
    [tokenSecret release];
    [verify release];
    [callbackUrl release];
    [super dealloc];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"consumerKey:%@, consumerSecret:%@, tokenKey:%@, tokenSecret:%@, verify:%@, callbackUrl:%@", consumerKey, consumerSecret, tokenKey, tokenSecret, verify, callbackUrl];
}
@end
