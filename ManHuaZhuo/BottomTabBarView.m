//
//  BottomTabBarView.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "BottomTabBarView.h"



@interface CustomTabBarView ()

@property(nonatomic,retain)UIImage *normalImg;
@property(nonatomic,retain)UIImage *selectedImg;

@end

@implementation CustomTabBarView

@synthesize lblTabBar,tabBarImageView;
@synthesize normalImg,selectedImg;
@synthesize delegate;

-(id)initWithText:(NSString *)text Image:(UIImage *)image selectedImg:(UIImage *)_selectedImg
{
    if(self=[super initWithFrame:CGRectMake(0, 0, 64, 44)])
    {
        normalImg=[image retain];
        selectedImg=[_selectedImg retain];
        
        tabBarImageView=[[UIImageView alloc] initWithFrame:CGRectMake(17, 2, 30, 30)];
        [self.tabBarImageView setImage:normalImg];
        [self addSubview:tabBarImageView];
        
        lblTabBar=[[UILabel alloc] initWithFrame:CGRectMake(2, 34, 60, 10)];
        [lblTabBar setBackgroundColor:[UIColor clearColor]];
        [lblTabBar setFont:[UIFont systemFontOfSize:10.0]];
        [lblTabBar setFont:[UIFont boldSystemFontOfSize:10.0]];
        [lblTabBar setTextColor:[UIColor whiteColor]];
        [lblTabBar setTextAlignment:UITextAlignmentCenter];
        [self.lblTabBar setText:text];
        [self addSubview:lblTabBar];
    }
    return self;
}

-(void)isSelected:(BOOL)flag
{
    if(flag)
    {
        [tabBarImageView setImage:selectedImg];
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_select_indicator.png"]]];
    }
    else {
        [tabBarImageView setImage:normalImg];
        [self setBackgroundColor:[UIColor clearColor]];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([delegate respondsToSelector:@selector(tabBarClick:)])
    {
        [delegate tabBarClick:self];
    }
}
-(void)dealloc
{
    self.delegate=nil;
    self.normalImg=nil;
    self.selectedImg=nil;
    self.tabBarImageView=nil;
    self.lblTabBar=nil;
    [super dealloc];
}

@end

@interface BottomTabBarView ()
@property(nonatomic,retain)UIImageView *backgroungImgView;
@end

@implementation BottomTabBarView

@synthesize backgroungImgView;
@synthesize tabItems,backgroundImage;
@synthesize selectedIndex;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame tabBarItems:(NSArray *)tabBarItems
{
    self = [super initWithFrame:frame];
    if (self) {
        backgroungImgView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [backgroungImgView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [backgroungImgView setUserInteractionEnabled:YES];
        [self addSubview:backgroungImgView];
        
        
        self.tabItems=tabBarItems;
        int itemCount=[tabItems count];
        for(int i=0;i<itemCount;i++)
        {
            CustomTabBarView *tab=[tabItems objectAtIndex:i];
            CGFloat offsetX=(frame.size.width-itemCount*tab.frame.size.width)/2;
            [tab setDelegate:self];
            [tab setFrame:CGRectMake(offsetX+tab.frame.size.width*i,0, tab.frame.size.width, tab.frame.size.height)];
            [backgroungImgView addSubview:tab];
        }
        [self setSelectedIndex:0];
    }
    return self;
}

-(void)setBackgroundImage:(UIImage *)_backgroundImage
{
    if(backgroundImage!=_backgroundImage)
    {
        [backgroundImage release];
        backgroundImage=[_backgroundImage retain];
        [backgroungImgView setImage:backgroundImage];
    }
}

-(void)setSelectedIndex:(NSUInteger)_selectedIndex
{
    selectedIndex=_selectedIndex;
    for(int i=0;i<[tabItems count];i++)
    {
        CustomTabBarView *tab=[tabItems objectAtIndex:i];
        if(i==selectedIndex)
        {
            [tab isSelected:YES];
        }
        else {
            [tab isSelected:NO];
        }
    }
}

-(void)hideBottomTabBar:(BOOL)flag
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    if(flag)
    {
        [backgroungImgView setFrame:CGRectMake(0-backgroungImgView.frame.size.width, backgroungImgView.frame.origin.y,backgroungImgView.frame.size.width, backgroungImgView.frame.size.height)];
    }
    else {
        [backgroungImgView setFrame:CGRectMake(0,  backgroungImgView.frame.origin.y, backgroungImgView.frame.size.width, backgroungImgView.frame.size.height)];
    }
    [UIView commitAnimations];
}

-(void)dealloc
{
    self.delegate=nil;
    self.backgroungImgView=nil;
    self.tabItems=nil;
    self.backgroundImage=nil;
    [super dealloc];
}

#pragma tabBar Delegate
-(void)tabBarClick:(CustomTabBarView *)tabBar
{
    NSInteger index=[tabItems indexOfObject:tabBar];
    [self setSelectedIndex:index];
    if([delegate respondsToSelector:@selector(tabBarSelected:)])
    {
        [delegate tabBarSelected:[NSNumber numberWithInt:index]];
    }
}
@end
