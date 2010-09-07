//
//  PopupBorderWithShadowView.h
//  Pants-Framework
//
//  Created by Paul Alexander on 9/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface PFPopupBorderWithShadowView : UIView 
{

@private
	UIColor * borderColor;	
	int borderWidth;
    CGAffineTransform hostTransform;
}

@property( nonatomic, retain ) UIColor * borderColor;
@property( nonatomic, assign ) int borderWidth;
@property( nonatomic, assign ) CGAffineTransform hostTransform;


@end
