//
//  PFDrawTools.h
//  Pants-Framework
//
//  Created by Paul Alexander on 9/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    kPFCornerRadiusCornersTopLeft       = 1,
    kPFCornerRadiusCornersTopRight      = 2,
    kPFCornerRadiusCornersBottomLeft    = 4,
    kPFCornerRadiusCornersBottomRight   = 8,
    
    kPFCornerRadiusCornersTop           = kPFCornerRadiusCornersTopLeft | kPFCornerRadiusCornersTopRight,
    kPFCornerRadiusCornersBottom        = kPFCornerRadiusCornersBottomLeft | kPFCornerRadiusCornersBottomRight,
    kPFCornerRadiusCornersLeft          = kPFCornerRadiusCornersBottomLeft | kPFCornerRadiusCornersTopLeft,
    kPFCornerRadiusCornersRight         = kPFCornerRadiusCornersBottomRight | kPFCornerRadiusCornersTopRight,
    
    kPFCornerRadiusCornersAll           = kPFCornerRadiusCornersTopLeft | kPFCornerRadiusCornersTopRight |
                                            kPFCornerRadiusCornersBottomLeft | kPFCornerRadiusCornersBottomRight,

} PFCornerRadiusCorners;


@interface PFDrawTools : NSObject {

}

+(CGMutablePathRef) createPathForRect: (CGRect) rect withCornerRadius: (CGFloat) radius;
+(CGMutablePathRef) createPathForRect: (CGRect) rect withCornerRadius: (CGFloat) radius andCorners: (PFCornerRadiusCorners) corners;

+(CGRect) drawGlassInContext: (CGContextRef) g 
                   forRect: (CGRect) rect 
                     color: (UIColor *) color
          withCornerRadius: (CGFloat) cornerRadius 
               borderWidth: (CGFloat) borderWidth 
               shadowDepth: (CGFloat) shadowDepth;
+(CGRect) calculateGlassRect: (CGRect) rect shadowDepth: (CGFloat) shadowDepth;

+(void) fillPath: (CGPathRef) path inContext: (CGContextRef) g withGradientUIColors: (NSArray *) uiColors;
+(void) fillPath: (CGPathRef) path inContext: (CGContextRef) g withGradientUIColors: (NSArray *) uiColors atLocations: (NSArray *) locations;
+(void) fillRect: (CGRect) rect inContext: (CGContextRef) g withGradientUIColors: (NSArray *) uiColors;

@end
