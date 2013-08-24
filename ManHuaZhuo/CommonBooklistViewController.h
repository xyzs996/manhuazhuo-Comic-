//
//  CommonBooklistViewController.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@class CommonBooklistViewController;

@protocol CommonBooklistDelegate <NSObject>

-(void)commonBooklistClickDelegate:(CommonBooklistViewController *)bookVC obj:(id)obj;

@end

#import <UIKit/UIKit.h>
#import "BookModel.h"
#import "DownloadHelper.h"
#import "Constants.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "WaitView.h"

@interface CommonBooklistViewController : UIViewController<DownloadHelperDelegate,UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate,EGORefreshTableFooterDelegate,WaitViewDelegate>

@property(nonatomic,assign)NSUInteger pageIndex;
@property(nonatomic,assign)id<CommonBooklistDelegate>delegate;

-(id)initWitCatalog:(BookModel *)bookModel frame:(CGRect)frame order:(OrderType)order state:(BookState)state;
-(id)initWithFrame:(CGRect)frame SearchURL:(NSString *)_serachURL;
-(void)reloadDataByOrder:(OrderType)order state:(BookState)state;
@end
