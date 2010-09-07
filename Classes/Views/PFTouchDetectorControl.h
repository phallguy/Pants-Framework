//
//  PFTouchDetectorControl.h
//  Pants-Framework
//
//  Created by Paul Alexander on 9/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PFTouchDetectorControl : UIControl 
{
@private
	id delegate;
	const void * context;
}

@property( nonatomic, assign ) id delegate;
@property( nonatomic, assign ) const void * context;
@end
