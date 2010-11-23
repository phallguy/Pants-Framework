//
//  PFDisclosureIndicatorView.h
//  Pants-Framework
//
//  Created by Paul Alexander on 11/20/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PFDisclosureIndicatorView : UIView 
{

@private
    UIColor * color;
    UIColor * highlightedColor;
}

@property( nonatomic, retain ) UIColor * color;
@property( nonatomic, retain ) UIColor * highlightedColor;

-(id) initWithFrame: (CGRect) frame color: (UIColor *) newColor highlightedColor: (UIColor *) newHighlightedColor;

@end
