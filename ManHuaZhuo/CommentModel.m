//
//  CommentModel.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

@synthesize commentID;
@synthesize commentDate;
@synthesize commentContent;
@synthesize userID;
@synthesize userNick;
@synthesize userPhotoURL;
@synthesize likeCount;
@synthesize clientType;
@synthesize bookID;
@synthesize replyCount;
@synthesize hasLiked;

-(void)dealloc
{
    self.clientType=nil;
    self.commentDate=nil;
    self.commentID=nil;
    self.commentContent=nil;
    self.userNick=nil;
    self.bookID=nil;
    self.userID=nil;
    self.userPhotoURL=nil;
    [super dealloc];
}
@end
