//
//  PFCalloutView.m
//  Disney Treasure Hunt
//
//  Created by Paul Alexander on 10/15/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFCalloutView.h"
#import "PFCalloutLayer.h"
#import "PFDrawTools.h"
#import "CALayer+PFExtensions.h"
#import <QuartzCore/QuartzCore.h>


@implementation PFCalloutView

@synthesize  closeOnTap;

-(void) dealloc 
{
    SafeRelease( calloutLayer );
    
    [super dealloc];
}

//+(Class) layerClass { return [PFCalloutLayer class]; }

-(id) initWithFrame: (CGRect) frame 
{
    if( self = [super initWithFrame: frame] ) 
    {
        //self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent: 0.5];
        
        calloutLayer = [[PFCalloutLayer alloc] init];
        [self.layer addSublayer: calloutLayer];
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        [self addTarget: self action: @selector(tapped) forControlEvents: UIControlEventTouchUpInside];
        
        
        UILabel * label = [[UILabel alloc] initWithFrame: frame];
        label.text = @"Dropped Pin";
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize: 17];
        label.center = CGPointMake( CGRectGetWidth( frame ) / 2 , 10 );
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.shadowOffset = CGSizeMake( 0, -1 );
        label.shadowColor = [[UIColor blackColor] colorWithAlphaComponent: .5];
        
        [self addSubview: label];
    }
    return self;
}

#pragma mark -
#pragma mark State

-(BOOL) isOpaque { return NO; }
-(BOOL) clearsContextBeforeDrawing { return YES; }


#pragma mark -
#pragma mark Events

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    
    CGPoint pointer = calloutLayer.pointerLocation;
    calloutLayer.pointerLocation = calloutLayer.position;
    CGRect bounds = CGRectMake( 0, 0, CGRectGetWidth( self.bounds ), CGRectGetHeight( self.bounds ) );
    bounds.size.height += kPFCalloutShadowSize;
    bounds.size.width += kPFCalloutShadowSize;
    
    calloutLayer.bounds = bounds;
    calloutLayer.position = CGPointMake( CGRectGetWidth( self.bounds ) / 2, 
                                         CGRectGetHeight( self.bounds ) / 2 + kPFCalloutShadowSize / 2 );
 
    calloutLayer.pointerLocation = pointer;
}

#pragma mark -
#pragma mark Actions

-(PFCalloutOrientation) resolveOrientationForTargetRect: (CGRect) rect inParentOfSize: (CGSize) size
{
    CGFloat selfWidth = CGRectGetWidth( self.bounds );
    CGFloat selfHeight = CGRectGetHeight( self.bounds );
    
    // Try to fit above
    if( CGRectGetMinY( rect ) - selfHeight > 0 )
        return PFCalloutOrientationAbove;
    
    // Try to fit below
    if( CGRectGetMaxY( rect ) + selfHeight < size.height )
        return PFCalloutOrientationBelow;
    
    // Try to fit right
    if( CGRectGetMaxX( rect ) + selfWidth < size.width )
        return PFCalloutOrientationRight;
    
    // Try to fit left
    if( CGRectGetMinX( rect ) - selfWidth > 0 )
        return PFCalloutOrientationLeft;

    return PFCalloutOrientationNone;
}



-(void) pointAt: (CGPoint) point orientation: (PFCalloutOrientation) orientation inView: (UIView *) parentView
{
    
    if( parentView == nil )
        parentView = self.superview;
    
    // resolve auto orientation    
    if( orientation == PFCalloutOrientationAuto )
        orientation = [self resolveOrientationForTargetRect: CGRectMake( point.x, point.y, 1, 1 ) inParentOfSize: self.superview.bounds.size ];
    
    CGPoint anchor;

    if( orientation == PFCalloutOrientationNone )
    {
        anchor = point;
    }
    else if( orientation == PFCalloutOrientationAbove || orientation == PFCalloutOrientationBelow )
    {
        CGFloat parentWidth = CGRectGetWidth( parentView.bounds );
        // If point is in left 1/3 of parent view, anchor on left
        if( point.x <= parentWidth / 3 )
            anchor.x = 0;
        
        // If point is in right 1/3 of parent view, anchor on right
        else if( point.x >= parentWidth - ( parentWidth / 3 ) )
            anchor.x = parentWidth - CGRectGetWidth( self.bounds ) - kPFCalloutShadowSize;
        
        // If point is in center 1/3 of parent view, anchor on right
        else
            anchor.x = ( parentWidth - CGRectGetWidth( self.bounds ) ) / 2;
        
        if( orientation == PFCalloutOrientationAbove )
        {
            anchor.y = point.y - CGRectGetHeight( self.bounds ) - kPFCalloutPointerSize;
            calloutLayer.pointerLocation = CGPointMake( point.x - anchor.x, CGRectGetHeight( self.bounds ) );
        }
        else
        {
            anchor.y = point.y + kPFCalloutPointerSize;
            calloutLayer.pointerLocation = CGPointMake( point.x - anchor.x, 0 );
        }

        self.center = CGPointMake( anchor.x + CGRectGetWidth( self.bounds ) / 2 + kPFCalloutShadowSize / 2, 
                                  anchor.y + CGRectGetHeight( self.bounds ) / 2 );
    }
    else
    {
        anchor.y = point.y;
        if( orientation == PFCalloutOrientationLeft )
        {
            anchor.x = point.x - CGRectGetWidth( self.bounds ) - kPFCalloutPointerSize;
            calloutLayer.pointerLocation = CGPointMake( CGRectGetWidth( self.bounds ) + kPFCalloutShadowSize / 2, 
                                                        point.y - anchor.y + CGRectGetHeight( self.bounds ) / 2 );
        }
        else
        {
            anchor.x = point.x + kPFCalloutPointerSize;
            calloutLayer.pointerLocation = CGPointMake( 0, point.y - anchor.y + CGRectGetHeight( self.bounds ) / 2 );
        }

        self.center = CGPointMake( anchor.x + CGRectGetWidth( self.bounds ) / 2, anchor.y );
    }
    
}

-(void) pointAt: (CGPoint) point orientation: (PFCalloutOrientation) orientation
{
    [self pointAt: point orientation: orientation inView: nil];
}

-(void) pointAtView: (UIView *) targetView orientation: (PFCalloutOrientation) orientation
{
    UIView * parentView = self.superview ? self.superview : targetView.superview;
    
    if( orientation == PFCalloutOrientationAuto )
        orientation = [self resolveOrientationForTargetRect: targetView.frame inParentOfSize: parentView.bounds.size];
    
    CGPoint point = targetView.center;
    switch( orientation )
    {
        case PFCalloutOrientationAbove:
            point.y -= CGRectGetHeight( targetView.bounds ) / 2;
            break;
        case PFCalloutOrientationBelow:
            point.y += CGRectGetHeight( targetView.bounds ) / 2;
            break;
        case PFCalloutOrientationLeft:
            point.x -= CGRectGetWidth( targetView.bounds ) / 2;
            break;
        case PFCalloutOrientationRight:
            point.x += CGRectGetWidth( targetView.bounds ) / 2;
            break;
    }
    
    [self pointAt: point orientation: orientation inView: parentView];
}

-(void) bounceIn
{
    [self.layer popBounceWithMinimumScale: 0 maximumScale: 1.1 tension: .5 duration: .5];
}

-(void) bounceOutAndRemove: (BOOL) remove
{
    [self.layer bounceOutWithMaximumScale: 1.5 
                                 duration: .25
                         completionTarget: remove ? self : nil 
                         completionAction: remove ? @selector(removeFromSuperview) : nil];
}

-(void) tapped
{
    if( closeOnTap )
        [self bounceOutAndRemove: YES];
}

-(void) sendActionsForControlEvents: (UIControlEvents) events
{
    [super sendActionsForControlEvents: events];
}
@end