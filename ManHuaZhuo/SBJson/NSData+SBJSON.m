//
//  NSData+SBJSON.m
//  DWRelativity
//
//  Created by 89 李成武 on 13-1-30.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "NSData+SBJSON.h"

#import "SBJsonParser.h"

@implementation NSData (SBJSON)


- (id)JSONValue
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    
    NSString *jsonString= [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding ];
    id repr = [jsonParser objectWithString:jsonString];
    if (!repr)
        NSLog(@"-JSONValue failed. Error trace is: %@", [jsonParser errorTrace]);
    [jsonParser release];
    [jsonString release];
    return repr;
}

@end
