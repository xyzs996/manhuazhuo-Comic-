//
//  CommonBooklistViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonBooklistViewController.h"
#import "BookCell.h"
#import "BookModel.h"
#import "UIImageView+WebCache.h"
#import "BookDAL.h"
#import "BookDetailViewController.h"
#import "JSON.h"

#define kBooklistRequestTag 500
#define kBooklistRequestPageTag 501
#define kBooklistSearchTag 502

@interface CommonBooklistViewController ()
{
    CGRect _targetFrame;
    OrderType _orderType;
    BookState _bookState;
    BOOL isLoading;
    BOOL _isSearch;
}

@property(nonatomic,retain)NSString *searchURL;
@property(nonatomic,retain)EGORefreshTableHeaderView *headerView;
@property(nonatomic,retain)EGORefreshTableFooterView *footerView;
@property(nonatomic,retain)BookModel *cataModel;
@property(nonatomic,retain)NSMutableArray *datalist;
@property(nonatomic,retain)UITableView *dataTableView;
@property(nonatomic,retain)UILabel *lblSearchResult;
@property(nonatomic,retain)WaitView *loadingView;

@end

@implementation CommonBooklistViewController

@synthesize delegate;
@synthesize cataModel;
@synthesize datalist;
@synthesize dataTableView;
@synthesize pageIndex;
@synthesize headerView;
@synthesize footerView;
@synthesize searchURL;
@synthesize lblSearchResult;
@synthesize loadingView;

-(id)initWitCatalog:(BookModel *)_bookModel frame:(CGRect)frame order:(OrderType)order state:(BookState)state
{
    if(self=[super init])
    {
        self.cataModel=_bookModel;
        _targetFrame=frame;
        _orderType=order;
        _bookState=state;
        [self.view setFrame:CGRectMake(0, _targetFrame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame SearchURL:(NSString *)_serachURL
{
    if(self=[super init])   
    {
        _targetFrame=frame;
        _isSearch=YES;
        self.searchURL=_serachURL;
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    dataTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, _targetFrame.size.width, _targetFrame.size.height) style:UITableViewStylePlain];
    [dataTableView setDelegate:self];
    [dataTableView setDataSource:self];
    [dataTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:dataTableView];
    
    if(!_isSearch)
    {
        headerView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        [headerView setDelegate:self];
        [headerView refreshLastUpdatedDate];
        [dataTableView addSubview:headerView];

        
        footerView=[[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        [footerView setDelegate:self];
        [footerView refreshLastUpdatedDate];
        [footerView setHidden:YES];
        [dataTableView addSubview:footerView];
        
        
        isLoading=YES;
        NSString *booklistURL=[[BookDAL sharedInstance] getBooklistByCataID:cataModel.bookID pageIndex:pageIndex pageSize:kBookPageSize bookState:(int)_bookState order:(int)_orderType];
        [[DownloadHelper sharedInstance] startRequest:booklistURL delegate:self tag:kBooklistRequestTag userInfo:nil];
    }
    else {
        
        self.navigationItem.title=@"搜索结果";
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 7, 48, 30)];
        [btn setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"nav_back_pressed.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
        
        lblSearchResult=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, dataTableView.frame.size.width, 30)];
        [lblSearchResult setBackgroundColor:[UIColor clearColor]];
        [lblSearchResult setTextAlignment:UITextAlignmentCenter];
        [lblSearchResult setCenter:self.view.center];
        [lblSearchResult setTextColor:[UIColor blackColor]];
        [lblSearchResult setText:@"搜索无结果"];
        [lblSearchResult setHidden:YES];
        [dataTableView addSubview:lblSearchResult];

        [[DownloadHelper sharedInstance] startRequest:searchURL delegate:self tag:kBooklistSearchTag userInfo:nil];
    }
    loadingView=[[WaitView alloc] initWithFrame:CGRectMake(0, 0,  _targetFrame.size.width,  _targetFrame.size.height)];
    [loadingView setDelegate:self];
    [self.view addSubview:loadingView];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)releaseData
{
    self.headerView=nil;
    self.footerView=nil;
    self.delegate=nil;
    self.datalist=nil;
    self.dataTableView=nil;
    self.lblSearchResult=nil;
}

-(void)dealloc
{
    self.searchURL=nil;
    self.cataModel=nil;
    [self releaseData];
    [super dealloc];
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

-(void)reloadDataByOrder:(OrderType)order state:(BookState)state
{
    [[DownloadHelper sharedInstance] cancelReqeustForDelegate:self];
    _orderType=order;
    _bookState=state;
    isLoading=YES;
    NSString *booklistURL=[[BookDAL sharedInstance] getBooklistByCataID:cataModel.bookID pageIndex:pageIndex pageSize:kBookPageSize bookState:(int)_bookState order:(int)_orderType];
    [[DownloadHelper sharedInstance] startRequest:booklistURL delegate:self tag:kBooklistRequestTag userInfo:nil];
}

#pragma tableview Datasource
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
    BookCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if(cell==nil)
    {
        cell=[[[BookCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentity] autorelease];
    }
    BookModel *book=[datalist objectAtIndex:indexPath.row];
    cell.lblName.text=[NSString stringWithFormat:@"%@(%@)",book.bookName,book.author];
    cell.lblAttri.text=[NSString stringWithFormat:@"人气：%@",book.clickCount];
    cell.lblIntro.text=book.bookIntro;
    [cell.iconImgView setImageWithURL:[NSURL URLWithString:book.bookIconURL]];
    [cell.stateImgView setImage:book.bookStateImg];
    return cell;
}

#pragma tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([delegate respondsToSelector:@selector(commonBooklistClickDelegate:obj:)])
    {
        [delegate commonBooklistClickDelegate:self obj:[datalist objectAtIndex:indexPath.row]];
    }
    else {
        BookDetailViewController *detailVController=[[BookDetailViewController alloc] initWithBook:[datalist objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:detailVController animated:YES];
        [detailVController release];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
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
    isLoading=YES;
    NSString *booklistURL=[[BookDAL sharedInstance] getBooklistByCataID:cataModel.bookID pageIndex:0 pageSize:kBookPageSize bookState:(int)_bookState order:(int)_orderType];
    [[DownloadHelper sharedInstance] startRequest:booklistURL delegate:self tag:kBooklistRequestTag userInfo:nil];
}

#pragma ego上拉新增
-(BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView *)view
{
    return isLoading;
}

-(NSDate *)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView *)view
{
    return [NSDate date];
}

-(void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView *)view
{
    pageIndex++;
    NSString *booklistURL=[[BookDAL sharedInstance] getBooklistByCataID:cataModel.bookID pageIndex:pageIndex pageSize:kBookPageSize bookState:(int)_bookState order:(int)_orderType];
    [[DownloadHelper sharedInstance] startRequest:booklistURL delegate:self tag:kBooklistRequestPageTag userInfo:nil];
} 

#pragma scrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [headerView egoRefreshScrollViewDidScroll:scrollView];
    if([datalist count]>3)
    {   
        [footerView egoRefreshScrollViewDidScroll:scrollView];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [headerView egoRefreshScrollViewDidEndDragging:scrollView];
    if([datalist count]>3)
    {
        [footerView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma loadView Delegate
-(void)waitViewTap:(NSString *)url
{
    if(_isSearch)
    {
        [[DownloadHelper sharedInstance] startRequest:url delegate:self tag:kBooklistSearchTag userInfo:nil];
    }
    else {
        [[DownloadHelper sharedInstance]startRequest:url delegate:self tag:kBooklistRequestTag userInfo:nil];
    }
}

#pragma DowloadHelper Delegate
-(void)DownloadFinished:(id)data downloadType:(NSNumber *)downloadType
{
    isLoading=NO;
    NSMutableArray *tmplist=[[BookDAL sharedInstance] parseBooklistByPage:[[data objectForKey:@"Data"] JSONValue]];
    if([tmplist count]>3)
    {
        [footerView setHidden:NO];
    }
    if(_isSearch)
    {
        tmplist=[[BookDAL sharedInstance] parseBooklist:[[data objectForKey:@"Data"]JSONValue]];
    }
    switch ([downloadType intValue]) {
        case kBooklistRequestTag:
            self.datalist=tmplist;
            [headerView egoRefreshScrollViewDataSourceDidFinishedLoading:dataTableView];
            break;
        case kBooklistRequestPageTag:
            for(BookModel *book in tmplist)
            {
                [self.datalist addObject:book];
            }
            [footerView egoRefreshScrollViewDataSourceDidFinishedLoading:dataTableView];
            break;
        case kBooklistSearchTag:
            if([tmplist count]==0)
            {
                [lblSearchResult setHidden:NO];
            }
            else {
                [lblSearchResult setHidden:YES];
            }
            self.datalist=tmplist;
            break;
        default:
            break;
    }
    if(pageIndex==0)
    {
        [dataTableView setContentOffset:CGPointMake(0, 0)];
    }
    [dataTableView reloadData];
    [footerView setFrame:CGRectMake(0, dataTableView.contentSize.height, dataTableView.frame.size.width, dataTableView.frame.size.height)];
    [loadingView removeFromSuperview];
}

-(void)DownloadFailed:(NSNumber *)errorCode downloadType:(NSNumber *)downloadType url:(NSString *)url
{
    isLoading=NO;
    pageIndex--;
    if(_isSearch)
    {
        [lblSearchResult setHidden:NO];
    }
    [loadingView setTitleText:nil url:url];
}
@end
