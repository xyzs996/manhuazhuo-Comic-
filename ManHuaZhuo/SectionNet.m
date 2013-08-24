//
//  SectionNet.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 13-4-19.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SectionNet.h"
#import "URLUtility.h"
#import "JSON.h"
#import "HttpClient.h"
#import "SectionDAL.h"
#import "BookModel.h"

static SectionNet *instance;

@interface SectionNet ()

@property(nonatomic,retain)HttpClient *sectionlistClient;

@end


@implementation SectionNet

@synthesize sectionlistClient;

+(SectionNet *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[SectionNet alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    self.sectionlistClient=nil;
    [instance release];
    instance=nil;
    [super dealloc];
}

+(id)startDownloadSectionlist:(BookModel *)curBook
{
    NSString *url=[[SectionDAL sharedInstance] getSectionURLByBookID:curBook.bookID];

    [self sharedInstance].sectionlistClient=[[[HttpClient alloc] init] autorelease];
    id jsonData=[[[self sharedInstance].sectionlistClient getRequestFromUrl:url error:nil] JSONValue];
    
    return [[SectionDAL sharedInstance] parseSectionlistFromData:jsonData curBook:curBook];
}

+(void)cancelDownloadSectionlist
{
    [[self sharedInstance].sectionlistClient cancelRequest];
}

@end
