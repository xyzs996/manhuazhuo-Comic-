//
//  BookModel.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-10-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject

@property(nonatomic,retain)NSString *bookID;
@property(nonatomic,retain)NSString *bookName;
@property(nonatomic,retain)NSString *bookIntro;
@property(nonatomic,retain)NSString *bookIconURL;
@property(nonatomic,retain)NSString *author;
@property(nonatomic,retain)NSString *creationDate;
@property(nonatomic,retain)NSString *bookState;
@property(nonatomic,retain)UIImage *bookStateImg;
@property(nonatomic,retain)NSString *bookLatter;
@property(nonatomic,retain)NSString *updateDate;
@property(nonatomic,retain)NSString *clickCount;
@property(nonatomic,retain)NSString *bookStateName;
@property(nonatomic,retain)NSString *catalogName;
@property(nonatomic,retain)NSMutableDictionary *sectionlist;
@property(nonatomic)int commentCount;
@end
