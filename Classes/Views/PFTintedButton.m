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

#define glowRadius      30

@interface PFTintedButton()
-(void) createBackgroundImage;
-(void) createGlowLayer;
@end


@implementation PFTintedButton

-(void) dealloc 
{
    SafeRelease( tint );
    SafeRelease( stretchImage );
    SafeRelease( subLabel );
    SafeRelease( glowLayer );

    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(createGlowLayer) object: nil];
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(renderGlowLayerOnMainThread) object: nil];
    
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
        // this is such a hack but there's no other way to determine if the title label's settings
        // have been modified in IB.
        NSDictionary * dic = [coder decodeObjectForKey: @"UIButtonStatefulContent"];
        NSObject * st = [dic objectForKey: [NSNumber numberWithInt: UIControlStateNormal]];
        NSString * bc = [st description];
        
        customTitleColor = [bc rangeOfString: @"TitleColor = UIDeviceRGBColorSpace 0.196078 0.309804 0.521569 1"].location == NSNotFound;
        customShadow = [bc rangeOfString: @"ShadowColor = UIDeviceRGBColorSpace 0.5 0.5 0.5 1"].location == NSNotFound;
        
        [self initCommon];
        
        //[super setBackgroundColor: [[UIColor redColor] colorWithAlphaComponent: .5]];
    }
    
    return self;
}

#pragma mark -
#pragma mark State

-(void) setNeedsNewBackground
{
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(createGlowLayer) object: nil];
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(renderGlowLayerOnMainThread) object: nil];
    
    SafeRelease( stretchImage );
    
    self.layer.shadowPath = nil;
    
    [glowLayer removeFromSuperlayer];
    SafeRelease( glowLayer );

    
    [self setNeedsDisplay];
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

    renderType = newRenderType;
    switch( newRenderType )
    {
        case PFTintedButtonRenderTypeCandy:
            self.titleLabel.font = [UIFont boldSystemFontOfSize: 26];
            cornerRadius = 15;
            break;
        case PFTintedButtonRenderTypeOpal:
            self.titleLabel.font = [UIFont boldSystemFontOfSize: 10];
            cornerRadius = 12;
            break;
        case PFTintedButtonRenderTypeStandard:
            self.titleLabel.font = [UIFont boldSystemFontOfSize: 20];
            cornerRadius = 6;
            break;
    }

    
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
    [super layoutSubviews];
    
    if( ! stretchImage )
    {
        [self createBackgroundImage];
        self.titleLabel.font = [UIFont boldSystemFontOfSize: 20];
        if( CGSizeEqualToSize( self.titleLabel.shadowOffset, CGSizeMake( 0, 0 ) ) )
            self.titleLabel.shadowOffset = CGSizeMake( 0, -1 );
    }
    
    if( renderType == PFTintedButtonRenderTypeCandy )
    {
        if( self.state == UIControlStateHighlighted && ! glowLayer )
            [self createGlowLayer];
        [glowLayer setHidden: self.state != UIControlStateHighlighted ];
    }
    
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
    
    // Outer bezel
    rect.size.height -= 1;
    p = [PFDrawTools createPathForRect: rect withCornerRadius: cornerRadius - .5];
    CGContextSetStrokeColorWithColor( g, [[UIColor colorWithWhite: 0 alpha: .60] CGColor] );
    CGContextSetLineWidth( g, .5 );
    CGContextAddPath( g, p );
    CGContextStrokePath( g );
    CGPathRelease( p );

    
    // Base Gradient
    rect = CGRectInset( fullRect, 1, 1 );
    rect.size.height -= 1;
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
    
    CGColorRef highlight = [[[UIColor whiteColor] colorWithAlphaComponent: .35] CGColor];
    CGContextSetFillColorWithColor( g, highlight );
    CGContextSetShadowWithColor( g, CGSizeMake( 0, 1 ), 0, highlight );
    CGContextEOFillPath( g );
    
    
    CGContextRestoreGState( g );
    
    
    // Outer emboss
    rect = fullRect;
    CGContextAddRect( g, fullRect );
    p = [PFDrawTools createPathForRect: CGRectOffset( rect, 0, -1 ) withCornerRadius: cornerRadius andCorners: kPFCornerRadiusCornersBottom];
    CGContextAddPath( g, p );
    CGContextEOClip( g );
    CGPathRelease( p );
    
    rect = CGRectOffset( rect, 0, -.5 );
    p = [PFDrawTools createPathForRect: rect withCornerRadius: cornerRadius ];
    CGContextSetStrokeColorWithColor( g, [[UIColor colorWithWhite: 1 alpha: .40] CGColor] );
    CGContextSetLineWidth( g, 1 );
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
}

-(void) createOpalBackgroundImage
{
    CGRect rect = CGRectMake( 0, 0, CGRectGetWidth( self.bounds ), CGRectGetHeight( self.bounds ) );
    CGRect fullRect = rect;
    
    CGFloat radius = cornerRadius;
    CGContextRef g = [self createImageContext: rect];
    CGMutablePathRef p;

    // Base gradient
    rect = CGRectInset( rect, 0.5, 0.5 );
    p = [PFDrawTools createPathForRect: rect withCornerRadius: radius];
    [PFDrawTools fillPath: p
                inContext: g
     withGradientUIColors: [NSArray arrayWithObjects: 
                            [tint dodge: [UIColor colorWithWhite: .65 alpha: 1]],
                            tint,
                            tint,
                            [tint lighten: .2], 
                            nil]
              atLocations: [NSArray arrayWithObjects: 
                            [NSNumber numberWithFloat: 0],
                            [NSNumber numberWithFloat: .60],
                            [NSNumber numberWithFloat: .75],
                            [NSNumber numberWithFloat: 1],
                            nil]];
    
    // Shadow
    self.layer.shadowPath = p;
    self.layer.shadowRadius = 1;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake( 0, 1 );
    self.layer.shadowOpacity = 1;
    
    CGPathRelease( p );
    

    // Rim light
    CGContextSaveGState( g );
    rect = CGRectInset( fullRect, 1, 1 );
    radius -= 1;
    
    p = [PFDrawTools createPathForRect: rect withCornerRadius: radius];
    CGContextAddPath( g, p );
    CGContextClip( g );        
    CGPathRelease( p );
    
    p = [PFDrawTools createPathForRect: CGRectOffset( rect, 0, 1 ) withCornerRadius: radius];
    CGContextAddPath( g, p );
    CGPathRelease( p );
    CGContextAddRect( g, fullRect );
    
    CGColorRef highlight = [[[UIColor whiteColor] colorWithAlphaComponent: .55] CGColor];
    CGContextSetFillColorWithColor( g, highlight );
    CGContextEOFillPath( g );
    
    
    CGContextRestoreGState( g );
    
    // Outer trim
    rect = CGRectInset( fullRect, 0.5, 0.5 );
    p = [PFDrawTools createPathForRect: rect withCornerRadius: cornerRadius];
    CGContextSetStrokeColorWithColor( g, [tint CGColor] );
    CGContextSetLineWidth( g, 1 );
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
        [super setTitleShadowColor: [tint darken: .25] forState: UIControlStateNormal];        
    }    
}

-(void) renderGlowLayerOnMainThread
{
    //[self performSelectorOnMainThread: @selector(createGlowLayer) withObject: nil waitUntilDone: NO];
    [self createGlowLayer];
}

-(void) createGlowLayer
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(createGlowLayer) object: nil];
    [NSObject cancelPreviousPerformRequestsWithTarget: self selector: @selector(renderGlowLayerOnMainThread) object: nil];
    CGRect rect = CGRectMake( 0, 0, CGRectGetWidth( self.bounds ), CGRectGetHeight( self.bounds ) );
    CGRect baseRect = CGRectInset( rect, 2, 2 );
    CGRect fullRect = rect;

    // Build glow layer
    rect = CGRectInset( fullRect, -glowRadius, -glowRadius );
    rect = CGRectOffset( rect, glowRadius, glowRadius );
    CGContextRef g = [self createImageContext: rect];
    
    CGContextAddRect( g,  rect );
    
    rect = CGRectOffset( baseRect, glowRadius, glowRadius );
    CGPathRef p = [PFDrawTools createPathForRect: rect withCornerRadius: cornerRadius];
    CGContextAddPath( g, p );
    CGContextEOClip( g );
    CGPathRelease( p );
    
    
    
    rect = CGRectInset( rect, -1, -1 );
    
    p = [PFDrawTools createPathForRect: rect withCornerRadius: cornerRadius];
    CGContextSetShadowWithColor( g, CGSizeZero, glowRadius * 2, [tint CGColor] );
    CGContextSetFillColorWithColor( g, [tint CGColor] );
    CGContextAddPath( g,  p );
    CGContextFillPath( g );
    CGContextAddPath( g,  p );
    CGContextFillPath( g );
    CGPathRelease( p );
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    glowLayer = [[CALayer alloc] init];
    glowLayer.frame = CGRectMake( 0, 0, img.size.width, img.size.height );
    glowLayer.position = CGPointMake( CGRectGetWidth( fullRect ) / 2, CGRectGetHeight( fullRect ) / 2 );
    glowLayer.contents = (id)[img CGImage];
    glowLayer.hidden = YES;
    [self.layer addSublayer: glowLayer];
    
    [pool release];
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
            [self performSelector: @selector(renderGlowLayerOnMainThread) withObject: nil afterDelay: 2];
            break;
        case PFTintedButtonRenderTypeOpal:
            [self createOpalBackgroundImage];
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
