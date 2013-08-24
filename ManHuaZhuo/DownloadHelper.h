//
//  DownloadHelper.h
//  IphoneReader
//
//  Created by TGBUS on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@protocol DownloadHelperDelegate <NSObject>

@optional
-(void)DownloadFailed:(NSNumber *)errorCode downloadType:(NSNumber *)downloadType url:(NSString *)url;//返回url，便于重新请求
-(void)DownloadFinished:(id)data downloadType:(NSNumber *)downloadType;//新闻数据请求完成后的委托 data是个字典Data key是个id类型的返回的数据

@end

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

//asi请求userinfo的参数
#define DownloadData @"Data"下载完后，实际得到的数据
#define DownloadTag @"DownloadType"
#define DownloadDelegateKey @"DownloadDelegate"

@interface DownloadHelper : NSObject<ASIHTTPRequestDelegate>

@property(nonatomic,retain)NSOperationQueue *downlist;
+(DownloadHelper *)sharedInstance;

-(NSString *)createUrlForRequest:(NSDictionary *)params;
-(NSDictionary *)getDictionaryFromData:(NSData *)resultData;

-(void)startRequest:(NSString *)url delegate:(id<DownloadHelperDelegate>)delegate tag:(int)tag userInfo:(NSMutableDictionary *)userInfo;

-(void)cancelReqeustForDelegate:(id<DownloadHelperDelegate>)delegate;
-(void)cancelRequestForTag:(int)_tag delegate:(id<DownloadHelperDelegate>)delegate;
-(void)cancelAllRequest;

-(void)suspend:(BOOL)flag;
@end
