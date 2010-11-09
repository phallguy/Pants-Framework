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
        
        h *= 60.0;
        if( h < 0 )
            h += 360;
    }
    
    hslComponents[0] = MAX( 0, MIN( 360.0, h ) );
    hslComponents[1] = MAX( 0, MIN( 1.0, s ) );
    hslComponents[2] = MAX( 0, MIN( 1.0, l ) );
    
}

void ConvertHSLtoRGB( const CGFloat * components, CGFloat * rgb )
{
    CGFloat h = components[0],
            s = components[1],
            l = components[2];
    CGFloat t1, t2;

    if( s == 0 )
    {
        rgb[0] = rgb[1] = rgb[2] = l;
    }
    else
    {
        if( l < 0.5 )
            t2 = l * ( 1 + s );
        else
            t2 = ( l + s ) - ( l * s );
        t1 = ( 2 * l ) - t2;
        
        h /= 360.0;
        
        rgb[0] = h + ( 1.0 / 3.0 );
        rgb[1] = h;
        rgb[2] = h - ( 1.0 / 3.0 );
        
        for( int ix = 0; ix < 3; ix++ )
        {
            if( rgb[ix] < 0.0 )
                rgb[ix] += 1.0;
            else if( rgb[ix] > 1.0 )
                rgb[ix] -= 1.0;
            
            if( rgb[ix] * 6.0 < 1 )
                rgb[ix] = t1 + ( ( t2 - t1 ) * 6 * rgb[ix] );
            else if( 2 * rgb[ix] < 1 )
                rgb[ix] = t2;
            else if( 3 * rgb[ix] < 2 )
                rgb[ix] = t1 + ( ( t2 - t1 ) * ( ( 2.0 / 3.0 ) - rgb[ix] ) * 6.0 );
            else
                rgb[ix] = t1;                
        }        
    }
    
    for( int ix = 0; ix < 3; ix++ )
        rgb[ix] = MAX( 0, MIN( 1, rgb[ix] ) );
}


+(UIColor *) random
{
    return [UIColor colorWithRed: ( arc4random() % 255 ) / 255.0 
                           green: ( arc4random() % 255 ) / 255.0
                            blue: ( arc4random() % 255 ) / 255.0  
                           alpha: 1];
}

+(UIColor *) randomClampedTo: (NSInteger) groups
{
    PFAssert( groups > 1, @"Must have at least 2 groups." );
    CGFloat components[3];
    
    for( int ix = 0; ix < 3; ix++ )
    {
        CGFloat v = arc4random() % groups;
        components[ ix ] = v / ( groups - 1 );
    }    
    
       
    return [UIColor colorWithRed: components[0] green: components[1] blue: components[2] alpha: 1];
}

+(NSArray *) colorArray: (NSInteger) groups
{
    NSMutableArray * array = [[[NSMutableArray alloc] initWithCapacity: groups * 9 ] autorelease];
    
    CGFloat part = 1.0 / ( groups - 1 );
    
    for( int r = 0; r < groups; r++ )
    for( int g = 0; g < groups; g++ )
    for( int b = 0; b < groups; b++ )
    {
        [array addObject: [UIColor colorWithRed: r * part green: g * part blue: b * part alpha: 1]];
    }
    
    return array;
}


-(BOOL) isSameAs: (UIColor *) clr
{
    if( clr == nil ) return  NO;
    
    CGColorRef selfRef = [self CGColor];
    CGColorRef clrRef = [clr CGColor];
    
    int count = CGColorGetNumberOfComponents( selfRef );
    
    if( count != CGColorGetNumberOfComponents( clrRef ) )
        return NO;
    
    const CGFloat * s = CGColorGetComponents( selfRef );
    const CGFloat * c = CGColorGetComponents( clrRef );
    
    for( int ix = 0; ix < count; ix++ )
    {
        if( s[ix] != c[ix] )
            return NO;
    }
    
    return YES;
}



-(UIColor *) lighten: (CGFloat) amount
{
    CGColorRef clr = [self CGColor];
    CGColorSpaceRef clrSpace = CGColorGetColorSpace( clr );
    
    const CGFloat * components;
    
    CGColorSpaceModel model = CGColorSpaceGetModel( clrSpace );

    if( model != kCGColorSpaceModelRGB && model != kCGColorSpaceModelLab )
        return self;

    components = CGColorGetComponents( clr );
    CGFloat hslComponents[3];
    CGFloat rgbComponents[3];

    if( model == kCGColorSpaceModelRGB )
        ConvertRGBtoHSL( components, hslComponents );
                
    hslComponents[1] -= amount; // saturation
    hslComponents[2] += amount; // lightness
    
    if( model == kCGColorSpaceModelRGB )
    {
        ConvertHSLtoRGB( hslComponents, rgbComponents );
        return [UIColor colorWithRed: rgbComponents[0] green: rgbComponents[1] blue: rgbComponents[2] alpha: CGColorGetAlpha( clr )];
    }
    
    
    return [UIColor colorWithHue: hslComponents[0] saturation: hslComponents[1] brightness: hslComponents[2] alpha: CGColorGetAlpha( clr )];
} 


-(UIColor *) darken: (CGFloat) amount
{
    CGColorRef clr = [self CGColor];
    CGColorSpaceRef clrSpace = CGColorGetColorSpace( clr );
    
    const CGFloat * components;
    
    CGColorSpaceModel model = CGColorSpaceGetModel( clrSpace );
    
    if( model != kCGColorSpaceModelRGB && model != kCGColorSpaceModelLab )
        return self;
    
    components = CGColorGetComponents( clr );
    CGFloat hslComponents[3];
    CGFloat rgbComponents[3];
    
    if( model == kCGColorSpaceModelRGB )
        ConvertRGBtoHSL( components, hslComponents );
    
    hslComponents[1] -= amount; // saturation
    hslComponents[2] -= amount; // lightness
    
    if( model == kCGColorSpaceModelRGB )
    {
        ConvertHSLtoRGB( hslComponents, rgbComponents );
        return [UIColor colorWithRed: rgbComponents[0] green: rgbComponents[1] blue: rgbComponents[2] alpha: CGColorGetAlpha( clr )];
    }
    
    
    return [UIColor colorWithHue: hslComponents[0] saturation: hslComponents[1] brightness: hslComponents[2] alpha: CGColorGetAlpha( clr )];
} 

-(void) getHue: (CGFloat *) hue saturation: (CGFloat *) saturation lightness: (CGFloat *) lightness
{
    if( hue != NULL )
        *hue = 0.0;
    if( saturation != NULL )
        *saturation = 0.0;
    if( lightness != NULL )
        *lightness = 0.0;
    
    
    
    CGColorRef clr = [self CGColor];
    CGColorSpaceRef clrSpace = CGColorGetColorSpace( clr );
    
    const CGFloat * components;
    
    CGColorSpaceModel model = CGColorSpaceGetModel( clrSpace );
    
    if( model == kCGColorSpaceModelMonochrome )
    {
        if( lightness != NULL )
            *lightness = components[0];
        return;
    }
    
    if( model != kCGColorSpaceModelRGB && model != kCGColorSpaceModelLab )
        return;
    
    components = CGColorGetComponents( clr );
    CGFloat hslComponents[3];
    
    if( model == kCGColorSpaceModelRGB )
        ConvertRGBtoHSL( components, hslComponents );

    if( hue != NULL )
        *hue = hslComponents[0];
    if( saturation != NULL )
        *saturation = hslComponents[1];
    if( lightness != NULL )
        *lightness = hslComponents[2]; 
}


-(NSString *) rgbHexValue
{
    CGColorRef color = [self CGColor];
    const CGFloat * components = CGColorGetComponents( color );
    int count = CGColorGetNumberOfComponents( color );
    
    if( count == 1 )
    {
        return [NSString stringWithFormat: @"#%.2X%.2X%.2X", 
                (int)round( components[ 0 ] * 255 ), 
                (int)round( components[ 0 ] * 255 ), 
                (int)round( components[ 0 ] * 255 )];
    }
    else if ( count == 3 || ( count == 4 && components[3] == 1 ) )
    {
        return [NSString stringWithFormat: @"#%.2X%.2X%.2X", 
                (int)round( components[ 0 ] * 255 ), 
                (int)round( components[ 1 ] * 255 ), 
                (int)round( components[ 2 ] * 255 )];    }
    else
    {
        return [NSString stringWithFormat: @"#%.2X%.2X%.2X", 
                (int)round( components[ 0 ] * 255 ), 
                (int)round( components[ 1 ] * 255 ), 
                (int)round( components[ 2 ] * 255 ),
                (int)round( components[ 3 ] * 255 )
                ];
    }
    
    return @"#000000";
}

+(UIColor *) colorFromRgbHex: (NSString *) value
{
    if( ! value )
        return [UIColor blackColor];
    
    if( [value hasPrefix: @"#"] )
        value = [value substringFromIndex: 1];
    
    NSScanner * scanner = [NSScanner scannerWithString: value];
    scanner.caseSensitive = NO;
    
    uint rgb;
    if( ! [scanner scanHexInt: &rgb] )
        return [UIColor blackColor];
    
    
    if( [value length] == 6 )
    {
        rgb <<= 8;
        rgb |= 0xFF;
    }
    
    return [UIColor colorWithRed: ( ( rgb >> 24 ) & 0xFF ) / 255.0 
                           green: ( ( rgb >> 16 ) & 0xFF ) / 255.0 
                            blue: ( ( rgb >> 8 ) & 0xFF ) / 255.0 
                           alpha: ( ( rgb ) & 0xFF ) / 255.0];
}


@end
