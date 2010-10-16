//
//  CALayer+PFExtensions.h
//  Pants-Framework
//
//  Created by Paul Alexander on 10/16/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CALayer (PFExtensions)

-(void) popBounceWithMinimumScale: (CGFloat) minScale  
                     maximumScale: (CGFloat) maxScale 
                          tension: (CGFloat) tension 
                         duration: (CFTimeInterval) duration;

@end
