//
//  ForgetPasswordViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "URLUtility.h"
#import "UserDAL.h"
#import "UserModel.h"
#import "UserResultModel.h"
#import "JSON.h"
#import "CommonHelper.h"

#define kRequestFindPwdTag 500

@interface ForgetPasswordViewController ()

@property(nonatomic,retain)UITextField *txtName;
@property(nonatomic,retain)UITextField *txtQuestion;
@property(nonatomic,retain)UITextField *txtAnswer;

-(void)findPassword;

@end

@implementation ForgetPasswordViewController

@synthesize txtName,txtQuestion,txtAnswer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)findPassword
{
    NSString *findURL=[[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjectsAndKeys:@"findpwd",@"method",txtName.text,@"email",txtQuestion.text,@"question",txtAnswer.text,@"answer", nil]];
    [[DownloadHelper sharedInstance] startRequest:findURL delegate:self tag:kRequestFindPwdTag userInfo:nil];
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
    
    
    //用户名
    UILabel *lblName=[[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, 20, 60, 25)];
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
    
    //问题
    UILabel *lblQuestion=[[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+lblName.frame.size.height+22, 60, 25)];
    [lblQuestion setFont:[UIFont boldSystemFontOfSize:16]];
    [lblQuestion setText:@"问 题:"];
    [lblQuestion setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:lblQuestion];
    [lblQuestion release];
    
    txtQuestion=[[UITextField alloc] initWithFrame:CGRectMake(lblQuestion.frame.origin.x+lblQuestion.frame.size.width+10, lblQuestion.frame.origin.y, 220, 27)];
    [txtQuestion setBorderStyle:UITextBorderStyleRoundedRect];
    [txtQuestion setPlaceholder:@"问题"];
    txtQuestion.secureTextEntry=YES;
    txtQuestion.returnKeyType=UIReturnKeyDone;
    txtQuestion.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtQuestion.delegate=self;
    [self.view addSubview:txtQuestion];
    
    //答案
    UILabel *lblAnswer=[[UILabel alloc] initWithFrame:CGRectMake(lblName.frame.origin.x, lblQuestion.frame.origin.y+lblQuestion.frame.size.height+22, 60, 25)];
    [lblAnswer setFont:[UIFont boldSystemFontOfSize:16]];
    [lblAnswer setText:@"答 案:"];
    [lblAnswer setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:lblAnswer];
    [lblAnswer release];
    
    txtAnswer=[[UITextField alloc] initWithFrame:CGRectMake(lblAnswer.frame.origin.x+lblAnswer.frame.size.width+10, lblAnswer.frame.origin.y, 220, 27)];
    [txtAnswer setBorderStyle:UITextBorderStyleRoundedRect];
    [txtAnswer setPlaceholder:@"答案"];
    txtAnswer.secureTextEntry=YES;
    txtAnswer.returnKeyType=UIReturnKeyDone;
    txtAnswer.clearButtonMode=UITextFieldViewModeWhileEditing;
    txtAnswer.delegate=self;
    [self.view addSubview:txtAnswer];

    //注册
    UIButton *btnFind=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnFind setTitle:@"找回密码" forState:UIControlStateNormal];
    [btnFind.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [btnFind setFrame:CGRectMake((self.view.frame.size.width-135)/2, lblAnswer.frame.origin.y+lblAnswer.frame.size.height+20, 135, 40)];
    [btnFind setBackgroundImage:[UIImage imageNamed:@"btn_sectiion.png"] forState:UIControlStateNormal];
    [btnFind setBackgroundImage:[UIImage imageNamed:@"btn_sectiion_press.png"] forState:UIControlStateHighlighted];
    [btnFind addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFind];
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.navigationItem.title=@"找回密码";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.txtName=nil;
    self.txtQuestion=nil;
    self.txtAnswer=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark downloadHelper
-(void)DownloadFinished:(id)data downloadType:(NSNumber *)downloadType
{
    switch ([downloadType intValue]) {
        case kRequestFindPwdTag:
        {
            id result=[[data objectForKey:@"Data"] JSONValue];
            UserResultModel *resultModel=[[UserDAL sharedInstance] parseUserByData:[result objectForKey:@"UserModel"]];
            if([resultModel.userResult intValue] ==EmailNotExist)
            {
                [CommonHelper showAlert:nil msg:@"该邮箱不存在"];
            }
            else if([resultModel.userResult intValue]==Success)
            {
                [CommonHelper showAlert:nil msg:[NSString stringWithFormat:@"您的密码为%@",resultModel.userInfo.pwd]];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
