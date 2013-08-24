


#import <Foundation/Foundation.h>
#import "WeiboCommon.h"
#import "WeiboCommonAPI.h"



@interface WeiboWrapper : NSObject

//-----------
+ (BOOL)publishMessage:(NSString *)content andController:(UIViewController*)controller andUserData:(NSInteger)userData;
+ (BOOL)publishMessage:(NSString *)content andWeiboId:(NSInteger)weiboId andController:(UIViewController *)controller andUserData:(NSInteger)userData;
+ (BOOL)publishMessage:(NSString *)content andFilePath:(NSString *)imagePath andController:(UIViewController*)controller andUserData:(NSInteger)userData;
+ (BOOL)publishMessage:(NSString *)content andImagePath:(NSString*)imgPath andWeiboId:(NSInteger)weiboId andController:(UIViewController *)controller andUserData:(NSInteger)userData;
+ (void)navigateToWeiboSettingController:(UINavigationController *)nav;
@end
