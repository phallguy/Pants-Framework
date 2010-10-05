//
//  Utility.m
//  Surveyor
//
//  Created by Paul Alexander on 7/19/10.
//  Copyright 2010 XHEO INC. All rights reserved.
//

#import "PFUtility.h"
#import <CommonCrypto/CommonDigest.h>

#import <sys/types.h>
#import <unistd.h>
#import <sys/sysctl.h>


@implementation PFUtility

+(NSString*) createUuid
{
	CFUUIDRef puuid = CFUUIDCreate( nil );
	CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
	CFRelease(puuid);
	return [(NSString *)uuidString autorelease];
}


@end


@implementation NSString (PFUtility )

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


@end

#if DEBUG
extern bool AmIBeingDebugged(void)
// Returns true if the current process is being debugged (either
// running under the debugger or has a debugger attached post facto).
{
    int                 junk;
    int                 mib[4];
    struct kinfo_proc   info;
    size_t              size;
    
    // Initialize the flags so that, if sysctl fails for some bizarre
    // reason, we get a predictable result.
    
    info.kp_proc.p_flag = 0;
    
    // Initialize mib, which tells sysctl the info we want, in this case
    // we're looking for information about a specific process ID.
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();
    
    // Call sysctl.
    
    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    assert(junk == 0);
    
    // We're being debugged if the P_TRACED flag is set.
    
    return ( (info.kp_proc.p_flag & P_TRACED) != 0 );
}
#endif