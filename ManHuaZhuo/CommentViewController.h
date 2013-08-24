//
//  CommentViewController.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadHelper.h"
#import "WriteCommentViewController.h"
#import "CommentCell.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface CommentViewController : WriteCommentViewController<DownloadHelperDelegate,UITableViewDataSource,UITableViewDelegate,CommentCellDelegate,EGORefreshTableFooterDelegate,EGORefreshTableHeaderDelegate>

-(id)initWithBookID:(NSString *)bookID commentCount:(int)commentCount;

@end
