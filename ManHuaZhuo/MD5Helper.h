//
//  MD5Helper.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

@interface MD5Helper : NSObject

+ (NSString *)md5Digest:(NSString *)str;

@end
