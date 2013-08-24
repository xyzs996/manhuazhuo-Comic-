//
//  UIViewController+GoBack.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+GoBack.h"
#import "SearchViewController.h"

@implementation UIViewController (GoBack)

-(void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)searchAction
{
    SearchViewController *searchVController=[[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVController animated:YES];
    [searchVController release];
}
@end
