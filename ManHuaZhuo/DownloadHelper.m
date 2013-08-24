//
//  DownloadHelper.m
//  IphoneReader
//
//  Created by TGBUS on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DownloadHelper.h"
#import "JSON.h"

static DownloadHelper *instance;

@implementation DownloadHelper

@synthesize downlist;

-(void)dealloc
{
    self.downlist=nil;
    [instance release];
    [super dealloc];
}

+(DownloadHelper *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[DownloadHelper alloc] init];
    }
    return instance;
}

-(void)suspend:(BOOL)flag
{
    [downlist setSuspended:flag];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:flag];
}

-(NSString *)createUrlForRequest:(NSDictionary *)params
{
    NSString *baseUrl=@"";
    for(NSString *key in [params allKeys])
    {
        baseUrl=[baseUrl stringByAppendingFormat:@"%@=%@&",key,[params objectForKey:key]];
    }
    baseUrl=[baseUrl substringToIndex:[baseUrl length]-1];
    return baseUrl;
}

//把网络请求回来的二进制格式成json字典
-(NSDictionary *)getDictionaryFromData:(NSData *)resultData
{
    NSString *resultString=[[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    NSDictionary *resultDict=[resultString JSONValue];
//    NSLog(@"~~~~~~~~!!!~~~~~~");
//    NSDictionary *resultDict=[resultData objectFromJSONData];
    [resultString release];
    return resultDict;
}

-(void)startRequest:(NSString *)url delegate:(id<DownloadHelperDelegate>)delegate tag:(int)tag userInfo:(NSMutableDictionary *)userInfo
{
    url=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if(downlist==nil)
    {
        downlist=[[NSOperationQueue alloc] init];
        [downlist setMaxConcurrentOperationCount:2];
    }
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setShouldRedirect:YES];
    [request setDelegate:self];
    [request setTimeOutSeconds:90.0f];
    NSLog(@"请求的数据请求=%@",request.url);
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    if(userInfo!=nil)
    {
        for(NSString *key in [userInfo allKeys])
        {
            [dict setObject:[userInfo objectForKey:key] forKey:key];
        }
    }
    [dict setObject:[NSNumber numberWithInt:tag] forKey:DownloadTag];
    if(delegate!=nil)
    {
        [dict setObject:delegate forKey:DownloadDelegateKey];
    }
    [request setUserInfo:dict];
    [dict release];
    [downlist addOperation:request];
    [request release];
}

#pragma ASI请求委托

-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
//    NSLog(@"responseHeaders=%@",responseHeaders);
}
//重定向
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"DownloadHelper下载错误:%@",request.error);
    if(request.error.code==2)//超时，重定向
    {
        [request redirectToURL:request.url];
        
    }
    NSDictionary *dict=[request userInfo];
    id<DownloadHelperDelegate> tmpDelegate=[dict objectForKey:DownloadDelegateKey];
    if([tmpDelegate respondsToSelector:@selector(DownloadFailed:downloadType:url:)])
    {
        [tmpDelegate DownloadFailed:[NSNumber numberWithInt:request.error.code] downloadType:[dict objectForKey:DownloadTag] url:[request.url description]];
    }
    [request clearDelegatesAndCancel];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    //返回数据为nil
    if(request.responseData==nil)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"网络异常" message:@"请检查您的网络连接是否正常!" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
//    NSLog(@"%d==》%@",[request.responseData length],[[[NSString alloc] initWithData:request.responseData encoding:request.responseEncoding] autorelease]);
    NSString *resultDict=[[[NSString alloc] initWithData:request.responseData encoding:request.responseEncoding] autorelease];
    NSDictionary *dict=[request userInfo];
    id<DownloadHelperDelegate> tmpDelegate=[dict objectForKey:DownloadDelegateKey];
    if([tmpDelegate respondsToSelector:@selector(DownloadFinished:downloadType:)])
    {
        NSMutableDictionary *paramsDict=[[NSMutableDictionary alloc] init];
        if(resultDict!=nil)
        {
            [paramsDict setObject:resultDict forKey:@"Data"];
        }
        for(NSString *key in [dict allKeys])
        {
            [paramsDict setObject:[dict objectForKey:key] forKey:key];
        }
//        [tmpDelegate performSelector:@selector(DownloadFinished:downloadType:) withObject:[dict objectForKey:DownloadTag]];
        [tmpDelegate DownloadFinished:paramsDict downloadType:[dict objectForKey:DownloadTag]];
        [paramsDict release];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)cancelReqeustForDelegate:(id<DownloadHelperDelegate>)delegate
{
    for(ASIHTTPRequest *request in downlist.operations)
    {
         id<DownloadHelperDelegate> tmpDelegate=[request.userInfo objectForKey:DownloadDelegateKey];
        if(tmpDelegate==delegate)
        {
            [request clearDelegatesAndCancel];
        }
    }
}



-(void)cancelRequestForTag:(int)_tag delegate:(id<DownloadHelperDelegate>)delegate
{
    for(ASIHTTPRequest *request in [self.downlist operations])
    {
        id<DownloadHelperDelegate> tmpDelegate=[request.userInfo objectForKey:DownloadDelegateKey];
        if(tmpDelegate==delegate)
        {
            NSNumber *tag=[request.userInfo objectForKey:DownloadTag];
            if([tag intValue]==_tag)
            {
                [request clearDelegatesAndCancel];
                break;
            }
        }
    }
}

-(void)cancelAllRequest
{
    for(ASIHTTPRequest *request in downlist.operations)
    {
        [request clearDelegatesAndCancel];
    }
    [downlist cancelAllOperations];
}

@end
