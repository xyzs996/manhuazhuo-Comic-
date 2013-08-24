//
//  ResponseModel.h
//  LBShopMall
//
//  Created by 国翔 韩 on 13-3-25.
//  Copyright (c) 2013年 联龙博通在线服务中心.李成武. All rights reserved.
//
//  服务器返回数据模型

#import <Foundation/Foundation.h>

@class ErrorModel;
@interface ResponseModel : NSObject

@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain)NSString *response;
@property(nonatomic,retain)id resultInfo;
@property(nonatomic,retain)ErrorModel *error;

@end
