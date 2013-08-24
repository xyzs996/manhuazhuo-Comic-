//
//  CommentCell.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentCell.h"

#define kCommentCellDateColor [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0f]


@interface CommentCell ()

@property(nonatomic,retain)UIImageView *likeImgView;
@property(nonatomic,retain)UIImageView *handlikeImgView;
@property(nonatomic,retain)UIButton *btnLike;
-(void)replyAction:(id)sender;

@end

@implementation CommentCell

@synthesize lbllikeCount;
@synthesize btnLike;
@synthesize handlikeImgView;
@synthesize delegate;
@synthesize likeImgView;
@synthesize userPhoto;
@synthesize lblDate;
@synthesize lblNick;
@synthesize lblContent;
@synthesize lblClientType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        userPhoto=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self addSubview:userPhoto];
        
        lblNick=[[UILabel alloc] initWithFrame:CGRectMake(userPhoto.frame.origin.x+userPhoto.frame.size.width+10, userPhoto.frame.origin.y, 90, 25)];
        [lblNick setFont:[UIFont systemFontOfSize:14]];
        [lblNick setFont:[UIFont boldSystemFontOfSize:14]];
        [lblNick setTextColor:[UIColor colorWithRed:87/255.0 green:107/255.0 blue:149/255.0 alpha:1.0f]];
        [lblNick setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lblNick];
        
        lblClientType=[[UILabel alloc] initWithFrame:CGRectMake(lblNick.frame.origin.x+lblNick.frame.size.width, userPhoto.frame.origin.y+1, 280, 25)];
        [lblClientType setFont:[UIFont systemFontOfSize:11]];
        [lblClientType setTextColor:kCommentCellDateColor];
        [lblClientType setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lblClientType];
        
        lblContent=[[UILabel alloc] initWithFrame:CGRectMake(lblNick.frame.origin.x, lblNick.frame.origin.y+lblNick.frame.size.height+5, 240, 40)];
        [lblContent setNumberOfLines:0];
        [lblContent setTextAlignment:UITextAlignmentLeft];
        [lblContent setFont:[UIFont systemFontOfSize:11]];
        [lblContent setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lblContent];

        lblDate=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-80, lblClientType.frame.origin.y, 100, 25)];
        [lblDate setFont:[UIFont systemFontOfSize:13]];
        [lblDate setTextColor:kCommentCellDateColor];
        [lblDate setBackgroundColor:[UIColor clearColor]];
        [self addSubview:lblDate];
        
        
        //回复view
        UIImage *bgImg=[UIImage imageNamed:@"comment_reply_bg.png"];
        UIImage *newBgImg= [bgImg stretchableImageWithLeftCapWidth:20 topCapHeight:0];
        likeImgView=[[UIImageView alloc] initWithImage:newBgImg];
        [likeImgView setFrame:CGRectMake(lblNick.frame.origin.x, lblContent.frame.origin.y+lblContent.frame.size.height+5, 100, 34)];
        [likeImgView setUserInteractionEnabled:YES];
        [self addSubview:likeImgView];
        
        //顶
        btnLike=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnLike setFrame:CGRectMake(4, 9, 29, 22)];
        [btnLike.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btnLike setTag:kButtonLikeTag];
        [btnLike setTitleColor:[UIColor colorWithRed:87/255.0 green:107/255.0 blue:149/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btnLike setBackgroundImage:[UIImage imageNamed:@"comment_ding_bg.png"] forState:UIControlStateHighlighted];
        [btnLike setTitle:@"顶" forState:UIControlStateNormal];
        [btnLike addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        [likeImgView addSubview:btnLike];
        
        
        //回复
        UIButton *btnReply=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnReply setFrame:CGRectMake(btnLike.frame.origin.x+btnLike.frame.size.width+10, btnLike.frame.origin.y, 40, 22)];
        [btnReply.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btnReply setTag:kButtonReplyTag];
        [btnReply setTitleColor:[UIColor colorWithRed:87/255.0 green:107/255.0 blue:149/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btnReply setBackgroundImage:[UIImage imageNamed:@"comment_ding_bg.png"] forState:UIControlStateHighlighted];
        [btnReply setTitle:@"回复" forState:UIControlStateNormal];
        [btnReply addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
        [likeImgView addSubview:btnReply];
        
        handlikeImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_ding.png"]];
        [handlikeImgView setFrame:CGRectMake(200, 13, 14, 15)];
        [likeImgView addSubview:handlikeImgView];
        
        lbllikeCount=[[UILabel alloc] initWithFrame:CGRectMake(handlikeImgView.frame.origin.x+handlikeImgView.frame.size.width+2, handlikeImgView.frame.origin.y, 13, handlikeImgView.frame.size.height)];
        [lbllikeCount setTextColor:[UIColor colorWithRed:87/255.0 green:107/255.0 blue:149/255.0 alpha:1.0f]];
        [lbllikeCount setBackgroundColor:[UIColor clearColor]];
        [lbllikeCount setFont:[UIFont systemFontOfSize:14]];
        [likeImgView addSubview:lbllikeCount];
        
        [self setBackgroundColor:[UIColor colorWithRed:237/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]];
        //cell的背景图片和选中的样式
//        UIImageView *cellBgImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"evaluation_cell.png"]];
//        [self setBackgroundView:cellBgImgView];
//        [cellBgImgView release];
        
        UIImageView *cellSelectedImgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_bg_press.png"]];
        [self setSelectedBackgroundView:cellSelectedImgView];
        [cellSelectedImgView release];
        
        [self setClipsToBounds:YES];

    }
    return self;
}

-(void)likeState:(int)state
{
    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:2.0];
    if(state==0)
    {
        [btnLike setTitle:@"顶" forState:UIControlStateNormal];
        [handlikeImgView setHidden:YES];
        [lbllikeCount setHidden:YES];
        [btnLike setEnabled:YES];
        [likeImgView setFrame:CGRectMake(lblNick.frame.origin.x, lblContent.frame.origin.y+lblContent.frame.size.height+5, 100, 34)];
    }
    else 
    {
        if(state==1) {
            [btnLike setTitle:@"顶" forState:UIControlStateNormal];
            [btnLike setEnabled:YES];
        }
        else if(state==2) {
            [btnLike setTitle:@"已顶" forState:UIControlStateNormal];
            [btnLike setEnabled:NO];
        }
        [lbllikeCount setHidden:NO];
        [handlikeImgView setHidden:NO];
        [likeImgView setFrame:CGRectMake(lblNick.frame.origin.x, lblContent.frame.origin.y+lblContent.frame.size.height+5, 240, 34)];
    }
    [UIView commitAnimations];
}

-(void)replyAction:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if([delegate respondsToSelector:@selector(CommentClick:buttonType:)])
    {
        [delegate CommentClick:self buttonType:[NSNumber numberWithInt:btn.tag]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    self.lbllikeCount=nil;
    self.handlikeImgView=nil;
    self.delegate=nil;
    self.likeImgView=nil;
    self.lblClientType=nil;
    self.userPhoto=nil;
    self.lblDate=nil;
    self.lblContent=nil;
    self.lblNick=nil;
    [super dealloc];
}

@end
