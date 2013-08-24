//
//  HttpClient.h
//  LBShopMall
//
//  Created by 国翔 韩 on 13-4-2.
//  Copyright (c) 2013年 联龙博通在线服务中心.李成武. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ResponseModel.h"

@class ErrorModel;
@interface HttpClient : NSObject<ASIHTTPRequestDelegate>

@property(nonatomic,retain)ErrorModel *error;//记录请求网络错误和服务器返回的错误

-(NSString *)getRequestFromUrl:(NSString *)url error:(ErrorModel *)error;
-(NSString *)postRequestFromUrl:(NSString *)url error:(ErrorModel *)error;


-(void)cancelRequest;//取消当前HttpClient对象正在的请求

@end
