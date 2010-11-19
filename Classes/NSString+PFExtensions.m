//
//  NSString+PFExtensions.m
//  Pants-Framework
//
//  Created by Paul Alexander on 10/7/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "NSString+PFExtensions.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (PFExtensions)

-(NSString*) md5
{
    const char * cstr = [self UTF8String];
    unsigned char result[ CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cstr, strlen( cstr ), result );
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSString*) uuid
{
	CFUUIDRef puuid = CFUUIDCreate( nil );
	CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);
	CFRelease(puuid);
    CFRelease(uuidString);
    
	return [result autorelease];
}

@end
