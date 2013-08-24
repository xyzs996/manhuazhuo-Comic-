//
//  MenuView.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MenuView.h"
#import "AppDelegate.h"


@interface MenuView ()
{
    BOOL isShowRightView;
    NSInteger selectedCellIndex;
}

@property(nonatomic,retain)UITableView *dataTableView;
@property(nonatomic,retain)NSArray *sectionlist;
@property(nonatomic,retain)NSArray *datalist;
@property(nonatomic,retain)UITapGestureRecognizer *tapGesture;

@end
@implementation MenuView

@synthesize datalist,dataTableView;
@synthesize sectionlist;
@synthesize tapGesture;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        dataTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        [dataTableView setDelegate:self];
        [dataTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [dataTableView setDataSource:self];
        [self addSubview:dataTableView];
        
        tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCurrentRightView)];
        [tapGesture setDelegate:self];
        [self addGestureRecognizer:tapGesture];
        [tapGesture setEnabled:NO];

        [dataTableView setBackgroundColor:[UIColor colorWithRed:66/255.0 green:74/255.0 blue:97/255.0 alpha:1.0f]];
    }
    return self;
}

-(void)dealloc
{
    self.delegate=nil;
    self.datalist=nil;
    self.sectionlist=nil;
    self.dataTableView=nil;
    [super dealloc];
}

-(BOOL)isShowRightView
{
    return isShowRightView;
}

-(void)showCurrentRightView:(NSArray *)titlelist celllist:(NSArray *)celllist selectedIndex:(NSInteger)_selectedIndex selectedBarIndex:(NSUInteger)selectedBarIndex
{
    [dataTableView setHidden:NO];
    selectedCellIndex=_selectedIndex;
    self.sectionlist=titlelist;
    self.datalist=celllist;
    [dataTableView reloadData];
    [dataTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.15];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.windowTap setEnabled:YES];
    [appDelegate.tabBarController.view setFrame:CGRectMake(-appDelegate.tabBarController.view.frame.size.width+120, 0, appDelegate.tabBarController.view.frame.size.width, appDelegate.tabBarController.view.frame.size.height)];
    [UIView commitAnimations];
    [tapGesture setEnabled:YES];   
    isShowRightView=YES;
}

-(void)hideCurrentRightView
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.windowTap setEnabled:NO];
    [UIView animateWithDuration:0.15 animations:^(void){
        [appDelegate.tabBarController.view setFrame:CGRectMake(0, 0, appDelegate.tabBarController.view.frame.size.width, appDelegate.tabBarController.view.frame.size.height)];
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
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 22)];
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
    cell.textLabel.text=[datalist objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([delegate respondsToSelector:@selector(rightViewClick:indexPath:)])
    {
        [delegate rightViewClick:tableView indexPath:indexPath];
    }
    [self hideCurrentRightView];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point=[touch locationInView:self];
    if(point.y<160)
    {
        return NO;
    }
    return YES;
}

@end
