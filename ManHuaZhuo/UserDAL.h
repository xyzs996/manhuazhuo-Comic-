//
//  UserDAL.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserResultModel;

@interface UserDAL : NSObject

+(UserDAL *)sharedInstance;

-(UserResultModel *)parseUserByData:(id)resultData;

@end
