//
//  PFImageCache.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/21/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFImageCache.h"
#import "PFCachedImage.h"
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
        
        
        NSSearchPathDirectory dir = 
#if DEBUG
        NSDocumentDirectory;
#else
        NSCachesDirectory;
#endif
        
        
        cachePath = [[[[NSSearchPathForDirectoriesInDomains( dir, NSUserDomainMask,  YES ) objectAtIndex: 0] 
                     stringByAppendingPathComponent: @"ImageCache" ] 
                     stringByAppendingPathComponent: [rootPath md5] ] retain];
        
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

- (NSString*) findMostSpecificImageForName: (NSString *) name
{
    NSString * ext = [name pathExtension];
	NSString * baseName = [rootPath stringByAppendingPathComponent: [name stringByDeletingPathExtension]];
	NSString * deviceBaseName = [self deviceSpecificNameFromName: baseName];
	NSString * imageName;
    NSFileManager * fm = [NSFileManager defaultManager];
	
	// Try device specific, resolution specific first
	if( scaleFactor != nil )
	{
		imageName = [[deviceBaseName stringByAppendingString: scaleFactor] stringByAppendingPathExtension: ext];
        if( [fm fileExistsAtPath: imageName] )
            return imageName;
	}
	
	// Try device specific
	imageName = [deviceBaseName stringByAppendingPathExtension: ext];
    if( [fm fileExistsAtPath: imageName] )
        return imageName;
    
	// Try resolution specific
	if( scaleFactor != nil )
	{
		imageName = [[baseName stringByAppendingString: scaleFactor] stringByAppendingPathExtension: ext];
        if( [fm fileExistsAtPath: imageName] )
            return imageName;
	}
	
	imageName = [baseName stringByAppendingPathExtension: ext];
    if( [fm fileExistsAtPath: imageName] )
        return imageName;
    
	return nil;
}

-(void) clampCapacity
{
    @synchronized( self )
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
                if( (NSNull *)img == [NSNull null] )
                {
                    if( oldestKey == nil )
                        oldestKey = key;
                    continue;
                }
                
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
}

-(UIImage*) imageNamed: (NSString *) imageName
{
    // Have to synchronize the entire method because the returned image
    // needs to be retained in the autorelease pool before it is returned
    // otherwise a trim of the image cache may release the image before
    // it is returned and retained by the caller.
    
    @synchronized(self)
    {   
        UIImage * result = [cachedImages objectForKey: imageName];
        if( ! result )
        {
            result = [PFCachedImage cachedImageWithPath: [self findMostSpecificImageForName: imageName]];
            
            if( result != nil )
            {
                [cachedImages setObject: result forKey: imageName];
                [self clampCapacity];
            }        
        }
        
        return [[result retain] autorelease];
    }
}

-(UIImage*) imageNamed: (NSString *) imageName forSize: (CGSize) size
{
    if( size.width <= 0 || size.height <= 0 )
        return nil;
    
    NSString * resolved = [self findMostSpecificImageForName: imageName];
    NSString * resolvedName = [[resolved pathComponents] lastObject];
    
    if( scaleFactor != nil )
    {
        NSRange range = [resolvedName rangeOfString: scaleFactor];
        if( range.location == NSNotFound )
        {
            resolvedName = [NSString stringWithFormat: @"%@%@.%@",
                        [resolvedName stringByDeletingPathExtension],
                        scaleFactor,
                        [resolvedName pathExtension]];
        }
    }
    
           
    NSString * cacheName = [NSString stringWithFormat: @"%@/img_at_%fx%f_for_%@", 
                                cachePath,
                                size.width,
                                size.height,
                                resolvedName
                            ];

    
    // Have to synchronize the entire method because the returned image
    // needs to be retained in the autorelease pool before it is returned
    // otherwise a trim of the image cache may release the image before
    // it is returned and retained by the caller.
    @synchronized( self )
    {
        UIImage * result = [cachedImages objectForKey: cacheName];

        if( ((NSNull *)result) == [NSNull null] )
            return nil;
        
        if( result )
            return [[result retain] autorelease];
        
        // Make sure our cache folder actually exists
        BOOL isDirectory;

        if( ! [[NSFileManager defaultManager] fileExistsAtPath: cachePath isDirectory: &isDirectory] || ! isDirectory )
        {
            [[NSFileManager defaultManager] createDirectoryAtPath: cachePath 
                                      withIntermediateDirectories: YES 
                                                       attributes: nil 
                                                            error: NULL];
        }
        
        if( [[NSFileManager defaultManager] fileExistsAtPath: cacheName] )
        {   
            // Only use the cached image if the original has not been modified since the cache was 
            // created.
            NSDate * originalModified = [[[NSFileManager defaultManager] attributesOfItemAtPath: resolved error: NULL] objectForKey: NSFileModificationDate];
            NSDate * cacheModified = [[[NSFileManager defaultManager] attributesOfItemAtPath: cacheName error: NULL] objectForKey: NSFileModificationDate];
            
            if( [originalModified compare: cacheModified] == NSOrderedAscending )
            {
                // See if we've sized it and saved that before
                result = [PFCachedImage cachedImageWithPath: cacheName];
                
                if( result != nil )
                {
                    [cachedImages setObject: result forKey: imageName];
                    [self clampCapacity];            

                    return [[result retain] autorelease];
                }
            }
        }

        // Adjust dimensions to automatically scale to the screen
        CGFloat scale = [[UIScreen mainScreen] scale];
        size = CGSizeMake( size.width * scale, size.height * scale );

               
        // Resize the image and cache it
        UIImage * original = [UIImage imageWithContentsOfFile: resolved];
        
        if( original == nil )
        {
            [cachedImages setObject: [NSNull null] forKey: cacheName];
            return nil;
        }
        
        CGFloat originalScale = 1.0;
        if( [original respondsToSelector: @selector(scale)] )
            originalScale = original.scale;
        
        
        if( original.size.width * originalScale == size.width && original.size.height * originalScale == size.height )
        {
            [[NSFileManager defaultManager] copyItemAtPath: resolved toPath: cacheName error: NULL];
        }
        else
        {
            result = [original resizedImage: size interpolationQuality: kCGInterpolationHigh];
            NSAssert( result.CGImage, @"Couldn't resize image" );
            
            NSData * data;
            
            if( [[imageName pathExtension] compare: @"png"] == NSOrderedSame )
                data = UIImagePNGRepresentation( result );
            else
                data = UIImageJPEGRepresentation( result, 100 );
            
            NSAssert( data, @"Couldn't save image" );
            
            [data writeToFile: cacheName atomically: NO];
        }
        
        result = [PFCachedImage cachedImageWithPath: cacheName];
        
        
        [cachedImages setObject: result forKey: cacheName];
        [self clampCapacity];
    
        return [[result retain] autorelease];
    }    
}

-(void) trim
{
    @synchronized(self)
    {
        NSLog( @"**** PFImageCache trimming"  );
        
        time_t now = time( NULL );
        
        NSEnumerator * e = cachedImages.keyEnumerator;
        id key;
        
        NSMutableArray * deadKeys = [[NSMutableArray alloc] init];
        
        while( key = [e nextObject] )
        {
            PFCachedImage * img = [cachedImages objectForKey: key];
            
            if( ((NSNull*)img) == [NSNull null] )
                [deadKeys addObject: key];
            else
            {
                [img trim];
            
                 // Hasn't been used in the last 2 minutes, so probabbly don't need it soon
                if( now - img.timestamp > 120 )
                    [deadKeys addObject: key];
            }
        }       
        
        for( key in deadKeys )
        {
            [cachedImages removeObjectForKey: key];
        }
    }
}

-(void) clear
{
    @synchronized( self )
    {
        [cachedImages removeAllObjects];
    }
}

@end
