//
//  BookNet.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 13-4-26.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BookNet.h"
#import "URLUtility.h"
#import "JSON.h"
#import "HttpClient.h"
#import "SectionDAL.h"
#import "BookModel.h"
#import "BookDAL.h"
#import "ResponseModel.h"

static BookNet *instance;

@interface BookNet ()

@property(nonatomic,retain)HttpClient *recommandlistClient;

@end



@implementation BookNet

@synthesize recommandlistClient;

+(BookNet *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[BookNet alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    self.recommandlistClient=nil;
    [instance release];
    instance=nil;
    [super dealloc];
}

+(id)startRecommandlistByPage:(int)pageIndex pageSize:(int)pageSize
{
    NSString *url=[[BookDAL sharedInstance] getRecommandURL:pageIndex andPageSize:pageSize];
    
    [self sharedInstance].recommandlistClient=[[[HttpClient alloc] init] autorelease];
    id jsonData=[[[self sharedInstance].recommandlistClient getRequestFromUrl:url error:nil] JSONValue];
    
    
    ResponseModel *response=[[[ResponseModel alloc] init] autorelease];
    response.resultInfo=[[BookDAL sharedInstance] parseBooklist:jsonData];
    response.error=[self sharedInstance].recommandlistClient.error;
    return response;
}

+(void)cancelRecommandlist
{
    [[self sharedInstance].recommandlistClient cancelRequest];
}

@end
