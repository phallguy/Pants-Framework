//
//  UIColor+PFExtensions.m
//  Pants-Framework
//
//  Created by Paul Alexander on 10/8/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "UIColor+PFExtensions.h"


@implementation UIColor (PFExtensions)

void ConvertRGBtoHSL( const CGFloat * components, CGFloat * hslComponents )
{
    CGFloat r, g, b;
    
    r = components[0];
    g = components[1];
    b = components[2];
    
    CGFloat h, s, l;
    
    CGFloat max = MAX( r, MAX( g, b ) );
    CGFloat min = MIN( r, MIN( g, b ) );
    
    l = ( max + min ) / 2;
    
    if( max == min )
    {
        s = 0;
        h = 0;
    }    
    else
    {
        if( l < 0.5 )
        {
            s = ( max - min ) / ( max + min );
        }
        else
        {
            s = ( max - min ) / ( 2.0 - max - min );
        }
        
        if( r == max )
            h = ( g - b ) / ( max - min );
        else if( g == max )
            h = 2.0 + ( b - r ) / ( max - min );
        else
            h = 4.0 + ( r - g ) / ( max - min );
    }
    
    hslComponents[0] = h;
    hslComponents[1] = s;
    hslComponents[2] = l;
    
}


+(UIColor *) random
{
    return [UIColor colorWithRed: ( arc4random() % 255 ) / 255.0 
                           green: ( arc4random() % 255 ) / 255.0
                            blue: ( arc4random() % 255 ) / 255.0  
                           alpha: 1];
}

-(UIColor *) lighten: (CGFloat) amount
{
    CGColorRef clr = [self CGColor];
    CGColorSpaceRef clrSpace = CGColorGetColorSpace( clr );
    
    CGFloat h,s,l,a;
    int componentCount;
    const CGFloat * components;
    
    CGColorSpaceModel model = CGColorSpaceGetModel( clrSpace );

    if( model != kCGColorSpaceModelRGB && model != kCGColorSpaceModelLab )
        return self;

    componentCount = CGColorGetNumberOfComponents( clr );
    components = CGColorGetComponents( clr );
    CGFloat hslComponents[4];

    if( model == kCGColorSpaceModelRGB )
        ConvertRGBtoHSL( components, hslComponents );
                
    h = components[0];
    s = components[1];
    l = components[2];
    a = CGColorGetAlpha( clr );
    
    s -= amount;
    l += amount;
    
    
    return [UIColor colorWithHue: h saturation: s brightness: l alpha: a];
}


@end
