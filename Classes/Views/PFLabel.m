//
//  PFLabel.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/16/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFLabel.h"


@implementation PFLabel

-(void) dealloc 
{
    [super dealloc];
}

-(void) initCommon
{
    shadowBlur = 3;
}

-(id) initWithFrame: (CGRect) frame 
{
    if( self = [super initWithFrame:frame] )
    {
        [self initCommon];
    }
    
    return self;
}

-(id) initWithCoder: (NSCoder *) coder 
{
    if( self = [super initWithCoder:coder] ) 
    {
        [self initCommon];
    }
    
    return self;
}


-(UIColor*) shadowColor{ return nil; }
-(CGFloat) shadowBlur{ return shadowBlur; }
-(void) setShadowBlur: (CGFloat) newShadowBlur
{
    if( newShadowBlur == shadowBlur )
        return;
    
    shadowBlur = newShadowBlur;
    [self setNeedsDisplay];
}
  


-(void) drawTextInRect: (CGRect) rect
{
    CGContextRef g = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor( g, self.shadowOffset, shadowBlur, [super.shadowColor CGColor] );
    
    [super drawTextInRect: rect];
}

-(CGRect) textRectForBounds: (CGRect) bounds limitedToNumberOfLines: (NSInteger) numberOfLines
{
    CGRect result = [super textRectForBounds: bounds limitedToNumberOfLines: numberOfLines];
    
    result = CGRectMake( CGRectGetMinX( result ),
                         CGRectGetMinY( result ),
                         CGRectGetWidth( result ) - shadowBlur,
                         CGRectGetHeight( result ) - shadowBlur );
    
    return result;
}

@end
