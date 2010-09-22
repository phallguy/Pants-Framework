//
//  PFImageCache.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/21/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFImageCache.h"
#import "PFCachedImage.h"
#import "PFUtility.h"
#import "UIImage+Resize.h"

@interface PFImageCache ()

-(void) didReceiveMemoryWarning: (NSNotification *) notification;

@end


@implementation PFImageCache

-(void) dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];

    SafeRelease( rootPath );
    SafeRelease( cachePath );
    SafeRelease( cachedImages );
    SafeRelease( scaleFactor );
    
    
    [super dealloc];
}

-(id) initWithRootPath: (NSString *) newRootPath capacity: (NSInteger) capacity
{
    if( self = [super init] )
    {
        rootPath = [newRootPath copy];
        cachedImages = [[NSMutableDictionary alloc] init];
        maxCapacity = capacity;
        
        cachePath = [[[NSSearchPathForDirectoriesInDomains( NSCachesDirectory, NSUserDomainMask,  YES ) objectAtIndex: 0] 
                     stringByAppendingPathComponent: @"ImageCache" ] 
                     stringByAppendingPathComponent: [rootPath md5] ];
        
        CGFloat scale = [[UIScreen mainScreen] scale];
		
		if( scale != 1.0f )
			scaleFactor = [[NSString stringWithFormat: @"@%.0fx", scale] retain];
        else
            scaleFactor = nil;
        
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(didReceiveMemoryWarning:) 
                                                     name: UIApplicationDidReceiveMemoryWarningNotification 
                                                   object: nil];
    }
    
    return self;
}

-(void) didReceiveMemoryWarning: (NSNotification *) notification
{
    [self trim];
}


- (NSString *) deviceSpecificNameFromName: (NSString *) baseName  
{
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad )
		return [baseName stringByAppendingString: @"~ipad"];
	else
		return [baseName stringByAppendingString: @"~iphone"];
}

- (UIImage*) findMostSpecificImageForName: (NSString *) name inFolder: (NSString *) baseFolder
{
	PFCachedImage * img;
    NSString * ext = [name pathExtension];
	NSString * baseName = [baseFolder stringByAppendingPathComponent: [name stringByDeletingPathExtension]];
	NSString * deviceBaseName = [self deviceSpecificNameFromName: baseName];
	NSString * imageName;
	
	// Try device specific, resolution specific first
	if( scaleFactor != nil )
	{
		imageName = [[deviceBaseName stringByAppendingString: scaleFactor] stringByAppendingPathExtension: ext];
		img = [PFCachedImage cachedImageWithPath: imageName];		
		if( img != nil ) return img;
	}
	
	// Try device specific
	imageName = [deviceBaseName stringByAppendingPathExtension: ext];
	img = [PFCachedImage cachedImageWithPath: imageName];				
	if( img != nil ) return img;
	
	// Try resolution specific
	if( scaleFactor != nil )
	{
		imageName = [[baseName stringByAppendingString: scaleFactor] stringByAppendingPathExtension: ext];
		img = [PFCachedImage cachedImageWithPath: imageName];		
		if( img != nil ) return img;
	}
	
	// Try raw
	imageName = [baseName stringByAppendingPathExtension: ext];
	return [PFCachedImage cachedImageWithPath: imageName];
}

-(void) clampCapacity
{
    // Naive approach that continues to remove the oldest image until the capacity
    // is reduced to less than max capactiy. Should be OK since we should only ever 
    // add one to the image cache and exceed maxCapacity by one.
    while( cachedImages.count > maxCapacity )
    {
        PFCachedImage * oldest = nil;
        id oldestKey;
        
        NSEnumerator * e = cachedImages.keyEnumerator;
        id key;
        
        while( key = [e nextObject] )
        {
            PFCachedImage * img = [cachedImages objectForKey: key];
            if( oldest == nil || img.timestamp < oldest.timestamp )
            {
                oldest = img;
                oldestKey = key;
            }
        }
        
        if( oldestKey )
        {
            [cachedImages removeObjectForKey: oldestKey];
        }
        else
        {
            break;
        }
    }
}

-(UIImage*) imageNamed: (NSString *) imageName
{
    @synchronized(self)
    {
        UIImage * result;
        
        result = [cachedImages objectForKey: imageName];
        if( result )
            return result;
                
        result = [self findMostSpecificImageForName: imageName inFolder: rootPath];
        
        if( result != nil )
        {
            [cachedImages setObject: result forKey: imageName];
            [self clampCapacity];            

        }
        
        
        return  result;
    }
}

-(UIImage*) imageNamed: (NSString *) imageName forSize: (CGSize) size
{
    NSString * cacheName = [NSString stringWithFormat: @"%@_%fx%f%@", [imageName stringByDeletingPathExtension], size.width, size.height, [imageName pathExtension]];
    
    @synchronized( self )
    {
        UIImage * result = [cachedImages objectForKey: cacheName];
        if( result )
            return result;
        
        BOOL isDirectory;
        if( ! [[NSFileManager defaultManager] fileExistsAtPath: cachePath isDirectory: &isDirectory] || ! isDirectory )
        {
            [[NSFileManager defaultManager] createDirectoryAtPath: cachePath withIntermediateDirectories: YES attributes: nil error: NULL];
        }
        
        // See if we've sized it and saved that before
        result = [self findMostSpecificImageForName: cacheName inFolder: cachePath];
        if( result != nil )
        {
            [cachedImages setObject: result forKey: imageName];
            [self clampCapacity];            
            return result;
        }
        
        // Resize the image and cache it
        UIImage * original = [self imageNamed: imageName];
        result = [original resizedImage: size interpolationQuality: kCGInterpolationHigh];

        NSData * data;
        
        if( [[imageName pathExtension] compare: @"png"] == NSOrderedSame )
            data = UIImagePNGRepresentation( result );
        else
            data = UIImageJPEGRepresentation( result, 100 );
        
        [data writeToFile: [cachePath stringByAppendingPathComponent: cacheName] atomically: NO];
        
        return result;
    }
}

-(void) trim
{
    @synchronized(self)
    {
        time_t now = time( NULL );
        
        NSEnumerator * e = cachedImages.keyEnumerator;
        id key;
        
        while( key = [e nextObject] )
        {
            PFCachedImage * img = [cachedImages objectForKey: key];
            
            [img trim];
            
             // Hasn't been used in the last 2 minutes, so probabbly don't need it soon
            if( now - img.timestamp > 120 )
                [cachedImages removeObjectForKey: key];
        }       
        
    }
}

@end
