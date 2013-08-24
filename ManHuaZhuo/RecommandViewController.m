//
//  RecommandViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecommandViewController.h"
#import "AppDelegate.h"
#import "BookModel.h"
#import "SearchViewController.h"
#import "BookCell.h"
#import "UIImageView+WebCache.h"
#import "BookDAL.h"
#import "ImageViewCell.h"
#import "BookDetailViewController.h"
#import "CommonHelper.h"
#import "BookNet.h"
#import "ResponseModel.h"

@interface RecommandViewController ()
{
    BOOL isLoadingNext;
    int _pageIndex;
}

@property(nonatomic,retain)NSMutableArray *booklist;
@property(nonatomic,retain)WaterFlowView *waterView;

-(void)startRecommandlistInThread;//线程中请求推荐书籍

@end

@implementation RecommandViewController

@synthesize waterView;
@synthesize booklist;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)releaseData
{
    self.waterView=nil;
    self.booklist=nil;
    self.waterView.delegate=nil;
    self.waterView=nil;
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseData];
}

-(void)dealloc
{
    [self releaseData];
    [super dealloc];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)loadView
{
    [super loadView];

    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 7, 48, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_search.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_search_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];

    //瀑布流控件
    waterView=[[WaterFlowView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-44)];
    [waterView setTag:600];
    [waterView setWaterFlowViewDelegate:self];
    [waterView setWaterFlowViewDatasource:self];
    [self.view addSubview:waterView];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showLoadingView];
    
    
    _pageIndex=0;
    [NSThread detachNewThreadSelector:@selector(startRecommandlistInThread) toTarget:self withObject:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - private method
-(void)startRecommandlistInThread
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];

    ResponseModel *response=[BookNet startRecommandlistByPage:_pageIndex pageSize:40];
    if(_pageIndex==0)
    {
        self.booklist=response.resultInfo;
    }
    else {
        [self.booklist addObjectsFromArray:response.resultInfo];
    }
    isLoadingNext=NO;

    dispatch_async(dispatch_get_main_queue(), ^(void){
        if(response.error!=nil)
        {
            [self showErrorView];
            return;
        }
        [waterView reloadData];
        [self hideLoadingView];
    });
    [pool release];
}

-(void)errorViewTappedGesture:(UITapGestureRecognizer *)gesture
{
    [super errorViewTappedGesture:gesture];
    [NSThread detachNewThreadSelector:@selector(startRecommandlistInThread) toTarget:self withObject:nil];
}

#pragma mark WaterFlowViewDataSource
- (NSInteger)numberOfColumsInWaterFlowView:(WaterFlowView *)waterFlowView{
    
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        return 3;
    }
    else {
        return 6;
    }
}

- (NSInteger)numberOfAllWaterFlowView:(WaterFlowView *)waterFlowView{
    
    return [booklist count];
}

- (UIView *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(IndexPath *)indexPath{
    
    ImageViewCell *view = [[[ImageViewCell alloc] initWithIdentifier:nil] autorelease];
    
    return view;
}


-(void)waterFlowView:(WaterFlowView *)waterFlowView  relayoutCellSubview:(UIView *)view withIndexPath:(IndexPath *)indexPath{
    
    //arrIndex是某个数据在总数组中的索引
    int arrIndex = indexPath.row * waterFlowView.columnCount + indexPath.column;
    
    
    BookModel *book=[booklist objectAtIndex:arrIndex];
    //    NSURL *URL = [NSURL URLWithString:object.imgUrl];
    
    ImageViewCell *imageViewCell = (ImageViewCell *)view;
    imageViewCell.indexPath = indexPath;
    imageViewCell.columnCount = waterFlowView.columnCount;
    [imageViewCell relayoutViews];
    //    [(ImageViewCell *)view setImageWithURL:URL];
    [(ImageViewCell *)view setImageWithURL:[NSURL URLWithString:book.bookIconURL]];
}


#pragma mark WaterFlowViewDelegate
- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(IndexPath *)indexPath{
    
    return 140;

}

- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(IndexPath *)indexPath{
    
    //    NSLog(@"indexpath row == %d,column == %d",indexPath.row,indexPath.column
    int clickIndex=indexPath.row*3+indexPath.column;
    BookModel *book=[booklist objectAtIndex:clickIndex];
    NSLog(@"%@",book);
    BookDetailViewController *detailVController=[[BookDetailViewController alloc] initWithBook:book];
    [self.navigationController pushViewController:detailVController animated:YES];
    [detailVController release];
}

-(void)waterFlowView:(WaterFlowView *)waterFlowViewNeedReqeustData
{
    if(!isLoadingNext)
    {
        isLoadingNext=YES;
        _pageIndex++;
        [NSThread detachNewThreadSelector:@selector(startRecommandlistInThread) toTarget:self withObject:nil];
    }
}

@end
