//
//  PFTintedButton.m
//  Pants-Framework
//
//  Created by Paul Alexander on 11/7/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFTintedButton.h"
#import "PFDrawTools.h"
#import "UIColor+PFExtensions.h"
#import <QuartzCore/QuartzCore.h>

@interface PFTintedButton()
-(void) createBackgroundImage;
@end


@implementation PFTintedButton


-(void) dealloc 
{
    SafeRelease( tint );
    SafeRelease( stretchImage );
    
    [super dealloc];
}

-(void) initCommon
{
    cornerRadius = 6;
    
    self.titleLabel.shadowOffset = CGSizeMake( 0, -1 );
    self.titleLabel.font = [UIFont boldSystemFontOfSize: 20];
    
    [self setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    
}

-(id) initWithFrame: (CGRect) frame 
{
    if( self = [super initWithFrame: frame] ) 
    {
        [self initCommon];
    }
    
    return self;
}

-(id) initWithCoder: (NSCoder *) coder 
{
    if( self = [super initWithCoder: coder] ) 
    {
        [self initCommon];
    }
    
    return self;
}

#pragma mark -
#pragma mark State

-(void) setNeedsNewBackground
{
    SafeRelease( stretchImage );
    [self setNeedsLayout];
}

-(UIColor *) tint { return tint; }
-(void) setTint: (UIColor *) newTint
{
    if( tint == newTint ) return;
    
    [tint release];
    tint = [newTint retain];
    [self setNeedsNewBackground];
}

-(CGFloat) cornerRadius { return cornerRadius; }
-(void) setCornerRadius: (CGFloat) newCornerRadius
{
    if( cornerRadius == newCornerRadius ) 
        return;
    cornerRadius = newCornerRadius;
    [self setNeedsNewBackground];
}

-(void) setBackgroundColor: (UIColor *) color
{
    self.tint = color;
}

#pragma mark -
#pragma Drawing

-(void) layoutSubviews
{
    if( ! stretchImage )
        [self createBackgroundImage];
    [super layoutSubviews];
}


-(void) createBackgroundImage
{
    // Draw the image to be stretched
    CGRect rect = CGRectMake( 0, 0, CGRectGetWidth( self.frame ), CGRectGetHeight( self.frame ) );
    CGRect fullRect = rect;
    CGFloat radius = cornerRadius;
    
    if( [self respondsToSelector: @selector(contentScaleFactor)] )
    {
        CGFloat scale = [[UIScreen mainScreen] scale];
        UIGraphicsBeginImageContextWithOptions( rect.size, NO, scale );
    }else
    {
        UIGraphicsBeginImageContext( rect.size );
    }
    
    CGContextRef g = UIGraphicsGetCurrentContext();
    CGMutablePathRef p;
    
    // Align strokes to pixel boundaries
    rect = CGRectInset( rect, .5, .5 );
    radius -= 1;
    
    // Base Gradient
    rect = CGRectInset( rect, .5, .5 );
    rect.size.height -= .5;
    p = [PFDrawTools createPathForRect: rect withCornerRadius: radius];
    
    [PFDrawTools fillPath: p 
                inContext: g 
     withGradientUIColors: [NSArray arrayWithObjects: tint, tint, tint, [tint darken: .025], nil]
     ];
    
    CGPathRelease( p );
    
    // Gloss
    CGRect halfRect = rect;
    halfRect.size.height /= 2;
    CGFloat lightness;
    [tint getHue: NULL saturation: NULL lightness: &lightness];        
    
    p = [PFDrawTools createPathForRect: halfRect withCornerRadius: radius andCorners: kPFCornerRadiusCornersTop];
    [PFDrawTools fillPath: p
                inContext: g 
     withGradientUIColors: [NSArray arrayWithObjects: [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: lightness * 1.2],
                            [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: lightness * .45],
                            nil]
     ];
    
    CGPathRelease( p );        
    
    // Top Highlight
    CGContextSaveGState( g );
    
    p = [PFDrawTools createPathForRect: rect withCornerRadius: radius];
    CGContextAddPath( g, p );
    CGContextClip( g );        
    CGPathRelease( p );
    
    p = [PFDrawTools createPathForRect: CGRectInset( rect, .25, .25 ) withCornerRadius: radius];
    CGContextAddPath( g, p );
    CGPathRelease( p );
    CGContextAddRect( g, fullRect );
    
    CGColorRef highlight = [[[UIColor whiteColor] colorWithAlphaComponent: .5] CGColor];
    CGContextSetFillColorWithColor( g, highlight );
    CGContextSetShadowWithColor( g, CGSizeMake( 0, .5 ), 0, highlight );
    CGContextEOFillPath( g );
    
    
    CGContextRestoreGState( g );
    
    // Outer bezel
    rect = CGRectInset( fullRect, .75, .75 );
    rect.size.height -= .5;
    p = [PFDrawTools createPathForRect: rect withCornerRadius: cornerRadius];
    CGContextSetStrokeColorWithColor( g, [[UIColor colorWithWhite: 0 alpha: .60] CGColor] );
    CGContextSetLineWidth( g, .5 );
    CGContextAddPath( g, p );
    CGContextStrokePath( g );
    CGPathRelease( p );
    
    // Outer emboss
    rect = CGRectInset( fullRect, .25, .25 );
    p = [PFDrawTools createPathForRect: rect withCornerRadius: cornerRadius];
    CGContextSetStrokeColorWithColor( g, [[UIColor colorWithWhite: 0 alpha: .15] CGColor] );
    CGContextSetLineWidth( g, .5 );
    CGContextAddPath( g, p );
    CGContextStrokePath( g );
    CGPathRelease( p );        
    
    
    CGContextAddRect( g, fullRect );
    p = [PFDrawTools createPathForRect: CGRectOffset( rect, 0, -1 ) withCornerRadius: cornerRadius];
    CGContextAddPath( g, p );
    CGContextEOClip( g );
    CGPathRelease( p );
    
    
    p = [PFDrawTools createPathForRect: rect withCornerRadius: cornerRadius];
    CGContextSetStrokeColorWithColor( g, [[UIColor colorWithWhite: 1 alpha: .75] CGColor] );
    CGContextSetLineWidth( g, .5 );
    CGContextAddPath( g, p );
    CGContextStrokePath( g );
    CGPathRelease( p );        
    
    
    
    
    // Save it, create strechable image and assign to layer contents
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    stretchImage = [[img stretchableImageWithLeftCapWidth: CGRectGetWidth( rect ) / 2 topCapHeight: 0] retain];
    [self setBackgroundImage: stretchImage forState: UIControlStateNormal];
    UIGraphicsEndImageContext();

    
    self.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent: 1 - lightness];

}



@end
