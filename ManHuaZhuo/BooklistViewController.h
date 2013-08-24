//
//  BooklistViewController.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"
#import "CommonBooklistViewController.h"
#import "CustomSegmentController.h"
#import "CustomTabBarViewController.h"
#import "MenuView.h"

@interface BooklistViewController : UIViewController<CommonBooklistDelegate,TypeClickDelegate,RightViewDelegate>


-(id)initWithCatalog:(BookModel *)catalog;

@end
