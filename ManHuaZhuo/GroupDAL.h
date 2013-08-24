//
//  GroupDAL.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupDAL : NSObject

+(GroupDAL *)sharedInstance;

-(NSString *)getGroupRootPath;//得到分组的根级目录
-(NSMutableArray *)getLocalGroup;//得到本地书籍分组,返回字符串数组
-(NSMutableArray *)getLocalBooksByGroupName:(NSString *)groupName;//得到有下载完成的书籍

@end
