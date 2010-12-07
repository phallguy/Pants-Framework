//
//  PFVersion.m
//  Pants-Framework
//
//  Created by Paul Alexander on 12/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PFVersion.h"


@implementation PFVersion

@synthesize major, minor, release, original, moniker;

-(void) dealloc 
{
    
    SafeRelease( original );
    SafeRelease( moniker );
    
    [super dealloc];
}

-(id) initWithString: (NSString *) version
{
    if( version == nil )
    {
        [self release];
        return nil;
    }
    
    if( ( self = [super init] ) )
    {
        original = [version copy];
        
        NSArray * parts = [original componentsSeparatedByString: @"."];
        if( parts.count > 0 )
            major = [[parts objectAtIndex: 0] intValue];
        else
            major = -1;
        if( parts.count > 1 )
            minor = [[parts objectAtIndex: 1] intValue];
        else
            minor = -1;
        if( parts.count > 2 )
            release = [[parts objectAtIndex: 2] intValue];
        else
            release = -1;
        
        if( parts.count > 3 )
            moniker = [[parts objectAtIndex: 3] copy];
        else
        {
            NSString * val = [parts lastObject];
            NSRange range = [val rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @" \t"]];
            
            if( range.location != NSNotFound )
            {
                moniker = [[val substringFromIndex: range.location + 1] copy];
            }
        }
    }
    
    return self;
}

-(id) copyWithZone: (NSZone *) zone
{
    PFVersion * copy = [[PFVersion allocWithZone: zone] initWithString: original];
    
    copy.major = major;
    copy.minor = minor;
    copy.release = release;
    copy.moniker = moniker;
    
    return copy;
}

-(id) initWithCoder: (NSCoder *) coder
{
    if( ( self = [super init] ) )
    {
        major = [[coder valueForKey: @"major"] intValue];
        minor = [[coder valueForKey: @"minor"] intValue];
        release = [[coder valueForKey: @"release"] intValue];
        
        if( [coder containsValueForKey: @"original"] )
            original = [[coder valueForKey: @"original"] copy];
        
        if( [coder containsValueForKey: @"moniker"] )
            moniker = [[coder valueForKey: @"moniker"] copy];
    }
    
    return self;
}

-(void) encodeWithCoder: (NSCoder *) coder
{
    [coder setValue: [NSNumber numberWithInt: major] forKey: @"major"];
    [coder setValue: [NSNumber numberWithInt: minor] forKey: @"minor"];
    [coder setValue: [NSNumber numberWithInt: release] forKey: @"release"];

    if( original )
        [coder setValue: original forKey: @"original"];
    if( moniker )
        [coder setValue: moniker forKey: @"moniker"];
}


+(PFVersion *) versionFromString:(NSString *)version
{
    if( ! version )
        return nil;
    return [[[PFVersion alloc] initWithString: version] autorelease];
}

-(NSString *) stringValue
{
    if( major == -1 )
        return @"";
    
    if( minor == -1 )
        return [NSString stringWithFormat: @"%d", major];
    
    if( release == -1 )
        return [NSString stringWithFormat: @"%d.%d", major, minor];
    
    if( moniker == nil )
        return [NSString stringWithFormat: @"%d.%d.%d", major, minor, release];
    
    return [NSString stringWithFormat: @"%d.%d.%d %@", major, minor, release, moniker];
}

-(NSString *) description
{
    return [self stringValue];
}

#define COMPARE_INT(x,y) x > y ? NSOrderedDescending : ( x < y ? NSOrderedAscending : NSOrderedSame )

-(NSComparisonResult) compare: (PFVersion *) comparand
{

    NSComparisonResult result = COMPARE_INT( major, comparand.major );
    
    if( result != NSOrderedSame )
        return result;
    
    result = COMPARE_INT( minor, comparand.minor );
    if( result != NSOrderedSame )
        return result;
    
    result = COMPARE_INT( release, comparand.release );
    if( result != NSOrderedSame )
        return result;
    
    if( moniker != nil )
    {
        return [moniker compare: comparand.moniker];
    }
    else if( comparand.moniker != nil )
        return NSOrderedAscending;
    
    
    return NSOrderedSame;
}
@end
