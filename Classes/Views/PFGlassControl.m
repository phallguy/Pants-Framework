//
//  PFGlassControl.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/22/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFGlassControl.h"
#import "PFDrawTools.h"
#import <QuartzCore/QuartzCore.h>

@implementation PFGlassControl


-(void) initCommonGlassControlState
{
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    
    [self initializeDefaultGlassState];
}

-(id) initWithFrame: (CGRect) frame 
{
    if( self = [super initWithFrame: frame] ) 
    {
		[self initCommonGlassControlState];
    }
    return self;
}

-(id) initWithCoder: (NSCoder *) aDecoder
{
	if( self = [super initWithCoder: aDecoder] )
	{
		[self initCommonGlassControlState];
	}
	
	return self;
}

#pragma mark -
#pragma mark State

-(BOOL) isOpaque{ return NO; }
-(BOOL) clearsContextBeforeDrawing{ return NO; }

-(CGFloat) borderWidth{ return borderWidth; }
-(void) setBorderWidth: (CGFloat) newBorderWidth
{
	if( borderWidth == newBorderWidth )
		return;
	
	borderWidth = newBorderWidth;
	[self setNeedsDisplay];
}

-(CGFloat) cornerRadius { return cornerRadius; }
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

-(void) initializeDefaultGlassState
{
    borderWidth = 8;
	cornerRadius = 6;
	shadowDepth = 8;    
}

-(UIImage*) photoOfSize: (CGSize) size { return nil; }


#pragma mark -
#pragma mark Drawing

-(void) drawRect: (CGRect) rect 
{
    [self drawGlassRect: rect];
    
    [[UIColor clearColor] set];
}

-(CGRect) drawGlassRect: (CGRect) rect
{
	CGContextRef g = UIGraphicsGetCurrentContext();
	
	//CGContextSetShouldAntialias( g, YES );
    
    CGRect r = [PFDrawTools drawGlassInContext: g 
                                   forRect: rect 
                                     color: [UIColor whiteColor] 
                          withCornerRadius: cornerRadius 
                               borderWidth: borderWidth 
                               shadowDepth: shadowDepth];
    
    CGRect photoRect = CGRectInset( r, self.borderWidth, self.borderWidth );
	CGPathRef photoPath = [PFDrawTools createPathForRect: photoRect	withCornerRadius: self.cornerRadius / 2];
    
	CGContextAddPath( g, photoPath );
	CGContextClip( g );
    
    UIImage * photo = [self photoOfSize: photoRect.size];
    
    if( photo == nil )
        photo = [UIImage imageNamed: @"MissingPhoto.png"];
    
    NSLog( @"photo scale: %f", photo.scale );
    
	[photo drawInRect: photoRect];
    //[photo drawAtPoint: photoRect.origin];
	
	
	[[UIColor colorWithRed: .5 green: .5 blue: .5 alpha: 1] set];
	CGContextAddPath( g,  photoPath );
	CGContextStrokePath( g );
	CGPathRelease( photoPath );
    
    return r;
}

@end
