

#import <Foundation/Foundation.h>
#import "MicroBlogOauth.h"
#import "MicroBlogOauthKey.h"
#import "MicroBlogRequest.h"
#import "WeiboCommon.h"

@class WeiboCommonAPI;
@protocol WeiboCommonAPIDelegate <NSObject>
@optional
- (void)getOauthTokenSuccess:(WeiboCommonAPI*)api andOauthToken:(NSString *)oauthToken andOauthTokenSecret:(NSString *)oauthTokenSecret;
- (void)getOauthTokenFailed:(WeiboCommonAPI*)api;
- (void)getAccessTokenFailed:(WeiboCommonAPI*)api;
- (void)getaccesstokenSuccess:(WeiboCommonAPI*)api;
- (void)getUserInfoSuccess:(WeiboCommonAPI*)api andUserName:(NSString *)userName;
- (void)getUserInfoFailed:(WeiboCommonAPI*)api;
- (void)publishMessageSuccess:(WeiboCommonAPI*)api;
- (void)publishMessageFailed:(WeiboCommonAPI*)api;
@end

@interface WeiboCommonAPI : NSObject
<NSURLConnectionDelegate>
{
    /*
     当前请求的标志
     */
    NSInteger currentRequestId;
    NSInteger currentWeiboId;

}

/*
 发送请求时的oauthKey，包括本地的key和accesstoken
 */
@property (nonatomic, retain) MicroBlogOauthKey *oauthKey;
/*
 与服务器连接的connection
 */
@property (nonatomic, retain) NSURLConnection *connectionWeibo;
/*
 数据的缓存
 */
@property (nonatomic, retain) NSMutableData *dataReceive;

/*
 当前正在请求的微博的ID
 */
@property (nonatomic, assign) NSInteger currentWeiboId;
/*
 Delegate
 */
@property (nonatomic, assign) id<WeiboCommonAPIDelegate> delegate;
/*
 发送的内容
 */
@property (nonatomic, retain) NSString *stringSendingContent;
@property (nonatomic, retain) NSString *stringFilePath;
//在发送网易微博时使用
@property (nonatomic, retain) NSString *stringImageUrl;
/*
 是否发送多个？
 */
@property (nonatomic, assign) BOOL numerousPublish;
/*
 用户的个人数据
 */
@property (nonatomic, assign) NSInteger userData;
/*
 根据weiboId初始化它的key信息，包括本地的key和accesstoken
 */
- (void)initAccessTokenWithBlogId:(enum WeiboId)weiboId;

/*
 获取oauth_token
 */
- (void)getOauthTokenWithWeiboId:(enum WeiboId)weiboId;
/*
 由OauthToken、OauthTokenSecret、Verify换取AccessToken和AccessTokenSecret
 */
- (void)getAccessTokenWithOauthToken:(NSString *)oauthToken andOauthTokenSecret:(NSString*)oauthTokenSecret andVerifier:(NSString*)verifier andBlogId:(enum WeiboId)weiboId;
/*
 获取用户信息
 */
- (void)getUserInfoWithWeiboId:(enum WeiboId)weiboId;
/*
 发送微博
 */
- (void)publishMessageWithContent:(NSString *)content andBlogId:(enum WeiboId)weiboId;
/*
 发送带图片的微博
 */
- (void)publishMessageWithContent:(NSString *)content andBlogId:(enum WeiboId)weiboId andImagePath:(NSString *)filePath;

/*
 向已绑定并打开的微博里发送微博
 */
- (BOOL)publishMessageWithContent:(NSString*)content andImagePath:(NSString *)imagePath;

//urlencode
- (NSString *)urlencode:(NSString *)str;
@end








































