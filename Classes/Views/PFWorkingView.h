//
//  PFWorkingView.h
//  Pants-Framework
//
//  Created by Paul Alexander on 12/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PFWorkingView : UIImageView 
{

@private
    UIActivityIndicatorView * activityIndicator;
    UILabel * titleLabel;
    UIButton * cancelButton;
    UIView * statusView;
}

@property( nonatomic, readonly ) UIActivityIndicatorView * activityIndicator;
@property( nonatomic, readonly ) UILabel * titleLabel;
@property( nonatomic, readonly ) UIButton * cancelButton;

-(id) initWithTitle: (NSString *) title showCancelButton: (BOOL) showCancelButton;

@end
