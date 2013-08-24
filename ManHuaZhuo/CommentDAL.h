//
//  CommentDAL.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentDAL : NSObject

+(CommentDAL *)sharedInstance;


//获取评论的个数
-(NSString *)getCommentCountByBookID:(NSString *)bookID;
-(int)parseCommentCountFromResult:(id)result;

-(NSString *)getHotCommentlistURL:(NSString *)bookID;
-(NSString *)getCommentlistByBookID:(NSString *)bookID andPageIndex:(int)pageIndex;

//获取评论列表,解析完是2个队列，最热和最新的
-(NSString *)getCommentlistByBookID:(NSString *)bookID;
-(NSMutableArray *)parseCommentlistFromResult:(id)result;

-(NSMutableArray *)parseReplylisFromResult:(id)result;
@end
