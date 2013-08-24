//
//  LoginViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "URLUtility.h"
#import "CommonHelper.h"
#import "UserModel.h"
#import "JSON.h"
#import "UserResultModel.h"
#import "UserDAL.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"

#define kButtonRegisterTag 500
#define kButtonLoginTag 501

#define kRequestLoginTag 600

@interface LoginViewController ()

@property(nonatomic,retain)UITextField *txtName;
@property(nonatomic,retain)UITextField *txtPwd;

-(void)dismissSelf;
-(void)buttonAction:(id)sender;
-(void)loginAction;
-(void)forgetPassword;
@end

@implementation LoginViewController

@synthesize txtPwd;
@synthesize txtName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dismissSelf
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)forgetPassword
{
    ForgetPasswordViewController *forgetVController=[[ForgetPasswordViewController alloc] init];
    [self .navigationController pushViewController:forgetVController animated:YES];
    [forgetVController release];
}

-(void)buttonAction:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    switch (btn.tag) {
        case kButtonLoginTag://登陆
        {
            if([txtName.text length]==0)
            {
                [CommonHelper showAlert:nil msg:@"请输入账号邮箱"];
                return;
            }
            [self loginAction];
            [txtName resignFirstResponder];
        }
            break;
        case kButtonRegisterTag://注册
        {
            RegisterViewController *registerVController=[[RegisterViewController alloc] init];
            [self.navigationController pushViewController:registerVController animated:YES];
            [registerVController release];
        }
        default:
            break;
    }
}

-(void)loginAction
{
    [[DownloadHelper sharedInstance] cancelRequestForTag:kRequestLoginTag delegate:self];
    NSString *loginURL=[[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjectsAndKeys:@"login",@"method",txtName.text,@"email",txtPwd.text,@"pwd",nil]];
    [[DownloadHelper sharedInstance] startRequest:loginURL delegate:self tag:kRequestLoginTag userInfo:nil];
}

-(void)loadView
{
    [super loadView];
    //取消
    UIButton *btnComment=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnComment setFrame:CGRectMake(0, 7, 50, 30)];
    [btnComment.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [btnComment setBackgroundImage:[UIImage imageNamed:@"nav_normal.png"] forState:UIControlStateNormal];
    [btnComment addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [btnComment setTitle:@"取消" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btnComment] autorelease];
    
//    //忘记密码
//    UIButton *btnForget=[UIButton buttonWithType:UIButtonTypeCustom];
//    [btnForget setFrame:CGRectMake(0, 7, 60, 30)];
//    [btnForget.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
//    [btnForget setBackgroundImage:[UIImage imageNamed:@"nav_normal.png"] forState:UIControlStateNormal];
//    [btnForget addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
//    [btnForget setTitle:@"忘记密码" forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btnForget] autorelease];
    
    
    //用户名
    UILabel *lblName=[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, 30, 60, 25)];
    [lblName setFont:[UIFont boldSystemFontOfSize:16]];
    [lblName setText:@"用户名:"];
    [lblName setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:lblName];
    [lblName release];
    
    txtName=[[UITextField alloc] initWithFrame:CGRectMake(lblName.frame.origin.x+lblName.frame.size.width+10, lblName.frame.origin.y, 220, 27)];
    [txtName setBorderStyle:UITextBorderStyleRoundedRect];
    [txtName setPlaceholder:@"邮箱"];
    txtName.returnKeyType=UIReturnKeyDone;
    txtName.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtName.delegate=self;
    [self.view addSubview:txtName];
    
    //密码
    UILabel *lblPwd=[[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+lblName.frame.size.height+22, 60, 25)];
    [lblPwd setFont:[UIFont boldSystemFontOfSize:16]];
    [lblPwd setText:@"密 码:"];
    [lblPwd setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:lblPwd];
    [lblPwd release];
    
    txtPwd=[[UITextField alloc] initWithFrame:CGRectMake(lblPwd.frame.origin.x+lblPwd.frame.size.width+10, lblPwd.frame.origin.y, 220, 27)];
    [txtPwd setBorderStyle:UITextBorderStyleRoundedRect];
    [txtPwd setPlaceholder:@"密码"];
    txtPwd.secureTextEntry=YES;
    txtPwd.returnKeyType=UIReturnKeyDone;
    txtPwd.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtPwd.delegate=self;
    [self.view addSubview:txtPwd];
    
    
    UIButton *btnRegister=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRegister setTag:kButtonRegisterTag];
    [btnRegister setTitle:@"注  册" forState:UIControlStateNormal];
    [btnRegister.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [btnRegister setFrame:CGRectMake(lblPwd.frame.origin.x, lblPwd.frame.origin.y+lblPwd.frame.size.height+30, 135,40)];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_share.png"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_share_pressed.png"] forState:UIControlStateHighlighted];
    [btnRegister addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRegister];
    
    
    UIButton *btnLogin=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogin setTag:kButtonLoginTag];
    [btnLogin setTitle:@"登  陆" forState:UIControlStateNormal];
    [btnLogin.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [btnLogin setFrame:CGRectMake(btnRegister.frame.origin.x+btnRegister.frame.size.width+30, btnRegister.frame.origin.y, 135, 40)];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_sectiion.png"] forState:UIControlStateNormal];
    [btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_sectiion_press.png"] forState:UIControlStateHighlighted];
    [btnLogin addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    //导航栏
    if([[[UIDevice currentDevice] systemVersion] intValue]>=5)
    {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title=@"登陆";
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[DownloadHelper sharedInstance] cancelReqeustForDelegate:self];
}

-(void)releaseData
{
    self.txtPwd=nil;
    self.txtName=nil;
}

-(void)dealloc
{
    [self releaseData];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtName resignFirstResponder];
    [txtPwd resignFirstResponder];
}

#pragma mark textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma downloadHelper Delegate
-(void)DownloadFinished:(id)data downloadType:(NSNumber *)downloadType
{
    switch ([downloadType intValue]) {
        case kRequestLoginTag:
        {
            id resultData=[[data objectForKey:@"Data"] JSONValue];
            UserResultModel *userResult=[[UserDAL sharedInstance] parseUserByData:resultData];
            switch ([userResult.userResult intValue]) {
                case EmailNotExist:
                {
                    [CommonHelper showAlert:nil msg:@"账号不存在"];
                }
                    break;
                case Failed:
                {
                    [CommonHelper showAlert:nil msg:@"登陆失败"];
                }
                    break;
                case Success:
                {
                    [CommonHelper showAlert:nil msg:@"登陆成功"];
                    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
                    appDelegate.userSession=userResult.userInfo;
                    [self dismissSelf];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}
@end
