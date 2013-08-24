//
//  SwitchCell.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SwitchCell.h"

@interface SwitchCell ()

-(void)switchAction:(id)sender;
@end

@implementation SwitchCell

@synthesize switchView;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat offsetX=205;
        if([[[UIDevice currentDevice] systemVersion] intValue]>=5)
        {
            offsetX=220;
        }
        if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        {
            offsetX=600;
        }
        switchView=[[UISwitch alloc] initWithFrame:CGRectMake(offsetX, 9, 46, 30)];
        [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:switchView];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)switchAction:(id)sender
{
    if([delegate respondsToSelector:@selector(switchCell::)])
    {
        [delegate switchCell:self :[NSNumber numberWithBool:switchView.isOn]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    self.delegate=nil;
    self.switchView=nil;
    [super dealloc];
}
@end
