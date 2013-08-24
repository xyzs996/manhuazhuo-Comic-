//
//  UINavigationBar+BackgroundImage.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UINavigationBar+BackgroundImage.h"
#import "AppDelegate.h"

@implementation UINavigationBar (BackgroundImage)

-(void)drawRect:(CGRect)rect
{
    UIImage *img=((AppDelegate *)[[UIApplication sharedApplication]delegate]).navBarBgImg;
//    UIImage *img=[UIImage imageNamed:@"nav_bg_ios4.png"];
    if(img!=nil)
    {
        [img drawInRect:CGRectMake(0, 0, self.frame.size.width, 44)];
    }
    else {
//         [self setBarStyle:UIBarStyleBlackTranslucent];
//        [super drawRect:rect];
       
    }
}

@end
