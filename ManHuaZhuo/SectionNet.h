//
//  SectionNet.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 13-4-19.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BookModel;

@interface SectionNet : NSObject

+(id)startDownloadSectionlist:(BookModel *)curBook;
+(void)cancelDownloadSectionlist;

@end
