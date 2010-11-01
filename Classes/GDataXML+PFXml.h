//
//  PFXmlTools.h
//  Pants-Framework
//
//  Created by Paul Alexander on 9/17/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GDataXMLNode.h"



@interface GDataXMLNode (PFXml)


@end

@interface GDataXMLElement (PFXml)


-(NSString *) stringValueOfAttributeNamed: (NSString *) name;
-(int) intValueOfAttributeNamed: (NSString *) name;
-(double) doubleValueOfAttributeNamed: (NSString *) name;
-(NSDate *) dateValueOfAttributeNamed: (NSString *) name;
-(NSDate *) isoDateValueOfAttributeNamed: (NSString *) name;
-(UIColor *) colorValueOfAttributeNamed: (NSString *) name;
-(BOOL) boolValueOfAttributeNamed: (NSString *) name;
-(BOOL) boolValueOfAttributeNamed: (NSString *) name withDefault: (BOOL) defaultValue;

-(NSString *) stringValueOfElementNamed: (NSString *) name;


-(GDataXMLElement*) firstElementForName: (NSString *) name;
-(CLLocationCoordinate2D) coordinateFromElementName: (NSString*) name;
-(CLLocationCoordinate2D) coordinateFromElement;


-(void) setAttributeWithName: (NSString *) name toValue: (NSString *) value;

@end

@interface NSString (PFXml)
-(GDataXMLElement*) xml;
@end

@interface NSDate (PFXml) 

-(NSString *) isoStringValue;
+(NSDate *) dateFromIsoString: (NSString *) value;

@end

@interface UIColor (PFXml)

-(NSString *) rgbHexValue;
+(UIColor *) colorFromRgbHex: (NSString *) value;

@end