//
//  CommentCell.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@class CommentCell;

@protocol CommentCellDelegate <NSObject>

-(void)CommentClick:(CommentCell *)cell buttonType:(NSNumber *)buttonType;

@end
#import <UIKit/UIKit.h>


#define kButtonLikeTag 500
#define kButtonReplyTag 501


@interface CommentCell : UITableViewCell

@property(nonatomic,retain)UILabel *lbllikeCount;
@property(nonatomic,retain)UIImageView *userPhoto;
@property(nonatomic,retain)UILabel *lblNick;
@property(nonatomic,retain)UILabel *lblClientType;
@property(nonatomic,retain)UILabel *lblContent;
@property(nonatomic,retain)UILabel *lblDate;
@property(nonatomic,assign)id<CommentCellDelegate>delegate;

//0-正常 1-别人赞了 2-自己赞了
-(void)likeState:(int)state;
@end
