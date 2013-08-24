//
//  BookCell.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookCell : UITableViewCell

@property(nonatomic,retain)UILabel *lblName;
@property(nonatomic,retain)UILabel *lblIntro;
@property(nonatomic,retain)UILabel *lblAttri;
@property(nonatomic,retain)UIImageView *iconImgView;
@property(nonatomic,retain)UIImageView *stateImgView;

@end
