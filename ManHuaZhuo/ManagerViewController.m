//
//  ManagerViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ManagerViewController.h"
#import "BookDAL.h"
#import "TabSegmentItem.h"
#import "FileHelper.h"
#import "GroupDAL.h"
#import "LocalBookViewController.h"
#import "CommonHelper.h"
#import "Constants.h"


#define kTextFieldInputTag 500

@interface ManagerViewController ()

@property(nonatomic,retain)UITableView *groupTableView;
@property(nonatomic,retain)NSMutableArray *booklist;
@property(nonatomic,retain)NSMutableArray *grouplist;

-(void)loadLocalGroupsInThread;//后台加载本地分组数据
-(void)editTableView;
-(void)addGroup;

@end

@implementation ManagerViewController

@synthesize booklist;
@synthesize groupTableView;
@synthesize grouplist;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

-(void)loadView
{
    [super loadView];
    
    groupTableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-44-44)];
    [groupTableView setDelegate:self];
    [groupTableView setDataSource:self];
    [self.view addSubview:groupTableView];
    
    //新增group
    UIButton *btnGroup=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnGroup setFrame:CGRectMake(0, 7, 60, 30)];
    [btnGroup.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [btnGroup setTitle:@"新增分组" forState:UIControlStateNormal];
    [btnGroup setBackgroundImage:[UIImage imageNamed:@"nav_normal.png"] forState:UIControlStateNormal];
    [btnGroup addTarget:self action:@selector(addGroup) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btnGroup] autorelease];
    
    //编辑
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 7, 48, 30)];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_normal.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(editTableView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
}

int count=0;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [CommonHelper showHud:self title:@"请稍候..." selector:@selector(loadLocalGroupsInThread) arg:nil targetView:self.view];   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [groupTableView deselectRowAtIndexPath:[groupTableView indexPathForSelectedRow] animated:YES];
}

-(void)releaseData
{
    self.groupTableView=nil;
    self.booklist=nil;
}

-(void)dealloc
{
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

-(void)loadLocalGroupsInThread
{
    self.grouplist=[[[GroupDAL sharedInstance] getLocalGroup] retain];
    [groupTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

-(void)editTableView
{   
    if([groupTableView isEditing])
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
    [groupTableView setEditing:!groupTableView.isEditing animated:YES];
}

-(void)addGroup
{
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入分组名称" message:@"\n" delegate:self cancelButtonTitle:@"添加" otherButtonTitles:@"取消",nil]; 
    if([[[UIDevice currentDevice] systemVersion]intValue]>=5)
    {
        [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    }
    else {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 45, 245, 25)];
        textField.tag=kTextFieldInputTag;
        [textField setBackgroundColor:[UIColor clearColor]];
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        [dialog addSubview:textField];
        [textField release];
    }   
    UITextField *txtName= [dialog textFieldAtIndex:0];
    [txtName setKeyboardType:UIKeyboardTypeDefault];
    [txtName becomeFirstResponder];
    [dialog show];
    [dialog release];
}


#pragma mark tableview dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [grouplist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity=@"CellIdentity";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if(!cell)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentity] autorelease];
    }
    cell.textLabel.text=[grouplist objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *groupName=[grouplist objectAtIndex:indexPath.row];
    LocalBookViewController *localVController=[[LocalBookViewController alloc] initWithGroupName:groupName];
    [localVController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:localVController animated:YES];
    [localVController release];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(editTableView)]autorelease];
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    //编辑
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 7, 48, 30)];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_normal.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(editTableView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *groupName=[grouplist objectAtIndex:indexPath.row];
    
    NSString *groupPath=[[[GroupDAL sharedInstance]getGroupRootPath] stringByAppendingPathComponent:groupName];
    [[FileHelper sharedInstance] performSelectorInBackground:@selector(removeItemAtPath:) withObject:groupPath];
    
    [grouplist removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark UIalertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)//添加
    {
        UITextField *txtName = [alertView textFieldAtIndex:0];
        if(txtName==nil)
        {
            txtName=(UITextField *)[alertView viewWithTag:kTextFieldInputTag];
        }
        if([txtName.text length]==0)
        {
            [CommonHelper showAlert:nil msg:@"分组名称不能为空"];
            return;
        }
        NSString *grouppath=[kDownloadedPath stringByAppendingPathComponent:txtName.text];
        if([[FileHelper sharedInstance] isExistPath:grouppath])
        {
            [CommonHelper showAlert:nil msg:@"该分组已经存在了,请重新换一个名字"];
            return;
        }
        [[FileHelper sharedInstance] createDirectory:grouppath];
        grouplist=[[[GroupDAL sharedInstance] getLocalGroup] retain];
        [groupTableView reloadData];
    }
}
@end
