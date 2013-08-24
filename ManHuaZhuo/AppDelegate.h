//
//  AppDelegate.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarViewController.h"
#import "BottomTabBarView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "WeiboWrapper.h"
#import "MenuView.h"
#import "SectionModel.h"
#import "DownloadViewController.h"
#import "GADBannerView.h"
#import "DownloadHelper.h"

@class UserModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate,TabBarDelegate,DownloadHelperDelegate>

@property(nonatomic,retain)UITapGestureRecognizer *windowTap;//右侧出现分类后可以点击左侧消失
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)CustomTabBarViewController *cusTabBarVController;
@property(nonatomic,retain) GADBannerView *bannerView_;
@property(nonatomic,assign)SystemSoundID pull_pull;
@property(nonatomic,assign)SystemSoundID pull_release;
@property(nonatomic,retain)UIImage *navBarBgImg;
@property(nonatomic,retain)UITabBarController *tabBarController;
@property(nonatomic,retain)BottomTabBarView *bottomView;
@property (nonatomic, retain) WeiboCommonAPI *weiboApi;
@property(nonatomic,retain) MenuView *menuView;
@property(nonatomic,retain)DownloadViewController *downVController;

@property(nonatomic,retain)UserModel *userSession;

-(void)showPictureViewController:(SectionModel *)section isLocalRequest:(BOOL)isLocalRequest;
-(void)hidePictureViewController;
@end
