//
//  PFImageCache.h
//  Pants-Framework
//
//  Created by Paul Alexander on 9/21/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface PFImageCache : NSObject 
{
@private
    NSString * rootPath;
    NSString * cachePath;
    NSString * scaleFactor;
    NSMutableDictionary * cachedImages;
    
    NSInteger maxCapacity;
}

-(id) initWithRootPath: (NSString*) newRootPath capacity: (NSInteger) capacity;
-(UIImage*) imageNamed: (NSString*) imageName;
-(UIImage*) imageNamed: (NSString*) imageName forSize: (CGSize) size;

-(void) trim;
-(void) clear;

@end
