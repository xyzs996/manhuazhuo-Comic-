//
//  TabSegmentItem.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TabSegmentItem.h"

@implementation TabSegmentItem

@synthesize lblTitle;
@synthesize identity;

- (id)initWithFrame:(CGRect)frame withIdentity:(NSString *)_identity
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat leftGap=5;
        CGFloat topGap=5;
        lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(leftGap, 0, frame.size.width-2*leftGap, frame.size.height-2*topGap)];
        [lblTitle setFont:[UIFont systemFontOfSize:16]];
//        [lblTitle setFont:[UIFont boldSystemFontOfSize:16]];
        [lblTitle setTextAlignment:UITextAlignmentCenter];
        [lblTitle setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lblTitle];
        
        self.identity=_identity;
    }
    return self;
}

-(void)dealloc
{
    self.lblTitle=nil;
    self.identity=nil;
    [super dealloc];
}
@end
