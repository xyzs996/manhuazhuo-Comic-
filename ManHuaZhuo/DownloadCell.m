//
//  DownloadCell.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DownloadCell.h"
#import "SectionDownloadManager.h"

@implementation DownloadCell

@synthesize lblName;
@synthesize lblState;
@synthesize lblProgress;
@synthesize proView;
@synthesize stateImgView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *bgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
        [bgImgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [bgImgView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self setBackgroundView:bgImgView];
        [bgImgView release];
        
        
        lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280, 23)];
        [lblName setBackgroundColor:[UIColor clearColor]];
        [lblName setFont:[UIFont boldSystemFontOfSize:16]];
        [self.contentView addSubview:lblName];
        
        proView=[[UIProgressView alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+lblName.frame.size.height+8, lblName.frame.size.width, 9)];
        [self.contentView addSubview:proView];
        
        stateImgView=[[UIImageView alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, proView.frame.origin.y+proView.frame.size.height+8, 16, 16)];
        [stateImgView setImage:[UIImage imageNamed:@"download_pause_small.png"]];
        [self.contentView addSubview:stateImgView];
        
        
        lblState=[[UILabel alloc] initWithFrame:CGRectMake(stateImgView.frame.origin.x+stateImgView.frame.size.width+3, 52, 80, 25)];
        [lblState setBackgroundColor:[UIColor clearColor]];
        [lblState setFont:[UIFont systemFontOfSize:12]];
        [lblState setText:@"暂停中"];
        [self.contentView addSubview:lblState];
        
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        {
            [proView setFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+lblName.frame.size.height+8, 700, 9)];
        }
    }
    return self;
}

-(void)updateCellState:(NSNumber *)sectionState
{
    self.lblState.text=[[SectionDownloadManager sharedInstance] getStateStringByState:[sectionState intValue]];
    switch ([sectionState intValue]) {
        case SectionWatting:
        {
            [stateImgView setImage:[UIImage imageNamed:@"download_waiting.png"]];
        }
            break;
        case SectionDownloading:
        {
            [stateImgView setImage:[UIImage imageNamed:@"download_downloading.png"]];
        }
            break;
        case SectionPause:
        {
            [stateImgView setImage:[UIImage imageNamed:@"download_pause_small.png"]];
        }
        default:
            break;
    }
}

//恢复原始状态
-(void)recoverFrame
{
    [lblName setFrame:CGRectMake(10, 10, 280, 23)];
   
    [stateImgView setFrame:CGRectMake(lblName.frame.origin.x, proView.frame.origin.y+proView.frame.size.height+8, 16, 16)];
    [lblState setFrame:CGRectMake(stateImgView.frame.origin.x+stateImgView.frame.size.width+3, 52, 80, 25)];
    
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        [proView setFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+lblName.frame.size.height+8, 700, 9)];
    }
    else {
        [proView setFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+lblName.frame.size.height+8, lblName.frame.size.width, 9)];
    }
}

-(void)updateCellLeftDeleteState//只显示左边的删除符号
{
    float gap=30;
    [lblName setFrame:CGRectMake(lblName.frame.origin.x, 10,280-gap, 23)];
    
    [stateImgView setFrame:CGRectMake(lblName.frame.origin.x, proView.frame.origin.y+proView.frame.size.height+8, 16, 16)];
    [lblState setFrame:CGRectMake(lblName.frame.origin.x+stateImgView.frame.size.width+3, 52, 80, 25)];
    
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        [proView setFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+lblName.frame.size.height+8, 700, 9)];
    }
    else {
        [proView setFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+lblName.frame.size.height+8, lblName.frame.size.width, 9)];
    }
}

-(void)updateCellRightDeleteState//只显示右边的删除符号
{
    float gap=45;
    
    
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        [proView setFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+lblName.frame.size.height+8, 700, 9)];
    }
    else {
        [proView setFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+lblName.frame.size.height+8, proView.frame.size.width-gap, 9)];
    }
}

-(void)updateCellClickDeleteState//左右删除符号都显示
{
    float gap=50;
    [stateImgView setFrame:CGRectMake(lblName.frame.origin.x, proView.frame.origin.y+proView.frame.size.height+8, 16, 16)];
    [lblState setFrame:CGRectMake(lblName.frame.origin.x+stateImgView.frame.size.width+3, 52, 80, 25)];
    [lblName setFrame:CGRectMake(lblName.frame.origin.x, 10,lblName.frame.size.width-gap, 23)];

    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        [proView setFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+lblName.frame.size.height+8, 650, 9)];
    }
    else {
        [proView setFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+lblName.frame.size.height+8, lblName.frame.size.width, 9)];
    }
}

//0-正常 1-出现左边的删除符号 2-出现右边的删除按钮 3-1和2同时出现
-(void)willTransitionToState:(UITableViewCellStateMask)state
{
    NSLog(@"%d",state);
    [super willTransitionToState:state];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    switch (state) {
        case 0:
            [self recoverFrame];
            break;
        case 1:
            [self updateCellLeftDeleteState];
            break;
        case 2:
            [self updateCellRightDeleteState];
            break;
        case 3:
            [self updateCellClickDeleteState];
            break;
        default:
            break;
    }
    [UIView commitAnimations];
}

-(void)dealloc
{
    self.stateImgView=nil;
    self.lblProgress=nil;
    self.lblName=nil;
    self.lblState=nil;
    self.proView=nil;
    [super dealloc];
}
@end
