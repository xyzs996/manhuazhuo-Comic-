//
//  CatalogDAL.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "CatalogDAL.h"
#import "URLUtility.h"
#import "SBJson.h"
#import "BookModel.h"

static CatalogDAL *instance;

@implementation CatalogDAL

+(CatalogDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[CatalogDAL alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    [instance release];
    [super dealloc];
}

-(NSString *)getAllCatalogURL
{
    NSDictionary *params=[NSDictionary dictionaryWithObject:@"catalogs" forKey:@"method"];
    return [[URLUtility sharedInstance] getURLFromParams:params];
}

-(NSMutableArray *)parseCatalogs:(id)result
{
    NSMutableArray *catalist=nil;
    if([result isKindOfClass:[NSArray class]])
    {
        catalist=[[[NSMutableArray alloc] init] autorelease];
        for(id item in result)
        {
            if([item isKindOfClass:[NSDictionary class]])
            {
                BookModel *bookModel=[[BookModel alloc] init];
                bookModel.bookID=[item objectForKey:@"CatalogID"];
                bookModel.bookName=[item objectForKey:@"CatalogName"];
                bookModel.bookIconURL=[item objectForKey:@"CatalogOtherURL"];
                bookModel.bookIntro=[item objectForKey:@"CatalogDescription"];
                [catalist addObject:bookModel];
                [bookModel release];
            }
        }
    }
    return catalist; 
}
@end
