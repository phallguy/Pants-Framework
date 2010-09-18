//
//  PFXmlTools.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/17/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "GDataXML+PFXml.h"

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



@end