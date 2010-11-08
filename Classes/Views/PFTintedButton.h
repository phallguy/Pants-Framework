//
//  PFTintedButton.h
//  Pants-Framework
//
//  Created by Paul Alexander on 11/7/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PFTintedButton : UIButton
{
@private
    UIColor * tint;
    CGFloat cornerRadius;
    
    UIImage * stretchImage;
}

@property( nonatomic, retain ) UIColor * tint;
@property( nonatomic, assign ) CGFloat cornerRadius;


@end
