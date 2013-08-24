//
//  SettingViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import "SettingDAL.h"
#import "MoreModel.h"
#import "SDImageCache.h"
#import "CommonHelper.h"

@interface SettingViewController ()

@property(nonatomic,retain)NSDictionary *sectionlist;

-(void)clearCacheInThread;

@end

@implementation SettingViewController

@synthesize sectionlist;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //登陆Section
    
    NSMutableArray *loginlist=[NSMutableArray array];
    MoreModel *loginMore=[[MoreModel alloc] init];
    [loginMore setName:@"登陆"];
    [loginMore setType:MoreLoginType];
    [loginlist addObject:loginMore];
    [loginMore release];
    
    
    
    //开启通知
    NSMutableArray *notiflist=[NSMutableArray array];
    
    MoreModel *notifyMore=[[MoreModel alloc] init];
    [notifyMore setName:@"热门漫画更新通知"];
    [notifyMore setType:MoreNotifyType];
    [notiflist addObject:notifyMore];
    [notifyMore release];
    
    
    //app推荐
    NSMutableArray *applist=[NSMutableArray array];    
    
    MoreModel *cubeBrowser=[[MoreModel alloc] init];
    [cubeBrowser setName:@"3D浏览器"];
    [cubeBrowser setUrl:@"https://itunes.apple.com/us/app/cube-browser/id566325847?ls=1&mt=8"];
    [cubeBrowser setType:MoreRecommandAppType];
    [applist addObject:cubeBrowser];
    [cubeBrowser release];
    
    
    //清理缓存
    NSMutableArray *clearlist=[NSMutableArray array];    
    
    MoreModel *clearModel=[[MoreModel alloc] init];
    [clearModel setName:@"清理缓存"];
    [clearModel setType:MoreClearType];
    [clearlist addObject:clearModel];
    [clearModel release];

    
    self.sectionlist=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:loginlist,notiflist,applist,clearlist, nil] forKeys:[NSArray arrayWithObjects:@"用户信息管理",@"通知管理",@"App推荐",@"缓存管理", nil]];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"(appDelegate.userSession=%@",appDelegate.userSession);
    if(appDelegate.userSession!=nil)
    {
        NSMutableArray *loginlist=[sectionlist objectForKey:@"用户信息管理"];
        MoreModel *loginMore=[loginlist objectAtIndex:0];
        [loginMore setName:appDelegate.userSession.userNick];
        NSIndexPath *logIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:logIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(void)releaseData
{
}

-(void)dealloc
{
    [self releaseData];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark tableView delegate
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[sectionlist allKeys] objectAtIndex:section];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[sectionlist allKeys] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key=[[sectionlist allKeys] objectAtIndex:section];
    return [[sectionlist objectForKey:key] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key=[[sectionlist allKeys] objectAtIndex:indexPath.section];
    MoreModel *tmpMore=[[sectionlist objectForKey:key] objectAtIndex:indexPath.row];
    if(tmpMore.type!=MoreNotifyType)
    {
        static NSString *cellIdentity=@"CellIdentity";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentity];
        if(cell==nil)
        {
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity] autorelease];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
       
        cell.textLabel.text=tmpMore.name;
        return cell;
    }
    else 
    {
        static NSString *cellIdentity=@"SwitchCell";
        SwitchCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentity];
        if(cell==nil)
        {
            cell=[[[SwitchCell alloc] init] autorelease];
            [cell setDelegate:self];
        }
        cell.textLabel.text=tmpMore.name;
        cell.switchView.on=[[SettingDAL sharedInstance] shouldNotification];
        return cell;
    }
}

-(void)switchCell:(SwitchCell *)state :(NSNumber *)number
{
    [[SettingDAL sharedInstance] updateNotification:[number boolValue]];
    if([[SettingDAL sharedInstance] shouldNotification])
    {
        if([[UIApplication sharedApplication] enabledRemoteNotificationTypes]==UIRemoteNotificationTypeNone)
        {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
        }
    }
    else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeNone];
    }
}

#pragma mark tableView delegate

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if(section==[sectionlist count]-1)
    {
        NSString *versionString=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        return [NSString stringWithFormat:@"漫画桌\nV%@",versionString];
    }
else {
    return nil;
}
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    NSString *key=[[sectionlist allKeys] objectAtIndex:indexPath.section];
    MoreModel *tmpMore=[[sectionlist objectForKey:key] objectAtIndex:indexPath.row];
    if(tmpMore.type==MoreLoginType)
    {
        if(APPDELEGATE.userSession!=nil)
        {
            return; 
        }
        LoginViewController *loginVController=[[LoginViewController alloc] init];
        UINavigationController *logNavController=[[UINavigationController alloc] initWithRootViewController:loginVController];
        [self presentModalViewController:logNavController animated:YES];
        [logNavController release];
        [loginVController release];
    }
    else if(tmpMore.type==MoreRecommandAppType)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tmpMore.url]];
    }
    else if(tmpMore.type==MoreClearType)
    {
        if([CommonHelper showMsg:@"是否要清理图片缓存?"])
        {
            [CommonHelper showHud:self title:@"请稍候..." selector:@selector(clearCacheInThread) arg:nil targetView:self.view];
        }
    }
}

-(void)clearCacheInThread
{
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
