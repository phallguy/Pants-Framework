//
//  PFTintedButton.h
//  Pants-Framework
//
//  Created by Paul Alexander on 11/7/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CALayer;

typedef enum
{
    PFTintedButtonRenderTypeStandard,
    PFTintedButtonRenderTypeCandy,
    PFTintedButtonRenderTypeOpal,
} PFTintedButtonRenderType;


@interface PFTintedButton : UIButton
{
@private
    UIColor * tint;
    CGFloat cornerRadius;
    PFTintedButtonRenderType renderType;
    
    UIImage * stretchImage;
    CALayer * glowLayer;
    
    UILabel * subLabel;
    
    BOOL customShadow;
    BOOL customTitleColor;
}

@property( nonatomic, retain ) UIColor * tint;
@property( nonatomic, assign ) CGFloat cornerRadius;
@property( nonatomic, assign ) PFTintedButtonRenderType renderType;
@property( nonatomic, readonly ) UILabel * subLabel;



@end
