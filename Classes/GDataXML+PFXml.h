//
//  PFXmlTools.h
//  Pants-Framework
//
//  Created by Paul Alexander on 9/17/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GDataXMLNode.h"



@interface GDataXMLNode (PFXml)


@end

@interface GDataXMLElement (PFXml)


-(NSString *) stringValueOfAttributeNamed: (NSString *) name;
-(int) intValueOfAttributeNamed: (NSString *) name;
-(double) doubleValueOfAttributeNamed: (NSString *) name;
-(NSDate*) dateValueOfAttributeNamed: (NSString *) name;

-(NSString *) stringValueOfElementNamed: (NSString *) name;


-(GDataXMLElement*) firstElementForName: (NSString *) name;
-(CLLocationCoordinate2D) coordinateFromElementName: (NSString*) name;
-(CLLocationCoordinate2D) coordinateFromElement;

@end

@interface NSString (PFXml)
-(GDataXMLElement*) xml;
@end