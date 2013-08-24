//
//  ReplyViewController.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadHelper.h"
#import "WriteCommentViewController.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@class CommentModel;

@interface ReplyViewController :WriteCommentViewController <DownloadHelperDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableFooterDelegate,EGORefreshTableHeaderDelegate>

-(id)initWithCommentModel:(CommentModel *)commentModel;
@end
