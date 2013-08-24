//
//  SectionDAL.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "SectionDownloadManager.h"

@class BookModel;

@interface SectionDAL : NSObject

+(SectionDAL *)sharedInstance;

-(NSString *)getSectionURLByBookID:(NSString *)bookID;

-(NSMutableDictionary *)parseSectionlistFromData:(id)resultData curBook:(BookModel *)curBook;

-(NSMutableArray *)getFinishedSectionByGroupName:(NSString *)groupName withBookName:(NSString *)bookName;//获取某书名下已下载的章节

@end
