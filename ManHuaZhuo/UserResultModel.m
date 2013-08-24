//
//  UserResultModel.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserResultModel.h"

@implementation UserResultModel

@synthesize userResult;
@synthesize userInfo;

-(void)dealloc
{
    self.userResult=nil;
    self.userInfo=nil;
    [super dealloc];
}
@end
