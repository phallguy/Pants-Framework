//
//  PFDispatchTargetAction.h
//  Pants-Framework
//
//  Created by Paul Alexander on 11/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PFDispatchTargetAction : NSObject
{
    
@private
    id target;
    SEL action;
}

@property( nonatomic, readonly ) id target;
@property( nonatomic, readonly ) SEL action;

-(id) initWithTarget: (id) target action: (SEL) action;
+(PFDispatchTargetAction *) dispatchWithTarget: (id) target action: (SEL) action;

-(void) performWith: (id) withObject;

@end