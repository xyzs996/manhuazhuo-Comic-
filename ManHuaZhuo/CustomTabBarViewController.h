//
//  CustomTabBarViewController.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BottomTabBarView.h"
#import "MenuView.h"

@interface CustomTabBarViewController : UIViewController<TabBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)NSArray *viewControllers;
@property(nonatomic,retain)UIImage *backgroundImage;
@property(nonatomic,retain)NSArray *tabItems;
@property(nonatomic,assign)NSUInteger selectedIndex;
@property(nonatomic,assign)id<RightViewDelegate>delegate;

-(BOOL)isShowRightView;
-(void)showCurrentRightView:(NSArray *)titlelist celllist:(NSArray *)celllist selectedIndex:(NSInteger)selectedIndex;//显示当前控制器视图的右边
-(void)hideCurrentRightView;
-(void)hideBottomTabBar:(BOOL)flag;
@end
