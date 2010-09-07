// This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 
// Unported License. To view a copy of this license, visit 
// http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to Creative 
// Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.


#import "UIView+ShowThySelf.h"


@implementation UIView (ShowThySelf)

-(void) dismiss: (BOOL) animated
{
	UIView * touchScreen = self.superview;

	if( animated )
	{
		[UIView beginAnimations: @"popdownDialog" context: nil];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
		[UIView setAnimationDidStopSelector: @selector( closeAnimationPhase1Finished:finished:context: )];
		[UIView setAnimationDuration: .10];
		
		self.transform = CGAffineTransformMakeScale( 1.2, 1.2 );
		
		[UIView commitAnimations];
	}
	else
	{
		[touchScreen removeFromSuperview];
		[self removeFromSuperview];
		[touchScreen release];
	}
}


-(void) touchScreenPressed
{
    [self dismiss: YES];
}

-(void) popupAnimationFinished: (NSString*) animationID finished: (NSNumber*) finished context: (void*) context
{
	[UIView beginAnimations: @"popupShowingDialogPopBack" context: nil];
	self.transform = CGAffineTransformIdentity;
	
	[UIView commitAnimations];
}

-(void) closeAnimationPhase1Finished: (NSString*) animationID finished: (NSNumber*) finished context: (void*) context
{
	[UIView beginAnimations: @"popdownDialog" context: nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: @selector( closeAnimationFinished:finished:context: )];
	[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration: .10];
	
	self.transform = CGAffineTransformMakeScale( .01, .01 );
	
	[UIView commitAnimations];
}

-(void) closeAnimationFinished: (NSString*) animationID finished: (NSNumber*) finished context: (void*) context
{
	[self dismiss: NO];
}

-(void) popup: (BOOL) animated
{	
	UIWindow * window = [[UIApplication sharedApplication] keyWindow];
	if( ! window )
		window = [[[UIApplication sharedApplication] windows] objectAtIndex: 0];
	
	
	UIControl * touchScreen = [[UIControl alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
	
    [touchScreen addTarget: self 
                    action: @selector(touchScreenPressed) 
          forControlEvents: UIControlEventTouchUpInside];
	
	[touchScreen addSubview: self];
    
    self.center = touchScreen.center;
		
	[window addSubview: touchScreen];
    
	if( animated )
	{
		self.transform = CGAffineTransformMakeScale( 0.01,  0.01 );
		touchScreen.backgroundColor = [UIColor clearColor];

		[UIView beginAnimations: @"popupShowingDialog" context: nil];
		[UIView setAnimationDuration: .10];
		[UIView setAnimationDelegate: self];
		[UIView setAnimationCurve: UIViewAnimationCurveEaseIn];
		[UIView setAnimationDidStopSelector: @selector( popupAnimationFinished:finished:context: )];
		
		self.transform = CGAffineTransformMakeScale( 1.2, 1.2 );
		
		[UIView commitAnimations];
	}
}



-(void) cancelPopup: (BOOL) animated
{
	[self dismiss: animated];
}


@end
