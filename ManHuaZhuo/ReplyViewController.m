//
//  ReplyViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReplyViewController.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import "URLUtility.h"
#import "CommentDAL.h"
#import "JSON.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "CommonHelper.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"


#define kRequestReplylistTag 500
#define kReqeuestReplyFirstTag 502
#define kRequestPostReplyTag 501

@interface ReplyViewController ()
{
    BOOL isLoading;
    int pageIndex;
}

@property(nonatomic,retain)EGORefreshTableHeaderView *headerView;
@property(nonatomic,retain)UITableView *replyTableView;
@property(nonatomic,retain)CommentModel *currentComment;
@property(nonatomic,retain)NSMutableArray *replylist;
@property(nonatomic,retain)EGORefreshTableFooterView *footerView;

-(void)refreshCommentlistByPage:(int)page;
@end

@implementation ReplyViewController

@synthesize headerView;
@synthesize footerView;
@synthesize replyTableView;
@synthesize currentComment;
@synthesize replylist;

- (id)initWithCommentModel:(CommentModel *)commentModel
{
    self = [super init];
    if (self) {
        self.currentComment=commentModel;
        
        //返回按钮
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 7, 48, 30)];
        [btn setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"nav_back_pressed.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];

        self.navigationItem.title=[NSString stringWithFormat:@"%d回复",currentComment.replyCount];
    }
    return self;
}

-(void)postComment
{
    [self.txtComment resignFirstResponder];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    if(appDelegate.userSession==nil)
    {
        LoginViewController *loginVController=[[LoginViewController alloc] init];
        UINavigationController *logNavController=[[UINavigationController alloc] initWithRootViewController:loginVController];
        [self presentModalViewController:logNavController animated:YES];
        [logNavController release];
        [loginVController release];
        return;
    }
    if([self.commentString length]==0)
    {
        if([self.txtComment.text length]==0)
        {
            [CommonHelper showAlert:nil msg:@"评论不能为空"];
            return;
        }
        else {
            self.commentString=self.txtComment.text;
        }
    }
    NSLog(@"self.commentString==%@",self.commentString);
    NSString *postURL=[[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjectsAndKeys:@"insertnewreply",@"method",self.commentString,@"replycontent",[NSString stringWithFormat:@"%d",appDelegate.userSession.userID],@"userid",self.currentComment.commentID,@"commentid",[NSString stringWithFormat:@"%d",[CommonHelper getClientTypeID]],@"clienttypeid",nil]];
    [[DownloadHelper sharedInstance] startRequest:postURL delegate:self tag:kRequestPostReplyTag userInfo:nil];
}

-(void)loadView
{
    [super loadView];
    
    replyTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-42-44)];
    [replyTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [replyTableView setDelegate:self];
    [replyTableView setDataSource:self];
    [self.view addSubview:replyTableView];
    
    headerView=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, 0-replyTableView.frame.size.height, replyTableView.frame.size.width, replyTableView.frame.size.height)];
    headerView.delegate=self;
    [replyTableView addSubview:headerView];
    [headerView refreshLastUpdatedDate];

    
    footerView=[[EGORefreshTableFooterView alloc]initWithFrame:CGRectMake(0, 2000, replyTableView.frame.size.width, replyTableView.frame.size.height)];
    footerView.delegate=self;
    [replyTableView addSubview:footerView];
    [footerView refreshLastUpdatedDate];
    
    pageIndex=0;
    NSString *replyURL=[[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjectsAndKeys:@"replylist",@"method",self.currentComment.commentID,@"commentid",[NSString stringWithFormat:@"%d",pageIndex],@"pageindex", nil]];
    [[DownloadHelper sharedInstance] startRequest:replyURL delegate:self tag:kReqeuestReplyFirstTag userInfo:nil];
}

-(void)releaseData
{
    self.replyTableView=nil;
    self.replylist=nil;
    self.footerView.delegate=nil;
    self.footerView=nil;
    self.headerView.delegate=nil;
    self.headerView=nil;
}
-(void)dealloc
{
    [[DownloadHelper sharedInstance] cancelReqeustForDelegate:self];
    self.currentComment=nil;
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


#pragma mark - tableview DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [replylist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"CellIdentifier";
    CommentCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[CommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    CommentModel *comentModel=comentModel=[replylist objectAtIndex:indexPath.row];
    [cell.userPhoto setImageWithURL:[NSURL URLWithString:comentModel.userPhotoURL] placeholderImage:[UIImage imageNamed:@"comments_avatar.png"]];
    cell.lblNick.text=comentModel.userNick;
    cell.lblClientType.text=[NSString stringWithFormat:@"(来自%@)",comentModel.clientType];
    cell.lblDate.text=comentModel.commentDate;
    cell.lblContent.text=comentModel.commentContent;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}


#pragma egoFooter Delegate
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
    isLoading=YES;
    int currentPage=[replylist count]/20;
    //请求该书籍下的分页评论
    [self refreshCommentlistByPage:currentPage];
}

#pragma mark HeaderView delegate
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
    
    pageIndex=0;
    [self refreshCommentlistByPage:pageIndex];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [footerView egoRefreshScrollViewDidScroll:scrollView];
    [headerView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [headerView egoRefreshScrollViewDidEndDragging:scrollView];
    [footerView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - private method
-(void)refreshCommentlistByPage:(int)page
{
    NSString *replyURL=[[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjectsAndKeys:@"replylist",@"method",self.currentComment.commentID,@"commentid",[NSString stringWithFormat:@"%d",page],@"pageindex", nil]];
    [[DownloadHelper sharedInstance] startRequest:replyURL delegate:self tag:kReqeuestReplyFirstTag userInfo:nil];
}

#pragma mark - DownloadHelper Delegate
-(void)DownloadFinished:(id)data downloadType:(NSNumber *)downloadType
{
    switch ([downloadType intValue]) {
        case kReqeuestReplyFirstTag:
        {
            self.replylist=[[CommentDAL sharedInstance] parseReplylisFromResult:[[data objectForKey:@"Data"]JSONValue]];
        }
            break;
        case kRequestReplylistTag:
        {
            NSMutableArray *tmplist=[[CommentDAL sharedInstance] parseReplylisFromResult:[[data objectForKey:@"Data"] JSONValue]];
            if([tmplist count]!=0&&[tmplist count]!=1)
            {
                pageIndex++;
                if(replylist==nil)
                {
                    replylist=[[NSMutableArray alloc] init];
                }
                for(CommentModel *comment in tmplist)
                {
                    [self.replylist addObject:comment];
                }
            }
        }
            break;
        case kRequestPostReplyTag:
        {
            if([[data objectForKey:@"Data"]isEqualToString:@"True"])
            {
                pageIndex=0;
                [self refreshCommentlistByPage:pageIndex];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    self.txtComment.text=@"";
                    [CommonHelper showAlert:nil msg:@"回复成功！"];
                    self.navigationItem.title=[NSString stringWithFormat:@"%d回复",currentComment.replyCount];
                });
            }
            else {
                [CommonHelper showAlert:nil msg:@"回复失败!"];
            }
        }
            break;
        default:
            break;
    }
    [self.replyTableView reloadData];
    if([downloadType intValue]==kRequestReplylistTag||[downloadType intValue]==kReqeuestReplyFirstTag)
    {
        if(replyTableView.contentSize.height>replyTableView.frame.size.height)
        {
            [footerView setFrame:CGRectMake(0, replyTableView.contentSize.height, footerView.frame.size.width, footerView.frame.size.height)];
        }
        [headerView egoRefreshScrollViewDataSourceDidFinishedLoading:replyTableView];
        [footerView egoRefreshScrollViewDataSourceDidFinishedLoading:replyTableView];
        isLoading=NO;
    }
}

@end
