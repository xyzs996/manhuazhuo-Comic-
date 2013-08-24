//
//  AppDelegate.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "RecommandViewController.h"
#import "CatalogViewController.h"
#import "DownloadViewController.h"
#import "ManagerViewController.h"
#import "SettingViewController.h"
#import "BottomTabBarView.h"
#import "PictureViewController.h"
#import "UserModel.h"
#import "URLUtility.h"
#import "SettingDAL.h"
#import "VersionNet.h"
#import "CommonHelper.h"

@interface AppDelegate ()

@property(nonatomic,retain)PictureViewController *picVController;

-(void)windowTapGesture:(UITapGestureRecognizer *)tap;

@end

@implementation AppDelegate

@synthesize windowTap;
@synthesize bannerView_;
@synthesize userSession;
@synthesize downVController;
@synthesize picVController;
@synthesize navBarBgImg;
@synthesize window = _window;
@synthesize cusTabBarVController;
@synthesize pull_pull,pull_release;
@synthesize weiboApi;
@synthesize tabBarController;
@synthesize bottomView;
@synthesize menuView;

- (void)dealloc
{
    self.windowTap=nil;
    self.bannerView_=nil;
    self.userSession=nil;
    self.downVController=nil;
    self.menuView=nil;
    self.bottomView=nil;
    self.tabBarController=nil;
    self.weiboApi=nil;
    self.navBarBgImg=nil;
    [cusTabBarVController release];
    [_window release];
    [super dealloc];
}


-(void)publishMessageResult:(NSNotification*)notification
{
    NSDictionary* dict = [notification userInfo];
    if (dict) {
        BOOL success=[[dict objectForKey:@"success"] boolValue];
        if (!success) {
            UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                               message:@"分享到微博失败" 
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定" 
                                                     otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            return;
        }
        NSInteger weiboid=[[dict objectForKey:@"weiboid"] intValue];
        //NSInteger userData = [[dict objectForKey:@"userData"] intValue];
        NSString* result = nil;
        switch (weiboid) {
            case Weibo_Sina:
                result=@"已分享到新浪微博";
                break;
            case Weibo_Tencent:
                result=@"已分享到腾讯微博";
                break;
            case Weibo_Netease:
                result=@"已分享到网易微博";
                break;
            case Weibo_Sohu:
                result=@"已分享到搜狐微博";
                break;
            case Weibo_Max:
                return;
                break;
            default:
                
                break;
        }
        NSLog(@"%@", result);
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
                                                           message:result 
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定" 
                                                 otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}


-(void)loadSoundResource
{
    @autoreleasepool {
        NSURL *pullURL=[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"pull_pull.wav"];
        AudioServicesCreateSystemSoundID((CFURLRef)pullURL, &pull_pull);
        
        NSURL *releaseURL=[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"pull_release.wav"];
        AudioServicesCreateSystemSoundID((CFURLRef)releaseURL, &pull_release);
    }
}

-(void)windowTapGesture:(UITapGestureRecognizer *)tap
{
    [self.menuView hideCurrentRightView];
    [windowTap setEnabled:NO];
}
-(void)checkVersionInThread
{
    NSString *newVersion=[VersionNet startCheckVersion];
//    NSLog(@"newVersion=%@",newVersion);
    NSString *curVersion= [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    if([newVersion floatValue]>[curVersion floatValue])
    {
        if([[CommonHelper sharedInstance]showAlertWithResult:[NSString stringWithFormat:@"新版本%@发布啦，是否前去下载?",newVersion]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppDownloadURL]];
        }
    }
    else {
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [NSThread detachNewThreadSelector:@selector(checkVersionInThread) toTarget:self withObject:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    NSLog(@"=%@",self.window);
    //推荐
    RecommandViewController *recommandVCotroller=[[RecommandViewController alloc] init];
    recommandVCotroller.navigationItem.title=@"热门推荐";
    UINavigationController *recomNavController=[[UINavigationController alloc] initWithRootViewController:recommandVCotroller]; 
    
    //分类
    CatalogViewController *cataVController=[[CatalogViewController alloc] init];
    cataVController.navigationItem.title=@"漫画分类";
    UINavigationController *cataNavController=[[UINavigationController alloc] initWithRootViewController:cataVController];

    //下载
    downVController=[[DownloadViewController alloc] init];
    downVController.navigationItem.title=@"我的下载";
    UINavigationController *downNavVController=[[UINavigationController alloc] initWithRootViewController:downVController];
    
   //书籍管理
    ManagerViewController *manageVController=[[ManagerViewController alloc] init];
    manageVController.navigationItem.title=@"我的漫画";
    UINavigationController *manageNavVController=[[UINavigationController alloc] initWithRootViewController:manageVController];
    //设置
    SettingViewController *settingVController=[[SettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
    settingVController.navigationItem.title=@"软件设置";
    UINavigationController *settingNavVController=[[UINavigationController alloc] initWithRootViewController:settingVController];
    
    
    //导航栏
    if([[[UIDevice currentDevice] systemVersion] intValue]>=5)
    {
        [recomNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
        [cataNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
        [downNavVController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
        [manageNavVController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
        [settingNavVController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    CustomTabBarView *reComTabBar=[[CustomTabBarView alloc] initWithText:@"热门推荐" Image:[UIImage imageNamed:@"tab_featured.png"] selectedImg:[UIImage imageNamed:@"tab_featured_seclected.png"]];
    CustomTabBarView *cataTabBar=[[CustomTabBarView alloc] initWithText:@"漫画分类" Image:[UIImage imageNamed:@"tab_browse.png"] selectedImg:[UIImage imageNamed:@"tab_browse_seclected.png"]];
    CustomTabBarView *downTabBar=[[CustomTabBarView alloc] initWithText:@"我的下载" Image:[UIImage imageNamed:@"tab_top.png"] selectedImg:[UIImage imageNamed:@"tab_top_seclected.png"]];
    CustomTabBarView *manageTabBar=[[CustomTabBarView alloc] initWithText:@"我的漫画" Image:[UIImage imageNamed:@"tab_free.png"] selectedImg:[UIImage imageNamed:@"tab_free_seclected.png"]];
    CustomTabBarView *settingTabBar=[[CustomTabBarView alloc] initWithText:@"软件设置" Image:[UIImage imageNamed:@"tab_more.png"] selectedImg:[UIImage imageNamed:@"tab_more_seclected.png"]];

    self.tabBarController=[[[UITabBarController alloc] init] autorelease];
    [tabBarController.tabBar setFrame:CGRectMake(tabBarController.tabBar.frame.origin.x, tabBarController.tabBar.frame.origin.y+10, tabBarController.tabBar.frame.size.width, tabBarController.tabBar.frame.size.height-10)];
    [tabBarController setViewControllers:[NSArray arrayWithObjects:recomNavController,cataNavController,downNavVController,manageNavVController,settingNavVController, nil]];
    [tabBarController.tabBar setHidden:YES];
    for(UIView *view in [tabBarController.view subviews])
    {
        if(![view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height+5)];
        }
    }
    
    menuView=[[MenuView alloc] initWithFrame:CGRectMake(120, 20, 200, self.window.frame.size.height)];
    [self.window addSubview:menuView];
    
    bottomView=[[BottomTabBarView alloc] initWithFrame:CGRectMake(0, self.window.frame.size.height-44, self.window.frame.size.width, 44) tabBarItems:[NSArray arrayWithObjects:reComTabBar,cataTabBar,downTabBar,manageTabBar,settingTabBar,nil]];
    [bottomView setDelegate:self];
    [bottomView setBackgroundImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    [tabBarController.view addSubview:bottomView];
    
    self.window.rootViewController=tabBarController;

    [downNavVController release];
    [settingVController release];
    [settingNavVController release];
    [manageVController release];
    [manageNavVController release];
    [downTabBar release];
    [manageTabBar release];
    [settingTabBar release];
    [cataTabBar release];
    [cataVController release];
    [cataNavController release];
    [reComTabBar release];
    [recommandVCotroller release];
    [recomNavController release];

    [NSThread detachNewThreadSelector:@selector(loadSoundResource) toTarget:self withObject:nil];
    
    self.navBarBgImg=[UIImage imageNamed:@"nav_bg_iso4.png"];
    
    
    weiboApi = [[WeiboCommonAPI alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(publishMessageResult:)
												 name:PublishMessageResultNotification
											   object:nil];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    windowTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowTapGesture:)];
    [windowTap setEnabled:NO];
    [self.tabBarController.view addGestureRecognizer:windowTap];

   if( [[SettingDAL sharedInstance] isFirstInstallApp])
   {
       [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
       [[SettingDAL sharedInstance] updateNotification:YES];
   }
    [[SettingDAL sharedInstance] updateTurnPageDirection:YES];
    return YES;
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"asdfdas");
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token=[NSString stringWithFormat:@"%@",deviceToken];
    token=[token substringFromIndex:1];
    token=[token substringToIndex:token.length-1];
    token=[token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *tokenURL=[[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjectsAndKeys:@"postdevicetoken",@"method", token,@"token",nil]];
    [[DownloadHelper sharedInstance] startRequest:tokenURL delegate:nil tag:0 userInfo:nil];
    NSLog(@"获取devicetoken=%@",deviceToken);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册notification 失败%@",error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [cusTabBarVController viewDidUnload];
}

#pragma tabBarDelegate
-(void)tabBarSelected:(NSNumber *)selectedIndex
{
    [tabBarController setSelectedIndex:[selectedIndex intValue]];
}

-(void)showPictureViewController:(SectionModel *)section isLocalRequest:(BOOL)isLocalRequest
{
    CATransition *pushAnimation=[CATransition animation];
    pushAnimation.type=kCATransitionPush;
    pushAnimation.subtype=kCATransitionFromRight;
    pushAnimation.duration=0.3;
    [self.tabBarController.view setFrame:CGRectMake(0-self.tabBarController.view.frame.size.width, self.tabBarController.view.frame.origin.y, self.tabBarController.view.frame.size.width, self.tabBarController.view.frame.size.height)];
    [self.tabBarController.view.layer addAnimation:pushAnimation forKey:nil];
    self.picVController=[[[PictureViewController alloc] initWithSection:section isLocalRequest:isLocalRequest] autorelease];
    [self.window addSubview:picVController.view];
}

-(void)hidePictureViewController
{
    UIViewController *barVController=[tabBarController.viewControllers objectAtIndex:tabBarController.selectedIndex];
    [barVController viewDidAppear:YES];

    CATransition *pushAnimation=[CATransition animation];
    pushAnimation.type=kCATransitionPush;
    pushAnimation.subtype=kCATransitionFromLeft;
    pushAnimation.duration=0.3;
    [self.tabBarController.view setFrame:CGRectMake(0, self.tabBarController.view.frame.origin.y, self.tabBarController.view.frame.size.width, self.tabBarController.view.frame.size.height)];
    [self.tabBarController.view.layer addAnimation:pushAnimation forKey:nil];
    [self.picVController.view removeFromSuperview];
}

@end
