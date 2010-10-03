//
//  PFSpringLayout.h
//  Pants-Framework
//
//  Created by Paul Alexander on 10/2/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PFSpringLayout : NSObject
{
@private
    CGRect frame;
    NSMutableArray * nodes;
    
    double spring;
    double charge;
    double damping;
    
}

@property( nonatomic, assign ) CGRect frame;
@property( nonatomic, assign ) double spring;
@property( nonatomic, assign ) double charge;
@property( nonatomic, assign ) double damping;

-(id) initWithFrame: (CGRect) newFrame;

-(void) addView: (UIView *) view;
-(void) connectView: (UIView *) view toView: (UIView *) toView;
-(void) repelFrom: (CGPoint) point withMass: (double) mass;
-(void) connectAll;
-(void) connectAllByProximityToClosest: (NSInteger) closest;
-(void) connectAllByGridOfSize: (CGSize) size;
-(void) pinView: (UIView *) view;

-(BOOL) layoutWithMaxIterations: (NSInteger) iterations;

@end
