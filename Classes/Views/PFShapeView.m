//
//  PFShapeView.m
//  Pants-Framework
//
//  Created by Paul Alexander on 10/7/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFShapeView.h"
#import <QuartzCore/QuartzCore.h>


@implementation PFShapeView

@synthesize shape;

-(id) initWithFrame: (CGRect) frame 
{
    if( self = [super initWithFrame:frame] ) 
    {
        shape = [[CAShapeLayer alloc] init];
        shape.bounds = CGRectMake( 0, 0, CGRectGetWidth( frame ), CGRectGetHeight( frame ) );
        shape.position = CGPointMake( CGRectGetWidth( frame ) / 2, CGRectGetHeight( frame ) / 2 );
        shape.fillRule = kCAFillRuleNonZero;
        
        [self.layer addSublayer: shape];
    }
    
    return self;
}

-(void) dealloc 
{
    SafeRelease( shape );
    
    [super dealloc];
}

-(void) setPoints: (NSArray *) points
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    for( int ix = 0; ix < points.count; ix++ )
    {
        NSValue * val = [points objectAtIndex: ix];
        CGPoint point = [val CGPointValue];
        
        if( ix == 0 )
            CGPathMoveToPoint( path, NULL, point.x, point.y );
        else
            CGPathAddLineToPoint( path, NULL, point.x, point.y );        
    }
    
    CGPathCloseSubpath( path );
    
    shape.path = path;

    CGPathRelease( path );       

}




@end
