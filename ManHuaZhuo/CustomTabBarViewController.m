//
//  CustomTabBarViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomTabBarViewController.h"

#define kRightViewWidth 200

@interface CustomTabBarViewController ()
{
    NSInteger selectedCellIndex;
    BOOL isShowRightView;
}

@property(nonatomic,retain)UIImageView *backgroungImgView;
@property(nonatomic,retain)UITableView *dataTableView;
@property(nonatomic,retain)NSArray *sectionlist;
@property(nonatomic,retain)NSArray *datalist;
@property(nonatomic,retain)UITapGestureRecognizer *tapGesture;

@end

@implementation CustomTabBarViewController

@synthesize delegate;
@synthesize viewControllers,tabItems,backgroundImage;
@synthesize backgroungImgView;
@synthesize selectedIndex;
@synthesize datalist,dataTableView;
@synthesize sectionlist;
@synthesize tapGesture;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        backgroungImgView =[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
        [backgroungImgView setUserInteractionEnabled:YES];
        [self.view addSubview:backgroungImgView];
        
        dataTableView=[[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-kRightViewWidth, 0, kRightViewWidth, self.view.frame.size.height-44) style:UITableViewStylePlain];
        [dataTableView setDelegate:self];
        UIImageView *bgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sidebar_cell,png"]];
        [bgImgView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [bgImgView setFrame:dataTableView.frame];
        [dataTableView setBackgroundView:bgImgView];
        [bgImgView release];
        [dataTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [dataTableView setDataSource:self];
        [self.view addSubview:dataTableView];
        
        
        tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCurrentRightView)];
        [self.view addGestureRecognizer:tapGesture];
        [tapGesture setEnabled:NO];
        
    }
    return self;
}

-(void)setBackgroundImage:(UIImage *)_backgroundImage
{
    if(backgroundImage!=_backgroundImage)
    {
        [backgroundImage release];
        backgroundImage=[_backgroundImage retain];
        [backgroungImgView setImage:backgroundImage];
    }
}

-(void)setViewControllers:(NSArray *)_viewControllers
{
    if(viewControllers!=_viewControllers)
    {
        [viewControllers release];
        viewControllers=[_viewControllers retain];
        for(int i=0;i<[viewControllers count];i++)
        {
            UIViewController *viewControl=[viewControllers objectAtIndex:i];
            [viewControl.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
            [self.view addSubview:viewControl.view];
        }
        NSLog(@"%@",self.view);
    }
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"12+++++3");
    return YES;
}
-(void)setTabItems:(NSArray *)_tabItems
{
    if(tabItems!=_tabItems)
    {
        [tabItems release];
        tabItems=[_tabItems retain];
        NSUInteger itemCount=[tabItems count];
        if(itemCount>5)
        {
            itemCount=5;
        }
        for(int i=0;i<itemCount;i++)
        {
            CustomTabBarView *tab=[tabItems objectAtIndex:i];
            CGFloat offsetX=(self.view.frame.size.width-itemCount*tab.frame.size.width)/2;
            [tab setDelegate:self];
            [tab setFrame:CGRectMake(offsetX+tab.frame.size.width*i,0, tab.frame.size.width, tab.frame.size.height)];
            [backgroungImgView addSubview:tab];
        }
        [self setSelectedIndex:0];
    }
}

-(void)setSelectedIndex:(NSUInteger)_selectedIndex
{
    selectedIndex=_selectedIndex;
    for(int i=0;i<[tabItems count];i++)
    {
        CustomTabBarView *tab=[tabItems objectAtIndex:i];
        UIViewController *viewController=[viewControllers objectAtIndex:i];
        if(i==selectedIndex)
        {
            [tab isSelected:YES];
            [viewController.view setHidden:NO];
            [viewController viewDidAppear:YES];
        }
        else {
            [tab isSelected:NO];
            [viewController.view setHidden:YES];
        }
    }
}

-(void)releaseData
{
    self.datalist=nil;
    self.dataTableView=nil;
    self.backgroungImgView=nil;
    self.viewControllers=nil;
    self.tabItems=nil;
    self.backgroundImage=nil;
    self.sectionlist=nil;
    self.tapGesture=nil;
    self.delegate=nil;
}

-(void)dealloc
{
    [self releaseData];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    for(int i=0;i<[tabItems count];i++)
    {
        UIViewController *viewController=[viewControllers objectAtIndex:i];
        if(i!=selectedIndex)
        {
            if([viewController respondsToSelector:@selector(viewDidUnload)])
            {
                [viewController viewDidUnload];
            }
        }
    }
    [self releaseData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)isShowRightView
{
    return isShowRightView;
}

-(void)showCurrentRightView:(NSArray *)titlelist celllist:(NSArray *)celllist selectedIndex:(NSInteger)_selectedIndex
{
    [dataTableView setHidden:NO];
    selectedCellIndex=_selectedIndex;
    self.sectionlist=titlelist;
    self.datalist=celllist;
    [dataTableView reloadData];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.15];
    UIViewController *viewController=[viewControllers objectAtIndex:selectedIndex];
    [viewController.view setFrame:CGRectMake(0-kRightViewWidth, 0, viewController.view.frame.size.width, viewController.view.frame.size.height)];
    [UIView commitAnimations];
    [tapGesture setEnabled:YES];   
    isShowRightView=YES;
}

-(void)hideCurrentRightView
{
    [UIView animateWithDuration:0.15 animations:^(void){
        UIViewController *viewController=[viewControllers objectAtIndex:selectedIndex];
        [viewController.view setFrame:CGRectMake(0, 0, viewController.view.frame.size.width, viewController.view.frame.size.height)];
    } completion:^(BOOL finished){
        [dataTableView setHidden:YES];
    }];
    [tapGesture setEnabled:NO];
    isShowRightView=NO;
}

#pragma tableViewDataSource 
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionlist objectAtIndex:section];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *titleView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sidebar_cell_title.png"]] autorelease];
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, kRightViewWidth, 22)];
    [lblTitle setText:[sectionlist objectAtIndex:section]];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setTextColor:[UIColor whiteColor]];
    [lblTitle setFont:[UIFont systemFontOfSize:14.0]];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:14]];
    [lblTitle setTextAlignment:UITextAlignmentCenter];
    [titleView addSubview:lblTitle];
    [lblTitle release];
    return titleView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionlist count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datalist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity=@"CellIdentity";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentity] autorelease];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        
        
        //右侧的箭头
        UIImageView *rightImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sidebar_cell_access.png"]];
        [cell setAccessoryView:rightImgView];
        [rightImgView release];
        
        
        //背景图和按下状态图
        UIImageView *cellBgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sidebar_cell.png"]];
        [cell setBackgroundView:cellBgView];
        [cellBgView release];
        
        UIImageView *cellPressView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sidebar_cell_pressed.png"]];
        [cell setSelectedBackgroundView:cellPressView];
        [cellPressView release];
    }
    if(indexPath.row==selectedCellIndex)
    {
        [cell setSelected:YES];
    }
    cell.textLabel.text=[datalist objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([delegate respondsToSelector:@selector(rightViewClick:indexPath:)])
    {
        [delegate rightViewClick:tableView indexPath:indexPath];
    }
}

#pragma tabBarDelegate
-(void)tabBarClick:(CustomTabBarView *)tabBar
{
    for(int i=0;i<[tabItems count];i++)
    {
        CustomTabBarView *tab=[tabItems objectAtIndex:i];
        if(tab==tabBar)
        {
            [self setSelectedIndex:i];
        }
    }
}

-(void)hideBottomTabBar:(BOOL)flag
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    if(flag)
    {
        [backgroungImgView setFrame:CGRectMake(0-backgroungImgView.frame.size.width, backgroungImgView.frame.origin.y,backgroungImgView.frame.size.width, backgroungImgView.frame.size.height)];
    }
    else {
        [backgroungImgView setFrame:CGRectMake(0,  backgroungImgView.frame.origin.y, backgroungImgView.frame.size.width, backgroungImgView.frame.size.height)];
    }
    [UIView commitAnimations];
}
@end
