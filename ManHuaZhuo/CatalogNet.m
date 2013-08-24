//
//  CatalogNet.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 13-4-27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CatalogNet.h"
#import "URLUtility.h"
#import "JSON.h"
#import "HttpClient.h"
#import "SectionDAL.h"
#import "BookModel.h"
#import "BookDAL.h"
#import "ResponseModel.h"
#import "CatalogDAL.h"

static CatalogNet *instance;

@interface CatalogNet ()

@property(nonatomic,retain)HttpClient *catalistClient;

@end

@implementation CatalogNet

@synthesize catalistClient;

+(CatalogNet *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[CatalogNet alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    self.catalistClient=nil;
    [instance release];
    instance=nil;
    [super dealloc];
}

+(id)startAllCataloglist
{
    NSDictionary *params=[NSDictionary dictionaryWithObject:@"catalogs" forKey:@"method"];
    NSString *url= [[URLUtility sharedInstance] getURLFromParams:params];
    
    [self sharedInstance].catalistClient=[[[HttpClient alloc] init] autorelease];
    id jsonData=[[[self sharedInstance].catalistClient getRequestFromUrl:url error:nil] JSONValue];
    
    ResponseModel *response=[[[ResponseModel alloc] init] autorelease];
    response.resultInfo=[[CatalogDAL sharedInstance] parseCatalogs:jsonData];
    response.error=[self sharedInstance].catalistClient.error;
    return response;

}

@end
