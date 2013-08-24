//
//  PictureModel.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PictureModel.h"

@implementation PictureModel

@synthesize picID;
@synthesize picURL;
@synthesize picReferURL;
@synthesize sectionID;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super init])
    {
        self.picID=[aDecoder decodeObjectForKey:@"picID"];
        self.picURL=[aDecoder decodeObjectForKey:@"picURL"];
        self.picReferURL=[aDecoder decodeObjectForKey:@"picReferURL"];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    PictureModel *picModel=[[self class] copyWithZone:zone];
    picModel.picID=[[self.picID copyWithZone:zone]autorelease];
    picModel.picReferURL=[[self.picReferURL copyWithZone:zone] autorelease];
    picModel.picURL=[[self.picURL copyWithZone:zone] autorelease];
    return picModel;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:picURL forKey:@"picURL"];
    [aCoder encodeObject:picReferURL forKey:@"picReferURL"];
    [aCoder encodeObject:picID forKey:@"picID"];    
}

-(void)dealloc
{
    self.sectionID=nil;
    self.picURL=nil;
    self.picID=nil;
    self.picReferURL=nil;
    [super dealloc];
}
@end
