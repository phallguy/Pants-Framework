//
//  PFTouchDetectorControl.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PFTouchDetectorControl.h"


@implementation PFTouchDetectorControl

@synthesize delegate, context;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(BOOL) isOpaque{ return NO; }
-(BOOL) clearsContextBeforeDrawing{ return YES; }

- (void)drawRect:(CGRect)rect 
{
	CGContextRef g = UIGraphicsGetCurrentContext();
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGColorRef colors[] = {
		[[UIColor colorWithRed: 0 green: 0 blue: 0 alpha: .55] CGColor],
		[[UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0] CGColor]
	};
	CFArrayRef colorsRef = CFArrayCreate( NULL, (const void**)colors, 2, NULL );
	
	CGGradientRef gradient = CGGradientCreateWithColors( rgb, colorsRef, NULL );
	CGContextDrawRadialGradient( g, gradient, 
								 self.center, CGRectGetHeight( self.frame ) / 1.5, 
								 self.center, CGRectGetHeight( self.frame ) * .25, 
								 kCGGradientDrawsAfterEndLocation | kCGGradientDrawsBeforeStartLocation );
	
	
	CFRelease( colorsRef );
	CGColorSpaceRelease( rgb );
}

- (void)dealloc {
    [super dealloc];
}


@end
