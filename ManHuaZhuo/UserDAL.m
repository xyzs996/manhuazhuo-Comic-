//
//  UserDAL.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserDAL.h"
#import "UserResultModel.h"
#import "UserModel.h"

static UserDAL *instance;

@implementation UserDAL

+(UserDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[UserDAL alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    [instance release];
    [super dealloc];
}

-(UserResultModel *)parseUserByData:(id)resultData
{
    UserResultModel *resultModel=nil;
    if([resultData isKindOfClass:[NSDictionary class]])
    {
        resultModel=[[[UserResultModel alloc] init] autorelease];
        resultModel.userResult=[resultData objectForKey:@"UserResult"];
        id userInfo=[resultData objectForKey:@"UserModel"];
        if([userInfo isKindOfClass:[NSDictionary class]])
        {
            resultModel.userInfo=[[[UserModel alloc] init] autorelease];
            resultModel.userInfo.userID=[[userInfo objectForKey:@"UserID"] intValue];
            resultModel.userInfo.userNick=[userInfo objectForKey:@"UserNick"];
            resultModel.userInfo.email=[userInfo objectForKey:@"UserEmail"];
            resultModel.userInfo.pwd=[userInfo objectForKey:@"UserPwd"];
        }
    }
    return resultModel;
}
@end
