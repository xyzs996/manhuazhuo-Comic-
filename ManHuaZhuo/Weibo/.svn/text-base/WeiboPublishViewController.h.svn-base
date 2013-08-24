
#import <UIKit/UIKit.h>
#include "WeiboCommon.h"
#include "WeiboCommonAPI.h"

@interface WeiboPublishViewController : UIViewController
<WeiboCommonAPIDelegate, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL isVerifing;//是否正在进行验证码确认，避免重复确认
}
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (retain, nonatomic) IBOutlet UITextView *textViewContent;
@property (retain, nonatomic) IBOutlet UIImageView *imageViewPicture;
@property (retain, nonatomic) IBOutlet UITableView *tableViewWeiboInfo;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *barButtonItemSend;


@property (nonatomic, retain) NSArray *arrayWeiboInfo;

@property (nonatomic, assign) BOOL numerousPublish;
@property (nonatomic, assign) NSInteger weiboId;
@property (nonatomic, assign) WeiboCommonAPI *weiboApi;

/*
 存放授权时得到的OauthToken和OauthTokenSecret
 */
@property (nonatomic, retain) NSString *stringOauthToken;
@property (nonatomic, retain) NSString *stringOauthTokenSecret;
/*
 要发送的内容
 */
@property (nonatomic, retain) NSString *stringContent;
@property (nonatomic, retain) NSString *stringFilePath;
@property (nonatomic, assign) NSInteger userData;

@property (retain, nonatomic) IBOutlet UIView *viewInputVerify;
@property (retain, nonatomic) IBOutlet UITextField *textFieldVerify;
@property (retain, nonatomic) IBOutlet UIImageView *imageViewInputBg;

- (IBAction)barButtonItemCloseClicked:(id)sender;
- (IBAction)barButtonItemSendClicked:(id)sender;
- (IBAction)buttonSubmitVerifyClicked:(id)sender;


@end
