//
//  CustomSegmentController.h
//  -巴士商店-
//
//  Created by TGBUS on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@protocol TypeClickDelegate <NSObject>

@optional
-(void)TypeClick:(NSNumber *)index;

@end
#import <UIKit/UIKit.h>

#define k_seg_button_small 64
#define k_seg_button_middle 80

@interface CustomSegmentController : UIView
{
    int count;//选项卡的个数
    UIImageView *selectedImg;
    int startX;
    CGFloat btnWidth;//每个button的宽度
    CGFloat hotWidth;//中间图片的滑动最大宽度
}

-(id)initWithLabels:(NSArray *)labels buttonWidth:(CGFloat)buttonWidth;

-(void)setIndex:(int)_index;

@property(nonatomic,retain)UIImageView *selectedImg;
@property(nonatomic,assign)id<TypeClickDelegate> typeClickDelegate;

@end
