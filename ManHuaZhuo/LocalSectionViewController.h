//
//  LocalSectionViewController.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalSectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

-(id)initWithGroupName:(NSString *)groupName andBookName:(NSString *)bookName;

@end
