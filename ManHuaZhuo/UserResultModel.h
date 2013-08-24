//
//  UserResultModel.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@interface UserResultModel : NSObject

@property(nonatomic,retain)NSString *userResult;//登陆后者注册的结果int
@property(nonatomic,retain)UserModel *userInfo;
@end
