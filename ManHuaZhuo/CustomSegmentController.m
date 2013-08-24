//
//  CustomSegmentController.m
//  -巴士商店-
//
//  Created by TGBUS on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomSegmentController.h"


@implementation CustomSegmentController

@synthesize selectedImg;
@synthesize typeClickDelegate;

-(id)initWithLabels:(NSArray *)labels buttonWidth:(CGFloat)buttonWidth
{
    btnWidth=buttonWidth;
    hotWidth=14+[labels count]*btnWidth;
    startX=320-(320-hotWidth)/2-hotWidth;
    int height=32;
    self = [super initWithFrame:CGRectMake(0, 0, 320, height)];
    if (self) {
        NSString *imgName = [NSString stringWithFormat:@"nav_seg_bg.png"];
        count=[labels count];
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
        bgImageView.image = [UIImage imageNamed:imgName];
        [self addSubview:bgImageView];
        [bgImageView release];
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:imgName]]];
        
        int middleBgWidth=hotWidth-14;;
        
        //左图片
        UIImageView *leftImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_bar_bgleft.png"]];
        [leftImg setFrame:CGRectMake(startX, 0, 7, height)];
        [self addSubview:leftImg];
        [leftImg release];
       
        //中间的背景图片
        UIImageView *middleImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_bar_bg.png"]];
        [middleImg setFrame:CGRectMake(startX+7, 0, middleBgWidth, height)];
         
        //右图片
        UIImageView *rightImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_bar_bgright.png"]];
        [rightImg setFrame:CGRectMake(startX+middleBgWidth+7, 0, 7, height)];
        [self addSubview:rightImg];
        [rightImg release];
       

        imgName = [NSString stringWithFormat:@"nav_btn.png"];
        selectedImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        [selectedImg setFrame:CGRectMake(0*btnWidth, 3.5, btnWidth, 25)];
        [middleImg addSubview:selectedImg];
        
        for(int i=0;i<[labels count];i++)
        {
            NSString *tmpName=[labels objectAtIndex:i];
            UILabel *tmpLabel=[[UILabel alloc] initWithFrame:CGRectMake(i*btnWidth, 0, btnWidth, 32)];
            [tmpLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
            [tmpLabel setTextAlignment:UITextAlignmentCenter];
            [tmpLabel setBackgroundColor:[UIColor clearColor]];
            [tmpLabel setText:tmpName];
            [middleImg addSubview:tmpLabel];
            [tmpLabel release];
        }
        [self addSubview:middleImg];
        [middleImg release];
       ;
    }

    return self;

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
          }
    return self;
}

-(void)dealloc
{
    self.selectedImg=nil;
    self.typeClickDelegate=nil;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint newPoint=[[touches anyObject] locationInView:self];
    if(newPoint.x<320-(320-hotWidth)/2-7-3)
    {
        int index=(newPoint.x-startX)/btnWidth;
        if(index<count)
        {
            [UIView beginAnimations:nil context:nil];
            [selectedImg setFrame:CGRectMake(index*btnWidth, selectedImg.frame.origin.y, btnWidth, selectedImg.frame.size.height)];
            [UIView commitAnimations];
            if([typeClickDelegate respondsToSelector:@selector(TypeClick:)])
            {
                [typeClickDelegate performSelector:@selector(TypeClick:) withObject:[NSNumber numberWithInt:index]];
            }
        }
    }
}


-(void)setIndex:(int)_index
{
    [UIView beginAnimations:nil context:nil];
    [selectedImg setFrame:CGRectMake(_index*btnWidth, selectedImg.frame.origin.y, btnWidth, selectedImg.frame.size.height)];
    [UIView commitAnimations];
    if([typeClickDelegate respondsToSelector:@selector(TypeClick:)])
    {
        [typeClickDelegate performSelector:@selector(TypeClick:) withObject:[NSNumber numberWithInt:_index]];
    }

}
@end
