//
//  PopupBorderWithShadowView.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PFPopupBorderWithShadowView.h"
#import <QuartzCore/QuartzCore.h>
#import "PFDrawTools.h"

@implementation PFPopupBorderWithShadowView

@synthesize hostTransform;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(BOOL) isOpaque{ return NO; }
-(BOOL) clearsContextBeforeDrawing{ return YES; }

-(int) borderWidth{ return borderWidth; }
-(void) setBorderWidth: (int) newBorderWidth
{
	if( borderWidth == newBorderWidth )
		return;
	
	if( borderWidth != 0 )
		self.frame = CGRectInset( self.frame, borderWidth, borderWidth );
	
	borderWidth = newBorderWidth;
	
	self.frame = CGRectInset( self.frame, -borderWidth, -borderWidth );
}

-(UIColor*) borderColor{ return borderColor; }	
-(void) setBorderColor: (UIColor*) newBorderColor
{
	if( borderColor == newBorderColor )
		return;
	
	[borderColor release];
	borderColor = [newBorderColor retain];
	[self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void) drawRect: (CGRect)rect 
{
	CGContextRef g = UIGraphicsGetCurrentContext();

	UIView * child = [self.subviews objectAtIndex: 0];
	
	
	CGRect borderRect = CGRectInset( rect, borderWidth / 2, borderWidth / 2 );
	CGPathRef path;
	
	if( ! child || child.layer.cornerRadius <= 0 )
	{
		path = CGPathCreateMutable();
		CGPathAddRect( (CGMutablePathRef)path,  nil, borderRect );
	}
	else
	{
		path = [PFDrawTools createPathForRect: borderRect withCornerRadius: child.layer.cornerRadius + ( borderWidth / 2 )];
	}
	
	[self.borderColor set];
	
	CGContextAddPath( g, path );
	CGContextStrokePath( g );
	
	
	UIColor * shadowColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
	CGContextSetShadowWithColor( g, CGSizeZero, borderWidth / 2, shadowColor.CGColor );
	
	[[self.borderColor colorWithAlphaComponent: .5] set];
	
	CGContextAddPath( g, path );		
	CGContextFillPath( g );		
	
	CGPathRelease( path );
}

- (void)dealloc 
{
    SafeRelease( borderColor );
   
    [super dealloc];
}


@end
