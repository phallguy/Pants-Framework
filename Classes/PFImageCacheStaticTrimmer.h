//
//  PFImageCacheStaticTrimmer.h
//  Pants-Framework
//
//  Created by Paul Alexander on 10/29/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFCachedImage;

@interface PFImageCacheStaticTrimmer : NSObject 
{
@private
    NSMutableArray * images;
}

-(void) addImage: (PFCachedImage *) image;
-(void) removeImage: (PFCachedImage *) image;
-(void) trim;

+(PFImageCacheStaticTrimmer *) sharedTrimmer;

@end
