//
//  SectionModel.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Constants.h"
#import "PictureModel.h"
#import "BookModel.h"
#import "ASIHTTPRequest.h"

#define SectionDownloadNotification @"SectionDownloadNotification"//对象下载过程中，对全局程序的通知

@interface SectionModel : BookModel<NSCoding,NSCopying,ASIHTTPRequestDelegate,NSMutableCopying>

@property(nonatomic,retain)NSString *sectionID;
@property(nonatomic,retain)NSString *sectionURL;
@property(nonatomic,retain)NSString *sectionName;
@property(nonatomic,assign)NSUInteger picCount;
@property(nonatomic,retain)NSMutableArray *piclist;
@property(nonatomic,retain)NSString *className;
@property(nonatomic)BOOL isSelected;
@property(nonatomic,assign)SectionDownloadState sectionDownloadState;
@property(nonatomic,retain)NSString *bookID;
@property(nonatomic,retain)NSString *bookName;
@property(nonatomic,assign)CGFloat progress;
@property(nonatomic,retain)NSString *groupName;

-(void)start;
-(void)suspend;
-(void)cancel;
-(void)continueToDownload;
@end
