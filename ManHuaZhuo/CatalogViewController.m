//
//  CatalogViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CatalogViewController.h"
#import "BooklistViewController.h"
#import "BookModel.h"

@interface CatalogViewController ()

@property(nonatomic,retain)CommonCatalogViewController *commCataVCtroller;

@end

@implementation CatalogViewController

@synthesize commCataVCtroller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
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

    
    commCataVCtroller=[[CommonCatalogViewController alloc] init];
    [commCataVCtroller.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [commCataVCtroller setDelegate:self];
    [self.view addSubview:commCataVCtroller.view];
}


-(void)releaseData
{
    self.commCataVCtroller=nil;
}

-(void)dealloc
{
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
    [commCataVCtroller viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma commonVC delegate
-(void)commonCatalogCellClick:(CommonCatalogViewController *)commonVC obj:(id)obj
{
    BookModel *cataModel=(BookModel *)obj;
    BooklistViewController *bookVController=[[BooklistViewController alloc] initWithCatalog:cataModel];
    [self.navigationController pushViewController:bookVController animated:YES];
    [bookVController release];
}

#pragma waitView Delegate
-(void)waitViewTap:(NSString *)url
{
    
}
@end
