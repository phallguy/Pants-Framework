//
//  CALayer+PFExtensions.m
//  Pants-Framework
//
//  Created by Paul Alexander on 10/16/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "CALayer+PFExtensions.h"


#define kBounceFirstPhaseFraction 0.15
#define kMaxTension 0.9




@implementation CALayer (PFExtensions)


-(void) popSpringWithMinimumScale: (CGFloat) minScale  
                     maximumScale: (CGFloat) maxScale 
                          tension: (CGFloat) tension 
                         duration: (CFTimeInterval) duration
{
    
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath: @"transform.scale"];
    animation.duration = duration;
    animation.removedOnCompletion = YES;
    
    
    NSMutableArray * values = [NSMutableArray array];
    NSMutableArray * timings = [NSMutableArray array];
    NSMutableArray * times = [NSMutableArray array];
    double bounce = MAX( 1, maxScale ) - 1;
    

    CAMediaTimingFunction * easeOut = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    CAMediaTimingFunction * easeIn = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];

    [values addObject: [NSNumber numberWithFloat: minScale]];
    [timings addObject: easeOut];
    [times addObject: [NSNumber numberWithFloat: 0.0]];

    [values addObject: [NSNumber numberWithFloat: 1 + bounce]];
    [timings addObject: easeOut];
    [times addObject: [NSNumber numberWithFloat: kBounceFirstPhaseFraction]];

    if( tension > kMaxTension )
        tension = kMaxTension;
    
    int iterations = 0;
    while( bounce >= 0.01 )
    {
        bounce *= tension;
        iterations++;
    }    
    
    bounce = MAX( 1, maxScale ) - 1;  
    double bounceTime = kBounceFirstPhaseFraction;
    double bounceTimeSlice = ( 1 - kBounceFirstPhaseFraction ) / ( iterations * 2 );
    while( bounce >= 0.01 )
    {        
        bounceTime += bounceTimeSlice;

        [values addObject: [NSNumber numberWithFloat: 1 - bounce]];
        [timings addObject: easeIn];
        [times addObject: [NSNumber numberWithFloat: bounceTime]];
        
        bounceTime += bounceTimeSlice;
        
        [values addObject: [NSNumber numberWithFloat: 1 + bounce]];
        [timings addObject: easeOut];
        [times addObject: [NSNumber numberWithFloat: bounceTime]];

        bounce *= tension;
    }
    
    [values addObject: [NSNumber numberWithFloat: 1]];
    [timings addObject: easeOut];
    [times addObject: [NSNumber numberWithFloat: 0.1]];

     
    animation.values = values;
    animation.timingFunctions = timings;
    animation.keyTimes = times;
    
    [self addAnimation: animation forKey: @"popBounce"];
}

-(void) springOutWithMaximumScale: (CGFloat) maxScale 
                         duration: (CFTimeInterval) duration 
                 completionTarget: (id) completionTarget 
                 completionAction: (SEL) completionAction
{
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath: @"transform.scale"];
    animation.duration = duration;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    animation.values = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat: 1.0],
                        [NSNumber numberWithFloat: 1.3],
                        [NSNumber numberWithFloat: 0],
                        nil];
    
    animation.timingFunctions = [NSArray arrayWithObjects:
                                 [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                 [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut],
                                 [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn],
                                 nil
                                 ];
    
    animation.keyTimes = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat: 0.0],
                          [NSNumber numberWithFloat: 0.6],
                          [NSNumber numberWithFloat: 1],
                          nil];
    
    
    if( completionTarget && completionAction )
        animation.delegate = [PFAnimationCompletionDelegateDispatch dispatchWithTarget: completionTarget action: completionAction];
    
    [self addAnimation: animation forKey: @"bounceOutWithMaximumScale"];
    
    CABasicAnimation * fade = [CABasicAnimation animationWithKeyPath: @"opacity"];
    fade.fromValue = [NSNumber numberWithFloat: 1];
    fade.toValue = [NSNumber numberWithFloat: 0];
    fade.duration = duration;
    fade.fillMode = kCAFillModeForwards;
    fade.removedOnCompletion = NO;
    
    [self addAnimation: fade forKey: @"bounceOutWthMaximumScale_fade"];
    
}

@end


@implementation PFAnimationCompletionDelegateDispatch

-(id) initWithTarget: (id) newTarget action: (SEL) newAction
{
    if( self = [super init] )
    {
        target = newTarget;
        action = newAction;
    }
    
    return self;
}

-(void) animationDidStop: (CAAnimation *) theAnimation finished: (BOOL) flag
{
    [target performSelector: action];
}

-(void) animationDidStop: (NSString *) animationID finished: (NSNumber *) finished context: (void *) context
{
    [target performSelector: action];
}

+(id) dispatchWithTarget: (id) target action: (SEL) action
{
    return [[[PFAnimationCompletionDelegateDispatch alloc] initWithTarget: target action: action] autorelease];
}

@end