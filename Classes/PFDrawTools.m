//
//  PFDrawTools.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PFDrawTools.h"


@implementation PFDrawTools


+(CGMutablePathRef) createPathForRect: (CGRect) rect withCornerRadius: (CGFloat) radius;
{
	return [PFDrawTools createPathForRect: rect withCornerRadius: radius andCorners: kPFCornerRadiusCornersAll];
}

+(CGMutablePathRef) createPathForRect: (CGRect) rect withCornerRadius: (CGFloat) radius andCorners: (PFCornerRadiusCorners) corners;
{
    CGMutablePathRef path = CGPathCreateMutable();
	
    if( corners & kPFCornerRadiusCornersTopLeft )
    {
        CGPathMoveToPoint( path, 
                      nil, 
                      CGRectGetMinX( rect ) + radius, 
                      CGRectGetMinY( rect ) );
    }
    else
    {
        CGPathMoveToPoint( path, 
                          nil, 
                          CGRectGetMinX( rect ) , 
                          CGRectGetMinY( rect ) );
    }
	
	
    // top right arc
    if( corners & kPFCornerRadiusCornersTopRight )
    {
        CGPathAddArc( path, 
                     nil, 
                     CGRectGetMaxX( rect ) - radius, 
                     CGRectGetMinY( rect ) + radius, 
                     radius, 
                     -M_PI / 2, 
                     0,
                     NO );
    }
    else
    {
        CGPathAddLineToPoint( path, NULL, CGRectGetMaxX( rect ), CGRectGetMinY( rect ) );
    }
	
	// bottom right arc
    if( corners & kPFCornerRadiusCornersBottomRight )
    {
        CGPathAddArc( path, 
                     nil, 
                     CGRectGetMaxX( rect ) - radius, 
                     CGRectGetMaxY( rect ) - radius, 
                     radius, 
                     0, 
                     M_PI / 2,
                     NO );
    }
    else
    {
        CGPathAddLineToPoint( path, NULL, CGRectGetMaxX( rect ), CGRectGetMaxY( rect ) );
    }
		
	// bottom left arc
    if( corners & kPFCornerRadiusCornersBottomLeft )
    {
        CGPathAddArc( path, 
                     nil, 
                     CGRectGetMinX( rect ) + radius, 
                     CGRectGetMaxY( rect ) - radius, 
                     radius, 
                     M_PI / 2, 
                     M_PI,
                     NO );
    }
    else
    {
        CGPathAddLineToPoint( path, NULL, CGRectGetMinX( rect ), CGRectGetMaxY( rect ) );
    }
    
	// top left arc
	if( corners & kPFCornerRadiusCornersTopLeft )
    {
        CGPathAddArc( path, 
                     nil, 
                     CGRectGetMinX( rect ) + radius, 
                     CGRectGetMinY( rect ) + radius, 
                     radius, 
                     M_PI, 
                     M_PI * 1.5,
                     NO );
	}
	
	CGPathCloseSubpath( path );
    
    return path;
}

+(CGRect) calculateGlassRect: (CGRect) rect shadowDepth: (CGFloat) shadowDepth
{
	return CGRectMake( CGRectGetMinX( rect ) + 1.5, 
                       CGRectGetMinY( rect ) + 1.5, 
                       CGRectGetWidth( rect ) - shadowDepth, 
                       CGRectGetHeight( rect ) - shadowDepth );     
}

+(CGRect) drawGlassInContext: (CGContextRef) g 
                   forRect: (CGRect) rect 
                     color: (UIColor *) color
          withCornerRadius: (CGFloat) cornerRadius 
               borderWidth: (CGFloat) borderWidth 
               shadowDepth: (CGFloat) shadowDepth

{
	CGRect r = [PFDrawTools calculateGlassRect: rect shadowDepth: shadowDepth];
	CGPathRef path = [PFDrawTools createPathForRect: r withCornerRadius: cornerRadius];
		
	CGContextSaveGState( g );
	
	CGContextAddRect( g, rect );
	CGContextAddPath( g, path );
	CGContextEOClip( g );
	
	CGContextAddPath( g, path );
	CGContextSetShadowWithColor( g, CGSizeMake( ( shadowDepth / 3 ) - 1.5, ( shadowDepth / 3 ) - 1.5 ), shadowDepth,
								[[UIColor colorWithRed: 0 green: 0 blue: 0 alpha: .65] CGColor]);
	CGContextFillPath( g );
	
	CGContextRestoreGState( g );
	
	[[color colorWithAlphaComponent: .5] set];
	CGContextAddPath( g, path );
	CGContextFillPath( g );
	
	[color set];
	
	CGContextAddPath( g, path );
	CGContextStrokePath( g );
	
	CGPathRelease( path );
	
	CGPathRef innerPath = [PFDrawTools createPathForRect: CGRectInset( r, borderWidth / 2.25, borderWidth / 2.25 ) withCornerRadius: cornerRadius / 1.5];
	CGContextAddPath( g, innerPath );
	CGContextFillPath( g );
	
	CGPathRelease( innerPath );
    
    return r;
}

+(void) fillPath: (CGPathRef) path inContext: (CGContextRef) g withGradientUIColors: (NSArray *) uiColors
{
    [PFDrawTools fillPath: path inContext: g withGradientUIColors: uiColors atLocations: nil];
}

+(void) fillPath: (CGPathRef) path inContext: (CGContextRef) g withGradientUIColors: (NSArray *) uiColors atLocations: (NSArray *) locations
{
    CGContextAddPath( g, path );
    CGContextSaveGState( g );
    CGContextClip( g );
    
    CGColorRef colors[ uiColors.count ];
    CGRect boundingBox = CGPathGetBoundingBox( path );
    
    for( int ix = 0; ix < uiColors.count; ix++ )
    {
        UIColor * clr = [uiColors objectAtIndex: ix];
        colors[ ix ] = [clr CGColor];
    }
    	
	CFArrayRef colorsRef = CFArrayCreate( NULL, (const void**)colors, uiColors.count, NULL );
    CGFloat locationsRef[ locations.count ];
    if( locations )
    {
        for( int ix = 0; ix < locations.count; ix++ )
        {
            locationsRef[ix] = [[locations objectAtIndex: ix] floatValue];
        }
    }
	
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradientRef = CGGradientCreateWithColors( colorSpaceRef, colorsRef, locations ? locationsRef : NULL );
    
	CGContextDrawLinearGradient( g, 
                                gradientRef, 
                                CGPointMake( 0, CGRectGetMinY( boundingBox ) ), 
                                CGPointMake( 0, CGRectGetMaxY( boundingBox ) ),
                                kCGGradientDrawsBeforeStartLocation );
    
	CGColorSpaceRelease( colorSpaceRef );
	CGGradientRelease( gradientRef );
	CFRelease( colorsRef );
    CGContextRestoreGState( g );
    
}

+(void) fillRect: (CGRect) boundingBox inContext: (CGContextRef) g withGradientUIColors: (NSArray *) uiColors
{
    CGColorRef colors[ uiColors.count ];
    
    for( int ix = 0; ix < uiColors.count; ix++ )
    {
        UIColor * clr = [uiColors objectAtIndex: ix];
        colors[ ix ] = [clr CGColor];
    }
	
	CFArrayRef colorsRef = CFArrayCreate( NULL, (const void**)colors, uiColors.count, NULL );
	
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradientRef = CGGradientCreateWithColors( colorSpaceRef, colorsRef, NULL );
    
	CGContextDrawLinearGradient( g, 
                                gradientRef, 
                                CGPointMake( 0, CGRectGetMinY( boundingBox ) ), 
                                CGPointMake( 0, CGRectGetMaxY( boundingBox ) ),
                                kCGGradientDrawsBeforeStartLocation );
    
	CGColorSpaceRelease( colorSpaceRef );
	CGGradientRelease( gradientRef );
	CFRelease( colorsRef );
    
}

@end
