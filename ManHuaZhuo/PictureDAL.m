//
//  PictureDAL.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PictureDAL.h"
#import "URLUtility.h"
#import "PictureModel.h"
#import "MD5Helper.h"

static PictureDAL *instance;

@implementation PictureDAL

+(PictureDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[PictureDAL alloc] init];
    }
    return instance;
}


-(void)dealloc
{
    [instance release];
    [super dealloc];
}

-(NSString *)getPicNameByPictureURL:(NSString *)picURL andIndex:(int)index
{
    return [NSString stringWithFormat:@"%d--%@.%@",index,[MD5Helper md5Digest:picURL],picURL.lastPathComponent];
}

-(NSString *)getPicturelistURLBySectionID:(NSString *)sectionID
{
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:@"picturelist",@"method",sectionID,@"sectionid", nil];
    return [[URLUtility sharedInstance] getURLFromParams:params];
}

-(NSMutableArray *)parsePicturelist:(id)resultData
{
    NSMutableArray *piclist=nil;
    if([resultData isKindOfClass:[NSArray class]]&&[resultData count]!=0)
    {
        piclist=[[[NSMutableArray alloc] init] autorelease];
        for(id model in resultData)
        {
            if([model isKindOfClass:[NSDictionary class]])
            {
                PictureModel *picModel=[[PictureModel alloc] init];
                picModel.picID=[model objectForKey:@"PictureID"];
                picModel.picURL=[model objectForKey:@"PictureURL"];
                picModel.picReferURL=[model objectForKey :@"PictureRefererURL"];
                picModel.sectionID=[model objectForKey:@"SectionID"];
                [piclist addObject:picModel];
                [picModel release];
            }
        }
    }
    return piclist;
}


@end
