//
//  LocalBookViewController.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalBookViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

-(id)initWithGroupName:(NSString *)groupName;

@end
