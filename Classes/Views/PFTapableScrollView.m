//
//  PFTapableScrollView.m
//  Pants-Framework
//
//  Created by Paul Alexander on 11/7/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFTapableScrollView.h"


@implementation PFTapableScrollView


-(void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    if( ! self.dragging )
        [self.nextResponder touchesEnded: touches withEvent: event];
    else
        [super touchesEnded: touches withEvent: event];
}


@end
