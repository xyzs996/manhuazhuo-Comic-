//
//  LocalSectionViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalSectionViewController.h"
#import "SectionModel.h"
#import "SectionDAL.h"
#import "PictureViewController.h"
#import "AppDelegate.h"
#import "FileHelper.h"

@interface LocalSectionViewController ()

@property(nonatomic,retain)NSString *groupName;
@property(nonatomic,retain)NSString *bookName;
@property(nonatomic,retain)UITableView *sectionTableView;
@property(nonatomic,retain)NSMutableArray *sectionlist;

-(void)editTableView;
@end

@implementation LocalSectionViewController

@synthesize sectionlist;
@synthesize sectionTableView;
@synthesize bookName;
@synthesize groupName;

-(id)initWithGroupName:(NSString *)_groupName andBookName:(NSString *)_bookName
{
    if(self=[super init])
    {
        self.groupName=_groupName;
        self.bookName=_bookName;
        self.navigationItem.title=self.bookName;
        self.sectionlist=[[SectionDAL sharedInstance] getFinishedSectionByGroupName:self.groupName withBookName:self.bookName];
    }
    return self;
}

-(void)editTableView
{
    [sectionTableView setEditing:!sectionTableView.isEditing animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

    
    sectionTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    [sectionTableView setDelegate:self];
    [sectionTableView setDataSource:self];
    [self.view addSubview:sectionTableView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [sectionTableView deselectRowAtIndexPath:[sectionTableView indexPathForSelectedRow] animated:YES];
}

-(void)dealloc
{
    [self releaseData];
    [super dealloc];
}

-(void)releaseData
{
    self.sectionTableView=nil;
    self.sectionlist=nil;
    self.groupName=nil;
    self.bookName=nil;
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

#pragma mark tableview Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sectionlist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity=@"Identity";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentity] autorelease];
    }
    SectionModel *secModel=[sectionlist objectAtIndex:indexPath.row];
    cell.textLabel.text=secModel.sectionName;
    return cell;
}

#pragma mark sectionTableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionModel *secModel=[sectionlist objectAtIndex:indexPath.row];
    secModel.groupName=self.groupName;
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate showPictureViewController:secModel isLocalRequest:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SectionModel *secModel=[sectionlist objectAtIndex:indexPath.row];
    NSString *secPath=[[[kDownloadedPath stringByAppendingPathComponent:self.groupName]stringByAppendingPathComponent:self.bookName]stringByAppendingPathComponent:secModel.sectionName];

    [sectionlist removeObject:secModel];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [[FileHelper sharedInstance]performSelectorInBackground:@selector(removeItemAtPath:) withObject:secPath];
}
@end
