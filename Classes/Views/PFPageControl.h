//
//  PFPageControl.h
//  Pants-Framework
//
//  Created by Paul Alexander on 9/29/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//
//  Original inspiration from http://www.onidev.com/2009/12/02/customisable-uipagecontrol/

#import <UIKit/UIKit.h>


@interface PFPageControl : UIPageControl 
{

@private
    UIImage * defaultImage;
    UIImage * defaultHighlightedImage;
    
    
    NSMutableArray * customImages;
    NSMutableArray * customHighlitedImages;
}


@property( nonatomic, retain ) UIImage * defaultImage;
@property( nonatomic, retain ) UIImage * defaultHighlightedImage;


-(UIImage*) imageForPage: (NSInteger) pageIndex forState: (UIControlState) state;
-(void) setImage: (UIImage*) image forPage: (NSInteger) pageIndex forState: (UIControlState) state;


@end
