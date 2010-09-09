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

+(CGPathRef) createPathForRect: (CGRect) rect withCornerRadius: (CGFloat) radius;

@end
