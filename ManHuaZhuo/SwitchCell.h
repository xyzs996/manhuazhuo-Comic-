//
//  SwitchCell.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@class SwitchCell;

@protocol switchCellDelegate <NSObject>

-(void)switchCell:(SwitchCell *) state:(NSNumber *)number;

@end
#import <UIKit/UIKit.h>

@interface SwitchCell : UITableViewCell

@property(nonatomic,retain)UISwitch *switchView;
@property(nonatomic,assign)id<switchCellDelegate>delegate;
@end
