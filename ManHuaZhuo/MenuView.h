//
//  MenuView.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@protocol RightViewDelegate<NSObject>

-(void)rightViewClick:(UITableView *)tableview indexPath:(NSIndexPath *)indexPath;

@end

#import <UIKit/UIKit.h>

@interface MenuView : UIView<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property(nonatomic,assign)id<RightViewDelegate>delegate;


-(BOOL)isShowRightView;

-(void)showCurrentRightView:(NSArray *)titlelist celllist:(NSArray *)celllist selectedIndex:(NSInteger)_selectedIndex selectedBarIndex:(NSUInteger)selectedBarIndex;
-(void)hideCurrentRightView;
@end
