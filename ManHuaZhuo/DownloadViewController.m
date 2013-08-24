//
//  DownloadViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DownloadViewController.h"
#import "DownloadCell.h"
#import "CommonHelper.h"
#import "FileHelper.h"

@interface DownloadViewController ()

@property(nonatomic,retain)UITableView *downTableview;
@property(nonatomic,retain)NSMutableDictionary *downinglist;

-(void)loadLocalSectionlistInThread;//后台加载本地章节
-(BOOL)isExistQueue:(SectionModel *)sectionModel;
-(void)sectionDownloadNotification:(NSNotification *)notif;//章节下载的通知
-(void)updateCellUI:(SectionModel *)sectionModel;
@end

@implementation DownloadViewController

@synthesize downTableview;
@synthesize downinglist;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sectionDownloadNotification:) name:SectionDownloadNotification object:nil];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 7, 48, 30)];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_normal.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(editTableView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    
    
    
    downTableview=[[UITableView alloc] init];
    [downTableview setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-44)];
    [downTableview setDataSource:self];
    [downTableview setDelegate:self];
    [downTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:downTableview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [CommonHelper showHud:self title:@"请稍候..." selector:@selector(loadLocalSectionlistInThread) arg:nil targetView:self.view];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)releaseData
{
    self.downinglist=nil;
    self.downTableview=nil;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

#pragma mark - private method
-(void)loadLocalSectionlistInThread
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    self.downinglist=  [[SectionDownloadManager sharedInstance] getDownloadingFiles];
    [self.downTableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [pool release];
}

-(void)editTableView
{   
    if([downTableview isEditing])
    {
        UIButton *btnEdit=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnEdit setFrame:CGRectMake(0, 7, 48, 30)];
        [btnEdit.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
        [btnEdit setBackgroundImage:[UIImage imageNamed:@"nav_normal.png"] forState:UIControlStateNormal];
        [btnEdit addTarget:self action:@selector(editTableView) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btnEdit] autorelease];
    }
    else {
        self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(editTableView)]autorelease];
    }
    [downTableview setEditing:!downTableview.isEditing animated:YES];
}

#pragma mark Tableview DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [downinglist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify=@"CellIdentify";
    DownloadCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if(cell==nil)
    {
        cell=[[[DownloadCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentify] autorelease];
    }
    NSString *key=[[downinglist allKeys] objectAtIndex:indexPath.row];
    SectionModel *secModel=[downinglist objectForKey:key];
    [cell updateCellState:[NSNumber numberWithInt:secModel.sectionDownloadState]];
    cell.proView.progress=secModel.progress;
    cell.lblState.text=[[SectionDownloadManager sharedInstance] getStateStringByState:secModel.sectionDownloadState];
    cell.lblName.text=[NSString stringWithFormat:@"%@-%@",secModel.bookName,secModel.sectionName];
    return cell;
}

#pragma mark tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key=[[downinglist allKeys] objectAtIndex:indexPath.row];
    SectionModel *secModel=[downinglist objectForKey:key];
    if(![[SectionDownloadManager sharedInstance] isDownloadingSection:secModel])
    {
        [[SectionDownloadManager sharedInstance] continueToDownload:secModel];
    }
    else {
        //通知当前章节下载状态
        [[SectionDownloadManager sharedInstance] suspendForSection:secModel];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        NSString *key=[[downinglist allKeys] objectAtIndex:indexPath.row];
        SectionModel *delSection=[downinglist objectForKey:key];
        NSString *downingSecPath=[[kDownloadingPath stringByAppendingPathComponent:delSection.bookName] stringByAppendingPathComponent:delSection.sectionName];
        NSString *desSecPath=[[[kDownloadedPath stringByAppendingPathComponent:@"默认文件夹"] stringByAppendingPathComponent:delSection.bookName] stringByAppendingPathComponent:delSection.sectionName];
                
        //先恢复控件原始状态，否则重用会导致下面的cell控件不一致
        DownloadCell *cell=(DownloadCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell recoverFrame];
        
        //取消下载
        //通知当前章节下载状态
        delSection.sectionDownloadState=SectionNotDownload;
        [[NSNotificationCenter defaultCenter] postNotificationName:SectionDownloadNotification object:delSection];
        [[SectionDownloadManager sharedInstance] cancelForSection:delSection];

        
        //删除当前表格的数据源和Cell
        [downinglist removeObjectForKey:key];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        //删除正在下载的配置文件和已下载的
        [[FileHelper sharedInstance] performSelectorInBackground:@selector(removeItemAtPath:) withObject:downingSecPath];
        [[FileHelper sharedInstance] performSelectorInBackground:@selector(removeItemAtPath:) withObject:desSecPath];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(BOOL)isExistQueue:(SectionModel *)sectionModel
{
    BOOL flag=NO;
    SectionModel *secModel=[downinglist objectForKey:sectionModel.sectionID];
    if(secModel!=nil)
    {
        flag=YES;
    }
    return flag;
}

-(void)updateCellUI:(SectionModel *)sectionModel
{
    //获得indexpath
    int index=0;
    for(NSString *key in [downinglist allKeys])
    {
        SectionModel *tmpSection=[downinglist objectForKey:key];
        if(tmpSection.sectionID==sectionModel.sectionID)
        {
            break;
        }
        index++;
    }

    NSIndexPath *targetIndexPath=[NSIndexPath indexPathForRow:index inSection:0];

   
    switch (sectionModel.sectionDownloadState) {
        case SectionNew:
        {
            NSLog(@"新增下载%@",sectionModel);
            [downinglist setObject:sectionModel forKey:sectionModel.sectionID];
            [downTableview insertRowsAtIndexPaths:[NSArray arrayWithObject:targetIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
        case SectionWatting:
            if(![self isExistQueue:sectionModel])
            {
               
            }
            break;
        case SectionDownloaded:
        {
            NSLog(@"下载结束%@",sectionModel);
            [downinglist removeObjectForKey:sectionModel.sectionID];
            [downTableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:targetIndexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
            break;
        default:
            break;
    }
    //防止暂停和删除的情况更新UI挂掉
    
    if(sectionModel.sectionDownloadState!=SectionNotDownload||sectionModel.sectionDownloadState!=SectionDownloaded)
    {
        UITableViewCell *cell=[downTableview cellForRowAtIndexPath:targetIndexPath];
        if(cell==nil)
        {
            return;
        }
        SectionModel *tmpSection=[downinglist objectForKey:sectionModel.sectionID];
        if(tmpSection!=nil)
        {
            [downTableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:targetIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        [downTableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:targetIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - sectionDwonlaod Notification
-(void)sectionDownloadNotification:(NSNotification *)notif
{
    if([notif.name isEqualToString:SectionDownloadNotification])
    {
        SectionModel *newSectionModel=notif.object;
        
        //更新本地数据苑
        SectionModel *oldSection=[downinglist objectForKey:newSectionModel.sectionID];
        oldSection.sectionDownloadState=newSectionModel.sectionDownloadState;
        oldSection.progress=(CGFloat)newSectionModel.progress;
        //更新UI
        [self performSelectorOnMainThread:@selector(updateCellUI:) withObject:newSectionModel waitUntilDone:YES];
    }
}
@end