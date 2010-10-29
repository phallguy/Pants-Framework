//
//  PFLabel.h
//  Pants-Framework
//
//  Created by Paul Alexander on 9/16/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PFLabel : UILabel 
{

@private
    CGFloat shadowBlur;
    
}

@property( nonatomic, assign ) CGFloat shadowBlur;
-(void) alignToTopWithMaxHeight: (CGFloat) maxHeight;

@end
