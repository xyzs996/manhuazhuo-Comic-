//
//  PageControl.h
//  pageController_Test
//
//  Created by Ghost on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageControlDelegate;

@interface PageControl : UIView 
{
@private
    NSInteger	_currentPage;
    NSInteger	_numberOfPages;
	BOOL		_imageOrColor;
    UIColor *dotColorCurrentPage;
    UIColor *dotColorOtherPage;
	UIImage *dotImageCurrentPage;
    UIImage *dotImageOtherPage;

    NSObject<PageControlDelegate> *delegate;
}

// Set these to control the PageControl.
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;

// set these show Image or color.
@property (nonatomic) BOOL		imageOrColor;
// Customize these as well as the backgroundColor property.
@property (nonatomic, retain) UIColor *dotColorCurrentPage;
@property (nonatomic, retain) UIColor *dotColorOtherPage;
// Customize these as well as the image property.
@property (nonatomic, retain) UIImage *dotImageCurrentPage;
@property (nonatomic, retain) UIImage *dotImageOtherPage;

// Optional delegate for callbacks when user taps a page dot.
@property (nonatomic, assign) NSObject<PageControlDelegate> *delegate;

@end

@protocol PageControlDelegate<NSObject>
@optional
- (void)pageControlPageDidChange:(PageControl *)pageControl;
@end
