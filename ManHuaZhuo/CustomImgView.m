//
//  CustomImgView.m
//  OritationTest
//
//  Created by 89 李成武 on 11-1-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomImgView.h"

@interface CustomImgView ()
{
    BOOL isDownloading;
}

@property(nonatomic,retain)UIActivityIndicatorView *actView;
@property(nonatomic,retain)DDProgressView *proView;
@property(nonatomic,retain)ASIHTTPRequest *request;

@end

@implementation CustomImgView

@synthesize request;
@synthesize proView;
@synthesize actView;
@synthesize imgView;
@synthesize imgScrollView;

-(BOOL)isDownloading
{
    return  isDownloading;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [imgScrollView setMaximumZoomScale:3.0];
        [imgScrollView setDelegate:self];
        [self addSubview:imgScrollView];
        
        imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgScrollView.frame.size.width, imgScrollView.frame.size.height)];
        [imgScrollView addSubview:imgView];
        
        
        proView=[[DDProgressView alloc] initWithFrame:CGRectMake(20, (frame.size.height-30)/2, frame.size.width-40, 30)];
        [proView setHidden:YES];
        [imgView addSubview:proView];
    }
    return self;
}

-(void)dealloc
{
    [self.request clearDelegatesAndCancel];
    self.request=nil;
    self.proView=nil;
    self.imgView=nil;
    self.imgScrollView=nil;
    self.actView=nil;
    [super dealloc];
}

-(void)startDownImageByURL:(NSString *)picURL andPictureReferer:(NSString *)pictureReferer
{
    [proView setHidden:NO];
    request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:picURL]];
    [request setRequestHeaders:[NSMutableDictionary dictionaryWithObject:pictureReferer forKey:@"Referer"]];
    [request setDelegate:self];
    [request setDownloadProgressDelegate:proView];
    [request startAsynchronous];
    isDownloading=YES;
}

#pragma UIScrollView Delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imgView;
}

#pragma mark asi delegate
-(void)requestFinished:(ASIHTTPRequest *)_request
{
    [proView removeFromSuperview];
    [self.imgView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageWithData:_request.responseData] waitUntilDone:YES];
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    isDownloading=NO;
}
@end
