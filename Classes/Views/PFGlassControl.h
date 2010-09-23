//
//  PFGlassControl.h
//  Pants-Framework
//
//  Created by Paul Alexander on 9/22/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PFGlassControl : UIControl 
{
    
@private
	CGFloat borderWidth;
	CGFloat cornerRadius;
	CGFloat shadowDepth;
}

@property( nonatomic, assign ) CGFloat borderWidth;
@property( nonatomic, assign ) CGFloat cornerRadius;
@property( nonatomic, assign ) CGFloat shadowDepth;

-(CGRect) drawGlassRect: (CGRect) rect;
-(void) initializeDefaultGlassState;
-(UIImage*) photo;

@end
