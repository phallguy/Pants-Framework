// This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 
// Unported License. To view a copy of this license, visit 
// http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to Creative 
// Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.


#import "UIView+ShowThySelf.h"
#import "PFPopupBorderWithShadowView.h"
#import "PFTouchDetectorControl.h"
#import	<QuartzCore/QuartzCore.h>


@implementation UIView (ShowThySelf)

-(void) dismiss: (BOOL) animated
{
	PFPopupBorderWithShadowView * hostView = (PFPopupBorderWithShadowView*) self.superview;
	PFTouchDetectorControl * touchScreen = (PFTouchDetectorControl*) hostView.superview;

	if( animated )
	{
		[UIView beginAnimations: @"popdownDialog" context: nil];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
		[UIView setAnimationDidStopSelector: @selector( closeAnimationPhase1Finished:finished:context: )];
		[UIView setAnimationDuration: .10];
		
		hostView.transform = CGAffineTransformScale( hostView.hostTransform, 1.1, 1.1 );
		
		[UIView commitAnimations];
	}
	else
	{
		[touchScreen removeFromSuperview];
		[self removeFromSuperview];
		
		if( touchScreen.delegate && [touchScreen.delegate respondsToSelector: @selector( viewDidDismissPopup:context: ) ] )
		{
			[touchScreen.delegate viewDidDismissPopup: self context: touchScreen.context];
		}
	
		
		[hostView release];
		[touchScreen release];		
	}
}


-(void) touchScreenPressed: (id) sender
{
 	PFTouchDetectorControl * touchScreen = (PFTouchDetectorControl*)sender;
	
	if( touchScreen.delegate && [touchScreen.delegate respondsToSelector: @selector(viewDidTouchOutsidePopup:context:)] )
	{
		[touchScreen.delegate viewDidTouchOutsidePopup: self context: touchScreen.context];
	}
	else
	{
		[self dismiss: YES];
	}
}

-(void) popupAnimationFinished: (NSString*) animationID finished: (NSNumber*) finished context: (void*) context
{
	PFPopupBorderWithShadowView * hostView = (PFPopupBorderWithShadowView*) self.superview;

	[UIView beginAnimations: @"popupShowingDialogPopBack" context: nil];
	
	hostView.transform = hostView.hostTransform;
	
	[UIView commitAnimations];
}

-(void) closeAnimationPhase1Finished: (NSString*) animationID finished: (NSNumber*) finished context: (void*) context
{
	PFPopupBorderWithShadowView * hostView = (PFPopupBorderWithShadowView*) self.superview;
	PFTouchDetectorControl * touchScreen = (PFTouchDetectorControl*) hostView.superview;

	
	[UIView beginAnimations: @"popdownDialog" context: nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: @selector( closeAnimationFinished:finished:context: )];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration: .10];
	
	hostView.transform = CGAffineTransformMakeScale( .01, .01 );
	touchScreen.alpha = 0;
	
	[UIView commitAnimations];
}

-(void) closeAnimationFinished: (NSString*) animationID finished: (NSNumber*) finished context: (void*) context
{
	[self dismiss: NO];
}

-(void) popup: (BOOL) animated
{
	[self popupWithCornerRadius: 0 
					   animated: animated 
					   delegate: nil
						context: NULL];
}

-(void) popupWithCornerRadius: (CGFloat) radius 
					 animated: (BOOL) animated 
					 delegate: (id<PFShowThySelfCallbackDelegate>) callbackDelegate
					  context: (const void*) context
{	
    
	UIWindow * window = [[UIApplication sharedApplication] keyWindow];
	if( ! window )
		window = [[[UIApplication sharedApplication] windows] objectAtIndex: 0];
	
	
	PFTouchDetectorControl * touchScreen = [[PFTouchDetectorControl alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
	touchScreen.delegate = callbackDelegate;
	touchScreen.context = context;
    
    [touchScreen addTarget: self 
                    action: @selector(touchScreenPressed:) 
          forControlEvents: UIControlEventTouchUpInside];
    
    
    CGAffineTransform transform = self.transform;
    self.transform = CGAffineTransformIdentity;
	
	PFPopupBorderWithShadowView * hostView = [[PFPopupBorderWithShadowView alloc] initWithFrame: self.frame];
	hostView.borderWidth = 12;
	hostView.borderColor = self.backgroundColor;
    hostView.hostTransform = transform;
	
	if( radius > 0 )
	{
		self.layer.cornerRadius = radius;
		self.layer.masksToBounds = YES;
	}
	
	[hostView addSubview: self];
	[touchScreen addSubview: hostView];
    
	hostView.center = touchScreen.center;
    self.center = CGPointMake( CGRectGetWidth( hostView.frame ) / 2, CGRectGetHeight( hostView.frame ) / 2 );

	
		
	[window addSubview: touchScreen];
    
	if( animated )
	{
		hostView.transform = CGAffineTransformMakeScale( 0.01,  0.01 );
		touchScreen.alpha = 0;

		[UIView beginAnimations: @"popupShowingDialog" context: nil];
		[UIView setAnimationDuration: .10];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
		[UIView setAnimationDidStopSelector: @selector( popupAnimationFinished:finished:context: )];
		
		hostView.transform = CGAffineTransformMakeScale( 1.2, 1.2 );
		touchScreen.alpha = 1;
		
		[UIView commitAnimations];
	}
}



-(void) cancelPopup: (BOOL) animated
{
	[self dismiss: animated];
}


@end
