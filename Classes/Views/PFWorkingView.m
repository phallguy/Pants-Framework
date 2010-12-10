//
//  PFWorkingView.m
//  Pants-Framework
//
//  Created by Paul Alexander on 12/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PFWorkingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PFWorkingView

@synthesize activityIndicator, titleLabel, cancelButton;

-(void) dealloc
{
    SafeRelease( activityIndicator );
    SafeRelease( statusView );
    SafeRelease( titleLabel );
    SafeRelease( cancelButton );
    
    [super dealloc];
}

-(id) initWithTitle: (NSString *) title showCancelButton: (BOOL) showCancelButton
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    if( ( self = [super initWithFrame: frame] ) )
    {
        [self setImage: [UIImage imageNamed: @"ScreenOverlay.png"]];
        self.userInteractionEnabled = YES;
        
        statusView = [[UIView alloc] initWithFrame: CGRectMake( ( CGRectGetWidth( frame ) - 200 ) / 2,
                                                                ( CGRectGetHeight( frame ) - 200 ) / 2,
                                                                200,
                                                                200 )];
        
        statusView.layer.masksToBounds = YES;
        statusView.layer.cornerRadius = 16;
        statusView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: .75];
        
        [self addSubview: statusView];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.center = CGPointMake( 100, 60 );
        [activityIndicator startAnimating];
        [statusView addSubview: activityIndicator];
        
        titleLabel = [[UILabel alloc] initWithFrame: CGRectMake( 0, 90, 200, 40 )];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName: @"MarkerFelt-Thin" size: 25];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        [statusView addSubview: titleLabel];                    
        
        if( showCancelButton )
        {
            cancelButton = [[UIButton buttonWithType: UIButtonTypeRoundedRect] retain];
            cancelButton.frame = CGRectMake( 30, 140, 135, 38 );
            [cancelButton setTitle: @"Cancel" forState: UIControlStateNormal];
            [statusView addSubview: cancelButton];
        }
        
    }
    
    return self;
}


@end
