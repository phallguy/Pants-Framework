//
//  PFGradientView.m
//  Pants-Framework
//
//  Created by Paul Alexander on 10/29/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFGradientView.h"
#import "UIColor+PFExtensions.h"
#import <QuartzCore/QuartzCore.h>

@implementation PFGradientView

-(void) dealloc 
{
    [super dealloc];
}

+(Class) layerClass { return [CAGradientLayer class]; }

-(void) initCommon
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4;
}


-(id) initWithFrame: (CGRect) frame 
{
    if( self = [super initWithFrame:frame] )
    {
        [self initCommon];
    }
    return self;
}

-(id) initWithCoder: (NSCoder *) coder
{
    if( self = [super initWithCoder: coder] )
    {
        [self initCommon];
    }
    
    return self;
}

-(void) setStartColor: (UIColor *) newStartColor endColor: (UIColor *) newEndColor
{
    NSArray * colors = [NSArray arrayWithObjects:
                        (id)[newStartColor CGColor],
                        (id)[newEndColor CGColor],
                        nil];
    
    CAGradientLayer * gradLayer = (CAGradientLayer *)self.layer;
    gradLayer.colors = colors;
}

-(void) setColor: (UIColor *) color
{
    [self setStartColor: color endColor: [color darken: .25]];
}

@end
