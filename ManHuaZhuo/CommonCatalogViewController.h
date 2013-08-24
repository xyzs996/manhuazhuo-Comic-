//
//  CommonCatalogViewController.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@class CommonCatalogViewController;

@protocol CommonCatalogDelegate <NSObject>

@optional
-(void)commonCatalogCellClick:(CommonCatalogViewController *)commonVC obj:(id)obj;

@end
#import <UIKit/UIKit.h>
#import "DownloadHelper.h"
#import "EGORefreshTableHeaderView.h"
#import "WaitView.h"
#import "BaseViewController.h"

@interface CommonCatalogViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,DownloadHelperDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate,WaitViewDelegate>

@property(nonatomic,assign)id<CommonCatalogDelegate>delegate;

@end
