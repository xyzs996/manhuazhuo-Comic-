//
//  DateHelper.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+(NSString *)getFormatterDateStringFromDate:(NSDate *)date andFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+(NSDate *)getFormatterDateFromString:(NSString *)dateString andFormatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateString];
}

+(NSDateComponents *)getDateComponentFromDate:(NSDate *)date
{
    NSCalendar *calender=[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *comp=nil;
    NSInteger unitFlags= NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comp=[calender components:unitFlags fromDate:date];
    return comp;
}

@end
