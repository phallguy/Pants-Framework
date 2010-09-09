//
//  PFDrawTools.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PFDrawTools.h"


@implementation PFDrawTools


+(CGPathRef) createPathForRect: (CGRect) rect withCornerRadius: (CGFloat) radius;
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

@end
