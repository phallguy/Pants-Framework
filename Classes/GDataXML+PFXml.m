//
//  PFXmlTools.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/17/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "GDataXML+PFXml.h"
#import <CoreLocation/CoreLocation.h>

@implementation GDataXMLNode (PFXml)



@end

@implementation GDataXMLElement (PFXml)

-(NSString *) stringValueOfAttributeNamed: (NSString *) name
{
    GDataXMLNode * attr = [self attributeForName: name];
    return attr.stringValue;
}

-(int) intValueOfAttributeNamed: (NSString *) name
{
    NSString * value = [self stringValueOfAttributeNamed: name];
    
    return [value intValue];    
}

-(double) doubleValueOfAttributeNamed: (NSString *) name
{
    return [[self stringValueOfAttributeNamed: name] doubleValue];
}

-(NSDate*) dateValueOfAttributeNamed: (NSString *) name
{
    NSString * val = [self stringValueOfAttributeNamed: name];
    
    if( val == nil )
        return  nil;
    
    NSDateFormatter * f = [[NSDateFormatter alloc] init];
    NSDate * date = [f dateFromString: val];
    [f release];
    
    return date;
}



-(GDataXMLElement *) firstElementForName: (NSString *) name
{
    NSArray * elements = [self elementsForName: name];
    
    if( elements == nil || elements.count == 0 )
        return nil;
    
    return [elements objectAtIndex: 0];
}




-(NSString *) stringValueOfElementNamed: (NSString *) name
{
    return [[self firstElementForName: name] stringValue];
}

-(CLLocationCoordinate2D) coordinateFromElement
{

    CLLocationCoordinate2D coord = { [self doubleValueOfAttributeNamed: @"lat"], [self doubleValueOfAttributeNamed: @"long"] };

    return coord;
}

-(CLLocationCoordinate2D) coordinateFromElementName: (NSString*) name
{
    GDataXMLElement * element = [self firstElementForName: name];
    
    if( element == nil )
        return CLLocationCoordinate2DMake( 0, 0 );
    
    CLLocationCoordinate2D coord = { [element doubleValueOfAttributeNamed: @"lat"], [element doubleValueOfAttributeNamed: @"long"] };
    
    return coord;
}


@end


@implementation NSString (PFXml)

-(GDataXMLElement*) xml
{
    GDataXMLDocument * doc = [[[GDataXMLDocument alloc] initWithXMLString: self options: 0 error: NULL] autorelease];
    return doc.rootElement;
}

@end