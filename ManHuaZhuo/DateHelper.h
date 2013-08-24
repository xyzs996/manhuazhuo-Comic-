//
//  DateHelper.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+(NSString *)getFormatterDateStringFromDate:(NSDate *)date andFormatter:(NSString *)formatter;
+(NSDate *)getFormatterDateFromString:(NSString *)dateString andFormatter:(NSString *)formatter;
+(NSDateComponents *)getDateComponentFromDate:(NSDate *)date;

@end
