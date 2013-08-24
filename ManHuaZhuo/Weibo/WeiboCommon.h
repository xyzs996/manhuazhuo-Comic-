

#import <Foundation/Foundation.h>

enum WeiboId{
    Weibo_Sina = 1,
    Weibo_Tencent = 2,
    Weibo_Netease = 4,
    Weibo_Sohu = 8,
    Weibo_Max
};

#define PublishMessageResultNotification          @"PublishMessageResultNotification"
#define PublishMessageBeginNotification           @"PublishMessageBeginNotification"
#define RefreshDataWhenUidNotNullNotification     @"RefreshDataWhenUidNotNullNotification"


#define KEY_NETEASE @"hkwT3cny44Y9CORX"
#define SECRETKEY_NETEASE  @"yttuzccCKP8PCMWJcW6KUASNQrmCbQyd"
#define KEY_SOHU    @"gDhLNXV6cYvltQyOc5PT"
#define SECRETKEY_SOHU   @"gSMLf1%q)20DKDOlbhMRG4qFykf1cfCn(XWfOGm^"
#define KEY_TENCENT	@"801249594"
#define SECRETKEY_TENCENT	@"1ff17e98632522c1abeec037f0e54da5"
#define KEY_SINA	@"4071235295"
#define SECRETKEY_SINA	@"724aa142736931d2580ccc942ef51e34"

@interface WeiboCommon : NSObject {
    
}
/*
 根据blogid来保存字典信息
 */
+ (void)saveWeiboInfo:(NSDictionary *)parars blogId:(NSUInteger)blogid;
/*
 保存blogid的username，以方便授权成功时获取个人信息和每次发微博时更新姓名
 */
+ (void)saveWeiboName:(NSString *)name blogId:(NSInteger)blogid;
/*
 删除bloid的信息
 */
+ (void)deleteWeiboInfo:(NSUInteger)blogid;
/*
 检查该微博是否已绑定
 */
+ (BOOL)checkHasBindingById:(NSUInteger)blogId;
/*
 得到微博的所有保存信息，包括oauth_key、oauth_secret、可能存在name
 */
+ (NSDictionary*)getBlogInfo:(NSInteger)blogId;
/*
 得到微博对应的姓名，如果存在，返回姓名。不存在返回oauth_key（因为后面有用姓名来判断是否已绑定的逻辑）
 */
+ (NSString *)getUserNameWithId:(NSInteger)blogId;
/*
 设置微博是否开启
 */
+ (void)setWeiboEnableWithWeiboId:(NSInteger)weiboId andStatus:(BOOL)isEnabled;
/*
 得到微博是否开启
 */
+ (BOOL)getWeiboEnabledWithWeiboId:(NSInteger)weiboId;
/*
 加载微博信息，该数组里保存的是字典，内容包括name 和 enable
 */
+ (NSArray*)loadWeiboInfo;
/*
 加载已绑定的微博信息，该数组内容是字典，包括name和weiboid
 */
+ (NSArray*)loadAuthorizedWeiboInfo;
/*
 发送消息
 */
//+ (BOOL)publishMessage:(NSString *)content;

@end

