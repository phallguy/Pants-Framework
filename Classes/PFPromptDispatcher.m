//
//  PFAlertViewDispatcher.m
//  Pants-Framework
//
//  Created by Paul Alexander on 11/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PFPromptDispatcher.h"

@implementation PFPromptDispatcher

-(void) dealloc
{
    SafeRelease( dispatches );
    
    [super dealloc];
}

-(id) initWithHandlers: (id)firstTarget, ...
{
    if( ( self = [super init] ) )
    {
        dispatches = [[NSMutableArray alloc] init];
        [dispatches addObject: [NSNull null]]; // Cancel button
        
        
        va_list args;
        va_start( args, firstTarget );
        
        id target = firstTarget;
        SEL action = va_arg( args, SEL );
        
        while( target )
        {
            PFDispatchTargetAction * dispatch = [[PFDispatchTargetAction alloc] initWithTarget: target action: action];
            [dispatches addObject: dispatch];
            [dispatch release];
            
            target = va_arg( args, id );
            action = va_arg( args, SEL );
        }
        
        va_end( args );
    }
    
    return self;    
}

-(void) dispatchWith: (id) source forIndex: (NSInteger) buttonIndex
{
    if( dispatches.count > buttonIndex )
    {    
        PFDispatchTargetAction * dispatch = [dispatches objectAtIndex: buttonIndex];
        if( (NSNull *)dispatch != [NSNull null] )
            [dispatch performWith: source];
    }
    
    [self release];
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger) buttonIndex
{
    [self dispatchWith: alertView forIndex: buttonIndex];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dispatchWith: actionSheet forIndex: buttonIndex];
}

-(void) setHandlerTarget: (id) target action: (SEL) action forButtonIndex: (NSInteger) buttonIndex
{
    while( dispatches.count < buttonIndex )
        [dispatches addObject: [NSNull null]];
    
    PFDispatchTargetAction * dispatch = [[PFDispatchTargetAction alloc] initWithTarget: target action: action];
                                         
    
    [dispatches replaceObjectAtIndex: buttonIndex 
                          withObject: dispatch ];
    
    [dispatch release];
}

-(void) setCancelHandlerTarget: (id) target action: (SEL) action
{
    [self setHandlerTarget: target action: action forButtonIndex: 0];
}

@end



