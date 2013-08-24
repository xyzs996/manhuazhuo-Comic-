//
//  UserModel.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

typedef enum{
    Failed=0,
    Success=1,
    Exist=2,
    EmailNotExist=3
} LoginResult;
#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property(nonatomic,retain)NSString *userNick;
@property(nonatomic,assign)NSUInteger userID;
@property(nonatomic,retain)NSString *email;
@property(nonatomic,retain)NSString *pwd;
@property(nonatomic,retain)NSString *question;
@property(nonatomic,retain)NSString *answer;

@end
