//
//  WriteCommentViewController.m
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WriteCommentViewController.h"

@interface WriteCommentViewController ()

-(void)keyboardWillAppear:(NSNotification *)notif;

-(void)enableTap:(NSNumber *)flag;//是否禁用tap手势
-(void)tableViewTap:(UITapGestureRecognizer *)tap;

@end

@implementation WriteCommentViewController

@synthesize tap;
@synthesize txtComment;
@synthesize commentString;
@synthesize commentImgView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)enableTap:(NSNumber *)flag
{
    [tap setEnabled:[flag boolValue]];
}

-(void)tableViewTap:(UITapGestureRecognizer *)_tap
{
    [txtComment resignFirstResponder];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([[touch view] isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

-(void)keyboardWillAppear:(NSNotification *)notif
{
    NSLog(@"=========%@",notif.object);
        NSLog(@"====+++=====%@",notif.object);
    NSValue *value=[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame;
    [value getValue:&keyboardFrame];
    
    [txtComment setBackgroundColor:[UIColor whiteColor]];
    [UIView beginAnimations:nil context:nil];
    [commentImgView setFrame:CGRectMake(commentImgView.frame.origin.x, self.view.frame.size.height-keyboardFrame.size.height-commentImgView.frame.size.height, commentImgView.frame.size.width, commentImgView.frame.size.height)];
    [UIView commitAnimations];
    
    [commentImgView setImage:[UIImage imageNamed:@"comment_input_boxa.png"]];
//    [txtComment setText:commentString];
//    [txtComment setPlaceholder:nil];
    
    
    [tap setEnabled:YES];
}

-(void)keyboardWillDisAppear:(NSNotification *)notif
{
    self.commentString=txtComment.text;
    
    [txtComment setBackgroundColor:[UIColor clearColor]];
    
    
    NSValue *value=[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame;
    [value getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [commentImgView setFrame:CGRectMake(commentImgView.frame.origin.x, self.view.frame.size.height-commentImgView.frame.size.height, commentImgView.frame.size.width, commentImgView.frame.size.height)];
    
    //文字显示
//    [commentImgView setImage:[UIImage imageNamed:@"comment_fakedinput.png"]];
//    [txtComment setText:@""];
//    [txtComment setPlaceholder:@"     写评论"];
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(enableTap:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.3];
}

-(void)postComment
{
    [tap setEnabled:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTap:)];
    [tap setEnabled:NO];
    [tap setDelegate:self];
    [self.view addGestureRecognizer:tap];

    
    //评论条
    commentImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-42-44, self.view.frame.size.width, 42)];
    [commentImgView setUserInteractionEnabled:YES];
    [commentImgView setImage:[UIImage imageNamed:@"comment_fakedinput.png"]];
    [self.view addSubview:commentImgView];  
    
    txtComment=[[UITextField alloc] initWithFrame:CGRectMake(10, (commentImgView.frame.size.height-25)/2, 237, 26)];
    [txtComment setPlaceholder:@"     写评论"];
    [txtComment setBackgroundColor:[UIColor clearColor]];
    [commentImgView addSubview:txtComment];
    
    UIButton *btnComment=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnComment setTitleColor:[UIColor colorWithRed:152/255.0 green:153/255.0 blue:163/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btnComment.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [btnComment setFrame:CGRectMake(260, (commentImgView.frame.size.height-30)/2, 51, 30)];
    [btnComment setTitle:@"发表" forState:UIControlStateNormal];
    [btnComment setBackgroundImage:[UIImage imageNamed:@"comment_bar_btn_bg.png"] forState:UIControlStateNormal];
    [btnComment addTarget:self action:@selector(postComment) forControlEvents:UIControlEventTouchUpInside];
    [commentImgView addSubview:btnComment];
}

-(void)releaseData
{
    self.tap=nil;
    self.txtComment=nil;
    self.commentImgView=nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseData];
}

-(void)dealloc
{
    self.commentString=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [self releaseData];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
