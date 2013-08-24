//
//  VersionNet.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 13-4-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "VersionNet.h"
#import "URLUtility.h"
#import "HttpClient.h"

@implementation VersionNet

+(NSString *)startCheckVersion
{
    NSString *url=[[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObject:@"version" forKey:@"method"]];
    HttpClient *client=[[[HttpClient alloc] init] autorelease];
    return [client postRequestFromUrl:url error:nil];

}

@end
