//
//  PictureDAL.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureDAL : NSObject

+(PictureDAL *)sharedInstance;

-(NSString *)getPicNameByPictureURL:(NSString *)picURL andIndex:(int)index;
-(NSString *)getPicturelistURLBySectionID:(NSString *)sectionID;
-(NSMutableArray *)parsePicturelist:(id)resultData;

@end
