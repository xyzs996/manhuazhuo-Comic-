//
//  ResponseModel.m
//  LBShopMall
//
//  Created by 国翔 韩 on 13-3-25.
//  Copyright (c) 2013年 联龙博通在线服务中心.李成武. All rights reserved.
//

#import "ResponseModel.h"
#import "ErrorModel.h"

@implementation ResponseModel

@synthesize response;
@synthesize resultInfo;
@synthesize status;
@synthesize error;

-(void)dealloc
{
    self.error=nil;
    self.status=nil;
    self.response=nil;
    self.resultInfo=nil;
    [super dealloc];
}
@end
