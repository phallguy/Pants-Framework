//
//  CLLocationCoordinate2D+PFExtensions.m
//  Scavenger Hunt
//
//  Created by Paul Alexander on 9/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PFLocationTools.h"

#define kEarthRadius 6371

@implementation PFLocationTools

+(double) distanceBetween: (CLLocationCoordinate2D) origin and: (CLLocationCoordinate2D) destination
{
	double dlat = DegreesToRadians( origin.latitude - destination.latitude );
	double dlon	= DegreesToRadians( origin.longitude - destination.longitude );
	
	double a = sin( dlat / 2 ) * sin( dlat / 2 ) +
				cos( DegreesToRadians( origin.latitude ) ) * cos( DegreesToRadians( destination.latitude ) ) *
				sin( dlon / 2 ) * sin( dlon / 2 );
	double c = 2 * atan2( sqrt( a ), sqrt( 1 - a ) );
	
	return fabs( c * kEarthRadius ) * 1000;
}

@end
