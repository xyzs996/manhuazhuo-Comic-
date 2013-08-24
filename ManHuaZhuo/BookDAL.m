//
//  BookDAL.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BookDAL.h"
#import "URLUtility.h"
#import "BookModel.h"
#import "SectionModel.h"
#import "FileHelper.h"

//浏览历史路径
#define kHistoryPath [[NSHomeDirectory()stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"bookhistory.plist"]

static BookDAL *instance;

@implementation BookDAL

+(BookDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[BookDAL alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    [instance release];
    [super dealloc];
}

-(NSString *)getSearchURLByAuthorName:(NSString *)authorName
{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"search",@"method",authorName,@"name",@"1",@"type",nil];
    return [[URLUtility sharedInstance] getURLFromParams:params];
}

-(NSString *)getSearchURLByBookName:(NSString *)bookName
{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"search",@"method",bookName,@"name",@"0",@"type",nil];
    return [[URLUtility sharedInstance] getURLFromParams:params];
}

-(NSString *)getBooklistByCataID:(NSString *)cataID pageIndex:(int)pageIndex pageSize:(int)pageSize bookState:(int)bookState order:(int)order
{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys: @"booklist",@"method",
                          cataID, @"cataID",
                          [NSString stringWithFormat:@"%d",pageIndex],@"pageIndex",
                          [NSString stringWithFormat:@"%d",pageSize],@"pageSize",
                          [NSString stringWithFormat:@"%d",bookState],@"state",
                          [NSString stringWithFormat:@"%d",order],@"order",nil];
    
    return [[URLUtility sharedInstance] getURLFromParams:params];
}

-(NSString *)getKeylistURL:(NSString *)key
{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"getkey",@"method",key,@"key",nil];
    return [[URLUtility sharedInstance] getURLFromParams:params];
}

-(NSString *)getlinkBookByAuthor:(NSString *)author bookID:(NSString *)bookID
{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"linkbook",@"method",author,@"author",bookID,@"bookid", nil];
    return [[URLUtility sharedInstance] getURLFromParams:params];
}

-(NSMutableArray *)parseBooklist:(id)result
{
    NSMutableArray *booklist=nil;
    if([result isKindOfClass:[NSArray class]])
    {
        booklist=[[[NSMutableArray alloc] init] autorelease];
        for(id item in result)
        {
            if([item isKindOfClass:[NSDictionary class]])
            {
                BookModel *bookModel=[[BookModel alloc] init];
                bookModel.bookID=[item objectForKey:@"BookID"];
                bookModel.bookName=[item objectForKey:@"BookName"];
                bookModel.bookIntro=[item objectForKey:@"BookDescription"];
                bookModel.bookIconURL=[item objectForKey:@"BookIconOtherURL"];
                bookModel.author=[item objectForKey:@"BookAuthor"];
                bookModel.creationDate=[item objectForKey:@"BookCreationDate"];
                bookModel.updateDate=[item objectForKey:@"BookUpdateDate"];
                [bookModel setBookLatter:[item objectForKey:@"FistIndex"]];
                bookModel.bookState=[item objectForKey:@"BookState"];
                bookModel.bookStateName=[item objectForKey:@"BookStateName"];
                bookModel.clickCount=[item objectForKey:@"BookClickCount"];
                bookModel.catalogName=[item objectForKey:@"CatalogName"];
                [booklist addObject:bookModel];
                [bookModel release];
            }
        }
    }
    return booklist;
}

-(NSMutableArray *)parseBooklistByPage:(id)result
{
    NSMutableArray *catalist=nil;
    if([result isKindOfClass:[NSDictionary class]])
    {
        id booklist=[result objectForKey:@"Booklist"];
        catalist=[self parseBooklist:booklist];
    }
    return catalist; 
}

-(NSMutableArray *)getFinsihedBooklistByGroupPath:(NSString *)groupPath
{
    NSMutableArray *booklist=[[[NSMutableArray alloc]init] autorelease];
    NSMutableArray *tmpBooklist= [[FileHelper sharedInstance] getFilelistByPath:groupPath onlyDirectory:YES];
    for(NSString *tmpBookName in tmpBooklist)
    {
        NSString *bookConfigPath=[[groupPath stringByAppendingPathComponent:tmpBookName] stringByAppendingPathComponent:kBookConfigName];
        if([[FileHelper sharedInstance] isExistPath:bookConfigPath])
        {
            SectionModel *secDownModel=[[FileHelper sharedInstance] unArchiverModel:bookConfigPath];
            [booklist addObject:secDownModel];
        }
    }
    return booklist;
}

-(NSString *)getBookPathByGroupName:(NSString *)groupName withBookName:(NSString *)bookName
{
    return [[kDownloadedPath stringByAppendingPathComponent:groupName] stringByAppendingPathComponent:bookName];
}

-(NSString *)getRecommandURL:(int)pageIndex andPageSize:(int)pageSize
{
    return [[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"recommend", [NSString stringWithFormat:@"%d",pageIndex],[NSString stringWithFormat:@"%d",pageSize],nil] forKeys:[NSArray arrayWithObjects:@"method",@"pageindex",@"pagesize", nil]]];
}

-(void)addNewHistory:(BookModel *)newBook
{
    //获取所有数据
    NSMutableDictionary *historyDict= [self getHistoryProduts];
    
    BOOL isExist=NO;
    BookModel *tmpBook=[historyDict objectForKey:newBook.bookID];
    if(tmpBook!=nil)
    {
        isExist=YES;
    }
    //判断是否已经添加
    if(isExist)
    {
        return;
    }
    
    //新增
    if(historyDict==nil)
    {
        historyDict=[[[NSMutableDictionary alloc] init] autorelease];
    }
    [historyDict setObject:newBook forKey:newBook.bookID];
    [[FileHelper sharedInstance] archiverModel:historyDict filePath:kHistoryPath];
}

-(void)deleteBookByBookID:(int)bookID
{
    //获取所有数据
    NSMutableDictionary *historyDict= [self getHistoryProduts];
    [historyDict removeObjectForKey:[NSString stringWithFormat:@"%d",bookID]];
}

-(NSMutableDictionary *)getHistoryProduts
{
    return [[FileHelper sharedInstance] unArchiverModel:kHistoryPath];
}
@end
