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
	CGMutablePathRef path = CGPathCreateMutable();
	
	// top left inside arc
	CGPathMoveToPoint( path, 
					   nil, 
					   CGRectGetMinX( rect ) + radius, 
					   CGRectGetMinY( rect ) );
	
	// top border
	CGPathAddLineToPoint( path, 
						  nil, 
						  CGRectGetMaxX( rect ) - radius, 
						  CGRectGetMinY( rect ) );
	
	// top right arc
	CGPathAddArc( path, 
				  nil, 
				  CGRectGetMaxX( rect ) - radius, 
				  CGRectGetMinY( rect ) + radius, 
				  radius, 
				  -M_PI / 2, 
				  0,
  				  NO );
	
	// right border
	CGPathAddLineToPoint( path, nil, CGRectGetMaxX( rect ), CGRectGetMaxY( rect ) - radius );

	// bottom right arc
	CGPathAddArc( path, 
				 nil, 
				 CGRectGetMaxX( rect ) - radius, 
				 CGRectGetMaxY( rect ) - radius, 
				 radius, 
				 0, 
				 M_PI / 2,
				 NO );
	
	
	// bottom border
	CGPathAddLineToPoint( path, nil, CGRectGetMinX( rect ) + radius, CGRectGetMaxY( rect ) );
	
	// bottom left arc
	//CGPathAddLineToPoint( path, nil, CGRectGetMinX( rect ),  CGRectGetMaxY(rect ) - radius );
	
	CGPathAddArc( path, 
				 nil, 
				 CGRectGetMinX( rect ) + radius, 
				 CGRectGetMaxY( rect ) - radius, 
				 radius, 
				 M_PI / 2, 
				 M_PI,
				 NO );
		
	// left border
	CGPathAddLineToPoint( path, nil, CGRectGetMinX( rect ), CGRectGetMinY( rect ) + radius );
	
	
	// top right arc
	
	CGPathAddArc( path, 
				 nil, 
				 CGRectGetMinX( rect ) + radius, 
				 CGRectGetMinY( rect ) + radius, 
				 radius, 
				 M_PI, 
				 M_PI * 1.5,
				 NO );
	
	
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

@end
