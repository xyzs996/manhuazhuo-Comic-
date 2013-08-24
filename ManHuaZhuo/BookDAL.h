//
//  BookDAL.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BookModel;
@interface BookDAL : NSObject

+(BookDAL *)sharedInstance;

-(NSString *)getBooklistByCataID:(NSString *)cataID pageIndex:(int)pageIndex pageSize:(int)pageSize bookState:(int)bookState order:(int)order;
-(NSMutableArray *)parseBooklist:(id)result;
-(NSMutableArray *)parseBooklistByPage:(id)result;

-(NSString *)getSearchURLByBookName:(NSString *)bookName;
-(NSString *)getSearchURLByAuthorName:(NSString *)authorName;

-(NSString *)getKeylistURL:(NSString *)key;
-(NSString *)getlinkBookByAuthor:(NSString *)author bookID:(NSString *)bookID;//搜索该作者除当前书籍外的其它作品

-(NSMutableArray *)getFinsihedBooklistByGroupPath:(NSString *)groupPath;//得到该文件夹里已下载完成的书籍
-(NSString *)getBookPathByGroupName:(NSString *)groupName withBookName:(NSString *)bookName;


-(NSString *)getRecommandURL:(int)pageIndex andPageSize:(int)pageSize;//首页漫画列表


//历史记录的操作
-(void)addNewHistory:(BookModel *)newBook;
-(void)deleteBookByBookID:(int)bookID;
-(NSMutableDictionary *)getHistoryProduts;
@end
