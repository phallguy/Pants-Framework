//
//  PFGlassView.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/22/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFGlassView.h"
#import "PFDrawTools.h"
#import <QuartzCore/QuartzCore.h>

@implementation PFGlassView


-(void) initCommonGlassViewState
{
	borderWidth = 8;
	cornerRadius = 6;
	shadowDepth = 8;
}

-(id) init
{
    if( self = [super init] )
    {
        [self initCommonGlassViewState];
    }
    
    return self;
}

-(id) initWithFrame: (CGRect) frame 
{
    if( self = [super initWithFrame: frame] ) 
    {
		[self initCommonGlassViewState];
    }
    return self;
}

-(id) initWithCoder: (NSCoder *) aDecoder
{
	if( self = [super initWithCoder: aDecoder] )
	{
		[self initCommonGlassViewState];
	}
	
	return self;
}

#pragma mark -
#pragma mark State

-(BOOL) isOpaque{ return NO; }
-(BOOL) clearsContextBeforeDrawing{ return YES; }

-(CGFloat) borderWidth{ return borderWidth; }
-(void) setBorderWidth: (CGFloat) newBorderWidth
{
	if( borderWidth == newBorderWidth )
		return;
	
	borderWidth = newBorderWidth;
	[self setNeedsDisplay];
}

-(CGFloat) cornerRadius { return self.layer.cornerRadius; }
-(void) setCornerRadius: (CGFloat) newCornerRadius
{ 
	if( cornerRadius == newCornerRadius )
		return;
	
	cornerRadius = newCornerRadius;
	[self setNeedsDisplay];
}

-(CGFloat) shadowDepth{ return shadowDepth; }
-(void) setShadowDepth: (CGFloat) newShadowDepth
{
	if( shadowDepth == newShadowDepth )
		return;
	
	shadowDepth = newShadowDepth;
	[self setNeedsDisplay];
}

-(void) setFrame: (CGRect) newFrame
{
	[self setNeedsDisplay];
	[super setFrame: newFrame];
}

#pragma mark -
#pragma mark Drawing

-(void) drawRect: (CGRect) rect 
{
    [self drawGlassRect: rect];
}

-(CGRect) drawGlassRect: (CGRect) rect
{
	CGContextRef g = UIGraphicsGetCurrentContext();
	
	CGContextSetShouldAntialias( g, YES );
    
    return [PFDrawTools drawGlassInContext: g 
                                   forRect: rect 
                                     color: [UIColor whiteColor] 
                          withCornerRadius: cornerRadius 
                               borderWidth: borderWidth 
                               shadowDepth: shadowDepth];
    
}

@end
