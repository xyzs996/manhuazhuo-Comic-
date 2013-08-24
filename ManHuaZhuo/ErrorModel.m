//
//  ErrorModel.m
//  LBShopMall
//
//  Created by 国翔 韩 on 13-4-2.
//  Copyright (c) 2013年 联龙博通在线服务中心.李成武. All rights reserved.
//

#import "ErrorModel.h"

@implementation ErrorModel

@synthesize errorMsg;

-(id)initWithErrorCode:(NSString *)errorCode
{
    if(self=[super init])
    {
        if([errorCode isEqualToString:@"OPR_00501"])
        {
            errorMsg=@"用户名";
        }
    }
    return self;
}

-(id)initWithHttpError:(NSString *)httpErrorCode
{
    if(self=[super init])
    {}
    return self;
}

@end
