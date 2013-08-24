//
//  CommentViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentModel.h"
#import "CommentDAL.h"
#import "JSON.h"
#import "SettingDAL.h"
#import "URLUtility.h"
#import "ReplyViewController.h"
#import "CommonHelper.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UserModel.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"

#define kRequestHotCommentTag 501
#define kReqeustCommentFirstTag 504
#define kRequestCommentlistTag 500
#define kRequestPostCommentTag 502
#define kRequestLikeTag 503

@interface CommentViewController ()
{
    int pageIndex;
    BOOL isLoading;
}

@property(nonatomic,retain)EGORefreshTableHeaderView *headerView;
@property(nonatomic,retain)EGORefreshTableFooterView *footerView;
@property(nonatomic,retain)NSString *bookID;
@property(nonatomic)int commentCount;
@property(nonatomic,retain)NSMutableArray *grouplist;
@property(nonatomic,retain)NSMutableArray *hotCommentlist;
@property(nonatomic,retain)NSMutableArray *commentlist;
@property(nonatomic,retain)UITableView *commentTableView;

-(void)refreshCommentlistByPage:(int)pageIndex;//从0开始
-(void)postComment;
@end

@implementation CommentViewController

@synthesize headerView;
@synthesize footerView;
@synthesize hotCommentlist;
@synthesize commentTableView;
@synthesize bookID;
@synthesize commentCount;
@synthesize commentlist;
@synthesize grouplist;

-(id)initWithBookID:(NSString *)_bookID commentCount:(int)_commentCount
{
    if(self=[super init])
    {
        self.bookID=_bookID;
        commentCount=_commentCount;
    }
    return self;
}

-(void)postComment
{
    [super postComment];
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
    NSString *postURL=[[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjectsAndKeys:@"insertnewcomment",@"method",self.commentString,@"content",[NSString stringWithFormat:@"%d",appDelegate.userSession.userID],@"userid",self.bookID,@"bookid",[NSString stringWithFormat:@"%d",[CommonHelper getClientTypeID]],@"client",nil]];
    [[DownloadHelper sharedInstance] startRequest:postURL delegate:self tag:kRequestPostCommentTag userInfo:nil];
}



-(void)loadView
{
    [super loadView];
    [CommonHelper getClientTypeID];
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    //返回按钮
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 7, 48, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];

    
       
    commentTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-42) style:UITableViewStylePlain];
    [commentTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [commentTableView setDelegate:self];
    [commentTableView setDataSource:self];
    [self.view addSubview:commentTableView];
    
    headerView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-commentTableView.frame.size.height, commentTableView.frame.size.width, commentTableView.frame.size.height)];
    [headerView setDelegate:self];
    [commentTableView addSubview:headerView];
    [headerView refreshLastUpdatedDate];
        
    footerView=[[EGORefreshTableFooterView alloc]initWithFrame:CGRectMake(0, 2000, commentTableView.frame.size.width, commentTableView.frame.size.height)];
    footerView.delegate=self;
    [commentTableView addSubview:footerView];
    [footerView refreshLastUpdatedDate];
        
    self.navigationItem.title=[NSString stringWithFormat:@"%d 评论",commentCount];
    
    
    grouplist=[[NSMutableArray alloc] init];
    
    //获取热门评论
    NSString *hotCommentURL=[[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjectsAndKeys:@"hotcommentlist",@"method",bookID ,@"bookid",[[SettingDAL sharedInstance]getUUID],@"uuid",nil]];
    [[DownloadHelper sharedInstance] startRequest:hotCommentURL delegate:self tag:kRequestHotCommentTag userInfo:nil];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    pageIndex=0;
    //请求该书籍下的分页评论
    [self refreshCommentlistByPage:pageIndex];
    [commentTableView deselectRowAtIndexPath:[commentTableView indexPathForSelectedRow] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.tabBarController.tabBar setHidden:YES];
}

-(void)releaseData
{
    self.commentTableView=nil;
    self.commentlist=nil;
    self.hotCommentlist=nil;
    self.grouplist=nil;
    self.footerView.delegate=nil;
    self.footerView=nil;
    self.headerView.delegate=nil;
    self.headerView=nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseData];
}

-(void)dealloc
{
    [[DownloadHelper sharedInstance] cancelReqeustForDelegate:self];
      [self releaseData];
    self.bookID=nil;
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - tableview DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [grouplist count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[grouplist objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"CellIdentifier";
    CommentCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[[CommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        [cell setDelegate:self];
    }
    CommentModel *comentModel=[[grouplist objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(comentModel.replyCount==0)
    {
        [cell setSelectionStyle:UITableViewCellEditingStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    [cell.userPhoto setImageWithURL:[NSURL URLWithString:comentModel.userPhotoURL] placeholderImage:[UIImage imageNamed:@"comments_avatar.png"]];
    cell.lblNick.text=comentModel.userNick;
    cell.lblClientType.text=[NSString stringWithFormat:@"(来自%@)",comentModel.clientType];
    cell.lblDate.text=comentModel.commentDate;
    cell.lblContent.text=comentModel.commentContent;
    if(comentModel.likeCount==0)
    {
        [cell likeState:0];
    }
    else 
    {
        if(comentModel.likeCount!=0&&!comentModel.hasLiked) {
            [cell likeState:1];
        }
        else {
            [cell likeState:2];
        }
        cell.lbllikeCount.text=[NSString stringWithFormat:@"%d",comentModel.likeCount];
    }
    return cell;
}



#pragma mark - tableview delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *barView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_bar.png"]] autorelease];
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 20)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setTextColor:[UIColor colorWithRed:87/255.0 green:107/255.0 blue:149/255.0 alpha:1.0f]];
    [lblTitle setFont:[UIFont systemFontOfSize:14]];
    if(section==0) {
        lblTitle.text= @"热门评论";
    }
    else {
        lblTitle.text= @"最新评论";
    }
    [barView addSubview:lblTitle];
    [lblTitle release];
    return barView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0) {
        return @"热门评论";
    }
    else {
        return @"最新评论";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *comentModel=[[grouplist objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(comentModel.replyCount==0)
    {
        return;
    }
    else {
        ReplyViewController *replyVController=[[ReplyViewController alloc] initWithCommentModel:comentModel];
        [self.navigationController pushViewController:replyVController animated:YES];
        [replyVController release];
    }
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
    //请求该书籍下的分页评论
    NSString *nextURL=[[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                            @"commentlist",@"method"
                                                                            ,bookID,@"bookid"
                                                                            ,[[SettingDAL sharedInstance]getUUID],@"uuid"
                                                                            ,[NSString stringWithFormat:@"%d",pageIndex],@"pageindex"
                                                                            ,nil]];
    [[DownloadHelper sharedInstance] startRequest:nextURL delegate:self tag:kRequestCommentlistTag userInfo:nil];
}

-(void)refreshCommentlistByPage:(int)_pageIndex
{
    //请求该书籍下的分页评论
    NSString *commentlistURL=[[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                            @"commentlist",@"method"
                                                                            ,bookID,@"bookid"
                                                                            ,[[SettingDAL sharedInstance]getUUID],@"uuid"
                                                                            ,[NSString stringWithFormat:@"%d",_pageIndex],@"pageindex"
                                                                            ,nil]];
    [[DownloadHelper sharedInstance] startRequest:commentlistURL delegate:self tag:kReqeustCommentFirstTag userInfo:nil];
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
    //获取热门评论
    NSString *hotCommentURL=[[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjectsAndKeys:@"hotcommentlist",@"method",bookID ,@"bookid",[[SettingDAL sharedInstance]getUUID],@"uuid",nil]];
    [[DownloadHelper sharedInstance] startRequest:hotCommentURL delegate:self tag:kRequestHotCommentTag userInfo:nil];
    
    
    pageIndex=0;
    [self refreshCommentlistByPage:pageIndex];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [headerView egoRefreshScrollViewDidScroll:scrollView];
    [footerView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [headerView egoRefreshScrollViewDidEndDragging:scrollView];
    [footerView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - DownloadHelper Delegate
-(void)DownloadFinished:(id)data downloadType:(NSNumber *)downloadType
{
    switch ([downloadType intValue]) {
        case kRequestHotCommentTag:
        {
            self.hotCommentlist=[[CommentDAL sharedInstance] parseCommentlistFromResult:[[data objectForKey:@"Data"] JSONValue]];
        }
            break;
        case kReqeustCommentFirstTag:
        {
            self.commentlist=[[CommentDAL sharedInstance] parseCommentlistFromResult:[[data objectForKey:@"Data"]JSONValue]];
            if([commentlist count]!=0)
            {
                pageIndex++;
            }
        }
            break;
        case kRequestCommentlistTag:
        {
            NSMutableArray *tmplist=[[CommentDAL sharedInstance] parseCommentlistFromResult:[[data objectForKey:@"Data"] JSONValue]];
            if([tmplist count]!=0&&[tmplist count]!=1)
            {
                pageIndex++;
                if(commentlist==nil)
                {
                    commentlist=[[NSMutableArray alloc] init];
                }
                for(CommentModel *comment in tmplist)
                {
                    [self.commentlist addObject:comment];
                }
            }
        }
            break;
        case kRequestPostCommentTag:
        {
            if([[data objectForKey:@"Data"] intValue]==1)
            {
                [CommonHelper showAlert:nil msg:@"评论成功！"];
                pageIndex=0;
                [self refreshCommentlistByPage:pageIndex];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    self.txtComment.text=@"";
                    [commentTableView setContentOffset:CGPointMake(0, 0) animated:NO];
                });
            }
            else {
                [CommonHelper showAlert:nil msg:@"评论失败!"];
            }
        }
            break;
        case kRequestLikeTag:
        {
            NSIndexPath *selectedPath= [data objectForKey:@"IndexPath"];
            CommentModel *commModel=[commentlist objectAtIndex:selectedPath.row];
            commModel.likeCount++;
            commModel.hasLiked=YES;
            CommentCell *cell=(CommentCell *)[commentTableView cellForRowAtIndexPath:selectedPath];
            
            if(commModel.likeCount==0)
            {
                [cell likeState:0];
            }
            else 
            {
                if(commModel.likeCount!=0&&!commModel.hasLiked) {
                    [cell likeState:1];
                }
                else {
                    [cell likeState:2];
                }
                cell.lbllikeCount.text=[NSString stringWithFormat:@"%d",commModel.likeCount];
            }

        }
            break;
        default:
            break;
    }
    [grouplist removeAllObjects];
    if(hotCommentlist!=nil)
    {
        [grouplist addObject:hotCommentlist];
    }
    if(commentlist!=nil)
    {
        [grouplist addObject:commentlist];
    }
    [commentTableView reloadData];
    if([downloadType intValue]==kRequestCommentlistTag||[downloadType intValue]==kRequestHotCommentTag||[downloadType intValue]==kRequestCommentlistTag)
    {
        if(commentTableView.contentSize.height>commentTableView.frame.size.height)
        {
            [footerView setFrame:CGRectMake(0, commentTableView.contentSize.height, footerView.frame.size.width, footerView.frame.size.height)];
        }
        [headerView egoRefreshScrollViewDataSourceDidFinishedLoading:commentTableView];
        [footerView egoRefreshScrollViewDataSourceDidFinishedLoading:commentTableView];
        isLoading=NO;
    }
}

-(void)DownloadFailed:(NSNumber *)errorCode downloadType:(NSNumber *)downloadType url:(NSString *)url
{
    
}

#pragma mark CommentCellDelegate
-(void)CommentClick:(CommentCell *)cell buttonType:(NSNumber *)buttonType
{
    NSIndexPath *replyIndexPath= [commentTableView indexPathForCell:cell];
    CommentModel *comentModel=[[grouplist objectAtIndex:replyIndexPath.section] objectAtIndex:replyIndexPath.row];

    if([buttonType intValue]==kButtonReplyTag)
    {
        ReplyViewController *replyVController=[[ReplyViewController alloc] initWithCommentModel:comentModel];
        [self.navigationController pushViewController:replyVController animated:YES];
        [replyVController release];
    }
    else if([buttonType intValue]==kButtonLikeTag)
    {
        [[DownloadHelper sharedInstance] cancelRequestForTag:kRequestLikeTag delegate:self];
        NSString *likeURL=[[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjectsAndKeys:@"commentlike",@"method",comentModel.commentID,@"commentid",[[SettingDAL sharedInstance] getUUID],@"uuid", nil]];
        [[DownloadHelper sharedInstance] startRequest:likeURL delegate:self tag:kRequestLikeTag userInfo:[NSDictionary dictionaryWithObject:replyIndexPath forKey:@"IndexPath"]];
    }
}
@end
