//
//  PFImageCacheStaticTrimmer.m
//  Pants-Framework
//
//  Created by Paul Alexander on 10/29/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFImageCacheStaticTrimmer.h"
#import "PFCachedImage.h"

static PFImageCacheStaticTrimmer * sharedInstance = nil;

@implementation PFImageCacheStaticTrimmer

#pragma mark -
#pragma mark Singleton

+(PFImageCacheStaticTrimmer *) sharedTrimmer
{
    if( sharedInstance == nil )
    {
        @synchronized(self)
        {
            if( sharedInstance == nil )
            {
                sharedInstance = [[PFImageCacheStaticTrimmer alloc] init];
                return sharedInstance;
            }
        }
    }
    
    return sharedInstance;
}

+(id) allocWithZone: (NSZone *) zone
{
    if( sharedInstance == nil )
    {
        @synchronized( self )
        {
            if( sharedInstance == nil )
            {
                sharedInstance = [super allocWithZone: zone];
                
                [[NSNotificationCenter defaultCenter] addObserver: sharedInstance 
                                                         selector: @selector(didReceiveMemoryWarning:) 
                                                             name: UIApplicationDidReceiveMemoryWarningNotification 
                                                           object: nil];
                return sharedInstance;
            }
        }
    }
    
    return  nil;
}

-(id) copyWithzone: (NSZone *) zone { return self; }
-(id) retain { return self; }
-(NSUInteger) retainCount { return NSUIntegerMax; }
-(void) release {}
-(id) autorelease{ return self; }

-(void) didReceiveMemoryWarning: (NSNotification *) notification
{
    [self trim];
}


-(void) addImage: (PFCachedImage *) image
{
    @synchronized( self )
    {
        if( [images indexOfObject: image] == NSNotFound )
            [images addObject: image];
    }
}

-(void) removeImage: (PFCachedImage *) image
{
    @synchronized( self )
    {
        [images removeObject: image];
    }
}

-(void) trim
{
    @synchronized( self )
    {
        for( PFCachedImage * img in images )
        {
            [img trim];
        }
    }
}


@end
