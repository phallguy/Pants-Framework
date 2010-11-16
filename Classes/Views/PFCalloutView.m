//
//  PFCalloutView.m
//  Disney Treasure Hunt
//
//  Created by Paul Alexander on 10/15/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFCalloutView.h"
#import "PFCalloutLayer.h"
#import "PFCellContentView.h"
#import "PFDrawTools.h"
#import "CALayer+PFExtensions.h"
#import <QuartzCore/QuartzCore.h>


@implementation PFCalloutView

@synthesize  closeOnTap, context;

-(void) dealloc 
{
    SafeRelease( calloutLayer );
    SafeRelease( contentView );
    
    
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

        
        [self addTarget: self action: @selector(tapped) forControlEvents: UIControlEventTouchUpInside];

        
        frame.origin = CGPointZero;
        frame = CGRectInset( frame, kPFCalloutContentInset, kPFCalloutContentInset );
        contentView = [[PFCellContentView alloc] initWithFrame: frame];
        [self addSubview: contentView];
    }
    return self;
}

#pragma mark -
#pragma mark State

-(BOOL) isOpaque { return NO; }
-(BOOL) clearsContextBeforeDrawing { return YES; }

-(UIView *) contentView { return contentView; }
-(void) setContentView: (UIView *) newContentView
{
    if( newContentView == contentView )
        return;
    
    [contentView removeFromSuperview];
    [contentView release];
    contentView = nil;
    
    if( newContentView != nil )
    {
        contentView = [newContentView retain];
        [self addSubview: newContentView];
        [self setNeedsLayout];
    }
}

-(PFCellContentView *) cellContentView
{
    if( [contentView isKindOfClass: [PFCellContentView class]] )
        return contentView;
    return nil;
}


#pragma mark -
#pragma mark Events

-(CGSize) sizeThatFits: (CGSize) size
{
    CGSize contentSize = size;
    contentSize.width -= ( kPFCalloutContentInset * 2 ) + kPFCalloutShadowSize;
    contentSize.height -= ( kPFCalloutContentInset * 2 ) + kPFCalloutShadowSize;
    contentSize.height = MAX( kPFCalloutMinimumContentHeight, contentSize.height );
    
    CGSize originalSize = contentView.bounds.size;
    CGSize fitsize = [contentView sizeThatFits: contentSize];
    if( fitsize.height == 0 )
        fitsize.height = originalSize.height;
    if( fitsize.height < kPFCalloutMinimumContentHeight )
        fitsize.height = kPFCalloutMinimumContentHeight;
    
    fitsize.width =  MIN( size.width, ceil( fitsize.width + ( kPFCalloutContentInset * 2 ) ) );
    fitsize.height = MIN( size.height, ceil( fitsize.height + ( kPFCalloutContentInset * 2 ) ) );
    
    return fitsize;
}

-(void) updateCalloutLayerBounds
{
    CGRect bounds = CGRectMake( 0, 0, CGRectGetWidth( self.bounds ), CGRectGetHeight( self.bounds ) );
    
    [calloutLayer setBodyBounds: bounds];
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = CGRectMake( 0, 0, CGRectGetWidth( self.bounds ), CGRectGetHeight( self.bounds ) );
    contentView.frame = CGRectInset( bounds, kPFCalloutContentInset, kPFCalloutContentInset );
    [self updateCalloutLayerBounds];
}

#pragma mark -
#pragma mark Actions

-(PFCalloutOrientation) resolveOrientationForTargetRect: (CGRect) rect inParentOfSize: (CGSize) size
{
    CGSize selfSize = [self sizeThatFits: size];
    
    
    // Try to fit above
    if( CGRectGetMinY( rect ) - selfSize.height - kPFCalloutPointerSize > 0 )
        return PFCalloutOrientationAbove;
    
    // Try to fit below
    if( CGRectGetMaxY( rect ) + selfSize.height + kPFCalloutPointerSize < size.height )
        return PFCalloutOrientationBelow;
    
    // Try to fit right
    if( CGRectGetMaxX( rect ) + selfSize.width + kPFCalloutPointerSize < size.width )
        return PFCalloutOrientationRight;
    
    // Try to fit left
    if( CGRectGetMinX( rect ) - selfSize.width - kPFCalloutPointerSize > 0 )
        return PFCalloutOrientationLeft;

    return PFCalloutOrientationNone;
}



-(void) pointAt: (CGPoint) point offset: (CGSize) offset orientation: (PFCalloutOrientation) orientation inView: (UIView *) parentView
{
    
    if( parentView == nil )
        parentView = self.superview;
    
    self.bounds = CGRectMake( 0, 0, CGRectGetWidth( parentView.bounds ), CGRectGetHeight( parentView.bounds ) );
    [self sizeToFit];
    [self updateCalloutLayerBounds];
    
    // resolve auto orientation    
    if( orientation == PFCalloutOrientationAuto )
        orientation = [self resolveOrientationForTargetRect: CGRectMake( point.x - offset.width, point.y - offset.width, offset.width * 2, offset.height * 2 ) inParentOfSize: self.superview.bounds.size ];
    
    
    CGPoint anchor;
    calloutLayer.orientation = orientation;

    if( orientation == PFCalloutOrientationNone )
    {
        anchor = point;
    }
    else if( orientation == PFCalloutOrientationAbove || orientation == PFCalloutOrientationBelow )
    {
        CGFloat parentWidth = CGRectGetWidth( parentView.bounds );
        // If point is in left 1/3 of parent view, anchor on left
        if( point.x <= parentWidth / 3 )
            anchor.x = kPFCalloutShadowSize / 2 ;
        
        // If point is in right 1/3 of parent view, anchor on right
        else if( point.x >= parentWidth - ( parentWidth / 3 ) )
            anchor.x = parentWidth - CGRectGetWidth( self.bounds ) - kPFCalloutShadowSize / 2;
        
        // If point is in center 1/3 of parent view, anchor on right
        else
            anchor.x = ( parentWidth - CGRectGetWidth( self.bounds ) ) / 2;
        
        if( orientation == PFCalloutOrientationAbove )
        {
            anchor.y = point.y - CGRectGetHeight( self.bounds ) - kPFCalloutPointerSize - offset.height;
            calloutLayer.pointerLocation = CGPointMake( point.x - anchor.x + kPFCalloutShadowSize / 2 , CGRectGetHeight( self.bounds ) );
        }
        else
        {
            anchor.y = point.y + kPFCalloutPointerSize + offset.height;
            calloutLayer.pointerLocation = CGPointMake( point.x - anchor.x + kPFCalloutShadowSize / 2 , 0 );
        }

        
        
        
        self.center = CGPointMake( ceil( anchor.x + CGRectGetWidth( self.bounds ) / 2 ), 
                                   ceil( anchor.y + CGRectGetHeight( self.bounds ) / 2 ) );
    }
    else
    {
        anchor.y = point.y;
        if( orientation == PFCalloutOrientationLeft )
        {
            anchor.x = point.x - CGRectGetWidth( self.bounds ) - kPFCalloutPointerSize - offset.width;
            calloutLayer.pointerLocation = CGPointMake( CGRectGetWidth( self.bounds ) + kPFCalloutShadowSize / 2, 
                                                        point.y - anchor.y + CGRectGetHeight( self.bounds ) / 2 );
        }
        else
        {
            anchor.x = point.x + kPFCalloutPointerSize + offset.width;
            calloutLayer.pointerLocation = CGPointMake( 0, point.y - anchor.y + CGRectGetHeight( self.bounds ) / 2 );
        }

        self.center = CGPointMake( ceil( anchor.x + CGRectGetWidth( self.bounds ) / 2 ), ceil( anchor.y ) );
    }
    
}

-(void) pointAt: (CGPoint) point offset: (CGSize) size orientation: (PFCalloutOrientation) orientation
{
    [self pointAt: point offset: size orientation: orientation inView: nil];
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
    
    [self pointAt: point offset: CGSizeZero orientation: orientation inView: parentView];
}

-(void) springIn
{
    [self.layer removeAllAnimations];
    
    [self.layer popSpringWithMinimumScale: 0 maximumScale: 1.05 tension: .55 duration: .45];
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath: @"transform.translation"];
    animation.fromValue = [NSValue valueWithCGPoint: CGPointMake( calloutLayer.pointerLocation.x - CGRectGetWidth( self.bounds ) / 2, 
                                                                  calloutLayer.pointerLocation.y - CGRectGetHeight( self.bounds ) / 2 )];
    animation.toValue = [NSValue valueWithCGPoint: CGPointZero];
    animation.duration = 0.075;
    
    [self.layer addAnimation: animation forKey: @"springIn_translate"];
                           
}

-(void) springOutDelay: (id) remove
{
    [self springOutAndRemove: remove == nil afterDelay: 0];
}

-(void) springOutAndRemove: (BOOL) remove afterDelay: (NSTimeInterval) delay
{
    [NSObject cancelPreviousPerformRequestsWithTarget: self];
    
    if( delay )
    {
        [self performSelector: @selector(springOutDelay:) withObject: remove ? @"" : nil afterDelay: delay];
        return;
    }
    
    [self.layer springOutWithMaximumScale: 1.5 
                                 duration: .25
                         completionTarget: remove ? self : nil 
                         completionAction: remove ? @selector(removeFromSuperview) : nil];
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath: @"transform.translation"];
    animation.fromValue = [NSValue valueWithCGPoint: CGPointZero];
    animation.toValue = [NSValue valueWithCGPoint: CGPointMake( calloutLayer.pointerLocation.x - CGRectGetWidth( self.bounds ) / 2, 
                                                                 calloutLayer.pointerLocation.y - CGRectGetHeight( self.bounds ) / 2 )];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = .40;
    
    [self.layer addAnimation: animation forKey: @"springOut_translate"];
}

-(void) tapped
{
    if( closeOnTap )
        [self springOutAndRemove: YES afterDelay: 0];
}

-(void) sendActionsForControlEvents: (UIControlEvents) events
{
    [super sendActionsForControlEvents: events];
}
@end