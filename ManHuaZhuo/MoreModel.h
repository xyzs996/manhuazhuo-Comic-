//
//  MoreModel.h
//  Jewelry
//
//  Created by 国翔 韩 on 13-4-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//  更多视图里的每行对象


#import <Foundation/Foundation.h>

typedef enum{
    MoreLoginType=0,
    MoreNotifyType=1,
    MoreRecommandAppType=2,
    MoreVersionType=3,
    MoreClearType=4
} MoreType;

@interface MoreModel : NSObject

@property(nonatomic,retain)NSString *name;//名字
@property(nonatomic,retain)UIImage *img;//左侧的图片
@property(nonatomic,retain)NSString *url;//连接的地址
@property(nonatomic,assign)MoreType type;//种类

@end
