//
//  SearchViewController.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarViewController.h"
#import "DownloadHelper.h"

@interface SearchViewController : UIViewController<UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,RightViewDelegate,DownloadHelperDelegate>

@end
