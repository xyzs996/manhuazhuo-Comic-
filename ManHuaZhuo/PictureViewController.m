//
//  PictureViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PictureViewController.h"
#import "TFHpple.h"
#import "PictureModel.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "MD5Helper.h"
#import "FileHelper.h"
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "CommonHelper.h"
#import "SettingDAL.h"
#import "PictureDAL.h"
#import "MD5Helper.h"
#import "JSON.h"

#define kRotateBarTag 1000
#define kTurnBarTag 1001
#define kPictrueScrollViewTag 2000
#define kPicturelistRequestTag 3000


@interface PictureViewController ()
{
    CFRunLoopRef loop;
    bool isGetPicURL;
    NSThread *th;
    BOOL isShowBar;
    int currentPageIndex;//从0开始
    BOOL isLocalRequest;//是否是本地阅读
}

@property(nonatomic,retain)UILabel *lblPage;
@property(nonatomic,retain)UISlider *slierView;
@property(nonatomic,retain)UIToolbar *navBar;
@property(nonatomic,retain)UIToolbar *bottomToolBar;
@property(nonatomic,retain)UIToolbar *sliderBar;
@property(nonatomic,retain)MBProgressHUD *hudView;
@property(nonatomic,retain)SectionModel *currentSection;
@property(nonatomic,retain)UIScrollView *picScrollView;
//@property(nonatomic,retain)UIWebView *webView;

-(void)orationAction:(id)sender;
-(void)tapShowBar:(UITapGestureRecognizer *)tapGesture;//点击隐藏显示bar,和左右翻页手势
-(void)updateToPageIndex:(int)pagIndex;//移动到第几页，传入几就显示几
-(void)sliderChanged:(id)sender;
-(void)updateControlsByDirection:(BOOL)isScrolling;//通过翻页方向进行调整控件
-(void)downloadImageByCurrentPage:(int)currentPage;//currentPage从0开始
-(void)downloadImagesByPage:(int)page;//下载page前后各一张，3张图片


@end

@implementation PictureViewController

@synthesize lblPage;
@synthesize slierView;
@synthesize hudView;
@synthesize currentSection;
@synthesize picScrollView;
//@synthesize webView;
@synthesize bottomToolBar,navBar,sliderBar;

- (id)initWithSection:(SectionModel *)section isLocalRequest:(BOOL)_isLocalRequest
{
    self = [super init];
    if (self) {
        isLocalRequest=_isLocalRequest;
        self.currentSection=section;
        if(!isLocalRequest)
        {
            NSString *picURL=[[PictureDAL sharedInstance] getPicturelistURLBySectionID:currentSection.sectionID];
            [[DownloadHelper sharedInstance] startRequest:picURL delegate:self tag:kPicturelistRequestTag userInfo:nil];
        }
    }
    return self;
}

-(void)downloadImageByCurrentPage:(int)currentPage
{
    if([self.currentSection.piclist count]==0)
    {
        return;
    }
    CustomImgView *imgView=(CustomImgView *)[picScrollView viewWithTag:500+currentPage];
    if(imgView==nil)
    {
        CustomImgView *currImgView=[[CustomImgView alloc] initWithFrame:CGRectMake(picScrollView.frame.size.width*currentPage, picScrollView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        [currImgView setTag:500+currentPage];
        [picScrollView addSubview:currImgView];
        imgView=currImgView;
        [currImgView release];
    }
    if(currentPage>=[self.currentSection.piclist count])
    {
        currentPage=[self.currentSection.piclist count]-1;
    }
    if(currentPage<0)
    {
        currentPage=0;
    }
    PictureModel *picModel=[self.currentSection.piclist objectAtIndex:currentPage];
        NSLog(@"currentPage=%d%@%@",currentPage,picModel,picModel.picURL);
    if(imgView.imgView.image==nil&&!imgView.isDownloading)
    {
        if(isLocalRequest)
        { 
            NSString *picName=[[PictureDAL sharedInstance]getPicNameByPictureURL:picModel.picURL andIndex:currentPage];
            NSString *picPath=[[[[kDownloadedPath stringByAppendingPathComponent:self.currentSection.groupName] stringByAppendingPathComponent:self.currentSection.bookName] stringByAppendingPathComponent:self.currentSection.sectionName] stringByAppendingPathComponent:picName];
            UIImage *img=[UIImage imageWithContentsOfFile:picPath];
            if(img.size.width>320)
            {
                [imgView.imgView setImage:img];
            }
        }
        else {
            NSLog(@"picModel.picReferURL=%@",picModel.picReferURL);
            [imgView startDownImageByURL:picModel.picURL andPictureReferer:picModel.picReferURL];
        }
    }
}


-(void)tapShowBar:(UITapGestureRecognizer *)tapGesture
{
    CGPoint locationPoint=[tapGesture locationInView:self.view];
    CGFloat turnPageWidth=60;
    int currentPage=(int)slierView.value;
    if(locationPoint.x<turnPageWidth)
    {
        if(currentPage==slierView.minimumValue)
        {
            [CommonHelper showCustomHud:[UIImage imageNamed:@"tips_failed.png"] title:@"已经是第一页了" targetView:self.view];
        }
        else {
            [self updateToPageIndex:currentPage-1];
            [picScrollView setContentOffset:CGPointMake((currentPage-2)*picScrollView.frame.size.width, 0) animated:YES];
            [self downloadImageByCurrentPage:currentPage];
        }
    }
    else if(locationPoint.x>picScrollView.frame.size.width-turnPageWidth)
    {
        if(currentPage==slierView.maximumValue)
        {
            [CommonHelper showCustomHud:[UIImage imageNamed:@"tips_failed.png"] title:@"已经是最后一页了" targetView:self.view];
        }
        else {
            [self updateToPageIndex:currentPage+1];
            [picScrollView setContentOffset:CGPointMake(currentPage*picScrollView.frame.size.width, 0) animated:YES];
            [self downloadImageByCurrentPage:currentPage];
        }
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        CGFloat alpha=0;
        if(!isShowBar)
        {
            alpha=1.0;
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
        else
        {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }
        [self.navBar setAlpha:alpha];
        [self.sliderBar setAlpha:alpha];
        [self.bottomToolBar setAlpha:alpha];
        isShowBar=!isShowBar;
        [UIView commitAnimations];
    }
}

-(void)updateToPageIndex:(int)pagIndex
{
    [lblPage setText:[NSString stringWithFormat:@"%d\n%d",pagIndex,currentSection.picCount]];
    slierView.value=pagIndex;
}

-(void)sliderChanged:(id)sender
{
    UISlider *slider=(UISlider *)sender;
    currentPageIndex=slider.value-1;
    [self downloadImagesByPage:currentPageIndex];
    [lblPage setText:[NSString stringWithFormat:@"%d\n%d",currentPageIndex+1,currentSection.picCount]];
    if([[SettingDAL sharedInstance] shouldTurnToRight])
    {
        [picScrollView setContentOffset:CGPointMake(currentPageIndex*picScrollView.frame.size.width, 0) animated:YES];
    }
    else {
        [picScrollView setContentOffset:CGPointMake(([currentSection.piclist count]-currentPageIndex-1)*picScrollView.frame.size.width, picScrollView.frame.origin.y) animated:YES];
    }
}

-(void)updateControlsByDirection:(BOOL)isScrolling
{
    int currentPage=picScrollView.contentOffset.x/picScrollView.frame.size.width;
    if([[SettingDAL sharedInstance] shouldTurnToRight])
    {
        for(int i =0;i<[currentSection.piclist count];i++)
        {
            CustomImgView *imgView=(CustomImgView *)[picScrollView viewWithTag:500+i];
            [imgView setFrame:CGRectMake(i*picScrollView.frame.size.width, imgView.frame.origin.y, imgView.frame.size.width, imgView.frame.size.height)];
        }
        if(!isScrolling)
        {
            [picScrollView setContentOffset:CGPointMake(currentPage*picScrollView.frame.size.width, picScrollView.frame.origin.y)];
            NSLog(@"picScrollView=%@",picScrollView);
        }
        [lblPage setText:[NSString stringWithFormat:@"%d\n%d",currentPage+1,currentSection.picCount]];
        slierView.value=currentPage+1;
        slierView.transform=CGAffineTransformMakeRotation(0);
    }
    else {
        for(int i =0;i<[currentSection.piclist count];i++)
        {
            CustomImgView *imgView=(CustomImgView *)[picScrollView viewWithTag:500+i];
            [imgView setFrame:CGRectMake(([currentSection.piclist count]-i-1)*picScrollView.frame.size.width, imgView.frame.origin.y, imgView.frame.size.width, imgView.frame.size.height)];
        }
       if(!isScrolling)
        {
            [picScrollView setContentOffset:CGPointMake(([currentSection.piclist count]-currentPage-1)*picScrollView.frame.size.width, picScrollView.frame.origin.y)];
            NSLog(@"现在是从右向左=%d===picScrollView=%@",currentPage,picScrollView);
        }

        [lblPage setText:[NSString stringWithFormat:@"%d\n%d",[currentSection.piclist count]-currentPage,currentSection.picCount]];
        slierView.value=[currentSection.piclist count]-currentPage;
        slierView.transform=CGAffineTransformMakeRotation(M_PI);
    }
//    slierView.value=currentPageIndex;
//    [lblPage setText:[NSString stringWithFormat:@"%d\n%d",currentPageIndex,currentSection.picCount]];
    
}

-(void)loadView
{
    [super loadView];
    //    webView=[[UIWebView alloc] init];
    //    webView.delegate=self;
    
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+20)];
    CGFloat width=self.view.frame.size.width;
    CGFloat height=self.view.frame.size.height;
    picScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [picScrollView setTag:kPictrueScrollViewTag];
    [picScrollView setPagingEnabled:YES];
    [picScrollView setDelegate:self];
    [picScrollView setShowsHorizontalScrollIndicator:NO];
    [picScrollView setContentSize:CGSizeMake(picScrollView.frame.size.width*[currentSection.piclist count], picScrollView.frame.size.height)];
    [self.view addSubview:picScrollView];
    
    
    AppDelegate *appDelete=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    isShowBar=YES;
    UITapGestureRecognizer *tapBar=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShowBar:)];
    [picScrollView addGestureRecognizer:tapBar];
    [tapBar release];
    
    
    //顶部的导航栏
    self.navBar=[[[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)]autorelease];
    appDelete.navBarBgImg=nil;
    [navBar setBarStyle:UIBarStyleBlackTranslucent];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 7, 48, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:btn];
    
    UILabel *lblSectionName=[[UILabel alloc] initWithFrame:CGRectMake(40, 5, navBar.frame.size.width-80, 34)];
    [lblSectionName setBackgroundColor:[UIColor clearColor]];
    [lblSectionName setFont:[UIFont systemFontOfSize:17]];
    [lblSectionName setFont:[UIFont boldSystemFontOfSize:17]];
    [lblSectionName setTextColor:[UIColor whiteColor]];
    [lblSectionName setNumberOfLines:0];
    [lblSectionName setText:currentSection.sectionName];
    [lblSectionName setTextAlignment:UITextAlignmentCenter];
    [navBar addSubview:lblSectionName];
    [lblSectionName release];
    
    [self.view addSubview:navBar];
    
    
    //滑竿sliderbar和标签
    self.sliderBar=[[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)] autorelease];
    [sliderBar setBarStyle:UIBarStyleBlackTranslucent];
    lblPage=[[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)] autorelease];
    [lblPage setBackgroundColor:[UIColor clearColor]];
    [lblPage setTextAlignment:UITextAlignmentCenter];
    [lblPage setTextColor:[UIColor whiteColor]];
    [lblPage setFont:[UIFont boldSystemFontOfSize:17]];
    [lblPage setNumberOfLines:0];
    [lblPage setText:[NSString stringWithFormat:@"%d\n%d",1,currentSection.picCount]];
    [self.sliderBar addSubview:lblPage];
    self.slierView=[[[UISlider alloc] initWithFrame:CGRectMake(40, 10, self.view.frame.size.width-60, 24)] autorelease];
    [slierView setMaximumValue:currentSection.picCount];
    [slierView setMinimumValue:1];
    [slierView addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventTouchUpInside];
    [sliderBar addSubview:slierView];
    [self.view addSubview:sliderBar];
    
    //    //底部的bar
    //    self.bottomToolBar=[[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)] autorelease];
    //    [self.bottomToolBar setBarStyle:UIBarStyleBlackTranslucent];
    //    
    //    //旋转item
    //    BOOL shouldRotate=[[SettingDAL sharedInstance] shouleRotateView];
    //    NSString *imgName=@"autorotate_off.png";
    //    if (shouldRotate) {
    //        imgName=@"autorotate_on.png";
    //    }
    //    UIBarButtonItem *orationItem=[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imgName] style:UIBarButtonItemStylePlain target:self action:@selector(orationAction:)] autorelease];
    //    orationItem.tag=kRotateBarTag;
    //
    //    
    //    //翻页方向item
    //    BOOL shouldTurnToRight=[[SettingDAL sharedInstance] shouldTurnToRight];
    //    NSString *imgTurnName=@"leftbinding.png";
    //    if (!shouldTurnToRight) {
    //        NSLog(@"123123===");
    //        imgTurnName=@"rightbinding.png";
    //    }
    //    UIBarButtonItem *turnItem=[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imgTurnName] style:UIBarButtonItemStylePlain target:self action:@selector(orationAction:)] autorelease];
    //    turnItem.tag=kTurnBarTag;
    //    
    //    //空格
    //    UIBarButtonItem *spaceItem=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease];
    //    
    //    self.bottomToolBar.items=[NSArray arrayWithObjects:orationItem,spaceItem,turnItem, nil];
    //    [self.view addSubview:bottomToolBar];
    //    
    //    
    //    [self updateControlsByDirection:NO];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    currentPageIndex=0;
    if(isLocalRequest)
    {
        [self downloadImagesByPage:0];
    }
}

-(void)orientationChanged:(NSNotification *)notif
{
    CGFloat barHeight=44;
    if(UIInterfaceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
    {
        [self.navBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, barHeight)];
        NSLog(@"shuzhig");
    }
    else {
        NSLog(@"heng");
        barHeight=30;
        [self.navBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, barHeight)];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)orationAction:(id)sender
{
    UIBarButtonItem *item=(UIBarButtonItem *)sender;
    switch (item.tag) {
        case kRotateBarTag://是否支持旋转
        {
            BOOL shouldRotate=[[SettingDAL sharedInstance] shouleRotateView];
            [[SettingDAL sharedInstance] updateRotateViewState:!shouldRotate];
            NSString *imgName=@"autorotate_on.png";
            if (shouldRotate) {
                imgName=@"autorotate_off.png";
            }
            [item setImage:[UIImage imageNamed:imgName]];
        }
            break;
        case kTurnBarTag:
        {
            BOOL shouldTurnToRight=[[SettingDAL sharedInstance] shouldTurnToRight];
            [[SettingDAL sharedInstance] updateTurnPageDirection:!shouldTurnToRight];
            NSString *imgName=@"rightbinding.png";
            if ([[SettingDAL sharedInstance] shouldTurnToRight]) {
                imgName=@"leftbinding.png";
            }
            [item setImage:[UIImage imageNamed:imgName]];
            [self updateControlsByDirection:NO];
        }
        default:
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.navBarBgImg=[UIImage imageNamed:@"nav_bg_ios4.png"];
}

-(void)goBack
{
    AppDelegate *appdDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appdDelegate hidePictureViewController];
}

-(void)releaseData
{
    self.picScrollView=nil;
//    [webView stopLoading];
//    self.webView.delegate=nil;
//    self.webView=nil;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [self releaseData];
    self.hudView.delegate=self;
    self.hudView=nil;

    self.currentSection=nil;
    [super dealloc];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //内存满了，释放已经下载的数据漫画
    int currentPage=picScrollView.contentOffset.x/self.view.frame.size.width;
    
    for(int i=0;i<[self.currentSection.piclist count];i++)
    {
        if(![self isExistInCurrentPage:i currentPage:currentPage])
        {
            CustomImgView *imgView=(CustomImgView *)[picScrollView viewWithTag:500+i];
            [imgView removeFromSuperview];
        }
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseData];
}

-(BOOL)isExistInCurrentPage:(int)targetPage currentPage:(int)currentPage
{
    BOOL flag=NO;
    NSArray *currentImgs=[NSArray arrayWithObjects:[NSNumber numberWithInt:currentPage-1],[NSNumber numberWithInt:currentPage],[NSNumber numberWithInt:currentPage+1], nil];
    for(NSNumber *num in currentImgs)
    {
        if([num integerValue]==targetPage)
        {
            flag=YES;
        }
    }
    return flag;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma scrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.tag==kPictrueScrollViewTag)
    {
        [self updateControlsByDirection:YES];
    }
    int currentPage=scrollView.contentOffset.x/self.view.frame.size.width;
    [self downloadImagesByPage:currentPage];
//    [self downloadImageByCurrentPage:currentPage];
}

-(void)downloadImagesByPage:(int)page
{
    int endPage=page;
    if(page+2<[self.currentSection.piclist count])
    {
        endPage=page+2;
    }
    else if(page+1<[self.currentSection.piclist count])
    {
        endPage=page+1;
    }
    NSLog(@"startPage=%d,%d",endPage,page);
    //提前下载后2页漫画
    for(int i=page;i<=endPage;i++)
    {
        [self downloadImageByCurrentPage:i];
    }
}


#pragma mark sectonDownloadDelegate
-(void)sectionDownload:(SectionModel *)sectionModel CapturePicture:(PictureModel *)picModel isFinished:(NSNumber *)isFinished
{
    NSLog(@"picModel.picURL=%@",picModel.picURL);
}

-(void)DownloadFinished:(id)data downloadType:(NSNumber *)downloadType
{
    switch ([downloadType intValue]) {
        case kPicturelistRequestTag:
            self.currentSection.piclist=[[PictureDAL sharedInstance] parsePicturelist:[[data objectForKey:@"Data"]JSONValue]];
            [picScrollView setContentSize:CGSizeMake(self.view.frame.size.width*[self.currentSection.piclist count], self.view.frame.size.height)];
            [self downloadImagesByPage:0];
            break;
        default:
            break;
    }
}
@end
