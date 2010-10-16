//
//  CALayer+PFExtensions.m
//  Pants-Framework
//
//  Created by Paul Alexander on 10/16/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "CALayer+PFExtensions.h"


#define kBounceFirstPhaseFraction 0.05

@implementation CALayer (PFExtensions)


-(void) popBounceWithMinimumScale: (CGFloat) minScale  
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

@end
