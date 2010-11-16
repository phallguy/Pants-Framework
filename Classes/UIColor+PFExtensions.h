//
//  UIColor+PFExtensions.h
//  Pants-Framework
//
//  Created by Paul Alexander on 10/8/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (PFExtensions)

+(UIColor *) random;
+(UIColor *) randomClampedTo: (NSInteger) groups;
+(NSArray *) colorArray: (NSInteger) groups;

-(UIColor *) lighten: (CGFloat) amount;
-(UIColor *) darken: (CGFloat) amount;
-(UIColor *) dodge: (UIColor *) top;
-(UIColor *) burn: (UIColor *) top;


-(void) getHue: (CGFloat *) hue saturation: (CGFloat *) saturation lightness: (CGFloat *) lightness;

-(BOOL) isSameAs: (UIColor *) clr;

+(UIColor *) colorFromRgbHex: (NSString *) value;
-(NSString *) rgbHexValue;

@end
