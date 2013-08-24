

#import "WeiboPublishViewController.h"
#import "AppDelegate.h"
#import "RegexKitLite.h"

@interface WeiboPublishViewController()
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
- (void)showInputVerifyView;
- (void)switchToAutorizeMode;
- (void)switchToPublishMode;
- (void)showOauthTokenError;
@end


@implementation WeiboPublishViewController
@synthesize textViewContent;
@synthesize imageViewPicture;
@synthesize tableViewWeiboInfo;
@synthesize barButtonItemSend;
@synthesize viewInputVerify;
@synthesize textFieldVerify;
@synthesize imageViewInputBg;
@synthesize weiboId, weiboApi, numerousPublish;
@synthesize webView, navigationBar;
@synthesize stringOauthToken, stringOauthTokenSecret;
@synthesize stringContent, stringFilePath, userData;
@synthesize arrayWeiboInfo;


- (void)dealloc {
    
    self.weiboApi.delegate = nil;

    [navigationBar release];
    [webView release];
    
    [stringOauthToken release];
    [stringOauthTokenSecret release];
    
    [stringContent release];
    [stringFilePath release];
    
    [viewInputVerify release];
    [textFieldVerify release];
    [textViewContent release];
    [barButtonItemSend release];
    [tableViewWeiboInfo release];
    
    [arrayWeiboInfo release];
    
    [imageViewPicture release];
    [imageViewInputBg release];
    [super dealloc];
}

-(BOOL)isAuthorized{
    return [WeiboCommon checkHasBindingById:weiboId];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
    {
        [webView setFrame:CGRectMake(0, 44, 768, 960)];
    }
    
    
    // Do any additional setup after loading the view from its nib.
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.weiboApi = appDelegate.weiboApi;
    weiboApi.delegate = self;
    isVerifing = NO;
    
    if ([WeiboCommon checkHasBindingById:weiboId]) {
        self.arrayWeiboInfo = [WeiboCommon loadAuthorizedWeiboInfo];
        [self switchToPublishMode];
    }else{
        [self switchToAutorizeMode];
        [self showActivityIndicator];
        [weiboApi getOauthTokenWithWeiboId:weiboId];
    }
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [self setWebView:nil];
    [self setViewInputVerify:nil];
    [self setTextFieldVerify:nil];
    [self setTextViewContent:nil];
    [self setBarButtonItemSend:nil];
    [self setTableViewWeiboInfo:nil];
    [self setImageViewPicture:nil];
    [self setImageViewInputBg:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideActivityIndicator];
}

-(NSString*) valueForKey:(NSString *)key ofQuery:(NSString*)query
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	for(NSString *aPair in pairs){
		NSArray *keyAndValue = [aPair componentsSeparatedByString:@"="];
		if([keyAndValue count] != 2) continue;
		if([[keyAndValue objectAtIndex:0] isEqualToString:key]){
			return [keyAndValue objectAtIndex:1];
		}
	}
	return nil;
}

#pragma mark WeiboCommonAPIDelegate
/*
 当得到正确的oauthToken时，使用oauthToken来访问网页，请求用户输入用户名和密码
 */
- (void)getOauthTokenSuccess:(WeiboCommonAPI *)api andOauthToken:(NSString *)oauthToken andOauthTokenSecret:(NSString *)oauthTokenSecret
{
    [self hideActivityIndicator];
    self.stringOauthToken = oauthToken;
    self.stringOauthTokenSecret = oauthTokenSecret;
    NSString *baseUrl = nil;
    switch (weiboId) {
        case Weibo_Sina:
            baseUrl = @"http://api.t.sina.com.cn/oauth/authorize?oauth_token=";
            break;
        case Weibo_Tencent:
            baseUrl = @"http://open.t.qq.com/cgi-bin/authorize?oauth_token=";
            break;
        case Weibo_Netease:
            baseUrl = @"http://api.t.163.com/oauth/authorize?oauth_token=";
            break;
        case Weibo_Sohu:
            baseUrl = @"http://api.t.sohu.com/oauth/authorize?oauth_token=";
            break;
        default:
            break;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, oauthToken];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];	
}

- (void)getOauthTokenFailed:(WeiboCommonAPI *)api
{
    [self hideActivityIndicator];
    [self showOauthTokenError];
}

/*
 当获取到正确的AccessToken时，获取用户的信息，主要是用户昵称
 */
- (void)getaccesstokenSuccess:(WeiboCommonAPI *)api
{
    NSLog(@"getaccesstokenSuccess:(WeiboCommonAPI *)api");
    [weiboApi getUserInfoWithWeiboId:weiboId];
    isVerifing = NO;
}

- (void)getAccessTokenFailed:(WeiboCommonAPI *)api
{
    NSLog(@"getAccessTokenFailed:(WeiboCommonAPI *)api");
    [self showOauthTokenError];
    isVerifing = NO;
}

- (void)getUserInfoSuccess:(WeiboCommonAPI *)api andUserName:(NSString *)userName
{
    [self switchToPublishMode];
}

- (void)getUserInfoFailed:(WeiboCommonAPI *)api
{
    [self switchToPublishMode];
}

- (void)publishMessageFailed:(WeiboCommonAPI *)api
{
    NSLog(@"publishMessageFailed");
}

- (void)publishMessageSuccess:(WeiboCommonAPI *)api
{
    NSLog(@"publishMessageSuccess");
}

- (NSString *)getVeriferFromHtml:(NSString *)htmlStr
{
    NSString *mark = nil;
    
    switch (weiboId) {
        case Weibo_Sina:
            mark = @"<div class=\"getCodeWrap\"> 获取到的授权码：<span class=\"fb\">([0-9]*)</span>";
            break;
        case Weibo_Tencent:
            return nil;
            break;
        case Weibo_Sohu:
            mark = @"<li><span style=\"font-size:16px;font-weight:bold;color:red;\">([0-9]*)</span>";
            break;
        case Weibo_Netease:
            mark = @"<span class=\"pin\" id=\"verifier\">([0-9]*)</span>";
            break;
        default:
            return nil;
            break;
    }
    NSString *str = [htmlStr stringByMatching:mark capture:1];
    return str;
}


#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showActivityIndicator];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideActivityIndicator];
    if (!isVerifing) {
        NSString *htmlstr = [self.webView stringByEvaluatingJavaScriptFromString:
                             @"document.getElementsByTagName('html')[0].outerHTML"];
        NSLog(@"%@", htmlstr);
        NSString *verifier = [self getVeriferFromHtml:htmlstr];
        if (verifier) {
            self.textFieldVerify.text = verifier;
            [self buttonSubmitVerifyClicked:nil];
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	
	NSString *query = [[request URL] query];
    NSLog(@"%@", query);
//    NSRange rangeOfOauthtoken = [query rangeOfString:@"oauth_token"];
    if (query == nil ) {
        //[self showInputVerifyView];
    }
	NSString *verifier = [self valueForKey:@"oauth_verifier" ofQuery:query];
	if (verifier && ![verifier isEqualToString:@""]) {
        self.textFieldVerify.text = verifier;
        [self buttonSubmitVerifyClicked:nil];
    }
    return YES;
}

#pragma mark 其他界面函数
/*
 显示输入验证码的框
 */
- (void)showInputVerifyView
{
    self.viewInputVerify.frame = CGRectMake(0, 44, 320, 50);
    [self.view addSubview:self.viewInputVerify];
}
/*
 切换到授权模式
 */
- (void)switchToAutorizeMode
{
    NSString *title = nil;
    switch (weiboId) {
        case Weibo_Sina:
            title = @"添加新浪微博";
            break;
        case Weibo_Tencent:
            title = @"添加腾讯微博";
            break;
        case Weibo_Sohu:
            title = @"添加搜狐微博";
            break;
        case Weibo_Netease:
            title = @"添加网易微博";
            break;
        default:
            break;
    }
    self.navigationBar.topItem.title = title;
    self.textViewContent.hidden = YES;
    self.imageViewPicture.hidden = YES;
    self.tableViewWeiboInfo.hidden = YES;
    self.webView.hidden = NO;
    self.barButtonItemSend.enabled = NO;
}
/*
 当授权成功时，切换到发微博的模式
 */
- (void)switchToPublishMode
{
    self.textViewContent.hidden = NO;
    self.textViewContent.text = self.stringContent;
    self.imageViewInputBg.hidden = NO;
    self.webView.hidden = YES;
    self.viewInputVerify.hidden = YES;
    if (self.stringFilePath != nil) {
        self.imageViewPicture.hidden = NO;
        self.imageViewPicture.image = [UIImage imageWithContentsOfFile:self.stringFilePath];
        self.imageViewInputBg.frame = CGRectMake(77, 54, 238, 128);
        self.textViewContent.frame = CGRectMake(89, 66, 215, 98);
    }else {
        self.textViewContent.frame = CGRectMake(15, 66, 289, 98);
        self.imageViewInputBg.frame = CGRectMake(5, 54, 310, 128);
        self.imageViewPicture.hidden = YES;
    }
    if (numerousPublish) {
        self.navigationBar.topItem.title = @"分享到微博";
        self.tableViewWeiboInfo.hidden = NO;
    }else{
        self.navigationBar.topItem.title = [WeiboCommon getUserNameWithId:weiboId];
        self.tableViewWeiboInfo.hidden = YES;
    }
    
    self.barButtonItemSend.enabled = YES;
    [self.textViewContent becomeFirstResponder];
}

#pragma mark 公用函数
- (void)showActivityIndicator
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)hideActivityIndicator
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)showOauthTokenError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"增加失败，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
}


#pragma mark 按钮函数
- (IBAction)barButtonItemCloseClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)barButtonItemSendClicked:(id)sender 
{
    if ([self.textViewContent.text length] == 0) {
        return;
    }
    weiboApi.numerousPublish = numerousPublish;
    weiboApi.userData = self.userData;
    if (numerousPublish) {
        [weiboApi publishMessageWithContent:self.textViewContent.text andImagePath:self.stringFilePath];
    }else{
        if (self.stringFilePath) {
            [weiboApi publishMessageWithContent:self.textViewContent.text andBlogId:weiboId andImagePath:stringFilePath];
        }else {
            [weiboApi publishMessageWithContent:self.textViewContent.text andBlogId:weiboId];
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)buttonSubmitVerifyClicked:(id)sender {
    if ([self.textFieldVerify.text length] == 0 && !isVerifing) {
        return;
    }
    isVerifing = YES;
    [textFieldVerify resignFirstResponder];
    [weiboApi getAccessTokenWithOauthToken:self.stringOauthToken andOauthTokenSecret:self.stringOauthTokenSecret andVerifier:self.textFieldVerify.text andBlogId:weiboId];
}

#pragma mark 微博信息列表
#pragma mark UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"已开启的微博";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayWeiboInfo count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableViewWeiboInfo dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier] autorelease];
    }
    
    NSDictionary *dict = [self.arrayWeiboInfo objectAtIndex:indexPath.row];
    NSString *title = [dict objectForKey:@"name"];
    NSInteger weiboid = [[dict objectForKey:@"weiboid"] intValue];
    NSString *imageName = nil;
    switch (weiboid) {
        case Weibo_Sina:
            imageName = @"icon_sina";
            break;
        case Weibo_Tencent:
            imageName = @"icon_qq";
            break;
        case Weibo_Netease:
            imageName = @"icon_163";
            break;
        case Weibo_Sohu:
            imageName = @"icon_sohu";
            break;
        default:
            break;
    }
    cell.textLabel.text = title;
    cell.imageView.image = [UIImage imageNamed:imageName];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.textViewContent resignFirstResponder];
}

@end





















