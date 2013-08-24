//
//  PictureViewController.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionModel.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "CustomImgView.h"
#import "DownloadHelper.h"
#import "ASIHTTPRequest.h"

@interface PictureViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,ASIHTTPRequestDelegate,MBProgressHUDDelegate,DownloadHelperDelegate>

-(id)initWithSection:(SectionModel*)section isLocalRequest:(BOOL)isLocalRequest;
@end
