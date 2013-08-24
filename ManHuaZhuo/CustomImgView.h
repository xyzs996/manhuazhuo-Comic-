//
//  CustomImgView.h
//  OritationTest
//
//  Created by 89 李成武 on 11-1-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "DDProgressView.h"

@interface CustomImgView : UIView<UIScrollViewDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate>

@property(nonatomic,retain)UIImageView *imgView;
@property(nonatomic,retain)UIScrollView *imgScrollView;

-(void)startDownImageByURL:(NSString*)picURL andPictureReferer:(NSString *)pictureReferer;
-(BOOL)isDownloading;
@end
