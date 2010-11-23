//
//  PFDispatchTargetAction.m
//  Pants-Framework
//
//  Created by Paul Alexander on 11/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PFDispatchTargetAction.h"


@implementation PFDispatchTargetAction

@synthesize target, action;

-(void) dealloc
{
    SafeRelease( target );
    action = nil;
    
    [super dealloc];
}

-(id) init
{
    PFAssert( NO, @"Use initWithTarget instead." );
    return nil;
}

-(id) initWithTarget: (id) newTarget action: (SEL) newAction
{
    PFAssert( newAction, @"Missing action" );
    
    if( ( self = [super init] ) )
    {
        target = [newTarget retain];
        action = newAction;
    }
    
    return self;
}

-(void) performWith: (id) withObject
{
    NSString * str = NSStringFromSelector( action );
    if( [str rangeOfString: @":"].location == NSNotFound )
        [target performSelector: action];
    else
        [target performSelector: action withObject: withObject];
}

+(PFDispatchTargetAction *) dispatchWithTarget: (id) target action: (SEL) action
{
    return [[[PFDispatchTargetAction alloc] initWithTarget: target action: action] autorelease];
}
@end
