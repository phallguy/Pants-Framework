//
//  PFCalloutLayer.h
//  Disney Treasure Hunt
//
//  Created by Paul Alexander on 10/15/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kPFCalloutCornerRadius   6.0
#define kPFCalloutPointerSize    12.0
#define kPFCalloutShadowSize     10.0
#define kPFCalloutContentInset   8.0
#define kPFCalloutMinimumContentHeight  20.0

typedef enum 
{
    PFCalloutOrientationNone,
    PFCalloutOrientationAuto,
    PFCalloutOrientationAbove,
    PFCalloutOrientationBelow,
    PFCalloutOrientationLeft,
    PFCalloutOrientationRight,
} PFCalloutOrientation;


@interface PFCalloutLayer : CALayer 
{

@private
    UIColor * baseColor;
    CGPoint pointerLocation;
    PFCalloutOrientation orientation;
}

@property( nonatomic, retain ) UIColor * baseColor;
@property( nonatomic, assign ) CGPoint pointerLocation;
@property( nonatomic, assign) PFCalloutOrientation orientation;

-(void) setBodyBounds: (CGRect) rect;

@end
