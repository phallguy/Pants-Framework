//
//  PFContainerView.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/30/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFContainerView.h"


@implementation PFContainerView


-(BOOL) pointInside: (CGPoint) point withEvent: (UIEvent *) event
{
    for( UIView * childView in self.subviews )
        if( [childView pointInside: [self convertPoint: point toView: childView] withEvent: event] )
            return YES;
    
    return NO;
}



@end
