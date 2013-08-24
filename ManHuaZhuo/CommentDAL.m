//
//  CommentDAL.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentDAL.h"
#import "URLUtility.h"
#import "CommentModel.h"
#import "SettingDAL.h"
#import "DateHelper.h"

@interface CommentDAL ()

-(NSString *)getCommentDateString:(NSString *)dateString;

@end

static CommentDAL *instance;

@implementation CommentDAL

+(CommentDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[CommentDAL alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    [instance release];
    [super dealloc];
}

-(NSString *)getHotCommentlistURL:(NSString *)bookID
{
    return [[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjectsAndKeys:@"hotcommentlist",@"method",bookID ,@"bookid",nil]];
}

-(NSString *)getCommentlistByBookID:(NSString *)bookID andPageIndex:(int)pageIndex
{
    return [[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjectsAndKeys:@"commentlist",@"method",bookID,@"bookid", [NSString stringWithFormat:@"%d",pageIndex],@"pageindex",nil]];
}

-(NSString *)getCommentCountByBookID:(NSString *)bookID
{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"commentcount",@"method",bookID,@"bookid", nil];
    return [[URLUtility sharedInstance] getURLFromParams:params];
}

-(int)parseCommentCountFromResult:(id)result
{
    return [result intValue];
}

-(NSString *)getCommentlistByBookID:(NSString *)bookID
{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"sectionlist",@"method",bookID,@"bookid", nil];
    return [[URLUtility sharedInstance] getURLFromParams:params];
}

-(NSString *)getCommentDateString:(NSString *)dateString
{
    NSDate *date=[DateHelper getFormatterDateFromString:dateString andFormatter:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateComponents *dateComp=[DateHelper getDateComponentFromDate:date];
    NSDateComponents *nowComp=[DateHelper getDateComponentFromDate:[NSDate date]];
    
    NSString *showDateString=nil;
    BOOL monthFlag=[dateComp month]==[nowComp month];
    BOOL dayFlag=[dateComp day]==[nowComp day];
    BOOL hourFlag=abs([dateComp hour]-[nowComp hour])<3;
    NSLog(@"%d==%d",[dateComp day],[nowComp day]);
    if(monthFlag&&dayFlag&&([dateComp hour]==[nowComp hour]))//1小时内，刚刚
    {
        showDateString=@"刚刚";
    }
    else if(monthFlag&&dayFlag&&hourFlag)//3小时内，
    {
        showDateString=[NSString stringWithFormat:@"%d小时前",abs([dateComp hour]-[nowComp hour])];
    }
    else if(monthFlag&&dayFlag)//今天
    {
        showDateString=[NSString stringWithFormat:@"今天%@",[DateHelper getFormatterDateStringFromDate:date andFormatter:@"HH:mm:ss"]];
    }
    else {
        showDateString=[DateHelper getFormatterDateStringFromDate:date andFormatter:@"yyyy-MM-dd"];
    }
    return showDateString;
}


-(NSMutableArray *)parseCommentlistFromResult:(id)result
{
    NSMutableArray *commentlist=nil;
    if([result isKindOfClass:[NSArray class]])
    {
        commentlist=[[[NSMutableArray alloc] init] autorelease];
        for(id comment in result)
        {
            if([comment isKindOfClass:[NSDictionary class]])
            {
                CommentModel *commentModel=[[CommentModel alloc] init];
                commentModel.commentID=[comment objectForKey:@"CommentID"];
                commentModel.commentContent=[comment objectForKey:@"CommentContent"];
                commentModel.likeCount=[[comment objectForKey:@"LikeCount"] intValue];
                
                NSString *dateString=[comment objectForKey:@"CommentDate"];
                               
                commentModel.commentDate=[self getCommentDateString:dateString];
                commentModel.userID=[comment objectForKey:@"UserID"];
                commentModel.userNick=[comment objectForKey:@"UserNick"];
                commentModel.replyCount=[[comment objectForKey:@"ReplyCount"]intValue];
                commentModel.clientType=[comment objectForKey:@"ClientTypeName"];
                commentModel.hasLiked=[[comment objectForKey:@"HasLiked"] boolValue];
                [commentlist addObject:commentModel];
                [commentModel release];
            }
        }
    }
    return commentlist;
}

-(NSMutableArray *)parseReplylisFromResult:(id)result
{
    NSMutableArray *replylist=nil;
    if([result isKindOfClass:[NSArray class]])
    {
        replylist=[[[NSMutableArray alloc] init] autorelease];
        for(id comment in result)
        {
            if([comment isKindOfClass:[NSDictionary class]])
            {
                CommentModel *commentModel=[[CommentModel alloc] init];
                commentModel.commentID=[comment objectForKey:@"ReplyID"];
                commentModel.commentContent=[comment objectForKey:@"ReplyContent"];
                commentModel.likeCount=[[comment objectForKey:@"LikeCount"] intValue];
                commentModel.commentDate=[self getCommentDateString:[comment objectForKey:@"ReplyDate"]];
                commentModel.userID=[comment objectForKey:@"UserID"];
                commentModel.userNick=[comment objectForKey:@"UserNick"];
                commentModel.replyCount=[[comment objectForKey:@"ReplyCount"]intValue];
                commentModel.clientType=[comment objectForKey:@"ClientTypeName"];
                commentModel.hasLiked=[[comment objectForKey:@"HasLiked"] boolValue];
                [replylist addObject:commentModel];
                [commentModel release];
            }
        }
    }
    return replylist;
}

@end
