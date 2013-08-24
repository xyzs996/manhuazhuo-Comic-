//
//  SectionDownloadManager.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SectionDownloadManager.h"
#import "FileHelper.h"

@interface SectionDownloadManager ()

@property(nonatomic,retain)NSOperationQueue *picDownlist;//下载图片的列表

-(void)startNewTaskInThread:(id)data;//线程中新增下载
-(void)sectionDownloadStateChanaged:(NSNotification *)notification;//队列中的对象的下载状态通知
@end


static SectionDownloadManager *instance;

@implementation SectionDownloadManager

@synthesize downinglist;
@synthesize picDownlist;

+(SectionDownloadManager *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[SectionDownloadManager alloc] init];
    }
    return instance;
}

-(id)init
{
    if(self=[super init])
    {
        picDownlist=[[NSOperationQueue alloc] init];
        [picDownlist setMaxConcurrentOperationCount:2];
        self.downinglist=[self getDownloadingFiles];
//        downinglist=[[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc
{
    [self.picDownlist cancelAllOperations];
    self.picDownlist=nil;
    [instance release];
    instance=nil;
    self.downinglist=nil;
    [super dealloc];
}

#pragma mark - private method 

-(void)sectionDownloadStateChanaged:(NSNotification *)notification
{
    SectionModel *sectionModel=notification.object;
    switch (sectionModel.sectionDownloadState) {
        case SectionDownloaded:
        {
            [downinglist removeObjectForKey:sectionModel.sectionID];
        }
            break;
            
        default:
            break;
    }
}

-(void)startDownSection:(SectionModel *)secModel
{
    [NSThread detachNewThreadSelector:@selector(startNewTaskInThread:) toTarget:self withObject:secModel];
}

-(void)startNewTaskInThread:(id)data
{
    @autoreleasepool {
        SectionModel *secModel=(SectionModel *)data;
        if(![self isDownloadingSection:secModel])
        {
            //实例化新的对象，断绝与之前的对象的关系
            SectionModel *copySection=[[[SectionModel alloc] init] autorelease];
            copySection.sectionID=secModel.sectionID;
            copySection.sectionURL=secModel.sectionURL;
            copySection.sectionName=secModel.sectionName;
            copySection.sectionDownloadState=secModel.sectionDownloadState;
            copySection.picCount=secModel.picCount;
            copySection.piclist=secModel.piclist;
            copySection.className=secModel.className;
            copySection.isSelected=secModel.isSelected;
            copySection.bookID=secModel.bookID;
            copySection.bookName=secModel.bookName;
            copySection.bookIconURL=secModel.bookIconURL;
            copySection.author=secModel.author;
            copySection.bookIntro=secModel.bookIntro;
            copySection.groupName=secModel.groupName;
            [downinglist setObject:copySection forKey:copySection.sectionID];
            [copySection start];
        }
    }
}

-(void)continueToDownload:(id)data
{
    SectionModel *secModel=(SectionModel *)data;
    SectionModel *curModel=[downinglist objectForKey:secModel.sectionID];
    [curModel continueToDownload];
}

-(BOOL)isDownloadingSection:(SectionModel *)sectionModel
{
    SectionModel *secDownModel=[downinglist objectForKey:sectionModel.sectionID];
    BOOL flag=NO;
    if(secDownModel!=nil)
    {
        if(secDownModel.sectionDownloadState==SectionDownloading)
        {
            flag=YES;
        }
    }
    return flag;
}

//得到正在下载的章节
-(NSMutableDictionary *)getDownloadingFiles
{
    NSMutableDictionary *files=[[[NSMutableDictionary alloc] init] autorelease];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSArray *bookFolderlist=[fileManager contentsOfDirectoryAtPath:kDownloadingPath error:nil];
    for(NSString *bookName in bookFolderlist)
    {
        NSString *bookPath=[kDownloadingPath stringByAppendingPathComponent:bookName];
        NSArray *sectionFolderlist=[fileManager contentsOfDirectoryAtPath:bookPath error:nil];
        for(NSString *section in sectionFolderlist)
        {
            if(![[section substringToIndex:1] isEqualToString:@"."])//忽略.DS_Store
            {
                NSString *sectionPath=[bookPath stringByAppendingPathComponent:section];
                NSString *sectionConfigPath=[sectionPath stringByAppendingPathComponent:kSectionConfigName];
                if([[FileHelper sharedInstance] isExistPath:sectionConfigPath])
                {
                    SectionModel *secModel=[[FileHelper sharedInstance] unArchiverModel:sectionConfigPath];
                    NSString *desSectionPath=[[[kDownloadedPath stringByAppendingPathComponent:kDefaultDownloadFolder] stringByAppendingPathComponent:secModel.bookName] stringByAppendingPathComponent:secModel.sectionName];
                    NSFileManager *fileManager=[NSFileManager defaultManager];
                    NSArray *filelist=[fileManager contentsOfDirectoryAtPath:desSectionPath error:nil];
                    secModel.progress=(CGFloat)[filelist count]/secModel.picCount;
                    secModel.sectionDownloadState=SectionPause;
                    
                    [files setObject:secModel forKey:secModel.sectionID];
                }
            }
        }
    }
    return files;
}


-(void)cancelAllDowning
{
    for(NSString *key in [downinglist allKeys])
    {
        SectionModel *helper=[downinglist objectForKey:[downinglist objectForKey:key]];
        [helper cancel];
    }
    self.downinglist=nil;
}

-(void)cancelForSection:(SectionModel *)sectionModel
{
    SectionModel *secDownModel=[downinglist objectForKey:sectionModel.sectionID];
    [secDownModel cancel];
    [downinglist removeObjectForKey:sectionModel.sectionID];
}


-(void)suspendForSection:(SectionModel *)sectionModel
{
    SectionModel *secDownModel=[downinglist objectForKey:sectionModel.sectionID];
    [secDownModel suspend];
}

-(SectionDownloadState)getStateBySectionModel:(SectionModel *)sectionModel
{
    SectionDownloadState downState=SectionNotDownload;
    SectionModel *tmpSecModel=[self.downinglist objectForKey:sectionModel.sectionID];
    if(tmpSecModel!=nil)
    {
        downState=tmpSecModel.sectionDownloadState;
    }
    else {
        NSString *sectionPath=[[[[kDownloadedPath stringByAppendingPathComponent:kDefaultDownloadFolder] stringByAppendingPathComponent:sectionModel.bookName] stringByAppendingPathComponent:sectionModel.sectionName] stringByAppendingPathComponent:kSectionConfigName];
        if([[FileHelper sharedInstance] isExistPath:sectionPath])
        {
            downState=SectionDownloaded;
        }
        else {
            downState=SectionNotDownload;
        }
    }
    return downState;
}

-(NSString *)getStateStringByState:(SectionDownloadState)state
{
    if(state==SectionDownloaded)
    {
        return @"已下载";
    }
    else if(state==SectionDownloading)
    {
        return @"下载中";
    }
    else if(state==SectionWatting)
    {
        return @"地址获取中";
    }
    else if(state==SectionPause) {
        return @"暂停中";
    }
    return @"";
}
#pragma sectionHelper Delegate

-(CGFloat)getProgressBySection:(SectionModel *)sectionModel
{
    NSString *secPath=[[kDownloadingPath stringByAppendingPathComponent:sectionModel.bookName] stringByAppendingPathComponent:sectionModel.sectionName];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error=nil;
    NSArray *picItems=[fileManager contentsOfDirectoryAtPath:secPath error:&error];
    int tmpFileCount=0;
    if(error!=nil)
    {
        NSLog(@"%@",error);
    }
    for(NSString *fileName in picItems)
    {
        if([fileName hasSuffix:@"temp"])
        {
            tmpFileCount++;
        }
    }
    return (CGFloat)([picItems count]-1-tmpFileCount)/[sectionModel.piclist count];//漫画文件夹下有一个配置文件
}



@end
