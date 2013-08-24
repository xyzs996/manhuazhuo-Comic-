//
//  BookModel.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel

@synthesize catalogName;
@synthesize bookID;
@synthesize bookName;
@synthesize bookIntro;
@synthesize bookIconURL;
@synthesize author;
@synthesize creationDate;
@synthesize bookState;
@synthesize bookStateImg;
@synthesize bookLatter;
@synthesize updateDate;
@synthesize bookStateName;
@synthesize clickCount;
@synthesize sectionlist;
@synthesize commentCount;

-(void)dealloc
{
    self.sectionlist=nil;
    self.catalogName=nil;
    self.bookStateName=nil;
    self.bookID=nil;
    self.bookName=nil;
    self.bookIntro=nil;
    self.bookIconURL=nil;
    self.author=nil;
    self.updateDate=nil;
    self.creationDate=nil;
    self.bookState=nil;
    self.bookStateImg=nil;
    self.bookLatter=nil;
    [super dealloc];
}
@end
