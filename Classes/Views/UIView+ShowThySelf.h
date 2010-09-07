// This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 
// Unported License. To view a copy of this license, visit 
// http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to Creative 
// Commons, 171 Second Street, Suite 300, San Francisco, California, 94105, USA.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PFShowThySelfCallbackDelegate;


@interface UIView (ShowThySelf)

-(void) popupWithCornerRadius: (CGFloat) radius 
					 animated: (BOOL) animated 
					 delegate: (id<PFShowThySelfCallbackDelegate>) callbackDelegate
					  context: (const void*) context;
-(void) popup: (BOOL) animated;
-(void) cancelPopup: (BOOL) animated;

@end


@protocol PFShowThySelfCallbackDelegate
@optional
-(void) viewDidTouchOutsidePopup: (UIView*) popupView context: (const void*) context;
-(void) viewDidDismissPopup: (UIView*) popupView context: (const void*) context;

@end