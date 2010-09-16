//
//  PFGlassButton.h
//  Pants-Framework
//
//  Created by Paul Alexander on 9/16/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PFGlassButton : UIButton
{
    
@private
    CGFloat cornerRadius;
    CGFloat shadowBlur;
}

@property( nonatomic, assign ) CGFloat cornerRadius;
@property( nonatomic, assign ) CGFloat shadowBlur;

@end
