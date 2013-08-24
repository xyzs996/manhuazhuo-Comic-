//
//  BottomTabBarView.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


@class CustomTabBarView;

@protocol TabBarDelegate <NSObject>

@optional
-(void)tabBarClick:(CustomTabBarView *)tabBar;
-(void)tabBarSelected:(NSNumber *)selectedIndex;
@end
#import <UIKit/UIKit.h>

@interface CustomTabBarView : UIView

@property(nonatomic,retain)UIImageView *tabBarImageView;
@property(nonatomic,retain)UILabel *lblTabBar;
@property(nonatomic,assign)id<TabBarDelegate> delegate;

-(id)initWithText:(NSString *)text Image:(UIImage *)image selectedImg:(UIImage *)selectedImg;
-(void)isSelected:(BOOL)flag;

@end


#import <UIKit/UIKit.h>

@interface BottomTabBarView : UIView<TabBarDelegate>

@property(nonatomic,retain)UIImage *backgroundImage;
@property(nonatomic,retain)NSArray *tabItems;
@property(nonatomic,assign)NSUInteger selectedIndex;
@property(nonatomic,assign)id<TabBarDelegate>delegate;

-(id)initWithFrame:(CGRect)frame tabBarItems:(NSArray *)tabBarItems;
-(void)hideBottomTabBar:(BOOL)flag;
@end
