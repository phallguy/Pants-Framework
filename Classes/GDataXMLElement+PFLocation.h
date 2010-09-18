//
//  GDataXmlElement+PFLocation.h
//  Pants-Framework
//
//  Created by Paul Alexander on 9/17/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GDataXMLNode.h"

@interface GDataXMLElement (PFLocation)

-(CLLocationCoordinate2D) locationFromElement: (GDataXMLElement*) element;

@end
