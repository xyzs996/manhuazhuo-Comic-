//
//  LocalBookViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalBookViewController.h"
#import "BookDAL.h"
#import "SectionModel.h"
#import "GroupDAL.h"
#import "BookCell.h"
#import "UIImageView+WebCache.h"
#import "LocalSectionViewController.h"
#import "AppDelegate.h"
#import "CommonHelper.h"
#import "FileHelper.h"
//#import "ModalAlert.h"

#define kTableViewBookTag 500
#define kTableViewTargetTag 501
#define kBarButtonSelect 503
#define kBarButtonDeSelect 504
#define kBarButtonDelete 505
#define kBarButtonMoveTag 506

@interface LocalBookViewController ()

@property(nonatomic,retain)NSString *groupName;
@property(nonatomic,retain)NSMutableArray *booklist;
@property(nonatomic,retain)NSMutableArray *grouplist;
@property(nonatomic,retain)UITableView *bookTableView;
@property(nonatomic,retain)UIToolbar *bottomBar;
@property(nonatomic,retain)UITableView *targetTableView;

-(void)editTableView;
-(void)barAction:(id)sender;
-(void)showGroupTableView:(BOOL)flag;

@end

@implementation LocalBookViewController

@synthesize bottomBar;
@synthesize groupName;
@synthesize booklist;
@synthesize bookTableView;
@synthesize targetTableView;
@synthesize grouplist;

-(id)initWithGroupName:(NSString *)_groupName
{
    if(self=[super init])
    {
        self.navigationItem.title=_groupName;
        self.groupName=_groupName;
        NSString *groupPath=[[[GroupDAL sharedInstance]getGroupRootPath] stringByAppendingPathComponent:groupName];
        booklist=[[[BookDAL sharedInstance] getFinsihedBooklistByGroupPath:groupPath] retain];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 7, 48, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    
    UIButton *btnEdit=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnEdit setFrame:CGRectMake(0, 7, 48, 30)];
    [btnEdit.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [btnEdit setTitle:@"编辑" forState:UIControlStateNormal];
    [btnEdit setBackgroundImage:[UIImage imageNamed:@"nav_normal.png"] forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(editTableView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btnEdit] autorelease];
    
    
    bookTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-44)];
    [bookTableView setTag:kTableViewBookTag];
    [bookTableView setDelegate:self];
    [bookTableView setDataSource:self];
    [bookTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:bookTableView];
    [bookTableView reloadData];
    
    //底部的bar
    bottomBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44-44, self.view.frame.size.width, 44)];
    [bottomBar setBarStyle:UIBarStyleBlack];
    [self.view addSubview:bottomBar];
    
    UIBarButtonItem *selectBar=[[[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStyleBordered target:self action:@selector(barAction:)]autorelease];
    [selectBar setTag:kBarButtonSelect];
    
    UIBarButtonItem *deSelectBar=[[[UIBarButtonItem alloc] initWithTitle:@"取消反选" style:UIBarButtonItemStyleBordered target:self action:@selector(barAction:)]autorelease];
    [deSelectBar setTag:kBarButtonDeSelect];
    
    UIBarButtonItem *deleteBar=[[[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(barAction:)]autorelease];
    [deleteBar setTag:kBarButtonDelete];
    
    UIBarButtonItem *moveBar=[[[UIBarButtonItem alloc] initWithTitle:@"移动至" style:UIBarButtonItemStyleBordered target:self action:@selector(barAction:)]autorelease];
    [moveBar setTag:kBarButtonMoveTag];
    
    [bottomBar setItems:[NSArray arrayWithObjects:selectBar,deSelectBar,deleteBar,moveBar, nil]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)dealloc
{
    [self releaseData];
    [super dealloc];
}

-(void)releaseData
{
    self.grouplist=nil;
    self.targetTableView=nil;
    self.bottomBar=nil;
    self.groupName=nil;
    self.bookTableView=nil;
    self.booklist=nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [bookTableView deselectRowAtIndexPath:[bookTableView indexPathForSelectedRow] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.tabBarController.tabBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.tabBarController.tabBar setHidden:YES];
    [appDelegate.bottomView setHidden:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - private  method
-(void)showGroupTableView:(BOOL)flag
{
    [UIView beginAnimations:nil context:nil];
    if(targetTableView==nil)
    {
        targetTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, -300, 300, 200) style:UITableViewStylePlain];
        [targetTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [targetTableView setDelegate:self];
        [targetTableView setDataSource:self];
        [targetTableView setTag:kTableViewTargetTag];
        [self.view addSubview:targetTableView];
    }
    if(flag)
    {
        if(self.grouplist==nil)
        {
            grouplist=[[NSMutableArray alloc] init];
        }
        [self.grouplist removeAllObjects];
        NSMutableArray *tmplist=[[GroupDAL sharedInstance] getLocalGroup];
        for(NSString *str in tmplist)
        {
            if(![self.groupName isEqualToString:str])
            {
                [self.grouplist addObject:str];
            }
        }
        [targetTableView setFrame:CGRectMake(10, 100, 300, 200)];
        [targetTableView reloadData];
        
    }
    else {
        [targetTableView setFrame:CGRectMake(10, -300, 300, 200)];
    }
    [UIView commitAnimations];
}

-(void)editTableView
{
    if(bookTableView.isEditing)
    {
        [self showGroupTableView:NO];
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
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.bottomView setHidden:!bookTableView.isEditing];
    [bookTableView setEditing:!bookTableView.isEditing animated:YES];
}

-(void)barAction:(id)sender
{
    UIBarButtonItem *bar=(UIBarButtonItem *)sender;
    switch (bar.tag) {
        case kBarButtonSelect:
        {
            for(int i=0;i<[booklist count];i++)
            {
                [bookTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }
            break;
        case kBarButtonDeSelect:
        {
            for(int i=0;i<[booklist count];i++)
            {
                [bookTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
            }
        }
            break;
        case kBarButtonDelete:
        {
            NSArray *selectedIndexPath=[bookTableView indexPathsForSelectedRows];
            if([selectedIndexPath count]==0)
            {
                [CommonHelper showAlert:nil msg:@"请先选择要删除的书籍"];
                return;
            }
            if([CommonHelper showMsg:@"确定删除选中的书籍?"])
            {
                for(NSIndexPath *indexPath in selectedIndexPath)
                { 
                    SectionModel *secModel=[booklist objectAtIndex:indexPath.row];
                    NSString *bookPath=[[kDownloadedPath stringByAppendingPathComponent:secModel.groupName] stringByAppendingPathComponent:secModel.bookName];
                    [booklist removeObject:secModel];
                    [[FileHelper sharedInstance] performSelectorInBackground:@selector(removeItemAtPath:) withObject:bookPath];
                }
                [bookTableView reloadData];
            }
        }
            break;
        case kBarButtonMoveTag:
        {
            NSArray *selectedIndexPath=[bookTableView indexPathsForSelectedRows];
            if([selectedIndexPath count]==0)
            {
                [CommonHelper showAlert:nil msg:@"请先选择要删除的书籍"];
                return;
            }
            [self showGroupTableView:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark tableviewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==kTableViewTargetTag)
    {
        return [grouplist count];
    }
    else {
        return [booklist count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==kTableViewBookTag)
    {
        static NSString *cellIdentity=@"BookIdentity";
        BookCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentity];
        if(cell==nil)
        {
            cell=[[[BookCell alloc] init] autorelease];
        }
        SectionModel *secModel=[booklist objectAtIndex:indexPath.row];
        cell.lblName.text=[NSString stringWithFormat:@"%@(%@)",secModel.bookName,secModel.author];
    //    cell.lblAttri.text=[NSString stringWithFormat:@"人气：%@",secModel.clickCount];
        cell.lblIntro.text=secModel.bookIntro;
        [cell.iconImgView setImageWithURL:[NSURL URLWithString:secModel.bookIconURL]];
        [cell.stateImgView setImage:secModel.bookStateImg];
    return cell;
    }
    else {
        static NSString *cellIdentity=@"TargetCellIdentity";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentity];
        if(cell==nil)
        {
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentity] autorelease];
        }
        cell.textLabel.text=[grouplist objectAtIndex:indexPath.row];
        return cell;
    }
}

#pragma mark tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==kTableViewBookTag)
    {
        return 95;
    }
    else {
        return 40;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==kTableViewBookTag)
    {
        SectionModel *secModel=[booklist objectAtIndex:indexPath.row];
        if(!tableView.isEditing)
        {
            LocalSectionViewController *secVController=[[LocalSectionViewController alloc] initWithGroupName:self.groupName andBookName:secModel.bookName];
            [self.navigationController pushViewController:secVController animated:YES];
            [secVController release];
        }
    }
    else {
        NSArray *selectedlist=[bookTableView indexPathsForSelectedRows];
        for(NSIndexPath *tmpindexPath in selectedlist)
        {
            SectionModel *secModel=[booklist objectAtIndex:tmpindexPath.row];
            NSString *bookPath=[[kDownloadedPath stringByAppendingPathComponent:self.groupName] stringByAppendingPathComponent:secModel.bookName];
            NSString *desPath=[[kDownloadedPath stringByAppendingPathComponent:[grouplist objectAtIndex:indexPath.row]] stringByAppendingPathComponent:secModel.bookName];
            [[FileHelper sharedInstance] moveFilesFrom:bookPath toDestionPath:desPath];
        }
        [self showGroupTableView:NO];
        NSString *groupPath=[[[GroupDAL sharedInstance]getGroupRootPath] stringByAppendingPathComponent:groupName];
        booklist=[[[BookDAL sharedInstance] getFinsihedBooklistByGroupPath:groupPath] retain];
        [bookTableView reloadData];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==kTableViewBookTag)
    {
        SectionModel *secModel=[booklist objectAtIndex:indexPath.row];
        NSString *bookPath=[[BookDAL sharedInstance] getBookPathByGroupName:self.groupName withBookName:secModel.bookName];
        
        [booklist removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [[FileHelper sharedInstance] performSelectorInBackground:@selector(removeItemAtPath:) withObject:bookPath];
    }
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert|UITableViewCellEditingStyleDelete;
}

@end
