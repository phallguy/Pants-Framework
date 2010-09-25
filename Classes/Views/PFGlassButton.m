//
//  PFGlassButton.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/16/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFGlassButton.h"
#import "PFDrawTools.h"
#import <QuartzCore/QuartzCore.h>

@implementation PFGlassButton

-(void) dealloc 
{
    [super dealloc];
}


-(void) initCommon
{
    cornerRadius = 12;
    shadowBlur = 15;
}

-(id) initWithFrame: (CGRect) frame 
{
    if( self = [super initWithFrame: frame] ) 
    {
        [self initCommon];
    }
    
    return self;
}

-(id) initWithCoder: (NSCoder *) coder 
{
    if( self = [super initWithCoder: coder] ) 
    {
        [self initCommon];
    }
    
    return self;
}

#pragma mark -
#pragma mark State

-(CGFloat) cornerRadius { return cornerRadius; }
-(void) setCornerRadius: (CGFloat) newCornerRadius
{
    if( cornerRadius == newCornerRadius )
        return;
    
    cornerRadius = newCornerRadius;
    [self setNeedsDisplay];

}

-(CGFloat) shadowBlur { return shadowBlur; }
-(void) setShadowBlur: (CGFloat) newShadowBlur
{
    if( shadowBlur == newShadowBlur )
        return;
    
    shadowBlur = newShadowBlur;
    [self setNeedsDisplay];
}

-(void) setHighlighted: (BOOL) newHighlighted
{
    [super setHighlighted: newHighlighted];
    [self setNeedsDisplay];
}


#pragma mark -
#pragma mark Drawing & Layout

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
-(void) drawRect: (CGRect) rect 
{
    CGContextRef g = UIGraphicsGetCurrentContext();
    
    UIColor * color = self.highlighted 
                        ? [UIColor colorWithRed: 0 green: 0.3867 blue: 0.832 alpha: 1] 
                        : [UIColor whiteColor];
    
    CGRect r = [PFDrawTools drawGlassInContext: g 
                            forRect: rect 
                              color: color
                   withCornerRadius: cornerRadius 
                        borderWidth: cornerRadius 
                        shadowDepth: shadowBlur];
    

    if( ! self.highlighted )
        return;
    
    CGRect gr = CGRectInset( r, cornerRadius / 2, cornerRadius / 2 );
    
    CGPathRef path = [PFDrawTools createPathForRect:  gr
                                   withCornerRadius: cornerRadius / 2];
    
    // Render a clipped radial gradient
	CGContextAddPath( g, path );
	CGContextClip( g );	
	
	CGColorRef colors[] = 
    { 
        [[UIColor colorWithRed: 0.01953 green: 0.543 blue: 0.957 alpha: 1] CGColor],
		[color CGColor]
    };
	
	CFArrayRef colorsRef = CFArrayCreate( NULL, (const void**)colors, 2, NULL );
	
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradientRef = CGGradientCreateWithColors( colorSpaceRef, colorsRef, NULL );
    
	CGContextDrawLinearGradient( g, gradientRef, CGPointMake( 0, CGRectGetMinY( gr) ), CGPointMake( 0, CGRectGetMaxY( gr ) ),
                                kCGGradientDrawsBeforeStartLocation );
    
	CGColorSpaceRelease( colorSpaceRef );
	CGGradientRelease( gradientRef );
	CGPathRelease( path );
	CFRelease( colorsRef );

}

-(CGRect) contentRectForBounds: (CGRect) rect
{
    return [PFDrawTools calculateGlassRect: [super contentRectForBounds: rect] shadowDepth: shadowBlur];
}

@end
