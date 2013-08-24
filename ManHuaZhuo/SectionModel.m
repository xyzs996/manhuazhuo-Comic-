//
//  SectionModel.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SectionModel.h"
#import "FileHelper.h"
#import "Constants.h"
#import "PictureDAL.h"
#import "JSON.h"

@interface SectionModel()
{
    BOOL _isDowning;//整个对象是否还存在下载队列中，(暂停也是正在下载)
}
@property(nonatomic,retain)NSOperationQueue *downlist;
@end



@implementation SectionModel

@synthesize sectionID;
@synthesize sectionURL;
@synthesize sectionName;
@synthesize picCount;
@synthesize piclist;
@synthesize className;
@synthesize isSelected;
@synthesize sectionDownloadState;
@synthesize bookID;
@synthesize bookName;
@synthesize progress;
@synthesize groupName;
@synthesize downlist;


-(id)mutableCopyWithZone:(NSZone *)zone
{
    SectionModel *sectionModel=NSCopyObject(self,0,zone);
    sectionModel.sectionID=[self.sectionID mutableCopy];
    sectionModel.sectionURL=[self.sectionURL mutableCopy];
    sectionModel.sectionName=[self.sectionName mutableCopy];
    sectionModel.sectionDownloadState=self.sectionDownloadState;
    sectionModel.picCount=self.picCount;
    sectionModel.piclist=[self.piclist mutableCopy];
    sectionModel.className=[self.className mutableCopy];
    sectionModel.isSelected=self.isSelected;
    sectionModel.bookID=[self.bookID mutableCopy];
    sectionModel.bookName=[self.bookName mutableCopy];
    sectionModel.bookIconURL=[self.bookIconURL mutableCopy];
    sectionModel.author=[self.author mutableCopy];
    sectionModel.bookIntro=[self.bookIntro mutableCopy];
    sectionModel.groupName=[self.groupName mutableCopy];
    return sectionModel;
}


-(id)copyWithZone:(NSZone *)zone
{
    SectionModel *sectionModel=[[[self class] allocWithZone:zone] init];
    sectionModel.sectionID=[[self.sectionID copyWithZone:zone] autorelease];
    sectionModel.sectionURL=[[self.sectionURL copyWithZone:zone] autorelease];
    sectionModel.sectionName=[[self.sectionName copyWithZone:zone] autorelease];
    sectionModel.sectionDownloadState=self.sectionDownloadState;
    sectionModel.picCount=self.picCount;
    sectionModel.piclist=[[self.piclist copyWithZone:zone] autorelease];
    sectionModel.className=[[self.className copyWithZone:zone] autorelease];
    sectionModel.isSelected=self.isSelected;
    sectionModel.bookID=[[self.bookID copyWithZone:zone] autorelease];
    sectionModel.bookName=[[self.bookName copyWithZone:zone] autorelease];
    sectionModel.bookIconURL=[[self.bookIconURL copyWithZone:zone] autorelease];
    sectionModel.author=[[self.author copyWithZone:zone] autorelease];
    sectionModel.bookIntro=[[self.bookIntro copyWithZone:zone] autorelease];
    sectionModel.groupName=[[self.groupName copyWithZone:zone] autorelease];
    return sectionModel;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:sectionID forKey:@"sectionID"];
    [aCoder encodeObject:sectionURL forKey:@"sectionURL"];
    [aCoder encodeObject:sectionName forKey:@"sectionName"];
    [aCoder encodeInt:picCount forKey:@"picCount"];
//    NSString *piclistPath=[[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:self.bookName] stringByAppendingPathComponent:self.sectionName] stringByAppendingFormat:@"piclist.archive"];
//    [[FileHelper sharedInstance] archiverModel:piclist filePath:piclistPath];
    [aCoder encodeObject:piclist forKey:@"piclist"];
    [aCoder encodeObject:className forKey:@"className"];
    [aCoder encodeBool:isSelected forKey:@"isSelected"];
    [aCoder encodeInt:sectionDownloadState forKey:@"sectionDownloadState"];
    [aCoder encodeObject:bookID forKey:@"bookID"];
    [aCoder encodeObject:bookName forKey:@"bookName"];
    [aCoder encodeObject:self.bookIconURL forKey:@"BookIconURL"];
    [aCoder encodeObject:self.author forKey:@"Author"];
    [aCoder encodeObject:self.bookIntro forKey:@"Introduce"];
    [aCoder encodeObject:self.groupName forKey:@"groupName"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super init])
    {
        self.sectionID=[aDecoder decodeObjectForKey:@"sectionID"];
        self.sectionURL=[aDecoder decodeObjectForKey:@"sectionURL"];
        self.sectionName=[aDecoder decodeObjectForKey:@"sectionName"];
//        NSString *piclistPath=[[[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:self.bookName] stringByAppendingPathComponent:self.sectionName] stringByAppendingFormat:@"piclist.archive"];
//        self.piclist=[[FileHelper sharedInstance] unArchiverModel:piclistPath];
        self.piclist=[aDecoder decodeObjectForKey:@"piclist"];
        self.picCount=[aDecoder decodeIntForKey:@"picCount"];
        self.className=[aDecoder decodeObjectForKey:@"className"];
        self.isSelected=[aDecoder decodeBoolForKey:@"isSelected"];
        self.sectionDownloadState=[aDecoder decodeIntForKey:@"sectionDownloadState"];
        self.bookID=[aDecoder decodeObjectForKey:@"bookID"];
        self.bookName=[aDecoder decodeObjectForKey:@"bookName"];
        self.bookIconURL=[aDecoder decodeObjectForKey:@"BookIconURL"];
        self.author=[aDecoder decodeObjectForKey:@"Author"];
        self.bookIntro=[aDecoder decodeObjectForKey:@"Introduce"];
        self.groupName=[aDecoder decodeObjectForKey:@"groupName"];
    }
    return self;
}

-(void)dealloc
{
    self.downlist=nil;
    self.groupName=nil;
    self.bookName=nil;
    self.bookID=nil;
    self.className=nil;
    self.piclist=nil;
    self.sectionName=nil;
    self.sectionURL=nil;
    self.sectionID=nil;
    [super dealloc];
}

-(void)start
{   
    //新增下载
    self.sectionDownloadState=SectionNew;
    [[NSNotificationCenter defaultCenter] postNotificationName:SectionDownloadNotification object:self]; 
    
    [self continueToDownload];
}

-(void)suspend
{    
    //取消正在下载的
    for(ASIHTTPRequest *request in downlist.operations)
    {
        if(request.isExecuting)
        {
            [request clearDelegatesAndCancel];
        }
    }
    
    [downlist setSuspended:YES];
    self.sectionDownloadState=SectionPause;
    [[NSNotificationCenter defaultCenter] postNotificationName:SectionDownloadNotification object:self];
}

-(void)continueToDownload
{
    
    [downlist setSuspended:NO];
    
    //等待下载
    self.sectionDownloadState=SectionWatting;
    [[NSNotificationCenter defaultCenter] postNotificationName:SectionDownloadNotification object:self];
    
    
    //*********************创建必备的文件夹和每个section的对象归档信息
    NSString *bookPath=[kDownloadingPath stringByAppendingPathComponent:self.bookName];
    NSString *sectionPath=[bookPath stringByAppendingPathComponent:self.sectionName];
    NSString *sectionConfigPath=[sectionPath stringByAppendingPathComponent:kSectionConfigName];
    
    if(![[FileHelper sharedInstance] isExistPath:bookPath])
    {
        //创建书籍的文件夹
        if(![[FileHelper sharedInstance] createDirectory:bookPath])
        {
            NSLog(@"创建书籍文件夹失败!");
            return;
        }
    }
    if(![[FileHelper sharedInstance] isExistPath:sectionPath])
    {
        if(![[FileHelper sharedInstance] createDirectory:sectionPath])
        {
            NSLog(@"创建章节失败");
            return;
        }
    }
    //默认下载都在“默认文件夹”,该文件夹名字不可编辑和删除
    NSString *destionBookPath=[[kDownloadedPath stringByAppendingPathComponent:kDefaultDownloadFolder] stringByAppendingPathComponent:self.bookName];
    NSString *destionSectionPath=[destionBookPath stringByAppendingPathComponent:self.sectionName];
    if(![[FileHelper sharedInstance] isExistPath:destionBookPath])
    {
        //创建书籍的文件夹
        if(![[FileHelper sharedInstance] createDirectory:destionBookPath])
        {
            NSLog(@"创建书籍文件夹失败!");
            return;
        }
    }
    if(![[FileHelper sharedInstance] isExistPath:destionSectionPath])
    {
        if(![[FileHelper sharedInstance] createDirectory:destionSectionPath])
        {
            NSLog(@"创建章节失败");
            return;
        }
    }
    
    
    
    //归档配置文件
    if(![[FileHelper sharedInstance] isExistPath:sectionConfigPath])
    {
        [[FileHelper sharedInstance] archiverModel:self filePath:sectionConfigPath];
    }
    
    
    //如果没有获取该章节的图片列表，则先下载，再更新配置归档
    if([self.piclist count]==0)
    {
        NSString *pictureURL=[[PictureDAL sharedInstance] getPicturelistURLBySectionID:self.sectionID];
        
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:pictureURL]];
        NSData *resultData=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        self.piclist=[[PictureDAL sharedInstance] parsePicturelist:[resultData JSONValue]];
        [[FileHelper sharedInstance] archiverModel:self filePath:sectionConfigPath];
    }
    
    
    
    //开始下载图片
    self.groupName=kDefaultDownloadFolder;
    if(self.downlist==nil)
    {
        self.downlist=[[[NSOperationQueue alloc]init]autorelease];
        [downlist setMaxConcurrentOperationCount:2];
    }
    int downingCount=0;//统计有多少个开始下载,以便通知开始的进度
    //解析的图片列表是按照url页数升序的
    for(int i=0;i<[self.piclist count];i++)
    {
        PictureModel*pic=[self.piclist objectAtIndex:i];
        NSString *md5Name=[[PictureDAL sharedInstance] getPicNameByPictureURL:pic.picURL andIndex:i];
        NSString *destionPath=[destionSectionPath stringByAppendingPathComponent:md5Name];
        NSString *tmpPath=[sectionPath stringByAppendingPathComponent:md5Name];
        if(![[FileHelper sharedInstance] isExistPath:destionPath])
        {
            ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:pic.picURL]];
            [request setRequestHeaders:[NSMutableDictionary dictionaryWithObject:pic.picReferURL forKey:@"Referer"]];
            [request setDownloadDestinationPath:destionPath];
            [request setTemporaryFileDownloadPath:tmpPath];
            [request setDelegate:self];
            [request setShouldContinueWhenAppEntersBackground:YES];
            [request setAllowResumeForFileDownloads:YES];
            [downlist addOperation:request];
            [request release];
            downingCount++;
        }
    }
    
    
    //监听进度和完成情况
    _isDowning=YES;
    while (_isDowning) {
        if(self.sectionDownloadState==SectionPause)
        {
            continue;
        }
        NSString *desSectionPath=[[[kDownloadedPath stringByAppendingPathComponent:kDefaultDownloadFolder] stringByAppendingPathComponent:self.bookName] stringByAppendingPathComponent:self.sectionName];
        int fileCount=[[FileHelper sharedInstance] getFileCountByPath:desSectionPath];
        //        NSLog(@"fileCount=%d,%d",fileCount,[self.piclist count]);
        if(downlist.operations==0&&(fileCount!=self.picCount))//取消
        {
            return;
        }
        self.progress=(CGFloat)fileCount/[self.piclist count];
        if(fileCount==[self.piclist count])//下载完成
        {
            NSString *bookPath=[kDownloadingPath stringByAppendingPathComponent:self.bookName];
            NSString *sectionPath=[bookPath stringByAppendingPathComponent:self.sectionName];
            
            //删除配置文件和文件夹
            if([[FileHelper sharedInstance]isExistPath:sectionPath])
            {
                [[FileHelper sharedInstance] removeItemAtPath:sectionPath];
            }
            
            
            
            self.sectionDownloadState=SectionDownloaded;
            NSString *bookConfigPath=[[[kDownloadedPath stringByAppendingPathComponent:kDefaultDownloadFolder] stringByAppendingPathComponent:self.self.bookName] stringByAppendingPathComponent:kBookConfigName];
            //到已下载文件夹下创建book的配置文件
            [[FileHelper sharedInstance] archiverModel:self filePath:bookConfigPath];
            
            //已下载的章节配置文件
            NSString *secConfigPath=[[[[kDownloadedPath stringByAppendingPathComponent:kDefaultDownloadFolder] stringByAppendingPathComponent:self.bookName] stringByAppendingPathComponent:self.sectionName] stringByAppendingPathComponent:kSectionConfigName];
            [[FileHelper sharedInstance] archiverModel:self filePath:secConfigPath];
            
            _isDowning=NO;
            //通知委托下载完成
            self.sectionDownloadState=SectionDownloaded;
            [[NSNotificationCenter defaultCenter] postNotificationName:SectionDownloadNotification object:self];
        }
        else {
            self.sectionDownloadState=SectionDownloading;
            [[NSNotificationCenter defaultCenter] postNotificationName:SectionDownloadNotification object:self];
            //间隔1s进行下载进度统计
            [NSThread sleepForTimeInterval:1.0f];
        }
    }
}

-(void)cancel
{
    self.sectionDownloadState=SectionCancel;
    [[NSNotificationCenter defaultCenter] postNotificationName:SectionDownloadNotification object:self];
    
    
    //取消下载
    _isDowning=NO;
    [downlist cancelAllOperations];
}

#pragma mark - asihttp _delegate
-(void)requestFailed:(ASIHTTPRequest *)request
{
    [request redirectToURL:request.url];
}

@end
