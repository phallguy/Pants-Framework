//
//  PFDrawTools.h
//  Pants-Framework
//
//  Created by Paul Alexander on 9/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PFDrawTools : NSObject {

}

+(CGMutablePathRef) createPathForRect: (CGRect) rect withCornerRadius: (CGFloat) radius;
+(CGRect) drawGlassInContext: (CGContextRef) g 
                   forRect: (CGRect) rect 
                     color: (UIColor *) color
          withCornerRadius: (CGFloat) cornerRadius 
               borderWidth: (CGFloat) borderWidth 
               shadowDepth: (CGFloat) shadowDepth;
+(CGRect) calculateGlassRect: (CGRect) rect shadowDepth: (CGFloat) shadowDepth;

@end
