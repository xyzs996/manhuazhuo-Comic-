//
//  BookNet.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 13-4-26.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookNet : NSObject

+(id)startRecommandlistByPage:(int)pageIndex pageSize:(int)pageSize;
+(void)cancelRecommandlist;

@end
