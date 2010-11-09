//
//  PFGradientView.h
//  Pants-Framework
//
//  Created by Paul Alexander on 10/29/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CAGradientLayer;

@interface PFGradientView : UIView 
{
@private
    UIColor * startColor;
    UIColor * endColor;
}

@property( nonatomic, readonly ) UIColor * startColor;
@property( nonatomic, readonly ) UIColor * endColor;

-(void) setStartColor: (UIColor *) newStartColor endColor: (UIColor *) newEndColor;
-(void) setColor: (UIColor *) color;
@end
