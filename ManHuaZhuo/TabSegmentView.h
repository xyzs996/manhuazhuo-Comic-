//
//  TabSementController.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>

@class TabSegmentView;
@class TabSegmentItem;

@protocol TabSegmentDataSource <NSObject>

@required
-(NSInteger)tabSegmentOfCount:(TabSegmentView *)segment;
//-(NSString *)tabSegment:(TabSegmentView *)segment stringForIndex:(NSNumber *)index;
-(TabSegmentItem *)tabSegment:(TabSegmentView *)segment viewForIndex:(NSNumber *)index;

@optional
-(CGFloat)tabSegment:(TabSegmentView *)segment heightForIndex:(NSNumber *)index;
-(UIFont *)tabSegmentOfFont:(TabSegmentView *)segment;

@end



@protocol TabSegmentDelegate <NSObject>

@optional 
-(void)tabSegment:(TabSegmentView *)segment didSelected:(NSNumber *)index;
@end



@interface TabSegmentView : UIScrollView<UIScrollViewDelegate>
{
    UITableView *tableView;
}

@property(nonatomic,retain)UIImageView *selectedImageView;
@property(nonatomic,retain)UIImageView *backgroundImageView;
@property(nonatomic,assign)id<TabSegmentDataSource> dataSource;
@property(nonatomic,retain)id<TabSegmentDelegate> tabSegmentdelegate;

-(TabSegmentItem *)dequeueResubleItemWithIdentity:(NSString *)identity;
-(void)reloadData;
-(void)insertItemAtIndex:(int)index;
-(void)deleteItemAtIndex:(int)index;
-(void)selectedIndex:(int)index;
@end


