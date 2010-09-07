//
//  Utility.m
//  Surveyor
//
//  Created by Paul Alexander on 7/19/10.
//  Copyright 2010 XHEO INC. All rights reserved.
//

#import "PFUtility.h"


@implementation PFUtility

+(NSString*) createUuid
{
	CFUUIDRef puuid = CFUUIDCreate( nil );
	CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
	CFRelease(puuid);
	return [(NSString *)uuidString autorelease];
}

@end
