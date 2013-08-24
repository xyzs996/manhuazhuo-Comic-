//
//  SettingDAL.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingDAL : NSObject

+(SettingDAL *)sharedInstance;

//是否旋转屏
-(void)updateRotateViewState:(BOOL)flag;
-(BOOL)shouleRotateView;

//翻页方向
-(void)updateTurnPageDirection:(BOOL)right;
-(BOOL)shouldTurnToRight;

-(NSString *)getUUID;

//离线通知
-(BOOL)shouldNotification;
-(void)updateNotification:(BOOL)flag;

//是否是第一次使用程序
-(BOOL)isFirstInstallApp;

@end
