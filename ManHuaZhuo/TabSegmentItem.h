//
//  TabSegmentItem.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabSegmentItem : UIView

@property(nonatomic,retain)UILabel *lblTitle;
@property(nonatomic,retain)NSString *identity;

- (id)initWithFrame:(CGRect)frame withIdentity:(NSString *)identity;

@end
