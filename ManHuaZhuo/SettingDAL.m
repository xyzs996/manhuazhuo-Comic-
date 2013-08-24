//
//  SettingDAL.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingDAL.h"

#define kSettingRotate @"ShouldRotate"
#define kSettingTurnDirection @"TurnDirection"
#define kSettingNotification @"Notification"
#define kSettingFirstInstallApp @"FirstInstallApp"

static SettingDAL *instance;

@implementation SettingDAL

+(SettingDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[SettingDAL alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    [instance release];
    [super dealloc];
}

-(BOOL)shouldNotification
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingNotification];
}

-(void)updateNotification:(BOOL)flag
{
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:kSettingNotification];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)updateRotateViewState:(BOOL)flag
{
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:kSettingRotate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)isFirstInstallApp
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:kSettingFirstInstallApp]==nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:kSettingFirstInstallApp];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    else {
        return NO;
    }
}

-(BOOL)shouleRotateView
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingRotate];
}

-(void)updateTurnPageDirection:(BOOL)right
{
    [[NSUserDefaults standardUserDefaults] setBool:right forKey:kSettingTurnDirection];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)shouldTurnToRight
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingTurnDirection];
}

-(NSString *)getUUID
{
    return [[UIDevice currentDevice] uniqueIdentifier];
}
@end
