//
//  PFProgressView.m
//  Pants-Framework
//
//  Created by Paul Alexander on 10/26/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFProgressView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PFProgressView


-(void) dealloc 
{
    SafeRelease( progressLayer );
    SafeRelease( baseImage );
    SafeRelease( progressImage );
    
    [super dealloc];
}

-(void) initCommonViews
{
    UIImage * b = [[UIImage imageNamed: @"ProgressBase.png"] stretchableImageWithLeftCapWidth: 5 topCapHeight: 0];
    UIImage * p = [[UIImage imageNamed: @"Progress.png"] stretchableImageWithLeftCapWidth: 5 topCapHeight: 0];
    
    [self setImageForBackground: b andProgress: p];
    
    // self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent: .3];
    self.backgroundColor = [UIColor clearColor];
}

-(id) initWithFrame: (CGRect) frame 
{
    if( self = [super initWithFrame:frame] ) 
    {
        [self initCommonViews];
    }
    return self;
}

-(id) initWithCoder: (NSCoder *) coder
{
    if( self = [super initWithCoder: coder] )
    {
        [self initCommonViews];
    }
    
    return self;
}

-(float) progress { return progress; }
-(void) setProgress: (float) newProgress
{
    if( newProgress == progress )
        return;
    
    progress = newProgress;
    [self setNeedsDisplay];
}


-(void) setImageForBackground: (UIImage *) newBaseImage andProgress: (UIImage *) newProgressImage
{
    if( baseImage != newBaseImage )
    {
        [baseImage release];
        baseImage = [newBaseImage retain];
    }
    
    if( progressImage != newProgressImage )
    {
        [progressImage release];
        progressImage = [newProgressImage retain];
    }
    
    [self setNeedsDisplay];
}

-(void) drawRect: (CGRect) rect
{
    [baseImage drawInRect: rect];
    [progressImage drawInRect: CGRectMake( 0, 0, CGRectGetWidth( rect ) * MAX( 0, MIN( 1, progress ) ), CGRectGetHeight( rect ) )];
}


@end
