//
//  SectionDownloadManager.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"
#import <Foundation/Foundation.h>
#import "SectionModel.h"
#import "SectionDownloadManager.h"
#import "ASIHTTPRequest.h"
#import "MD5Helper.h"
#import "PictureModel.h"

@interface SectionDownloadManager : NSObject<ASIHTTPRequestDelegate>

@property(nonatomic,retain)NSMutableDictionary *downinglist;

+(SectionDownloadManager *)sharedInstance;

-(void)startDownSection:(SectionModel *)secModel;
-(void)continueToDownload:(id)data;//继续下载
-(void)suspendForSection:(SectionModel *)secModel;
-(void)cancelAllDowning;
-(void)cancelForSection:(SectionModel *)sectionModel;

-(SectionDownloadState)getStateBySectionModel:(SectionModel *)sectionModel;
-(NSString *)getStateStringByState:(SectionDownloadState)state;//根据下载状态返回文本
-(NSMutableDictionary *)getDownloadingFiles;//获取正在下载的文件集合，对象是SectionModel
-(CGFloat)getProgressBySection:(SectionModel *)sectionModel;//得到这个section的下载进度
-(BOOL)isDownloadingSection:(SectionModel *)sectionModel;
@end
