//
//  DownloadCell.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadCell : UITableViewCell

@property(nonatomic,retain)UILabel *lblName;
@property(nonatomic,retain)UIProgressView *proView;
@property(nonatomic,retain)UIImageView *stateImgView;
@property(nonatomic,retain)UILabel *lblState;
@property(nonatomic,retain)UILabel *lblProgress;

-(void)updateCellState:(NSNumber *)sectionState;
-(void)recoverFrame;
@end
