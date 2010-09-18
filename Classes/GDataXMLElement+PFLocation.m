//
//  GDataXmlElement+PFLocation.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/17/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "GDataXMLElement+PFLocation.h"
#import "GDataXML+PFXml.h"


@implementation GDataXMLElement (PFLocation)

-(CLLocationCoordinate2D) locationFromElement: (GDataXMLElement *) element
{
    return CLLocationCoordinate2DMake( [self doubleValueOfAttributeNamed: @"lat"], [self doubleValueOfAttributeNamed: @"long" ] );
}

@end
