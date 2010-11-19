//
//  PFXmlTools.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/17/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "GDataXML+PFXml.h"
#import "UIColor+PFExtensions.h"
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
    NSString * str = [self stringValueOfAttributeNamed: name];
    double value = [str doubleValue];
    return value;
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

-(NSDate *) isoDateValueOfAttributeNamed: (NSString *) name
{
    NSString * val = [self stringValueOfAttributeNamed: name];
    if( val == nil )
        return nil;
    
    return [NSDate dateFromIsoString: val];
}

-(UIColor *) colorValueOfAttributeNamed: (NSString *) name
{
    NSString * val = [self stringValueOfAttributeNamed: name];
    if( val == nil )
        return nil;
    
    return [UIColor colorFromRgbHex: val];
}

-(BOOL) boolValueOfAttributeNamed: (NSString *) name
{
    return [self boolValueOfAttributeNamed: name withDefault: NO];
}

-(BOOL) boolValueOfAttributeNamed: (NSString *) name withDefault: (BOOL) defaultValue
{
    NSString * val = [self stringValueOfAttributeNamed: name];
    if( ! val )
        return defaultValue;
    
    if( [val caseInsensitiveCompare: @"YES" ] == NSOrderedSame ||
           [val caseInsensitiveCompare: @"Y" ] == NSOrderedSame ||
           [val caseInsensitiveCompare: @"TRUE" ] == NSOrderedSame ||
           [val caseInsensitiveCompare: @"T" ] == NSOrderedSame ||
           [val caseInsensitiveCompare: @"1" ] == NSOrderedSame )
        return YES;
    
    return NO;
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


-(void) setAttributeWithName: (NSString *) name toValue: (NSString *) value
{
    GDataXMLNode * attr = [self attributeForName: name];
    if( attr == nil )
    {
        attr = [GDataXMLNode attributeWithName: name stringValue: value];
        [self addAttribute: attr];
    }
    else
    {
        [attr setStringValue: value];
    }
}

@end


@implementation NSString (PFXml)

-(GDataXMLElement*) xml
{
    GDataXMLDocument * doc = [[[GDataXMLDocument alloc] initWithXMLString: self options: 0 error: NULL] autorelease];
    return doc.rootElement;
}

@end


@implementation NSDate (PFXml)

-(NSString *) isoStringValue
{
    NSDateFormatter * f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    NSString * result = [f stringFromDate: self];    
    [f release];
    
    return result;
}

+(NSDate *) dateFromIsoString: (NSString *) value
{
    NSDateFormatter * f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    NSDate * date = [f dateFromString: value];
    [f release];
    return date;
}

@end


