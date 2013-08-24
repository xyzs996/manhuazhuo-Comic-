//
//  ErrorModel.h
//  LBShopMall
//
//  Created by 国翔 韩 on 13-4-2.
//  Copyright (c) 2013年 联龙博通在线服务中心.李成武. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorModel : NSObject


@property(nonatomic,retain)NSString *errorMsg;


-(id)initWithErrorCode:(NSString *)errorCode;
-(id)initWithHttpError:(NSString *)httpErrorCode;
@end
