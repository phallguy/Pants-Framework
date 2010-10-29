//
//  PFProgressView.h
//  Pants-Framework
//
//  Created by Paul Alexander on 10/26/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CALayer;

@interface PFProgressView : UIView 
{
@private
    float progress;
    
    CALayer * progressLayer;
    
    UIImage * baseImage;
    UIImage * progressImage;
}

@property( nonatomic, assign ) float progress;

-(void) setImageForBackground: (UIImage *) newBaseImage andProgress: (UIImage *) newProgressImage;

@end
