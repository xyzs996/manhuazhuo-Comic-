//
//  UserModel.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

@synthesize userNick;
@synthesize userID;
@synthesize email;
@synthesize pwd;
@synthesize question;
@synthesize answer;

-(void)dealloc
{
    self.userNick=nil;
    self.email=nil;
    self.pwd=nil;
    self.question=nil;
    self.answer=nil;
    [super dealloc];
}
@end
