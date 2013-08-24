//
//  URLUtility.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define kHostURL @"http://manhuazhuocom.h02.000pc.net/ComicService/ComicHandle.ashx?"
#import "URLUtility.h"

static URLUtility *instance;
@implementation URLUtility

+(URLUtility *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[URLUtility alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    [instance release];
    [super dealloc];
}

-(NSString *)getURLFromParams:(NSDictionary *)params
{
    NSString *url=kHostURL;
    for(NSString *key in [params allKeys])
    {
        url=[url stringByAppendingFormat:@"%@=%@&",key,[params objectForKey:key]];
    }
    return [url substringToIndex:[url length]-1];
}

@end
