//
//  PageControl.m
//  pageController_Test
//
//  Created by Ghost on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PageControl.h"

// Tweak these or make them dynamic.
#define kDotDiameter 16.0
#define kDotSpacer 13.0

@implementation PageControl

@synthesize dotColorCurrentPage;
@synthesize dotColorOtherPage;
@synthesize dotImageCurrentPage;
@synthesize dotImageOtherPage;

@synthesize delegate;

- (NSInteger)currentPage
{
    return _currentPage;
}

- (void)setCurrentPage:(NSInteger)page
{
    _currentPage = MIN(MAX(0, page), _numberOfPages-1);
    [self setNeedsDisplay];
}

- (NSInteger)numberOfPages
{
    return _numberOfPages;
}

- (void)setNumberOfPages:(NSInteger)pages
{
    _numberOfPages = MAX(0, pages);
    _currentPage = MIN(MAX(0, _currentPage), _numberOfPages-1);
    [self setNeedsDisplay];
}

- (BOOL)imageOrColor
{
	return _imageOrColor;
}

- (void)setImageOrColor:(BOOL)isImage
{
	_imageOrColor = isImage;
	[self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
    {
        // Default colors.
        self.backgroundColor = [UIColor clearColor];
        self.dotColorCurrentPage = [UIColor blackColor];
        self.dotColorOtherPage = [UIColor lightGrayColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();   
    CGContextSetAllowsAntialiasing(context, true);
	
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = self.numberOfPages*kDotDiameter + MAX(0, self.numberOfPages-1)*kDotSpacer;
    CGFloat x = CGRectGetMidX(currentBounds)-dotsWidth/2;
    CGFloat y = CGRectGetMidY(currentBounds)-self.frame.size.height/2;
    for (int i=0; i<_numberOfPages; i++)
    {
        CGRect circleRect = CGRectMake(x, y, kDotDiameter, self.frame.size.height);

		if (_imageOrColor) {
			/*
			 *	更改图片
			 */
			if (i == _currentPage)
			{
				[dotImageCurrentPage drawInRect:circleRect];
			}
			else
			{
				[dotImageOtherPage drawInRect:circleRect];
			}	
		}else {
			/*
			 *	更改颜色
			 */
			if (i == _currentPage)
			{
				CGContextSetFillColorWithColor(context, self.dotColorCurrentPage.CGColor);
			}
			else
			{
				CGContextSetFillColorWithColor(context, self.dotColorOtherPage.CGColor);
			}
			CGContextFillEllipseInRect(context, circleRect);
		}
		x += kDotDiameter + kDotSpacer;
    }
}

- (void)dealloc 
{
    [dotColorCurrentPage release];
    [dotColorOtherPage release];
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.delegate){
		return;
	}
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
    CGFloat dotSpanX = self.numberOfPages*(kDotDiameter + kDotSpacer);
    CGFloat dotSpanY = kDotDiameter + kDotSpacer;
    CGRect currentBounds = self.bounds;
    CGFloat x = touchPoint.x + dotSpanX/2 - CGRectGetMidX(currentBounds);
    CGFloat y = touchPoint.y + dotSpanY/2 - CGRectGetMidY(currentBounds);
	if ((x<0) || (x>dotSpanX) || (y<0) || (y>dotSpanY)) {
		float compareX = touchPoint.x-CGRectGetMidX(currentBounds);
		if (compareX == 0) 
			return ;
		else if (compareX > 0)
			self.currentPage ++ ;
		else
			self.currentPage -- ;
	}else {
		self.currentPage = floor(x/(kDotDiameter+kDotSpacer));
	}
    if ([self.delegate respondsToSelector:@selector(pageControlPageDidChange:)])
    {
        [self.delegate pageControlPageDidChange:self];
    }
}

@end
