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

-(BOOL) isHighlited
{
    id view = self.superview;
    while( view != nil && ![view respondsToSelector: @selector(isHighlighted)] )
        view = [view superview];
    
    return [view isHighlighted];
}

-(void) drawRect: (CGRect) rect
{
    CGFloat x = CGRectGetMidX( self.bounds ) + kSize / 2;
    CGFloat y = CGRectGetMidY( self.bounds );
    
    CGContextRef g = UIGraphicsGetCurrentContext();

    CGContextMoveToPoint( g, x - kSize, y - kSize );
    CGContextAddLineToPoint( g, x, y );
    CGContextAddLineToPoint( g, x - kSize, y + kSize );
    CGContextSetLineCap( g, kCGLineCapSquare );
    CGContextSetLineJoin( g, kCGLineJoinMiter );
    CGContextSetLineWidth( g, kLineWidth );

    CGContextSetStrokeColorWithColor( g, [self isHighlited] ? [self.highlightedColor CGColor] : [self.color CGColor] );

    CGContextStrokePath(g);
}

@end
