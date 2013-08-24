//
//  SectionlistViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SectionlistViewController.h"
#import "SectionDAL.h"
#import "SectionModel.h"
#import "PictureViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "JSON.h"
#import "SectionNet.h"

#define kControlDownSection 1001
#define kControlSelectAll 1002

@interface SectionlistViewController ()
{
    BOOL isEditing;
    BOOL isSelectAll;
}

@property(nonatomic,retain) UIButton *btnSection;
@property(nonatomic,retain)UIButton *btnSelect;
@property(nonatomic,retain)BookModel *currentBook;
@property(nonatomic,retain)UITableView *dataTableView;

-(void)editSection:(id)sender;//编辑表格
-(void)downSection;//下载所选章节
-(void)downloadNotification:(NSNotification *)notification;//全局的下载通知
-(void)updateUIOnMainThread:(NSIndexPath *)tarIndex;//主界面更新UI
@end

@implementation SectionlistViewController

@synthesize btnSection;
@synthesize currentBook;
@synthesize dataTableView;
@synthesize btnSelect;

-(id)initWithBookModel:(BookModel *)bookModel
{
    if(self=[super init])
    {
        self.currentBook=bookModel;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadNotification:) name:SectionDownloadNotification object:nil];
    }
    return self;
}


-(void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationItem.title=[NSString stringWithFormat:@"%@(%@)",self.currentBook.bookName,self.currentBook.bookStateName];
    
   
    
    //弹出对话框确认，直接下载整本书籍
    self.btnSelect=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSelect setTag:kControlSelectAll];
    [btnSelect.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [btnSelect setTitle:@"全选章节" forState:UIControlStateNormal];
    [btnSelect setBackgroundImage:[UIImage imageNamed:@"product_button_blue.png"] forState:UIControlStateNormal];
    [btnSelect addTarget:self action:@selector(editSection:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSelect];

    
    //部分章节下载
    btnSection=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSection setFrame:CGRectMake(18, 20, 132, 32)];
    [btnSelect setFrame:btnSection.frame];
    [btnSection setTag:kControlDownSection];
    [btnSection.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [btnSection setTitle:@"筛选下载" forState:UIControlStateNormal];
    [btnSection setBackgroundImage:[UIImage imageNamed:@"product_button_blue.png"] forState:UIControlStateNormal];
    [btnSection addTarget:self action:@selector(editSection:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSection];

    
    dataTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height-44-44-80)];
    [dataTableView setDelegate:self];
    [dataTableView setDataSource:self];
    [self.view addSubview:dataTableView];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self showLoadingView];

    [NSThread detachNewThreadSelector:@selector(startRequestSectionlistInThread:) toTarget:self withObject:self.currentBook];
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [dataTableView deselectRowAtIndexPath:[dataTableView indexPathForSelectedRow] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}


-(void)releaseData
{
    self.dataTableView=nil;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [SectionNet cancelDownloadSectionlist];
    [self releaseData];
    self.currentBook=nil;
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

#pragma mark- private method


-(void)startRequestSectionlistInThread:(BookModel *)curBook
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    self.currentBook.sectionlist= [SectionNet startDownloadSectionlist:curBook];
    if([self.currentBook.sectionlist count]==0)
    {
        [self showErrorView];
        return;
    }
    [self performSelectorOnMainThread:@selector(hideLoadingView) withObject:nil waitUntilDone:YES];
    [dataTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [self hideLoadingView];
    [pool release];
}

-(void)downloadNotification:(NSNotification *)notification
{
    //如果正在下载过程中，章节列表视图未加载成功则不更新UI
    if([self.currentBook.sectionlist count]==0)
    {
        return;
    }
    //找到数据对象
    SectionModel *newSection=notification.object;
    SectionModel *oldSection=[self.currentBook.sectionlist objectForKey:newSection.sectionID];
    oldSection.sectionDownloadState=newSection.sectionDownloadState;
    
    //找到数据对象索引==》NSIndexPath
    int i=0;
    for(NSString *key in [self.currentBook.sectionlist allKeys])
    {
        if([key isEqualToString:newSection.sectionID])
        {
            break;
        }
        i++;
    }
    NSIndexPath *tarIndex=[NSIndexPath indexPathForRow:i inSection:0];
    
    //找到cell，更新ui
    [self performSelectorOnMainThread:@selector(updateUIOnMainThread:) withObject:tarIndex waitUntilDone:YES];
}

-(void)updateUIOnMainThread:(NSIndexPath *)tarIndex
{
    [dataTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:tarIndex] withRowAnimation:UITableViewRowAnimationNone];
}


-(void)downSection
{
    NSArray *selectedRows=  [dataTableView indexPathsForSelectedRows];
    for(int i=0;i<[selectedRows count];i++)
    {
        NSIndexPath *currentIndexPath=[selectedRows objectAtIndex:i];
        NSString *key=[[currentBook.sectionlist allKeys] objectAtIndex:currentIndexPath.row];
        SectionModel *selectedSection=[self.currentBook.sectionlist objectForKey:key];
        [[SectionDownloadManager sharedInstance] startDownSection:selectedSection];
    }
    [dataTableView reloadData];
}

-(void)updateCellSelect:(BOOL)flag
{
    for(int i=0;i<[[currentBook.sectionlist allKeys] count];i++)
    {
        if(flag)
        {
            [dataTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        else {
            [dataTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
        }
    }
}

-(void)editSection:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    switch (btn.tag) {
        case kControlDownSection://下载章节
        {
            [dataTableView setEditing:!isEditing animated:YES];
            if(!isEditing)
            {
                [UIView animateWithDuration:0.2 animations:^(void){
                    [btnSelect setFrame:CGRectMake(190, 20, 132, 32)];
                } completion:^(BOOL finished){
                    [UIView beginAnimations:nil context:nil];
                    [btnSelect setFrame:CGRectMake(170, 20, 132, 32)];
                    [UIView commitAnimations];
                }];
                [btnSection setTitle:@"取消下载" forState:UIControlStateNormal];
                
                UIButton *btnDown=[UIButton buttonWithType:UIButtonTypeCustom];
                [btnDown setFrame:CGRectMake(0, 0, 48, 30)];
                [btnDown.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
                [btnDown setTitle:@"下载" forState:UIControlStateNormal];
                [btnDown setBackgroundImage:[UIImage imageNamed:@"nav_normal.png"] forState:UIControlStateNormal];
                [btnDown addTarget:self action:@selector(downSection) forControlEvents:UIControlEventTouchUpInside];
                self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btnDown] autorelease];
            }
            else {
                [UIView animateWithDuration:0.3 animations:^(void){
                    [btnSelect setFrame:CGRectMake(190, 20, 132, 32)];
                } completion:^(BOOL finished){
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:0.2];
                    [btnSelect setFrame:btnSection.frame];
                    [UIView commitAnimations];
                }];
                [btnSection setTitle:@"筛选下载" forState:UIControlStateNormal];
                self.navigationItem.rightBarButtonItem=nil;
            }
            isEditing=!isEditing;
        }
            break;
        case kControlSelectAll:
        {
            if(isSelectAll)
            {
                [btnSelect setTitle:@"全选章节" forState:UIControlStateNormal];
                [self updateCellSelect:NO];
            }
            else {
                [btnSelect setTitle:@"取消全选" forState:UIControlStateNormal];
                [self updateCellSelect:YES];
            }
            isSelectAll=!isSelectAll;
        }
        default:
            break;
    }
}


#pragma tableview DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentBook.sectionlist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity=@"CellIdentify";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentity] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    NSString *key=[[currentBook.sectionlist allKeys] objectAtIndex:indexPath.row];
    SectionModel *section=[self.currentBook.sectionlist objectForKey:key];
    cell.textLabel.text=section.sectionName;
    NSString *detailString=[NSString stringWithFormat:@"%d页",section.picCount];
    detailString=[detailString stringByAppendingFormat:@"\n\n%@",[[SectionDownloadManager sharedInstance]getStateStringByState:section.sectionDownloadState]];
    cell.detailTextLabel.text=detailString;
    return cell;
}

#pragma tableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key=[[currentBook.sectionlist allKeys] objectAtIndex:indexPath.row];
    SectionModel *section=[self.currentBook.sectionlist objectForKey:key];
    if(isEditing)
    {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        section.isSelected=!cell.isSelected;
    }
    else {
        AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate showPictureViewController:section isLocalRequest:NO];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key=[[currentBook.sectionlist allKeys] objectAtIndex:indexPath.row];
    SectionModel *secModel=[self.currentBook.sectionlist objectForKey:key];
    if(secModel.sectionDownloadState!=SectionNotDownload)
    {
        return NO;
    }
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

#pragma mark - 错误视图的点击后处理
-(void)errorViewTappedGesture:(UITapGestureRecognizer *)gesture
{
    [NSThread detachNewThreadSelector:@selector(startRequestSectionlistInThread:) toTarget:self withObject:self.currentBook];
}

@end
