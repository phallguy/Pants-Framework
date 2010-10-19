//
//  PFCellContentView.m
//  Pants-Framework
//
//  Created by Paul Alexander on 10/18/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFCellContentView.h"


#define kPFCellContentInnerPadding 10.0

@implementation PFCellContentView
@synthesize textLabel, detailLabel, imageView, accessoryView;

-(void) dealloc 
{
    SafeRelease( textLabel );
    SafeRelease( detailLabel );
    SafeRelease( imageView );
    SafeRelease( accessoryView );
    
    [super dealloc];
}

-(id) initWithFrame: (CGRect) frame 
{
    if( self = [super initWithFrame:frame] ) 
    {
        self.backgroundColor = [UIColor clearColor];
        //self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent: .25];
    }
    return self;
}

#pragma mark - 
#pragma mark State

-(UILabel *) textLabel
{
    if( textLabel == nil )
    {
        textLabel = [[UILabel alloc] initWithFrame: self.bounds];
        textLabel.font = [UIFont boldSystemFontOfSize: 17];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.shadowOffset = CGSizeMake( 0, -1.5 );
        textLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent: .5];
        textLabel.userInteractionEnabled = NO;
        
        [self addSubview: textLabel];
        [self setNeedsLayout];
    }
    return textLabel;
}

-(UILabel *) detailLabel
{
    if( detailLabel == nil )
    {
        detailLabel = [[UILabel alloc] initWithFrame: self.bounds];
        
        detailLabel.font = [UIFont systemFontOfSize: 14];
        detailLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent: .8];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.userInteractionEnabled = NO;
        detailLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        [self addSubview: detailLabel];
        [self setNeedsLayout];
    }
    return detailLabel;
}

-(UIImageView *) imageView
{
    if( imageView == nil )
    {
        imageView = [[UIImageView alloc] initWithFrame: CGRectMake( 0, 0, CGRectGetHeight( self.bounds), CGRectGetHeight( self.bounds ) )];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.userInteractionEnabled = NO;
        
        [self addSubview: imageView];
        [self setNeedsLayout];        
    }
    
    return imageView;
}

-(UIView *) accessoryView
{
    if( accessoryView == nil )
    {
        accessoryView = [[UIButton buttonWithType: UIButtonTypeDetailDisclosure] retain];
        accessoryView.backgroundColor = [UIColor clearColor];
        [self addSubview: accessoryView];
        [self setNeedsLayout];
    }
    
    return accessoryView;
}




#pragma mark -
#pragma mark Layout


-(CGSize) sizeThatFits: (CGSize) totalSize
{
    CGSize size = totalSize;
    CGSize fitsize = CGSizeZero;
    CGSize imageSize = CGSizeZero;
    CGSize accessorySize = CGSizeZero;
    
    
    if( imageView != nil && ! imageView.hidden )
    {
        imageSize = [imageView sizeThatFits: size];
        fitsize.width += imageSize.width;
        fitsize.height = MAX( fitsize.height, imageSize.height );
        
        size.width -= imageSize.width;
        
        if( accessoryView && ! accessoryView.hidden )
        {
            size.width -= kPFCellContentInnerPadding;
            fitsize.width += kPFCellContentInnerPadding;
        }
        
        if( ( textLabel && ! textLabel.hidden ) || ( detailLabel && ! detailLabel.hidden ) )
        {
            size.width -= kPFCellContentInnerPadding;
            fitsize.width += kPFCellContentInnerPadding;
        }
    }
    
    if( accessoryView != nil && ! accessoryView.hidden )
    {
        accessorySize = [accessoryView sizeThatFits: size];
        fitsize.width += accessorySize.width;
        fitsize.height = MAX( fitsize.height, accessorySize.height );
        
        size.width -= accessorySize.width;
        
        if( ( textLabel && ! textLabel.hidden ) || ( detailLabel && ! detailLabel.hidden ) )
        {
            size.width -= kPFCellContentInnerPadding;
            fitsize.width += kPFCellContentInnerPadding;
        }        
    }    

    CGSize textSize = CGSizeZero;
   
    
    if( textLabel != nil && ! textLabel.hidden )
    {        
        textSize = [textLabel sizeThatFits: size];

        size.height -= textSize.height;
    }
    
    if( detailLabel != nil && ! detailLabel.hidden )
    {
        CGSize s = [detailLabel sizeThatFits: size];
        
        
        if( s.width > size.width )
        {
            s = [detailLabel.text sizeWithFont: detailLabel.font constrainedToSize: size lineBreakMode: detailLabel.lineBreakMode];
        }
        textSize.height += s.height;
        textSize.width = MAX( textSize.width, s.width );
    }    
    
    fitsize.height = MAX( fitsize.height, textSize.height );
    fitsize.width += textSize.width;
    
    fitsize.width = MIN( fitsize.width, totalSize.width );
    fitsize.height = MIN( fitsize.height, totalSize.height );
    
    return fitsize;
}

-(void) layoutSubviews
{
    
    [super layoutSubviews];
    
    CGRect textRect = self.bounds;
    
    if( imageView != nil && ! imageView.hidden )
    {
        
        CGSize size = [imageView sizeThatFits: self.bounds.size];
        imageView.frame = CGRectMake( 0, 0, size.width, size.height );

        textRect.origin.x += CGRectGetWidth( imageView.bounds );
        textRect.size.width -= CGRectGetWidth( imageView.bounds );

        
        if( ( textLabel && ! textLabel.hidden ) || ( detailLabel && ! detailLabel.hidden ) )
        {
            textRect.origin.x += kPFCellContentInnerPadding;
            textRect.size.width -= kPFCellContentInnerPadding;
        }
    }
    
    if( accessoryView != nil && ! accessoryView.hidden )
    {
        textRect.size.width -= CGRectGetWidth( accessoryView.bounds );
        CGRect frame = accessoryView.frame;
        frame.origin.x = CGRectGetWidth( self.bounds ) - CGRectGetWidth( accessoryView.bounds );
        frame.size.height = CGRectGetHeight( self.bounds );
        
        
        accessoryView.frame = frame;

        if( ( textLabel && ! textLabel.hidden ) || ( detailLabel && ! detailLabel.hidden ) )
        {
            textRect.size.width -= kPFCellContentInnerPadding;
        }
    }
    
    CGRect frame = textRect;
    
    if( detailLabel && ! detailLabel.hidden )
        frame.size.height = [textLabel sizeThatFits: textRect.size].height;
    frame.origin.y = textRect.origin.y;
    textLabel.frame = frame;
    
    textRect.size.height -= CGRectGetHeight( frame );
    textRect.origin.y += CGRectGetHeight( frame );    
    
    detailLabel.frame = textRect;
    detailLabel.numberOfLines = ceil( [detailLabel.text sizeWithFont: detailLabel.font constrainedToSize: textRect.size lineBreakMode: detailLabel.lineBreakMode].height / [detailLabel sizeThatFits: textRect.size].height );
}


-(BOOL) pointInside: (CGPoint) point withEvent: (UIEvent *) event
{
    for( UIView * childView in self.subviews )
        if( childView.userInteractionEnabled && [childView pointInside: [self convertPoint: point toView: childView] withEvent: event] )
            return YES;
    
    return NO;
}

@end
