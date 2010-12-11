//
//  UIDevice+PFExtensions.m
//  Pants-Framework
//
//  Created by Paul Alexander on 12/10/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "UIDevice+PFExtensions.h"
#include <sys/types.h>
#include <sys/sysctl.h>

const NSString * platformMap[][2] = {
    { @"iPhone1,1", @"iPhone 1G" },
    { @"iPhone1,2", @"iPhone 3G" },
    { @"iPhone2,1", @"iPhone 3GS" },
    { @"iPhone3,1", @"iPhone 4" },
    { @"iPod1,1", @"iPod 1G" },
    { @"iPod2,1", @"iPod 2G" },
    { @"iPod3,1", @"iPod 3G" },
    { @"iPod4,1", @"iPad" },
    { @"i386", @"Simulator" },
};

@implementation UIDevice (PFExtensions)


-(NSString *) platform
{
    size_t size;
    sysctlbyname( "hw.machine", NULL, &size, NULL, 0 );
    char * machine = malloc( size );
    sysctlbyname( "hw.machine", machine, &size, NULL, 0 );
    NSString * platform = [NSString stringWithCString: machine encoding: NSASCIIStringEncoding];
    free( machine );   
    
    return platform;
}

-(NSString *) platformCommonName
{
    NSString * platform = [self platform];
    for( int ix = 0; ix < sizeof(platformMap); ix++ )
    {
        NSString ** touple = platformMap[ix];
        
        if( [touple[0] isEqualToString: platform] )
            return [touple[1] autorelease];
    }
    
    return  platform;
}

-(unsigned long long) storageSize
{
    NSString * path = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) lastObject];
    NSDictionary * dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath: path error: NULL];
    
    if( ! dic )
        return 8000000000; // Assumne minimum of 8 "GB" device
    
    return [[dic objectForKey: NSFileSystemSize] unsignedLongLongValue];
}

-(NSString *) storageSizeCommonName
{
    unsigned long long rawsize = [self storageSize];
    double size = ceil( rawsize / 1000000000.0 ); // Convert to GB
    
    return [NSString stringWithFormat: @"%d GB", (long)size];
}

-(NSString *) versionString
{
    return [NSString stringWithFormat: @"%@ %@ with iOS version %@",
            [self platformCommonName],
            [self storageSizeCommonName],
            [self systemVersion]];
}

@end
