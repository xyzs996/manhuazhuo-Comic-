//
//  SectionlistViewController.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"
#import "SectionDownloadManager.h"
#import "BaseViewController.h"

@interface SectionlistViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

-(id)initWithBookModel:(BookModel *)bookModel;

@end
