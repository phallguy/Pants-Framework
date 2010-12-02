//
//  PFDisclosureIndicatorView.m
//  Pants-Framework
//
//  Created by Paul Alexander on 11/20/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PFDisclosureIndicatorView.h"

#define kLineWidth      3
#define kSize           4.5

@implementation PFDisclosureIndicatorView


-(void) dealloc 
{
    SafeRelease( color );
    SafeRelease( highlightedColor );
    SafeRelease( shadowColor );
    
    [super dealloc];
}

-(id) initWithFrame: (CGRect) frame color: (UIColor *) newColor highlightedColor: (UIColor *) newHighlightedColor
{
    if( ( self = [super initWithFrame: frame] ) )
    {
        color = [newColor retain];
        highlightedColor = [newHighlightedColor retain];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


-(UIColor *) color 
{
    if( color == nil )
        color = [[UIColor blackColor] retain];
    return color;
}

-(void) setColor: (UIColor *) newColor
{
    if( newColor == color )
        return;
    
    [color release];
    color = [newColor retain];
    [self setNeedsDisplay];
}

-(UIColor *) highlightedColor 
{
    if( color == nil )
        color = [[UIColor whiteColor] retain];
    return color;
}

-(void) setHighlightedColor: (UIColor *) newColor
{
    if( newColor == color )
        return;
    
    [highlightedColor release];
    highlightedColor = [newColor retain];
    [self setNeedsDisplay];
}

-(UIColor *) shadowColor { return shadowColor; }
-(void) setShadowColor: (UIColor *) newShadowColor
{
    if( newShadowColor == shadowColor )
        return;
    
    [shadowColor release];
    shadowColor = [newShadowColor retain];
    [self setNeedsDisplay];
}

-(BOOL) isHighlited
{
    id view = self.superview;
    while( view != nil && ![view respondsToSelector: @selector(isHighlighted)] )
        view = [view superview];
    
    return [view isHighlighted];
}

-(void) draw: (CGContextRef) g chevronAt: (CGPoint) point color: (UIColor *) chevronColor
{
    CGContextMoveToPoint( g, point.x - kSize, point.y - kSize );
    CGContextAddLineToPoint( g, point.x, point.y );
    CGContextAddLineToPoint( g, point.x - kSize, point.y + kSize );
    CGContextSetStrokeColorWithColor( g, [chevronColor CGColor] );
    
    CGContextStrokePath(g);
    
}

-(void) drawRect: (CGRect) rect
{
    CGPoint point = CGPointMake( CGRectGetMidX( self.bounds ) + kSize / 2,
                                 CGRectGetMidY( self.bounds ) );
    
    CGContextRef g = UIGraphicsGetCurrentContext();

    CGContextSetLineCap( g, kCGLineCapSquare );
    CGContextSetLineJoin( g, kCGLineJoinMiter );
    CGContextSetLineWidth( g, kLineWidth );

    if( shadowColor )
        [self draw: g chevronAt: CGPointMake( point.x, point.y - 1) color: shadowColor];
    
    [self draw: g chevronAt: point color: [self isHighlited] ? self.highlightedColor : self.color];
}

@end
