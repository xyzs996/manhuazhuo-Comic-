//
//  SectionDAL.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SectionDAL.h"
#import "URLUtility.h"
#import "SectionModel.h"
#import "TFHpple.h"
#import "FileHelper.h"

static SectionDAL *instance;

@interface SectionDAL ()
{}

-(int)getPageFromSectionURL:(NSString *)sectionURL;
@end
@implementation SectionDAL

+(SectionDAL *)sharedInstance
{
    if(instance==nil)
    {
         
        instance=[[SectionDAL alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    [instance release];
    [super dealloc];
}



-(NSString *)getSectionURLByBookID:(NSString *)bookID
{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"sectionlist",@"method",bookID,@"bookid", nil];
    return [[URLUtility sharedInstance] getURLFromParams:params];
}

-(NSMutableDictionary *)parseSectionlistFromData:(id)sectionData curBook:(BookModel *)bookData
{
    NSMutableDictionary *sectionlist=nil;
    if([sectionData isKindOfClass:[NSArray class]])
    {

        sectionlist=[[[NSMutableDictionary alloc] init] autorelease];
        for(id sec in sectionData)
        {
            if([sec isKindOfClass:[NSDictionary class]])
            {
                SectionModel *section=[[SectionModel alloc] init];
                section.sectionID=[[sec objectForKey:@"SectionID"] description];
//                NSLog(@" section.sectionID=%@", [section.sectionID class]);
                section.sectionName=[sec objectForKey:@"SectionName"];
                section.sectionURL=[sec objectForKey:@"SectionLinkURL"];
                section.picCount=[[sec objectForKey:@"PicCount"] intValue];
                section.className=[sec objectForKey:@"PictureClassName"];
                section.bookID=[sec objectForKey:@"BookID"];
                section.bookName=[sec objectForKey:@"BookName"];
                section.sectionDownloadState=[[SectionDownloadManager sharedInstance] getStateBySectionModel:section];

                //bookInfo
                if([bookData isKindOfClass:[BookModel class]])
                {
                    BookModel *bookModel=(BookModel *)bookData;
                    section.bookName=bookModel.bookName;
                    section.author=bookModel.author;
                    section.bookIconURL=bookModel.bookIconURL;
                    section.bookID=[bookModel.bookID description];
                    section.bookIntro=bookModel.bookIntro;
                }
                [sectionlist setObject:section forKey:section.sectionID];
                [section release];
            }
        }
    }
    return sectionlist;
}

-(int)getPageFromSectionURL:(NSString *)sectionURL
{
    NSString *pagePath=@"//html/body/div[5]/select";
    TFHpple *htmlParser=[[TFHpple alloc] initWithHTMLData:[NSData dataWithContentsOfURL:[NSURL URLWithString:sectionURL]]];
    NSArray *pageNodes=[htmlParser searchWithXPathQuery:pagePath];
    int page=0;
    for(TFHppleElement *element in pageNodes)
    {
        //        for(TFHppleElement *subElement in element.children)
        //        {
        //            NSLog(@"%@\n",subElement.tagName);
        //        }
        page=[element.children count];
        break;
    }
    [htmlParser release];
    return page;
}

-(NSMutableArray *)getFinishedSectionByGroupName:(NSString *)groupName withBookName:(NSString *)bookName
{
    NSMutableArray *sectionlist=[[[NSMutableArray alloc] init] autorelease];
    NSString *path=[[kDownloadedPath stringByAppendingPathComponent:groupName] stringByAppendingPathComponent:bookName];
    NSMutableArray *tmplist=[[FileHelper sharedInstance] getFilelistByPath:path onlyDirectory:YES];
    NSString *secConfigPath=nil;
    for(NSString *secName in tmplist)
    {
        secConfigPath=[[path stringByAppendingPathComponent:secName] stringByAppendingPathComponent:kSectionConfigName];
        if([[FileHelper sharedInstance] isExistPath:secConfigPath])
        {
            [sectionlist addObject:[[FileHelper sharedInstance]unArchiverModel:secConfigPath]];
        }
    }
    return sectionlist;
}
@end
