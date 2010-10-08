//
//  PFShapeView.h
//  Pants-Framework
//
//  Created by Paul Alexander on 10/7/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CAShapeLayer;

@interface PFShapeView : UIView 
{
@private
    CAShapeLayer * shape;
}

@property( nonatomic, readonly ) CAShapeLayer * shape;

-(void) setPoints: (NSArray *) points;

@end
