
#import "AppDelegate.h"
#import "WeiboCommon.h"

#define KeySinaWeibo    @"KeyUserDefaultSinaWeibo"
#define KeyTencentWeibo @"KeyUserDefaultTencentWeibo"
#define KeyNetEaseWeibo @"KeyUserDefaultNetEaseWeibo"
#define KeySouhuWeibo   @"KeyUserDefaultSouhuWeibo"

@interface WeiboCommon()
+ (NSDictionary*)getStaticDictionaryById:(NSUInteger)blogId;    
@end

#define FileName_Netease    @"NeteaseUser"
#define FileName_Tencent    @"TencentUser"
#define FileName_Sina       @"SinaUser"
#define FileName_Sohu       @"SohuUser"
static NSDictionary* staticNeteaseInfo;
static NSDictionary* staticSinaInfo;
static NSDictionary* staticTencentInfo;
static NSDictionary* staticSohuInfo;

@implementation WeiboCommon

+ (NSString *)getUserDefaultStringByWeiboId:(NSInteger)weiboId
{
    NSString *key = KeySinaWeibo;
    switch (weiboId) {
        case Weibo_Sina:
            key = KeySinaWeibo;
            break;
        case Weibo_Tencent:
            key = KeyTencentWeibo;
            break;
        case Weibo_Netease:
            key = KeyNetEaseWeibo;
            break;
        case Weibo_Sohu:
            key = KeySouhuWeibo;
            break;
        default:
            break;
    }
    return key;
}

+ (void)initialize
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if ([userdefault valueForKey:KeySinaWeibo] == nil) {
        for (int i=Weibo_Sina; i<Weibo_Max; i=i*2) {
            [userdefault setBool:YES forKey:[WeiboCommon getUserDefaultStringByWeiboId:i]];
        }
    }
}

+ (NSString *)getInfoFilePath:(NSUInteger)blogId
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = nil;
    NSString *infoFile=nil;
    switch (blogId) {
        case Weibo_Netease:
            fileName = FileName_Netease;
            break;
        case Weibo_Sina:
            fileName = FileName_Sina;
            break;
        case Weibo_Tencent:
            fileName = FileName_Tencent;
            break;
        case Weibo_Sohu:
            fileName = FileName_Sohu;
            break;
        default:
            break;
    }
    infoFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    return infoFile;
}

+ (void)saveWeiboInfo:(NSDictionary *)parars blogId:(NSUInteger)blogid
{
    NSString *infoFile = [WeiboCommon getInfoFilePath:blogid];
    [parars writeToFile:infoFile atomically:YES];
}

+ (void)saveWeiboName:(NSString *)name blogId:(NSInteger)blogid
{
    if (name == nil) {
        return;
    }
    NSDictionary *dict = [WeiboCommon getBlogInfo:blogid];
    if (dict == nil) {
        return;
    }
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionaryWithDictionary:dict];
    [dict2 setObject:name forKey:@"name"];
    [WeiboCommon saveWeiboInfo:dict2 blogId:blogid];
}

+ (void)deleteWeiboInfo:(NSUInteger)blogid
{
    NSString *infoFile = [WeiboCommon getInfoFilePath:blogid];
    [[NSFileManager defaultManager] removeItemAtPath:infoFile error:nil];
}

+ (NSDictionary*)getStaticDictionaryById:(NSUInteger)blogId
{
    switch (blogId) {
        case Weibo_Netease:
            return staticNeteaseInfo;
            break;
        case Weibo_Tencent:
            return staticTencentInfo;
            break;
        case Weibo_Sina:
            return staticSinaInfo;
            break;
        case Weibo_Sohu:
            return staticSohuInfo;
            break;
        default:
            break;
    }
    return nil;
}

+ (BOOL)checkHasBindingById:(NSUInteger)blogId
{
    NSString *infoFile = [WeiboCommon getInfoFilePath:blogId];
    if ([[NSFileManager defaultManager] fileExistsAtPath:infoFile] == NO) {
        return NO;
    }
    return YES;
}

+ (NSDictionary*)getBlogInfo:(NSInteger)blogId
{
    NSDictionary *dict;
    
    NSString *infoFile = [WeiboCommon getInfoFilePath:blogId];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:infoFile] == NO) {
        return nil;
    }
    dict = [NSDictionary dictionaryWithContentsOfFile:infoFile];
    return dict;
}

+ (NSString *)getUserNameWithId:(NSInteger)blogId
{
    NSString *name = nil;
    NSDictionary *param = [WeiboCommon getBlogInfo:blogId];
    if (param != nil) {
        name = [param objectForKey:@"name"];
        if (name == nil) {
            name = [param objectForKey:@"oauth_key"];
        }
    }
    return name;
}

+ (BOOL)getWeiboEnabledWithWeiboId:(NSInteger)weiboId
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:[WeiboCommon getUserDefaultStringByWeiboId:weiboId]];
}

+ (void)setWeiboEnableWithWeiboId:(NSInteger)weiboId andStatus:(BOOL)isEnabled
{
    [[NSUserDefaults standardUserDefaults] setBool:isEnabled forKey:[WeiboCommon getUserDefaultStringByWeiboId:weiboId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray*)loadWeiboInfo
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    for (int i=Weibo_Sina; i<Weibo_Max; i=i<<1) {
        NSString *name = [WeiboCommon getUserNameWithId:i];
        NSObject *nameValue = name;
        if (name == nil) {
            nameValue = [NSNull null];
        }
        BOOL isEnabled = [WeiboCommon getWeiboEnabledWithWeiboId:i];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:nameValue, @"name",[NSNumber numberWithBool:isEnabled], @"enable", [NSNumber numberWithInt:i], @"weiboid", nil];
        [array addObject:dict];
    }
    return array;
}

+ (NSArray*)loadAuthorizedWeiboInfo
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    for (int i=Weibo_Sina; i<Weibo_Max; i=i<<1) {
        NSString *name = [WeiboCommon getUserNameWithId:i];
        NSObject *nameValue = name;
        if (name != nil) {
            //nameValue = [NSNull null];
            BOOL isEnabled = [WeiboCommon getWeiboEnabledWithWeiboId:i];
            if (isEnabled) {
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:nameValue, @"name", [NSNumber numberWithInt:i], @"weiboid", nil];
                [array addObject:dict];
            }
        }
    }
    return array;
}

/*
+ (BOOL)publishMessage:(NSString *)content
{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return [delegate.weiboApi publishMessageWithContent:content];
}*/
@end


















