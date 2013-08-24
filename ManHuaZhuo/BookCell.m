//
//  BookCell.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BookCell.h"
#import "Constants.h"

@implementation BookCell

@synthesize lblName,lblIntro,iconImgView,stateImgView,lblAttri;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *bgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg.png"]];
        [self setBackgroundView:bgImgView];
        [bgImgView release];
        
        
        UIImageView *bgPressedImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
        [self setSelectedBackgroundView:bgPressedImgView];
        [bgPressedImgView release];
        
        
        lblName=[[UILabel alloc] initWithFrame:CGRectMake(80, 15, 200, 15)];
        [lblName setFont:[UIFont boldSystemFontOfSize:15.0]];
        [lblName setTextColor:kCellNameColor];
        [lblName setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:lblName];
        
        
        lblAttri=[[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, 40, lblName.frame.size.width, 12)];
        [lblAttri setBackgroundColor:[UIColor clearColor]];
        [lblAttri setFont:[UIFont systemFontOfSize:12.0]];
        [lblAttri setTextColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:150/255.0 alpha:1.0]];
        [self.contentView  addSubview:lblAttri];
        
        
        lblIntro=[[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, 55, lblName.frame.size.width, 30)];
        [lblIntro setBackgroundColor:[UIColor clearColor]];
        [lblIntro setFont:[UIFont systemFontOfSize:12.0]];
        [lblIntro setTextColor:[UIColor colorWithRed:140/255.0 green:140/255.0 blue:150/255.0 alpha:1.0]];
        [lblIntro setNumberOfLines:0];
        [self.contentView  addSubview:lblIntro];
        
        
        //书籍封面
        UIImageView *coverBgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cover_bg.png"]];
        [coverBgImgView setFrame:CGRectMake(5, 5, 64, 84)];
        iconImgView=[[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 60, 80)];
        [coverBgImgView addSubview:iconImgView];
        [self.contentView  addSubview:coverBgImgView];
        [coverBgImgView release];
        
        stateImgView=[[UIImageView alloc] initWithFrame:CGRectMake(200, 0, 22, 22)];
        [self.contentView  addSubview:stateImgView];
        
        UIImageView *accessImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_detail_button.png"]];
        self.accessoryView=accessImgView;
        [accessImgView release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)dealloc
{
    self.stateImgView=nil;
    self.lblName=nil;
    self.lblIntro=nil;
    self.lblAttri=nil;
    self.iconImgView=nil;
    [super dealloc];
}
@end
