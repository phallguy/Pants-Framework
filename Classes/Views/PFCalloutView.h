//
//  PFCalloutView.h
//  Disney Treasure Hunt
//
//  Created by Paul Alexander on 10/15/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFCalloutLayer.h"



@interface PFCalloutView : UIControl 
{

@private
    PFCalloutLayer * calloutLayer;
}

-(void) pointAt: (CGPoint) point orientation: (PFCalloutOrientation) orientation;
-(void) pointAtView: (UIView *) targetView orientation: (PFCalloutOrientation) orientation;
-(void) bounceIn;

@end
