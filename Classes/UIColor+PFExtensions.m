//
//  UIColor+PFExtensions.m
//  Pants-Framework
//
//  Created by Paul Alexander on 10/8/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "UIColor+PFExtensions.h"


@implementation UIColor (PFExtensions)

+(UIColor *) random
{
    return [UIColor colorWithRed: ( arc4random() % 255 ) / 255.0 green: ( arc4random() % 255 ) / 255.0 blue: ( arc4random() % 255 ) / 255.0  alpha: 1];
}

@end
