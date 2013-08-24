//
//  BookDetailViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BookDetailViewController.h"
#import "BookModel.h"
#import "UIImageView+WebCache.h"
#import "BookDAL.h"
#import "UIButton+WebCache.h"
#import "SectionlistViewController.h"
#import "AppDelegate.h"
#import "CommentViewController.h"
#import "CommentDAL.h"
#import "JSON.h"
#import "Constants.h"
#import "CommonHelper.h"

#define kRequestLinkBookTag 500
#define kButtonSectionTag 600
#define kButtonShareTag 601
#define kActivityTag 700
#define kLabeResultTag 701
#define kRequestCommentCount 702

@interface BookDetailViewController ()

@property(nonatomic,retain)BookModel *currentBook;
@property(nonatomic,retain)UIScrollView *linkScrollView;
@property(nonatomic,retain)UIView *linkBookViewBg;
@property(nonatomic,retain)PageControl *pageController;
@property(nonatomic,retain)NSMutableArray *linkbooklist;
@property(nonatomic,retain)UIScrollView *bgScrollView;//整个滑动的scollview

-(void)linkBookAction:(id)sender;//作者其它书籍的链接
-(void)readBookAction:(id)sender;//阅读章节和分享微博
-(void)commentAction:(id)sender;//评论按钮
@end

@implementation BookDetailViewController

@synthesize bgScrollView;
@synthesize linkScrollView;
@synthesize currentBook;
@synthesize pageController;
@synthesize linkBookViewBg;
@synthesize linkbooklist;

-(id)initWithBook:(BookModel *)book
{
    if(self=[super init])
    {
        self.currentBook=book;
    }
    return self;
}

-(void)readBookAction:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    switch (btn.tag) {
        case kButtonSectionTag:
        {
            SectionlistViewController *secVController=[[SectionlistViewController alloc] initWithBookModel:currentBook];
            [secVController showBackBar];
            [self.navigationController pushViewController:secVController animated:YES];
            [secVController release];
        }
            break;
        case kButtonShareTag:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"分享到", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"新浪微博", @""),NSLocalizedString(@"网易微博",@""),NSLocalizedString(@"腾讯微博", @""),NSLocalizedString(@"搜狐微博", @""),NSLocalizedString(@"分享设置",@""), nil];
            [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
            if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
            {
                AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
                [actionSheet showInView:appDelegate.window];
            }
            else {
                [actionSheet showInView:self.view];
            }
            [actionSheet release];        
        }
            break;
        default:
            break;
    }
}

-(void)commentAction:(id)sender
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.bottomView setHidden:YES];
    
    CommentViewController *commentVController=[[CommentViewController alloc] initWithBookID:currentBook.bookID commentCount:currentBook.commentCount];
    [commentVController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:commentVController animated:YES];
    [commentVController release];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.bottomView setHidden:NO];
    
    //请求该书籍的评论个数
    NSString *commentURL=[[CommentDAL sharedInstance] getCommentCountByBookID:self.currentBook.bookID];
    [[DownloadHelper sharedInstance] startRequest:commentURL delegate:self tag:kRequestCommentCount userInfo:nil];
    
    //横幅
    if(appDelegate.bannerView_==nil)
    {
        appDelegate.bannerView_ = [[[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner]autorelease];
    }
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    appDelegate.bannerView_.adUnitID = @"a1506a625f59a0a";
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    appDelegate.bannerView_.rootViewController =appDelegate.window.rootViewController;
    [bgScrollView addSubview:appDelegate.bannerView_];
    // Initiate a generic request to load it with an ad.
    [appDelegate.bannerView_ loadRequest:[GADRequest request]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=[NSString stringWithFormat:@"%@(%@)",self.currentBook.bookName,self.currentBook.bookStateName];
    
    UIButton *btnComment=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnComment setFrame:CGRectMake(0, 7, 60, 30)];
    [btnComment.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [btnComment setBackgroundImage:[UIImage imageNamed:@"nav_normal.png"] forState:UIControlStateNormal];
    [btnComment addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnComment setTitle:@"..." forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btnComment] autorelease];

    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 7, 48, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];

    bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-44)];
    [bgScrollView setBackgroundColor:[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0f]];
    [self.view addSubview:bgScrollView];

        
    //第一个漫画名称、作者、图片等属性视图
    CGFloat offsetX=7;
    CGFloat offsetY=53;
    CGFloat viewWidth=self.view.frame.size.width-offsetX*2;
    UIView *attriView=[[UIView alloc] initWithFrame:CGRectMake(offsetX, offsetY, viewWidth, 225)];
    [attriView setBackgroundColor:[UIColor whiteColor]];
    [attriView.layer setCornerRadius:8];
    [attriView.layer setMasksToBounds:YES];
    
    //漫画图片
    UIImageView *coverBgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cover_bg.png"]];
    [coverBgImgView setFrame:CGRectMake(8, 20, 96, 126)];
//    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
//    {
//        [coverBgImgView setFrame:CGRectMake(110, 20, 96, 126)];
//    }
    UIImageView *iconImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 120)];
    [iconImgView setImageWithURL:[NSURL URLWithString:currentBook.bookIconURL]];
    [coverBgImgView addSubview:iconImgView];
    [iconImgView release];
    [attriView addSubview:coverBgImgView];
    [coverBgImgView release];
    
    CGFloat gap=3;//字段之间的间隔
    //书名
    UILabel *lblName=[[UILabel alloc] initWithFrame:CGRectMake(coverBgImgView.frame.origin.x+coverBgImgView.frame.size.width+10, coverBgImgView.frame.origin.y-15, 200, 20)];
    [lblName setBackgroundColor:[UIColor clearColor]];
    [lblName setFont:[UIFont boldSystemFontOfSize:17]];
    [lblName setText:currentBook.bookName];
    [attriView addSubview:lblName];
    [lblName release];
    
    
    //所属类别
    UILabel *lblCatalog=[[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+lblName.frame.size.height+gap+2, lblName.frame.size.width, lblName.frame.size.height)];
    [lblCatalog setFont:[UIFont systemFontOfSize:13]];
    [lblCatalog setTextColor:[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0f]];
    [lblCatalog setBackgroundColor:[UIColor clearColor]];
    [lblCatalog setText:[NSString stringWithFormat:@"所属类别：%@",currentBook.catalogName]];
    [attriView addSubview:lblCatalog];
    [lblCatalog release];

    //作者
    UILabel *lblAuthor=[[UILabel alloc] initWithFrame:CGRectMake(lblCatalog.frame.origin.x, lblCatalog.frame.origin.y+lblCatalog.frame.size.height+gap+2, lblCatalog.frame.size.width, lblCatalog.frame.size.height)];
    [lblAuthor setFont:[UIFont systemFontOfSize:13]];
    [lblAuthor setTextColor:[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0f]];
    [lblAuthor setBackgroundColor:[UIColor clearColor]];
    [lblAuthor setText:[NSString stringWithFormat:@"作     者 ：%@",currentBook.author]];
    [attriView addSubview:lblAuthor];
    [lblAuthor release];
    
    //点击率
    UILabel *lblClick=[[UILabel alloc] initWithFrame:CGRectMake(lblAuthor.frame.origin.x, lblAuthor.frame.origin.y+lblAuthor.frame.size.height+gap, lblAuthor.frame.size.width, lblAuthor.frame.size.height)];
    [lblClick setFont:[UIFont systemFontOfSize:13]];
    [lblClick setTextColor:[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0f]];
    [lblClick setBackgroundColor:[UIColor clearColor]];
    [lblClick setText:[NSString stringWithFormat:@"点 击 率 ：%@",currentBook.clickCount]];
    [attriView addSubview:lblClick];
    [lblClick release];
    
    //上架日期
    UILabel *lblCreateDate=[[UILabel alloc] initWithFrame:CGRectMake(lblClick.frame.origin.x, lblClick.frame.origin.y+lblClick.frame.size.height+gap, lblClick.frame.size.width, lblClick.frame.size.height)];
    [lblCreateDate setFont:[UIFont systemFontOfSize:13]];
    [lblCreateDate setBackgroundColor:[UIColor clearColor]];
    [lblCreateDate setTextColor:[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0f]];
    [lblCreateDate setText:[NSString stringWithFormat:@"上架日期：%@",currentBook.creationDate]];
    [attriView addSubview:lblCreateDate];
    [lblCreateDate release];
    
    //更新日期
    UILabel *lblUpdateDate=[[UILabel alloc] initWithFrame:CGRectMake(lblCreateDate.frame.origin.x, lblCreateDate.frame.origin.y+lblCreateDate.frame.size.height+gap, lblCreateDate.frame.size.width, lblCreateDate.frame.size.height)];
    [lblUpdateDate setFont:[UIFont systemFontOfSize:13]];
    [lblUpdateDate setTextColor:[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0f]];
    [lblUpdateDate setBackgroundColor:[UIColor clearColor]];
    [lblUpdateDate setText:[NSString stringWithFormat:@"最后更新：%@",currentBook.updateDate]];
    [attriView addSubview:lblUpdateDate];
    [lblUpdateDate release];
    
    //连载状态
    UILabel *lblState=[[UILabel alloc] initWithFrame:CGRectMake(lblUpdateDate.frame.origin.x, lblUpdateDate.frame.origin.y+lblUpdateDate.frame.size.height+gap, lblUpdateDate.frame.size.width, lblUpdateDate.frame.size.height)];
    [lblState setFont:[UIFont systemFontOfSize:13]];
    [lblState setTextColor:[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0f]];
    [lblState setBackgroundColor:[UIColor clearColor]];
    [lblState setText:[NSString stringWithFormat:@"连载状态：%@",currentBook.bookStateName]];
    [attriView addSubview:lblState];
    [lblState release];

    //阅读章节
    UIButton *btnSection=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSection setTag:kButtonSectionTag];
    [btnSection setTitle:@"章节阅读" forState:UIControlStateNormal];
    [btnSection.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [btnSection setFrame:CGRectMake(coverBgImgView.frame.origin.x+10, lblState.frame.origin.y+lblState.frame.size.height+5, 135, 40)];
    [btnSection setBackgroundImage:[UIImage imageNamed:@"btn_sectiion.png"] forState:UIControlStateNormal];
    [btnSection setBackgroundImage:[UIImage imageNamed:@"btn_sectiion_press.png"] forState:UIControlStateHighlighted];
    [btnSection addTarget:self action:@selector(readBookAction:) forControlEvents:UIControlEventTouchUpInside];
    [attriView addSubview:btnSection];
    
    //分享到微博
    UIButton *btnShare=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnShare setTag:kButtonShareTag];
    [btnShare setTitle:@"分享微博" forState:UIControlStateNormal];
    [btnShare.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [btnShare setFrame:CGRectMake(btnSection.frame.origin.x+btnSection.frame.size.width+16, btnSection.frame.origin.y, btnSection.frame.size.width, btnSection.frame.size.height)];
    [btnShare setBackgroundImage:[UIImage imageNamed:@"btn_share.png"] forState:UIControlStateNormal];
    [btnShare setBackgroundImage:[UIImage imageNamed:@"btn_share_pressed.png"] forState:UIControlStateHighlighted];
    [btnShare addTarget:self action:@selector(readBookAction:) forControlEvents:UIControlEventTouchUpInside];
    [attriView addSubview:btnShare];
    [bgScrollView addSubview:attriView];
    
    
    
    //内容简介
    UIView *introView=[[UIView alloc] initWithFrame:CGRectMake(attriView.frame.origin.x, attriView.frame.origin.y+attriView.frame.size.height+5, attriView.frame.size.width, self.view.frame.size.width-120)];
    [introView setBackgroundColor:[UIColor whiteColor]];
    [introView.layer setCornerRadius:8];
    [introView.layer setMasksToBounds:YES];
    
    UILabel *lblIntroTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, introView.frame.size.width, 20)];
    [lblIntroTitle setText:@"内容提要"];
    [lblIntroTitle setFont:[UIFont boldSystemFontOfSize:16]];
    [lblIntroTitle setTextColor:[UIColor colorWithRed:199/255.0 green:199/255.0  blue:199/255.0  alpha:1.0f]];
    [lblIntroTitle setBackgroundColor:[UIColor clearColor]];
    [introView addSubview:lblIntroTitle];
    [lblIntroTitle release];
    
    CGSize size=[currentBook.bookIntro sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.view.frame.size.width-50, 10000)];
    UILabel *lblIntro=[[UILabel alloc] initWithFrame:CGRectMake(23, 40, self.view.frame.size.width-50, size.height)];
    [lblIntro setNumberOfLines:0];
    [lblIntro setBackgroundColor:[UIColor clearColor]];
    [lblIntro setFont:[UIFont systemFontOfSize:12]];
    [lblIntro setText:currentBook.bookIntro];
    [introView addSubview:lblIntro];
    [lblIntro release];
        
       
    //提示标签
    UILabel *lblLinkTitle=[[UILabel alloc] initWithFrame:CGRectMake(10,lblIntro.frame.origin.y+lblIntro.frame.size.height+10,200, 20)];
    [lblLinkTitle setText:@"该作者的其它作品"];
    [lblLinkTitle setFont:[UIFont boldSystemFontOfSize:16]];
    [lblLinkTitle setTextColor:[UIColor colorWithRed:199/255.0 green:199/255.0  blue:199/255.0  alpha:1.0f]];
    [lblLinkTitle setBackgroundColor:[UIColor clearColor]];
    [introView addSubview:lblLinkTitle];
    [lblLinkTitle release];

    
    //截图列表
    linkBookViewBg=[[UIView alloc] init];
    [linkBookViewBg.layer setBackgroundColor:[UIColor colorWithRed:232/255.0 green:232/255.0  blue:232/255.0  alpha:1.0f].CGColor];
    [linkBookViewBg.layer setCornerRadius:8];
    [linkBookViewBg.layer setMasksToBounds:YES];
    [linkBookViewBg.layer setBorderColor:[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0f].CGColor];
    [linkBookViewBg.layer setBorderWidth:1.0f];
    [linkBookViewBg setUserInteractionEnabled:YES];
    [linkBookViewBg setFrame:CGRectMake(10, lblLinkTitle.frame.origin.y+lblLinkTitle.frame.size.height+10,280, 150)];
    [introView addSubview:linkBookViewBg];
    [linkBookViewBg release];
        

    //截图背景上的scrollview
    linkScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, linkBookViewBg.frame.size.width, linkBookViewBg.frame.size.height-20)];
    [linkScrollView setDelegate:self];
    [linkScrollView setShowsHorizontalScrollIndicator:NO];
    [linkScrollView setPagingEnabled:YES];
    
    UILabel *lblResult=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, linkScrollView.frame.size.width, 30)];
    [lblResult setTag:kLabeResultTag];
    [lblResult setText:@"暂时只收录了该作者1本漫画"];
    [lblResult setTextAlignment:UITextAlignmentCenter];
    [lblResult setBackgroundColor:[UIColor clearColor]];
    [lblResult setFont:[UIFont systemFontOfSize:18]];
    [lblResult setTextColor:[UIColor grayColor]];
    [lblResult setCenter:linkScrollView.center];
    [linkScrollView addSubview:lblResult];
    [lblResult setHidden:YES];
    [lblResult release];
    
    UIActivityIndicatorView *actView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [actView setFrame:CGRectMake(0, 0, 30, 30)];
    [actView setCenter:linkScrollView.center];
    [actView setTag:kActivityTag];
    [linkScrollView addSubview:actView];
    [actView startAnimating];
    [actView release];

    
    [linkBookViewBg addSubview:linkScrollView];
    [linkScrollView release];
    
    
    [introView setFrame:CGRectMake(introView.frame.origin.x, introView.frame.origin.y, introView.frame.size.width, linkBookViewBg.frame.origin.y+linkBookViewBg.frame.size.height+10)];
    [bgScrollView addSubview:introView];
    CGFloat totalHeight=introView.frame.origin.y+introView.frame.size.height;
    [bgScrollView setContentSize:CGSizeMake(bgScrollView.frame.size.width, totalHeight+10)];


    [introView release];
    [attriView release];
    
    
    //请求该漫画作者的相关作品
    NSString *url=[[BookDAL sharedInstance] getlinkBookByAuthor:currentBook.author bookID:currentBook.bookID];
    [[DownloadHelper sharedInstance] startRequest:url delegate:self tag:kRequestLinkBookTag userInfo:nil];
}


-(void)releaseData
{
    self.pageController=nil;
    self.linkBookViewBg=nil;
    self.linkbooklist=nil;
}

-(void)dealloc
{
    self.bgScrollView=nil;
    self.currentBook=nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma pageControlerDelegate
-(void)pageControlPageDidChange:(PageControl *)pageControl
{
    [linkScrollView setContentOffset:CGPointMake(pageControl.currentPage*linkScrollView.frame.size.width, linkScrollView.frame.origin.y) animated:YES];
}

#pragma scrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage=scrollView.contentOffset.x/scrollView.frame.size.width;
    [pageController setCurrentPage:currentPage];
}



-(void)linkBookAction:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    BookModel *book=[linkbooklist objectAtIndex:btn.tag];
    BookDetailViewController *detailVController=[[BookDetailViewController alloc] initWithBook:book];
    [self.navigationController pushViewController:detailVController animated:YES];
    [detailVController release];
}


// 网易demo方法
- (void)buttonShareClicked:(int)tag {
    
    //图片要用jpg格式，苹果会把png格式的图片加密，无法获取了
    NSString *imagePath = @"Icon.jpg";
    NSString *message = [NSString stringWithFormat:@"我正在使用《漫画桌》观看漫画《%@》,管快来下载吧\n%@#\n                 来自我的iPhone",self.currentBook.bookName,kAppDownloadURL];
    switch (tag) {
        case 0:
            //            [WeiboWrapper publishMessage:@"分享的内容" andWeiboId:Weibo_Sina andController:self andUserData:0];
            [WeiboWrapper publishMessage:message andImagePath:imagePath andWeiboId:Weibo_Sina andController:self andUserData:0];
            break;
        case 1:
            //            [WeiboWrapper publishMessage:@"分享的内容" andWeiboId:Weibo_Tencent andController:self andUserData:0];
            [WeiboWrapper publishMessage:message andImagePath:imagePath andWeiboId:Weibo_Netease andController:self andUserData:0];
            break;
        case 2:
            //[WeiboWrapper publishMessage:@"分享的内容" andWeiboId:Weibo_Netease andController:self andUserData:0];
            [WeiboWrapper publishMessage:message andImagePath:imagePath andWeiboId:Weibo_Tencent andController:self andUserData:0];
            break;
        case 3:
            //            [WeiboWrapper publishMessage:@"分享的内容" andWeiboId:Weibo_Sohu andController:self andUserData:0];
            [WeiboWrapper publishMessage:message andImagePath:imagePath andWeiboId:Weibo_Sohu andController:self andUserData:0];
            break;
        case 4:
            [WeiboWrapper navigateToWeiboSettingController:self.navigationController];
            break;
        default:
            break;
    }
}

#pragma mark - ActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://新浪微博
        case 1://网易微博
        case 2://腾讯微博
        case 3://搜狐微博
//            [self buttonShareClicked:buttonIndex];
//            break;
        case 4://分享设置
            [self buttonShareClicked:buttonIndex];
        default:
            break;
    }
}

#pragma downloadhelper Delegate
-(void)DownloadFinished:(id)data downloadType:(NSNumber *)downloadType
{
    switch ([downloadType intValue]) {
        case kRequestLinkBookTag:
        {
            UIActivityIndicatorView *actView=(UIActivityIndicatorView *)[linkBookViewBg viewWithTag:kActivityTag]; 
            [actView removeFromSuperview];
            
            CGFloat width=60;
            CGFloat height=80;
            
            self.linkbooklist=[[BookDAL sharedInstance] parseBooklist:[[data objectForKey:@"Data"] JSONValue]];
            if([linkbooklist count]==0)
            {
                UILabel *lblResult=(UILabel *)[linkScrollView viewWithTag:kLabeResultTag];
                [lblResult setHidden:NO];
            }
            for(int i=0;i<[linkbooklist count];i++)
            {
                BookModel *book=[linkbooklist objectAtIndex:i];
                UIButton *btnBook=[[UIButton alloc] initWithFrame:CGRectMake(5+i*(width+10), 15, width, height)];
                [btnBook setImageWithURL:[NSURL URLWithString:book.bookIconURL]];
                [btnBook addTarget:self action:@selector(linkBookAction:) forControlEvents:UIControlEventTouchUpInside];
                [btnBook setTag:i];
                [linkScrollView addSubview:btnBook];
                [btnBook release];
                
                UILabel *lblName=[[UILabel alloc] initWithFrame:CGRectMake(5+i*(width+10), btnBook.frame.origin.y+height+5, width, 20)];
                [lblName setTextColor:[UIColor blackColor]];
                [lblName setBackgroundColor:[UIColor clearColor]];
                [lblName setFont:[UIFont systemFontOfSize:12]];
                [lblName setTextAlignment:UITextAlignmentCenter];
                [lblName setText:book.bookName];
                [linkScrollView addSubview:lblName];
                [lblName release];
            }
            
            CGFloat pageCount=ceil([linkbooklist count]/4.0);
            [linkScrollView setContentSize:CGSizeMake(linkScrollView.frame.size.width*pageCount, linkScrollView.frame.size.height)];
            
            //创建分页指示器
            pageController=[[PageControl alloc] initWithFrame:CGRectMake(0,125,linkScrollView.frame.size.width, 22)];
            [pageController setCenter:CGPointMake(linkScrollView.center.x, pageController.center.y)];
            [pageController setDelegate:self];
            [pageController setNumberOfPages:pageCount];
            [pageController setCurrentPage:0];
            [pageController setImageOrColor:YES];
            [pageController setDotImageCurrentPage:[UIImage imageNamed:@"selectedPoint.png"]];
            [pageController setDotImageOtherPage:[UIImage imageNamed:@"unSelectedPoint.png"]];
            [linkBookViewBg addSubview:pageController];
        }
            break;
        case kRequestCommentCount:
        {
            int commentCount=[[CommentDAL sharedInstance] parseCommentCountFromResult:[data objectForKey:@"Data"]];
            currentBook.commentCount=commentCount;
            UIButton *btnRight=(UIButton *)self.navigationItem.rightBarButtonItem.customView;
            [btnRight setTitle:[NSString stringWithFormat:@"%d 评论",commentCount] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}
@end
