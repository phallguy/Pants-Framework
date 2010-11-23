//
//  PFAlertViewDispatcher.h
//  Pants-Framework
//
//  Created by Paul Alexander on 11/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFDispatchTargetAction.h"


@interface PFPromptDispatcher : NSObject <UIAlertViewDelegate, UIActionSheetDelegate> 
{

@private
    NSMutableArray * dispatches;
    
}

-(void) setHandlerTarget: (id) target action: (SEL) action forButtonIndex: (NSInteger) buttonIndex;
-(void) setCancelHandlerTarget: (id) target action: (SEL) action;

-(id) initWithHandlers: (id) firstTarget,...;

@end
