//
//  BooklistViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BooklistViewController.h"
#import "AppDelegate.h"
#import "BookDetailViewController.h"

@interface BooklistViewController ()
{
    BookState state;//筛选条件
}

@property(nonatomic,retain)BookModel *catalog;
@property(nonatomic,retain)CustomSegmentController *segmentController;
@property(nonatomic,retain)CommonBooklistViewController *newsBooklistVController;
@property(nonatomic,retain)CommonBooklistViewController *hotBooklistVController;

-(void)showCondition;
@end

@implementation BooklistViewController

@synthesize catalog;
@synthesize hotBooklistVController;
@synthesize newsBooklistVController;
@synthesize segmentController;

-(id)initWithCatalog:(BookModel *)_catalog
{
    if(self=[super init])
    {
        self.catalog=_catalog;
        self.navigationItem.title=catalog.bookName;
    }
    return self;
}

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
        NSLog(@"asdfasd=======");
        [appDelegate.menuView showCurrentRightView:[NSArray arrayWithObjects:@"漫画完结状态", nil] celllist:[NSArray arrayWithObjects:@"全部漫画",@"连载中",@"已完结", nil] selectedIndex:state selectedBarIndex:1];
    }
    else {
        [appDelegate.menuView hideCurrentRightView];
        NSLog(@"YYYYY");
    }
}

-(void)loadView
{
    [super loadView];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 7, 48, 30)];
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

    
    
    segmentController=[[CustomSegmentController alloc] initWithLabels:[NSArray arrayWithObjects:@"人气火爆",@"最新更新", nil] buttonWidth:k_seg_button_middle];
    [segmentController setTypeClickDelegate:self];
    [self.view addSubview:segmentController];
    
    
    hotBooklistVController=[[CommonBooklistViewController alloc] initWitCatalog:catalog frame:CGRectMake(0, 32, self.view.frame.size.width, self.view.frame.size.height-32-44-44) order:OrderTypeHot state:BookStateAll];
    [hotBooklistVController setDelegate:self];
    [self.view addSubview:hotBooklistVController.view];
}

-(void)releaseData
{
    self.hotBooklistVController=nil;
    self.newsBooklistVController=nil;
    self.segmentController=nil;
}

-(void)dealloc
{
    [self releaseData];
    self.catalog=nil;
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
    [hotBooklistVController viewDidAppear:animated];
    [newsBooklistVController viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma TypeClick Delegate
-(void)TypeClick:(NSNumber *)index
{
    switch ([index intValue]) {
        case 0://人气
            [hotBooklistVController.view setHidden:NO];
            [newsBooklistVController.view setHidden:YES];
            break;
        case 1://更新时间
            if(newsBooklistVController==nil)
            {
                newsBooklistVController=[[CommonBooklistViewController alloc] initWitCatalog:catalog frame:CGRectMake(0, 32, self.view.frame.size.width, self.view.frame.size.height-32) order:OrderTypeNew state:state];
                [newsBooklistVController setDelegate:self];
                [self.view addSubview:newsBooklistVController.view];
            }
            [hotBooklistVController.view setHidden:YES];
            [newsBooklistVController.view setHidden:NO];
            break;
        default:
            break;
    }
}

#pragma CommonBooklistVC Delegate
-(void)commonBooklistClickDelegate:(CommonBooklistViewController *)bookVC obj:(id)obj
{
    BookDetailViewController *detailVController=[[BookDetailViewController alloc] initWithBook:obj];
    [self.navigationController pushViewController:detailVController animated:YES];
    [detailVController release];
}

#pragma rightView Delegate
-(void)rightViewClick:(UITableView *)tableview indexPath:(NSIndexPath *)indexPath
{
    state=(BookState)indexPath.row;
    if(![hotBooklistVController.view isHidden])//按照人气倒序
    {
        hotBooklistVController.pageIndex=0;
        [hotBooklistVController reloadDataByOrder:OrderTypeHot state:indexPath.row];
    }
    else {
        newsBooklistVController.pageIndex=0;
        [newsBooklistVController reloadDataByOrder:OrderTypeNew state:indexPath.row];
    }
}
@end
