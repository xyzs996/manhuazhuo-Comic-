//
//  HttpClient.m
//  LBShopMall
//
//  Created by 国翔 韩 on 13-4-2.
//  Copyright (c) 2013年 联龙博通在线服务中心.李成武. All rights reserved.
//

#import "HttpClient.h"
#import "ErrorModel.h"
#import "JSON.h"
#import "CommonHelper.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface HttpClient ()
{
    BOOL _isFinished;
}

@property(nonatomic,retain)ASIHTTPRequest *currentRequest;//全局的请求，用于取消请求

-(NSString *)requestFromUrl:(NSString *)url method:(NSString *)method error:(ErrorModel *)error;

@end

@implementation HttpClient

@synthesize currentRequest;
@synthesize error=_error;

-(NSString *)requestFromUrl:(NSString *)url method:(NSString *)method error:(ErrorModel *)error
{
    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"组合的url=%@",url);

    if([method isEqualToString:@"GET"])
    {
        self.currentRequest=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    }
    else {
        NSArray *urlist=[url componentsSeparatedByString:@"?"];
        NSString *paramsString=nil;
        if([urlist count]>1)
        {
            paramsString=[urlist objectAtIndex:1];
        }
        self.currentRequest=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlist objectAtIndex:0]]];
        
        NSMutableData *postData = [NSMutableData dataWithData:[paramsString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
        [currentRequest setPostBody:postData];
    }
//    [currentRequest addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
//    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d",[postData length]]];
//    [request addRequestHeader:@"Content-Type" value:[NSString stringWithFormat:@"%d",[postData length]]];
    
    
    [currentRequest setDelegate:self];
    [currentRequest setTimeOutSeconds:60.0f];
    [currentRequest setRequestMethod:method];
    [currentRequest startAsynchronous];
    while (!_isFinished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return currentRequest.responseString;
}

-(void)dealloc
{
    self.error=nil;
    [currentRequest clearDelegatesAndCancel];
    self.currentRequest=nil;
    [super dealloc];
}

-(void)cancelRequest
{
    [self.currentRequest clearDelegatesAndCancel];
    _isFinished=YES;
}

#pragma mark - private method

-(NSString *)getRequestFromUrl:(NSString *)url error:(ErrorModel *)error
{
    return [self requestFromUrl:url method:@"GET" error:error];
}

-(NSString *)postRequestFromUrl:(NSString *)url error:(ErrorModel *)error
{
    return [self requestFromUrl:url method:@"POST" error:error];
}

#pragma mark - asirequest delegate
-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    _isFinished=YES;
}

-(void)requestFailed:(ASIHTTPRequest *)request
{

    //处理网络错误
    if(self.currentRequest.error.code == 1){
//        [Utils alertWithTitle:@"提示" message:@"网络连接失败"];
    }
    self.error=[[[ErrorModel alloc] initWithHttpError:[NSString stringWithFormat:@"%d",request.error.code]] autorelease];
    
    [CommonHelper showMessage:@"请检查您的网络" inView:APPDELEGATE.window];
    _isFinished=YES;
}
@end
