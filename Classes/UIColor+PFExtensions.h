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

-(UIColor *) lighten: (CGFloat) amount;
-(UIColor *) darken: (CGFloat) amount;
-(void) getHue: (CGFloat *) hue saturation: (CGFloat *) saturation lightness: (CGFloat *) lightness;

-(BOOL) isSameAs: (UIColor *) clr;

@end
