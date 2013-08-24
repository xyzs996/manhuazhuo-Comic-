//
//  CommentModel.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property(nonatomic,retain)NSString *bookID;
@property(nonatomic,retain)NSString *commentID;
@property(nonatomic,retain)NSString *commentContent;
@property(nonatomic,retain)NSString *commentDate;
@property(nonatomic,retain)NSString *userID;
@property(nonatomic,retain)NSString *userPhotoURL;
@property(nonatomic,retain)NSString *userNick;
@property(nonatomic)int likeCount;
@property(nonatomic,retain)NSString *clientType;//iPhone4S iPhone4 iPad iTouch...
@property(nonatomic)int replyCount;
@property(nonatomic,assign)BOOL hasLiked;

@end
