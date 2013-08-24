//
//  URLUtility.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLUtility : NSObject

+(URLUtility *)sharedInstance;

-(NSString *)getURLFromParams:(NSDictionary *)params;

@end
