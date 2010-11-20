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

#define glowRadius      60

@interface PFTintedButton()
-(void) createBackgroundImage;
@end


@implementation PFTintedButton

-(void) dealloc 
{
    SafeRelease( tint );
    SafeRelease( stretchImage );
    SafeRelease( subLabel );
    SafeRelease( glowLayer );
    
    [super dealloc];
}

-(void) initCommon
{
    cornerRadius = 6;
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
    
    CGPathRef ref = self.layer.shadowPath;
    self.layer.shadowPath = nil;
    CGPathRelease( ref );
    
    [glowLayer removeFromSuperlayer];
    SafeRelease( glowLayer );

    
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

-(PFTintedButtonRenderType) renderType { return renderType; }
-(void) setRenderType: (PFTintedButtonRenderType) newRenderType
{
    if( renderType == newRenderType )
        return;

    switch( newRenderType )
    {
        case PFTintedButtonRenderTypeCandy:
            self.titleLabel.font = [UIFont boldSystemFontOfSize: 26];
            cornerRadius = 15;
            break;
        case PFTintedButtonRenderTypeStandard:
            self.titleLabel.font = [UIFont boldSystemFontOfSize: 20];
            cornerRadius = 6;
            break;
    }

    
    renderType = newRenderType;
    [self setNeedsNewBackground];
}

-(void) setBackgroundColor: (UIColor *) color
{
    self.tint = color;
}

-(UILabel *) subLabel 
{
    if( ! subLabel )
    {
        subLabel = [[UILabel alloc] initWithFrame: self.bounds];
        subLabel.backgroundColor = [UIColor clearColor];
        subLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview: subLabel];
        [self setNeedsLayout];
    }
    
    return subLabel;
}


-(void) setTitleColor: (UIColor *) color forState: (UIControlState) state
{
    if( state == UIControlStateNormal )
        customTitleColor = YES;
    
    [super setTitleColor: color forState: state];
}

-(void) setTitleShadowColor: (UIColor *) color forState: (UIControlState) state
{
    if( state == UIControlStateNormal )
        customShadow = YES;
    
    [super setTitleShadowColor: color forState: state];
}



#pragma mark -
#pragma Drawing

-(void) layoutSubviews
{
    if( ! stretchImage )
    {
        [self createBackgroundImage];
        self.titleLabel.font = [UIFont boldSystemFontOfSize: 20];
        if( CGSizeEqualToSize( self.titleLabel.shadowOffset, CGSizeMake( 0, 0 ) ) )
            self.titleLabel.shadowOffset = CGSizeMake( 0, -1 );
    }
    
    
    [super layoutSubviews];
    
    
    if( subLabel && subLabel.text.length )
    {
        CGFloat width = CGRectGetWidth( self.bounds );
        CGFloat height = CGRectGetHeight( self.bounds );
        CGFloat descender = self.titleLabel.font.descender;
        
        CGSize titleSize = [self.titleLabel.text sizeWithFont: self.titleLabel.font
                                                     forWidth: width
                                                lineBreakMode: UILineBreakModeMiddleTruncation];
        
        CGSize subSize = [subLabel.text sizeWithFont: subLabel.font 
                                            forWidth: width
                                       lineBreakMode: UILineBreakModeMiddleTruncation];


        self.titleLabel.frame = CGRectMake( ceil( ( width - titleSize.width ) / 2.0 ) ,
                                            ceil( ( height - titleSize.height - subSize.height - descender ) / 2.0 ), 
                                            titleSize.width, 
                                            titleSize.height );
        
       subLabel.frame = CGRectMake( ceil( ( width - subSize.width ) / 2.0 ) ,
                                    ceil( ( height - titleSize.height - subSize.height  + descender ) / 2.0 ) + titleSize.height, 
                                    subSize.width, 
                                    subSize.height );
        
        
        subLabel.textColor = [self titleColorForState: self.state];
        subLabel.shadowColor = [self titleShadowColorForState: self.state];
        subLabel.shadowOffset = self.titleLabel.shadowOffset;
    }
    
    [glowLayer setHidden: self.state != UIControlStateHighlighted ];
}

-(CGContextRef) createImageContext: (CGRect) rect
{
    if( [self respondsToSelector: @selector(contentScaleFactor)] )
    {
        CGFloat scale = [[UIScreen mainScreen] scale];
        UIGraphicsBeginImageContextWithOptions( rect.size, NO, scale );
    }else
    {
        UIGraphicsBeginImageContext( rect.size );
    }
    
    return UIGraphicsGetCurrentContext();
}

-(void) createStandardBackgroundImage
{
    // Draw the image to be stretched
    CGRect rect = CGRectMake( 0, 0, CGRectGetWidth( self.bounds ), CGRectGetHeight( self.bounds ) );
    CGRect fullRect = rect;
    CGFloat radius = cornerRadius;
    CGContextRef g = [self createImageContext: rect];
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
    CGContextSetStrokeColorWithColor( g, [[UIColor colorWithWhite: 1 alpha: .45] CGColor] );
    CGContextSetLineWidth( g, .5 );
    CGContextAddPath( g, p );
    CGContextStrokePath( g );
    CGPathRelease( p );        
    
    
    
    
    // Save it, create strechable image and assign to layer contents
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    stretchImage = [[img stretchableImageWithLeftCapWidth: CGRectGetWidth( rect ) / 2 topCapHeight: 0] retain];
    [self setBackgroundImage: stretchImage forState: UIControlStateNormal];
    UIGraphicsEndImageContext();    
    
    if( ! customShadow )
    {
        [super setTitleShadowColor:  [[UIColor blackColor] colorWithAlphaComponent: 1 - lightness] forState: UIControlStateNormal];
        customShadow = NO;
    }

}

-(void) createCandyBackgroundImage
{
    CGRect rect = CGRectMake( 0, 0, CGRectGetWidth( self.bounds ), CGRectGetHeight( self.bounds ) );
    CGRect fullRect = rect;
    
    CGFloat radius = cornerRadius;
    CGContextRef g = [self createImageContext: rect];
    CGMutablePathRef p;
    
    
    // Base Gradient
    CGRect baseRect = CGRectInset( rect, 2, 2 );
    rect = baseRect;
    p = [PFDrawTools createPathForRect: rect withCornerRadius: radius];
    
    [PFDrawTools fillPath: p 
                inContext: g 
     withGradientUIColors: [NSArray arrayWithObjects: tint, [[tint burn: [UIColor colorWithWhite: .7 alpha: 1] ] darken: .07], nil]
     ];
    
    
    // Shadow
    self.layer.shadowPath = p;
    self.layer.shadowRadius = 3;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake( 0, 6 );
    self.layer.shadowOpacity = .55;
                              
    // Outer stroke
    [[tint darken: .20] setStroke];
    CGContextAddPath( g, p );
    CGContextSetLineWidth( g, 3 );
    CGContextStrokePath( g );    
    
    // Gradient stroke
    CGContextAddPath( g, p );
    CGPathRelease( p );
    
    
    p = [PFDrawTools createPathForRect: CGRectInset( rect, 1.5, 1.5 ) withCornerRadius: radius - 1];
    CGContextAddPath( g, p );
    CGContextEOClip( g );
    CGPathRelease( p );
    
    [PFDrawTools fillRect: rect 
                inContext: g
     withGradientUIColors: [NSArray arrayWithObjects: [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1],  
                                                      [tint dodge: [UIColor colorWithWhite: .02 alpha: 1]], nil]];
    
    
    // Save it, create strechable image and assign to layer contents
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    stretchImage = [[img stretchableImageWithLeftCapWidth: CGRectGetWidth( rect ) / 2 topCapHeight: 0] retain];
    [self setBackgroundImage: stretchImage forState: UIControlStateNormal];
    [self setBackgroundImage: stretchImage forState: UIControlStateHighlighted];
    UIGraphicsEndImageContext();        
    
    if( ! customShadow )
    {
        [super setTitleShadowColor: [tint darken: .25] forState: UIControlStateNormal];
        
    }
    
    
    // Build glow layer
    rect = CGRectInset( fullRect, -glowRadius, -glowRadius );
    rect = CGRectOffset( rect, glowRadius, glowRadius );
    g = [self createImageContext: rect];

    CGContextAddRect( g,  rect );
    
    rect = CGRectOffset( baseRect, glowRadius, glowRadius );
    p = [PFDrawTools createPathForRect: rect withCornerRadius: cornerRadius];
    CGContextAddPath( g, p );
    CGContextEOClip( g );
    CGPathRelease( p );

    
    
    rect = CGRectInset( rect, -1, -1 );
    
    p = [PFDrawTools createPathForRect: rect withCornerRadius: cornerRadius];
    CGContextSetShadowWithColor( g, CGSizeZero, glowRadius, [tint CGColor] );
    CGContextSetFillColorWithColor( g, [tint CGColor] );
    CGContextAddPath( g,  p );
    CGContextFillPath( g );
    CGContextAddPath( g,  p );
    CGContextFillPath( g );
    CGPathRelease( p );
    
    img = UIGraphicsGetImageFromCurrentImageContext();
    glowLayer = [[CALayer alloc] init];
    glowLayer.frame = CGRectMake( 0, 0, img.size.width, img.size.height );
    glowLayer.position = CGPointMake( CGRectGetWidth( fullRect ) / 2, CGRectGetHeight( fullRect ) / 2 );
    glowLayer.contents = (id)[img CGImage];
    glowLayer.hidden = YES;
    [self.layer addSublayer: glowLayer];
}


-(void) createBackgroundImage
{
    if( ! customTitleColor )
    {
        [super setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
        customTitleColor = NO;
    }
    
    switch( renderType )
    {
        case PFTintedButtonRenderTypeCandy:
            [self createCandyBackgroundImage];
            break;
        default:
            [self createStandardBackgroundImage];
            break;            
    }
    

    if( subLabel )
    {
        subLabel.textColor = [self titleColorForState: UIControlStateNormal];
    }
}



@end
