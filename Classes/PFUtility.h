//
//  Utility.h
//  Surveyor
//
//  Created by Paul Alexander on 7/19/10.
//  Copyright 2010 XHEO INC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PFUtility : NSObject 
{

}

+(NSString*) createUuid;

@end

@interface NSString (PFUtility)

-(NSString*) md5;

@end
