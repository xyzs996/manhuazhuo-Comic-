//
//  RegisterViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "URLUtility.h"
#import "CommonHelper.h"
#import "JSON.h"
#import "UserResultModel.h"
#import "UserDAL.h"
#import "UserModel.h"
#import "AppDelegate.h"
#import "TPKeyboardAvoidingScrollView.h"

#define kRequestRegisterTag 500

@interface RegisterViewController ()

@property(nonatomic,retain)TPKeyboardAvoidingScrollView *movingView;
@property(nonatomic,retain)UITextField *txtName;
@property(nonatomic,retain)UITextField *txtPwd;
@property(nonatomic,retain)UITextField *txtPwdAgain;
@property(nonatomic,retain)UITextField *txtNick;
@property(nonatomic,retain)UITextField *txtQuestion;
@property(nonatomic,retain)UITextField *txtAnswere;
@property(nonatomic,retain)UIButton *btnRegister;

-(void)keyboardWillApear:(NSNotification *)noti;
-(void)keyboardWillDisAppear:(NSNotification *)notif;
-(void)movingViewTapGesture:(UITapGestureRecognizer *)tapGesture;
-(BOOL)checkRegisterInfo;
-(void)btnRegisterAction;

@end

@implementation RegisterViewController

@synthesize btnRegister;
@synthesize movingView;
@synthesize txtName,txtPwd,txtPwdAgain,txtNick,txtAnswere,txtQuestion;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)movingViewTapGesture:(UITapGestureRecognizer *)tapGesture
{
    if([tapGesture.view isKindOfClass:[UIButton class]])
    {
        [self btnRegister];
    }
    else {
    [txtAnswere resignFirstResponder];
    [txtName resignFirstResponder];
    [txtNick resignFirstResponder];
    [txtPwd resignFirstResponder];
    [txtPwdAgain resignFirstResponder];
    [txtQuestion resignFirstResponder];
    }
}
-(BOOL)checkRegisterInfo
{
    BOOL flag=YES;
    NSString *msg=nil;
    if(![txtPwd.text isEqualToString:txtPwdAgain.text])
    {
        msg=@"2次输入密码不一致";
        flag=NO;
    }
    if([txtName.text length]==0)
    {
        msg=@"用户名不能为空";
        flag=NO;
    }
    if([txtPwd.text length]==0)
    {
        msg=@"密码不能为空";
        flag=NO;
    }
    if([txtNick.text length]==0)
    {
        msg=@"昵称不能为空";
        flag=NO;
    }
    if([txtQuestion.text length]==0)
    {
        msg=@"安全问题不能为空";
        flag=NO;
    }
    if([txtAnswere.text length]==0)
    {
        msg=@"安全答案不能为空";
        flag=NO;
    }
    if(msg!=nil)
    {
        [CommonHelper showAlert:nil msg:msg];
    }
    return flag;
}

-(void)btnRegisterAction
{
    if(![self checkRegisterInfo])
    {
        return;
    }
    NSString *registerURL=[[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjectsAndKeys:@"register",@"method", txtName.text,@"email",txtPwd.text,@"pwd",txtNick.text,@"nick",txtQuestion.text,@"question",txtAnswere.text,@"answer",nil]];
    [[DownloadHelper sharedInstance] startRequest:registerURL delegate:self tag:kRequestRegisterTag userInfo:nil];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 7, 48, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_back_pressed.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    
    
    movingView=[[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
    [movingView setUserInteractionEnabled:YES];
    [movingView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-44-44)];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(movingViewTapGesture:)];
    [movingView addGestureRecognizer:tapGesture];
    [tapGesture setDelegate:self];
    [tapGesture release];
    [self.view addSubview:movingView];
    
    //用户名
    UILabel *lblName=[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, 30, 70, 25)];
    [lblName setFont:[UIFont boldSystemFontOfSize:16]];
    [lblName setText:@"用户名:"];
    [lblName setBackgroundColor:[UIColor clearColor]];
    [movingView addSubview:lblName];
    [lblName release];
    
    txtName=[[UITextField alloc] initWithFrame:CGRectMake(lblName.frame.origin.x+lblName.frame.size.width+10, lblName.frame.origin.y, 220, 27)];
    [txtName setBorderStyle:UITextBorderStyleRoundedRect];
    [txtName setPlaceholder:@"邮箱"];
    txtName.returnKeyType=UIReturnKeyDone;
    txtName.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtName.delegate=self;
    [movingView addSubview:txtName];

    //密码
    UILabel *lblPwd=[[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+lblName.frame.size.height+22, lblName.frame.size.width, lblName.frame.size.height)];
    [lblPwd setFont:[UIFont boldSystemFontOfSize:16]];
    [lblPwd setText:@"密 码:"];
    [lblPwd setBackgroundColor:[UIColor clearColor]];
    [movingView addSubview:lblPwd];
    [lblPwd release];
    
    txtPwd=[[UITextField alloc] initWithFrame:CGRectMake(lblPwd.frame.origin.x+lblPwd.frame.size.width+10, lblPwd.frame.origin.y, 220, 27)];
    [txtPwd setBorderStyle:UITextBorderStyleRoundedRect];
    [txtPwd setPlaceholder:@"密码"];
    txtPwd.secureTextEntry=YES;
    txtPwd.returnKeyType=UIReturnKeyDone;
    txtPwd.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtPwd.delegate=self;
    [movingView addSubview:txtPwd];

    //确认密码
    UILabel *lblPwdAgain=[[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, lblPwd.frame.origin.y+lblPwd.frame.size.height+22, lblName.frame.size.width, lblName.frame.size.height)];
    [lblPwdAgain setBackgroundColor:[UIColor clearColor]];
    [lblPwdAgain setFont:[UIFont boldSystemFontOfSize:16]];
    [lblPwdAgain setText:@"确认密码:"];
    [movingView addSubview:lblPwdAgain];
    [lblPwdAgain release];
    
    txtPwdAgain=[[UITextField alloc] initWithFrame:CGRectMake(lblPwdAgain.frame.origin.x+lblPwdAgain.frame.size.width+10, lblPwdAgain.frame.origin.y, 220, 27)];
    [txtPwdAgain setBorderStyle:UITextBorderStyleRoundedRect];
    [txtPwdAgain setPlaceholder:@"确认密码"];
    txtPwdAgain.secureTextEntry=YES;
    txtPwdAgain.returnKeyType=UIReturnKeyDone;
    txtPwdAgain.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtPwdAgain.delegate=self;
    [movingView addSubview:txtPwdAgain];
    
    //昵称
    UILabel *lblNick=[[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, lblPwdAgain.frame.origin.y+lblPwdAgain.frame.size.height+22, lblName.frame.size.width, lblName.frame.size.height)];
    [lblNick setFont:[UIFont boldSystemFontOfSize:16]];
    [lblNick setText:@"昵 称:"];
    [lblNick setBackgroundColor:[UIColor clearColor]];
    [movingView addSubview:lblNick];
    [lblNick release];
    
    txtNick=[[UITextField alloc] initWithFrame:CGRectMake(lblNick.frame.origin.x+lblNick.frame.size.width+10, lblNick.frame.origin.y, 220, 27)];
    [txtNick setBorderStyle:UITextBorderStyleRoundedRect];
    [txtNick setPlaceholder:@"昵称"];
    txtNick.returnKeyType=UIReturnKeyDone;
    txtNick.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtNick.delegate=self;
    [movingView addSubview:txtNick];


    //问题
    UILabel *lblQuestion=[[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, lblNick.frame.origin.y+lblNick.frame.size.height+22, lblName.frame.size.width, lblName.frame.size.height)];
    [lblQuestion setFont:[UIFont boldSystemFontOfSize:16]];
    [lblQuestion setText:@"安全问题:"];
    [lblQuestion setBackgroundColor:[UIColor clearColor]];
    [movingView addSubview:lblQuestion];
    [lblQuestion release];
    
    txtQuestion=[[UITextField alloc] initWithFrame:CGRectMake(lblQuestion.frame.origin.x+lblQuestion.frame.size.width+10, lblQuestion.frame.origin.y, 220, 27)];
    [txtQuestion setBorderStyle:UITextBorderStyleRoundedRect];
    [txtQuestion setPlaceholder:@"安全问题"];
    txtQuestion.returnKeyType=UIReturnKeyDone;
    txtQuestion.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtQuestion.delegate=self;
    [movingView addSubview:txtQuestion];

    
    //答案
    UILabel *lblAnswer=[[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, lblQuestion.frame.origin.y+lblQuestion.frame.size.height+22, lblName.frame.size.width, lblName.frame.size.height)];
    [lblAnswer setFont:[UIFont boldSystemFontOfSize:16]];
    [lblAnswer setText:@"安全答案:"];
    [lblAnswer setBackgroundColor:[UIColor clearColor]];
    [movingView addSubview:lblAnswer];
    [lblAnswer release];
    
    txtAnswere=[[UITextField alloc] initWithFrame:CGRectMake(lblAnswer.frame.origin.x+lblAnswer.frame.size.width+10, lblAnswer.frame.origin.y, 220, 27)];
    [txtAnswere setBorderStyle:UITextBorderStyleRoundedRect];
    [txtAnswere setPlaceholder:@"安全答案"];
    txtAnswere.returnKeyType=UIReturnKeyDone;
    txtAnswere.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtAnswere.delegate=self;
    [movingView addSubview:txtAnswere];

    
    btnRegister=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnRegister setTitle:@"注册" forState:UIControlStateNormal];
    [btnRegister.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [btnRegister setFrame:CGRectMake((self.view.frame.size.width-135)/2, lblAnswer.frame.origin.y+lblAnswer.frame.size.height+30, 135, 40)];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_sectiion.png"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_sectiion_press.png"] forState:UIControlStateHighlighted];
    [btnRegister addTarget:self action:@selector(btnRegisterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRegister];

    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.navigationItem.title=@"注册";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillApear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillApear:(NSNotification *)noti
{
    [movingView addSubview:btnRegister];
    NSValue *keyboardValue =[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame;
    [keyboardValue getValue:&keyboardFrame];
    [movingView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-keyboardFrame.size.height)];
}

-(void)keyboardWillDisAppear:(NSNotification *)notif
{
    [self.view addSubview:btnRegister];
    NSValue *keyboardValue =[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame;
    [keyboardValue getValue:&keyboardFrame];
    [movingView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+keyboardFrame.size.height)];
}

-(void)releaseData
{
    self.movingView=nil;
    self.txtAnswere=nil;
    self.txtNick=nil;
    self.txtQuestion=nil;
    self.txtPwd=nil;
    self.txtName=nil;
    self.txtPwdAgain=nil;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self releaseData];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseData];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark downloadHelper Delegate
-(void)DownloadFinished:(id)data downloadType:(NSNumber *)downloadType
{
    id resultData=[[data objectForKey:@"Data"] JSONValue];
    UserResultModel *userResult=[[UserDAL sharedInstance] parseUserByData:resultData];
    switch ([userResult.userResult intValue]) {
        case Exist:
        {
            [CommonHelper showAlert:nil msg:@"账号已经存在，请修改新的用户名"];
        }
            break;
        case EmailNotExist:
        {
//            [CommonHelper showAlert:nil msg:@"账号不存在"];
        }
            break;
        case Failed:
        {
            [CommonHelper showAlert:nil msg:@"注册失败"];
        }
            break;
        case Success:
        {
            [CommonHelper showAlert:nil msg:@"注册成功"];
            AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
            appDelegate.userSession=userResult.userInfo;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
