//
//  CatalogDAL.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatalogDAL : NSObject

+(CatalogDAL *)sharedInstance;

-(NSString *)getAllCatalogURL;
-(NSMutableArray *)parseCatalogs:(id)result;

@end
