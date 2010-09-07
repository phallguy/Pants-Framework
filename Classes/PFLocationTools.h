//
//  CLLocationCoordinate2D+PFExtensions.h
//  Scavenger Hunt
//
//  Created by Paul Alexander on 9/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PFLocationTools : NSObject

+(double) distanceBetween: (CLLocationCoordinate2D) origin and: (CLLocationCoordinate2D) destination;

@end
