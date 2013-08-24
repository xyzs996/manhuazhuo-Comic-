//
//  PictureModel.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureModel : NSObject<NSCoding,NSCopying>

@property(nonatomic,retain)NSString *picID;
@property(nonatomic,retain)NSString *picURL;;
@property(nonatomic,retain)NSString *picReferURL;
@property(nonatomic,retain)NSString *sectionID;

@end
