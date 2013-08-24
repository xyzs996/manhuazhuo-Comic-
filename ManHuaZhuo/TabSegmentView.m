//
//  TabSementController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TabSegmentView.h"
#import "TabSegmentItem.h"

#define kDefaultItemWidth 80//一个title显示的最大宽度
#define kItemGap 5//每个item前后间隔

@interface TabSegmentView ()
{
    BOOL isResumeOffset;
    int preClickIndex;//上次点击的索引
    int itemCount;
//    UITableView
}

@property(nonatomic,retain)NSMutableArray *visibleItems;
@property(nonatomic,retain)NSMutableDictionary *resuableItems;//字典列表，每个字典里有一个key：identity ，和一个value：列表 

-(NSMutableArray *)getReusableItemsByIdentity:(NSString *)identity;
@end
@implementation TabSegmentView

@synthesize visibleItems;
@synthesize resuableItems;
@synthesize selectedImageView;
@synthesize backgroundImageView;
@synthesize dataSource;
@synthesize tabSegmentdelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:self];
//        [self setShowsHorizontalScrollIndicator:NO];
        selectedImageView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CKTabViewButton_on.png"]]autorelease];
        [self addSubview:selectedImageView];
        
        visibleItems=[[NSMutableArray alloc] init];
        resuableItems=[[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void)dealloc
{
    self.visibleItems=nil;
    self.resuableItems=nil;
    self.tabSegmentdelegate=nil;
    self.backgroundImageView=nil;
    [super dealloc];
}

-(void)selectedIndex:(int)index
{
}

-(void)insertItemAtIndex:(int)index
{
    itemCount++;
    //重新设置ContentSize
    [self setContentSize:CGSizeMake(self.contentSize.width+kDefaultItemWidth, self.contentSize.height)];
    if(index>firstVisiableIndex+[visibleItems count])
    {
        //设置当前的最新的item的OffsetX
        [self setContentOffset:CGPointMake(self.contentSize.width-self.frame.size.width-5, 0) animated:YES];
        [self setContentOffset:CGPointMake(self.contentSize.width-self.frame.size.width, 0) animated:YES];
    }
    else if(index<=firstVisiableIndex)
    {
        //动画全部右移items
        [UIView beginAnimations:nil context:nil];
        for(TabSegmentItem *tmpItem in visibleItems)
        {
            tmpItem.frame=CGRectMake(tmpItem.frame.origin.x+kDefaultItemWidth, tmpItem.frame.origin.y, tmpItem.frame.size.width, tmpItem.frame.size.height);
        }
        [UIView commitAnimations];
        
        
        //设置当前的最新的item的OffsetX
        TabSegmentItem *firstItem=[visibleItems objectAtIndex:0];
        [self setContentOffset:CGPointMake(firstItem.frame.origin.x-kDefaultItemWidth, firstItem.frame.origin.y)];
        
        firstVisiableIndex++;
    }
    else {
//        [UIView beginAnimations:nil context:nil];
//        for(int i=0;i<[visibleItems count];i++)
//        {
//            if(i>=(index-firstVisiableIndex))
//            {
//                NSLog(@"~~~~~~~~~~%d",i);
//                TabSegmentItem *tmpItem=[visibleItems objectAtIndex:i];
//                tmpItem.frame=CGRectMake(tmpItem.frame.origin.x+kDefaultItemWidth, tmpItem.frame.origin.y, tmpItem.frame.size.width, tmpItem.frame.size.height);
//            }
//        }
//        [UIView commitAnimations];
//        TabSegmentItem *item=[visibleItems objectAtIndex:index];
//        firstVisiableIndex++;
//        [self setContentOffset:CGPointMake(item.frame.origin.x, 0)];
    }
    [self scrollViewDidScroll:self];
}

-(CGFloat)getWidthToIndex:(int)index
{
    CGFloat totalWidth=0.0;
    for(int i=0;i<itemCount;i++)
    {
        if(i<index)
        {
            CGFloat itemWidth=kDefaultItemWidth;
            if([dataSource respondsToSelector:@selector(tabSegment:heightForIndex:)])
            {
                itemWidth=[dataSource tabSegment:self heightForIndex:[NSNumber numberWithInt:i]];
            }
            totalWidth+=itemWidth;
        }
    }
    return totalWidth;
}

-(void)deleteItemAtIndex:(int)index
{
    CGFloat itemWidth=kDefaultItemWidth;
    if([dataSource respondsToSelector:@selector(tabSegment:heightForIndex:)])
    {
        itemWidth=[dataSource tabSegment:self heightForIndex:[NSNumber numberWithInt:index]];
    }
    itemCount--;
    [UIView beginAnimations:nil context:nil];
    [self setContentSize:CGSizeMake(self.contentSize.width-itemWidth, self.frame.size.height)];
    [UIView commitAnimations];
    [self setContentOffset:CGPointMake(1000, self.frame.origin.y)];
    [self setContentOffset:CGPointMake(0, self.frame.origin.y)];
}


-(CGFloat)getWidthByArray:(NSArray *)stringlist andFont:(UIFont *)_font andHeight:(CGFloat)height
{
    CGFloat totalWidth=0.0;
    for(NSString *tmpString in stringlist)
    {
         CGSize titleSize=[tmpString sizeWithFont:_font constrainedToSize:CGSizeMake(10000000, height) lineBreakMode:UILineBreakModeWordWrap];
        totalWidth+=titleSize.width+2*kItemGap;
    }
    return totalWidth;
}

-(void)reloadData
{
    firstVisiableIndex=0;
    itemCount=[dataSource tabSegmentOfCount:self];
    for(TabSegmentItem *tmpItem in visibleItems)
    {
        [tmpItem removeFromSuperview];
    }
    [visibleItems removeAllObjects];
    [resuableItems removeAllObjects];
    isResumeOffset=YES;
    [self setContentOffset:CGPointMake(0, 0)];
    isResumeOffset=NO;
    
    CGFloat totalWidth=0;
    for(int i=0;i<itemCount;i++)
    {
        CGFloat itemWidth=kDefaultItemWidth;
        if([dataSource respondsToSelector:@selector(tabSegment:heightForIndex:)])
        {
            itemWidth=[dataSource tabSegment:self heightForIndex:[NSNumber numberWithInt:i]];
        }
        if(totalWidth<self.frame.size.width)
        {
            TabSegmentItem *newItem=[dataSource tabSegment:self viewForIndex:[NSNumber numberWithInt:i]];
            [newItem setTag:i];
            [newItem setFrame:CGRectMake(totalWidth, 0, kDefaultItemWidth, self.frame.size.height)];
            [self addSubview:newItem];
            [visibleItems addObject:newItem];
        }
        totalWidth+=itemWidth;
    }
    //根据累加的宽度设置scrollView的宽度
    [self setContentSize:CGSizeMake(totalWidth, self.frame.size.height)];
}

int firstVisiableIndex=0;

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%f",scrollView.contentOffset.x);
    if(!isResumeOffset)
    {
        CGFloat visibleWidth=self.frame.size.width;
        
        TabSegmentItem *firstItem=[visibleItems objectAtIndex:0];
        if(firstItem!=nil)
        {
            //最左边的item离开可见区
            CGFloat firstOffsetX=firstItem.frame.origin.x+firstItem.frame.size.width;
            if(firstOffsetX<scrollView.contentOffset.x)
            {
                firstVisiableIndex++;
    //            NSLog(@"<<<<左边的出去了");
                //添加到可重用队列中
                NSMutableArray *identityArray=[self getReusableItemsByIdentity:firstItem.identity];
                [identityArray addObject:firstItem];
                [resuableItems setObject:identityArray forKey:firstItem.identity];

                //移除最左边刚出去的视图和可见对象数据队列里的引用
                [visibleItems removeObject:firstItem];
                [firstItem removeFromSuperview];
            }
            //最左边的出现新item
            if(firstItem.frame.origin.x>scrollView.contentOffset.x)
            {
                if(firstVisiableIndex==0)
                {
                    return;
                }
                firstVisiableIndex--;
                
                //添加到视图和可见队列
                TabSegmentItem *newItem=[dataSource tabSegment:self viewForIndex:[NSNumber numberWithInt:firstVisiableIndex]];
                [newItem setTag:firstVisiableIndex+[visibleItems count]];
                CGFloat itemWidth=kDefaultItemWidth;
                if([dataSource respondsToSelector:@selector(tabSegment:heightForIndex:)])
                {
                    itemWidth=[dataSource tabSegment:self heightForIndex:[NSNumber numberWithInt:firstVisiableIndex]];
                }
                [newItem setFrame:CGRectMake(firstItem.frame.origin.x-itemWidth, firstItem.frame.origin.y,itemWidth, firstItem.frame.size.height)];
                [self addSubview:newItem];
                [visibleItems insertObject:newItem atIndex:0];
                
                //删除可重用队列中的引用
                NSMutableArray *identityArray=[self getReusableItemsByIdentity:firstItem.identity];
                [identityArray removeObject:newItem];
                [resuableItems setObject:identityArray forKey:firstItem.identity];
            }
        }
        
        TabSegmentItem *lastItem=visibleItems.lastObject;
        if(lastItem!=nil)
        {
            //最右边新增item
            CGFloat lastOffsetX=lastItem.frame.origin.x+lastItem.frame.size.width;
            BOOL canRightExpand=((firstVisiableIndex+visibleItems.count)!=itemCount);//是否可以继续右拉
            if(lastOffsetX<=(scrollView.contentOffset.x+visibleWidth)&&canRightExpand)
            {
                NSLog(@"右边的进来了>>>");
                //获取新的使用的item放置到可见对象队列,并添加到视图上
                TabSegmentItem *newItem=[dataSource tabSegment:self viewForIndex:[NSNumber numberWithInt:firstVisiableIndex+visibleItems.count]];
                [newItem setTag:firstVisiableIndex+[visibleItems count]];
                CGFloat itemWidth=kDefaultItemWidth;
                if([dataSource respondsToSelector:@selector(tabSegment:heightForIndex:)])
                {
                    itemWidth=[dataSource tabSegment:self heightForIndex:[NSNumber numberWithInt:firstVisiableIndex]];
                    NSLog(@"itemWidth=%f",itemWidth);
                }
                NSLog(@"%f",self.contentSize.width);
                [newItem setFrame:CGRectMake(lastOffsetX, lastItem.frame.origin.y, itemWidth, lastItem.frame.size.height)];
                [visibleItems addObject:newItem];
                [self addSubview:newItem];
                
                //删除可重用队列中的对象引用
                NSMutableArray *identityArray=[self getReusableItemsByIdentity:firstItem.identity];
                [identityArray removeObject:newItem];
                [resuableItems setObject:identityArray forKey:firstItem.identity];
            }
            
            //最右边消失item
            if(lastItem.frame.origin.x>scrollView.contentOffset.x+self.frame.size.width)
            {
                //添加到可重用队列中
                NSMutableArray *identityArray=[self getReusableItemsByIdentity:firstItem.identity];
                [identityArray addObject:lastItem];
                [resuableItems setObject:identityArray forKey:lastItem.identity];
                
                //移除最右边刚出去的视图和可见对象数据队列里的引用
                [visibleItems removeObject:lastItem];
                [lastItem removeFromSuperview];
            }
        }
    }
}


-(NSMutableArray *)getReusableItemsByIdentity:(NSString *)identity
{
   id array= [resuableItems objectForKey:identity];
    if(array==nil)
    {
        array=[[[NSMutableArray alloc] init] autorelease];
    }
    return array;
}

-(TabSegmentItem *)dequeueResubleItemWithIdentity:(NSString *)identity
{
    NSMutableArray *itemlist= [resuableItems objectForKey:identity];
    if([itemlist count]==0)
    {
        return nil;
    }
    else {
        TabSegmentItem *firstItem=[itemlist objectAtIndex:0];
        return firstItem;
    }
}
@end
