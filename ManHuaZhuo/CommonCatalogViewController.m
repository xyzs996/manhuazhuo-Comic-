//
//  CommonCatalogViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonCatalogViewController.h"
#import "CatalogDAL.h"
#import "BookModel.h"
#import "CatalogCell.h"
#import "UIImageView+WebCache.h"
#import "CatalogNet.h"
#import "ResponseModel.h"

@interface CommonCatalogViewController ()
{
    BOOL isLoading;
}

@property(nonatomic,retain)EGORefreshTableHeaderView *headerView;
@property(nonatomic,retain)UITableView *dataTableView;
@property(nonatomic,retain)NSMutableArray *datalist;

-(void)startCataloglistInThread;
@end

@implementation CommonCatalogViewController

@synthesize delegate;
@synthesize dataTableView;
@synthesize datalist;
@synthesize headerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-44)];
    }
    return self;
}

-(void)releaseData
{
    self.headerView.delegate=nil;
    self.headerView=nil;
    self.dataTableView=nil;
    self.datalist=nil;
}

-(void)dealloc
{
    self.delegate=nil;
    [self releaseData];
    [super dealloc];
}

-(void)loadView
{
    [super loadView];
    dataTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-44) style:UITableViewStylePlain];
    [dataTableView setDelegate:self];
    [dataTableView setDataSource:self];
    [dataTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:dataTableView];
    
    
    headerView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [headerView setDelegate:self];
    [headerView refreshLastUpdatedDate];
    [dataTableView addSubview:headerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showLoadingView];
    
    [NSThread detachNewThreadSelector:@selector(startCataloglistInThread) toTarget:self withObject:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
     [self releaseData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [dataTableView deselectRowAtIndexPath:[dataTableView indexPathForSelectedRow] animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - private method
-(void)startCataloglistInThread
{
    @autoreleasepool {
        isLoading=YES;
        ResponseModel *response=[CatalogNet startAllCataloglist];
        self.datalist=response.resultInfo;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [headerView egoRefreshScrollViewDataSourceDidFinishedLoading:dataTableView];
            if(response.error!=nil)
            {
                [self showErrorView];
                return;
            }
            [dataTableView reloadData];
            [self hideLoadingView];
            isLoading=NO;
        });
    }
}

#pragma mark - Error
-(void)errorViewTappedGesture:(UITapGestureRecognizer *)gesture
{
    [super errorViewTappedGesture:gesture];
    [NSThread detachNewThreadSelector:@selector(startCataloglistInThread) toTarget:self withObject:nil];
}

#pragma TableViewData Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datalist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity=@"CellIdentity";
    CatalogCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if(cell==nil)
    {
        cell=[[[CatalogCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentity] autorelease];
    }
    BookModel *book=[datalist objectAtIndex:indexPath.row];
    cell.lblName.text=book.bookName;
    cell.lblIntro.text=book.bookIntro;
    [cell.iconImgView setImageWithURL:[NSURL URLWithString:book.bookIconURL]];
    return cell;
}

#pragma tableview Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([delegate respondsToSelector:@selector(commonCatalogCellClick:obj:)])
    {
        [delegate commonCatalogCellClick:self obj:[datalist objectAtIndex:indexPath.row]];
    }
}


#pragma ego下拉刷新委托
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return isLoading;
}

-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [NSThread detachNewThreadSelector:@selector(startCataloglistInThread) toTarget:self withObject:nil];
}

#pragma scrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [headerView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [headerView egoRefreshScrollViewDidEndDragging:scrollView];
}

@end
