//
//  MoreModel.m
//  Jewelry
//
//  Created by 国翔 韩 on 13-4-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MoreModel.h"

@implementation MoreModel

@synthesize name,img;
@synthesize type;
@synthesize url;

-(void)dealloc
{
    self.url=nil;
    self.name=nil;
    self.img=nil;
    [super dealloc];
}

@end
