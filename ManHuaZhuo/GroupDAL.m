//
//  GroupDAL.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GroupDAL.h"
#import "FileHelper.h"
#import "Constants.h"
#import "SectionModel.h"

static GroupDAL *instance;

@implementation GroupDAL

+(GroupDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[GroupDAL alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    [instance release];
    [super dealloc];
}

-(NSString *)getGroupRootPath
{
    return kDownloadedPath;
}

-(NSMutableArray *)getLocalGroup
{
    NSString *groupPath=kDownloadedPath;
    return [[FileHelper sharedInstance] getFilelistByPath:groupPath onlyDirectory:YES];
}

-(NSMutableArray *)getLocalBooksByGroupName:(NSString *)groupName
{
    NSString *rootPath=[kDownloadedPath stringByAppendingPathComponent:groupName];
    NSMutableArray *bookDirectorylist=[[FileHelper sharedInstance] getFilelistByPath:rootPath onlyDirectory:YES];
    NSMutableArray *booklist=[[[NSMutableArray alloc] init] autorelease];
    for(NSString *bookName in bookDirectorylist)
    {
        NSString *bookConfigPath=[[rootPath stringByAppendingPathComponent:bookName] stringByAppendingPathComponent:kBookConfigName];
        SectionModel *sectionDownModel=[[FileHelper sharedInstance] unArchiverModel:bookConfigPath];
        [booklist addObject:sectionDownModel];
    }
    return booklist;
}


@end
