//
//  SearchViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"
#import "CommonBooklistViewController.h"
#import "BookDAL.h"
#import "JSON.h"

#define kRequestKeylistTag 500


@interface SearchViewController ()
{
    BOOL isSearchByBookName;//按照书名进行搜索
}

@property(nonatomic,retain)UISearchDisplayController *searchVController;
@property(nonatomic,retain)NSMutableArray *searchlist;

@end

@implementation SearchViewController

@synthesize searchVController;
@synthesize searchlist;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)showCondition
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.menuView setDelegate:self];
    if(![appDelegate.menuView isShowRightView])
    {
        int selctIndex=0;
        if(!isSearchByBookName)
        {
            selctIndex=1;
        }
        [appDelegate.menuView showCurrentRightView:[NSArray arrayWithObjects:@"搜索类型", nil] celllist:[NSArray arrayWithObjects:@"按书名搜索",@"按作者搜索", nil] selectedIndex:selctIndex selectedBarIndex:0];
    }
    else {
        [appDelegate.menuView hideCurrentRightView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"漫画搜索";
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 48, 30)];
    [btn setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    
    
    UIButton *btnCondition=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnCondition setFrame:CGRectMake(0, 0, 48, 30)];
    [btnCondition setBackgroundImage:[UIImage imageNamed:@"nav_sort.png"] forState:UIControlStateNormal];
    [btnCondition setBackgroundImage:[UIImage imageNamed:@"nav_sort_press.png"] forState:UIControlStateHighlighted];
    [btnCondition addTarget:self action:@selector(showCondition) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btnCondition] autorelease];

    
    UISearchBar *searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [searchBar setDelegate:self];
    [searchBar setTintColor:[UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1.0]];
    [searchBar setPlaceholder:@"漫画的书名、作者"];
    searchVController=[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    [searchVController setDelegate:self];
    [searchVController setSearchResultsDataSource:self];
    [searchVController setSearchResultsDelegate:self];
    [self.view addSubview:searchVController.searchBar];
    [searchBar release];

    isSearchByBookName=YES;
    [self.view setBackgroundColor:[UIColor grayColor]];
}

-(void)releaseData
{
    self.searchVController=nil;
}

-(void)dealloc
{
    [self releaseData];
    self.searchlist=nil;
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

#pragma searchBar Delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *url=[[BookDAL sharedInstance] getSearchURLByBookName:searchBar.text];
    if(!isSearchByBookName)
    {
        url=[[BookDAL sharedInstance] getSearchURLByAuthorName:searchBar.text];
    }
    CommonBooklistViewController *booklistVController=[[CommonBooklistViewController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) SearchURL:url];
    [self.navigationController pushViewController:booklistVController animated:YES];
    [booklistVController release];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length]!=0)
    {
        [[DownloadHelper sharedInstance] cancelRequestForTag:kRequestKeylistTag delegate:self];
        NSString *keyURL=[[BookDAL sharedInstance] getKeylistURL:searchText];
        [[DownloadHelper sharedInstance] startRequest:keyURL delegate:self tag:kRequestKeylistTag userInfo:nil];
    }
}

#pragma tableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchlist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"CellIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.textLabel.text=[searchlist objectAtIndex:indexPath.row];
    return cell;
}

#pragma tableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key=[searchlist objectAtIndex:indexPath.row];
    NSString *url=[[BookDAL sharedInstance] getSearchURLByBookName:key];
    if(!isSearchByBookName)
    {
        url=[[BookDAL sharedInstance] getSearchURLByAuthorName:key];
    }
    CommonBooklistViewController *booklistVController=[[CommonBooklistViewController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44) SearchURL:url];
    [self.navigationController pushViewController:booklistVController animated:YES];
    [booklistVController release];

}

#pragma rightView Delegate
-(void)rightViewClick:(UITableView *)tableview indexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)//按照书名搜索
    {
        isSearchByBookName=YES;
    }
    else {
        isSearchByBookName=NO;
    }
}

#pragma DownloadHelper Delegate
-(void)DownloadFinished:(id)data downloadType:(NSNumber *)downloadType
{
    self.searchlist=[[data objectForKey:@"Data"] JSONValue];
    [searchVController.searchResultsTableView reloadData];
}
@end
