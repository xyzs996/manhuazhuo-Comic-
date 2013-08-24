//
//  WriteCommentViewController.h
//  ManHuaZhuo
//
//  Created by 国翔 韩 on 12-11-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteCommentViewController : UIViewController<UIGestureRecognizerDelegate>

@property(nonatomic,retain)NSString *commentString;
@property(nonatomic,retain)UIImageView *commentImgView;
@property(nonatomic,retain)UITapGestureRecognizer *tap;
@property(nonatomic,retain)UITextField *txtComment;
-(void)postComment;
-(void)keyboardWillDisAppear:(NSNotification *)notif;
@end
