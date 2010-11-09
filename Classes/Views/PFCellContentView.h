//
//  PFCellContentView.h
//  Pants-Framework
//
//  Created by Paul Alexander on 10/18/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PFCellContentView : UIView 
{

@private
    UILabel * textLabel;
    UILabel * detailLabel;
    UIImageView * imageView;
    UIButton * imageButtonOverlay;
    UIView * accessoryView;
}

@property( nonatomic, readonly ) UILabel * textLabel;
@property( nonatomic, readonly ) UILabel * detailLabel;
@property( nonatomic, readonly ) UIImageView * imageView;
@property( nonatomic, readonly ) UIButton * imageButtonOverlay;
@property( nonatomic, readonly ) UIView * accessoryView;

@end
