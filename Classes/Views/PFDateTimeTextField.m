//
//  PFDateTimeTextField.m
//  Pants-Framework
//
//  Created by Paul Alexander on 11/8/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFDateTimeTextField.h"
#import "UIView+PFExtensions.h"
#import "GDataXML+PFXml.h"
#import "PFCalloutLayer.h"

@implementation PFDateTimeTextField

@synthesize dateFormatter;

-(void) dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [datePicker removeFromSuperview];
    [shade removeFromSuperview];
    
    SafeRelease( shade );
    SafeRelease( datePicker );
    SafeRelease( dateFormatter );
    
    [super dealloc];
}

-(void) initCommon
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardDidShow:) name: UIKeyboardWillShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardDidHide:) name: UIKeyboardDidHideNotification object: nil];

    if( ! datePicker )
    {
        datePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake( 0, 0, 320, 216)];
        
        [datePicker addTarget: self action: @selector(dateValueChanged:forEvent:) forControlEvents: UIControlEventValueChanged];
    }

}

-(id) initWithFrame: (CGRect) frame 
{
    if( self = [super initWithFrame:frame] ) 
    {
        [self initCommon];
    }
    
    return self;
}

-(id) initWithCoder: (NSCoder *) coder
{
    if( self = [super initWithCoder: coder] )
    {
        [self initCommon];
    }
    
    return self;
}

-(NSDate *) date { return [self.dateFormatter dateFromString: self.text]; }
-(void) setDate: (NSDate *) date
{
    self.text = [self.dateFormatter stringFromDate: date];
}


-(NSDateFormatter *) dateFormatter
{
    if( dateFormatter == nil )
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        
        switch( datePicker.datePickerMode )
        {
            case UIDatePickerModeDate:
                [dateFormatter setTimeStyle: NSDateFormatterNoStyle];
                [dateFormatter setDateStyle: NSDateFormatterMediumStyle];
                break;
            case UIDatePickerModeDateAndTime:
                [dateFormatter setTimeStyle: NSDateFormatterMediumStyle];
                [dateFormatter setDateStyle: NSDateFormatterMediumStyle];
                break;
            case UIDatePickerModeCountDownTimer:
            case UIDatePickerModeTime:
                [dateFormatter setTimeStyle: NSDateFormatterMediumStyle];
                [dateFormatter setDateStyle: NSDateFormatterNoStyle];
                break;
        }
    }
    
    return dateFormatter;
}

-(UIDatePickerMode) datePickerMode { return datePicker.datePickerMode; }
-(void) setDatePickerMode: (UIDatePickerMode) datePickerMode
{
    datePicker.datePickerMode = datePickerMode;
    SafeRelease( dateFormatter );
}


-(UIView *) keyboardSuperview
{
    UIView * kb = [UIView findKeyboardView];
    if( kb )
        return [kb superview];
    
    return [[UIApplication sharedApplication] keyWindow];
}

-(void) showDatePicker
{

    UIView * parent = [self keyboardSuperview];
    
    if( ! shade && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        shade = [[UIView alloc] initWithFrame: CGRectMake( 0,  0, CGRectGetWidth( parent.frame ), CGRectGetHeight( parent.frame ) )];
        shade.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: .5];
        
        PFCalloutLayer * callout = [[PFCalloutLayer alloc] init];
        CGRect bounds = CGRectMake( 15, 15, CGRectGetWidth( datePicker.frame ), CGRectGetHeight( datePicker.frame ) );
        bounds = CGRectInset( bounds,  -15,  -15 );
        callout.bounds = bounds;
        callout.position = CGPointMake( CGRectGetMidX( shade.frame ), CGRectGetMidY( shade.frame ) );
        [callout setNeedsDisplay];
        
        [shade.layer addSublayer: callout];
    }                        
    
    
    shade.frame = CGRectMake( 0, 0, CGRectGetWidth( parent.frame ), CGRectGetHeight( parent.frame ) );
    [parent addSubview: shade];
    CGRect frame = [datePicker frame];
    //frame.size.height = 264;
    frame.origin = CGPointMake( CGRectGetMidX( parent.frame ) - CGRectGetWidth( frame ) / 2, CGRectGetMidY( parent.frame ) - CGRectGetHeight( frame ) / 2 );
    
    datePicker.frame = frame;
    [parent addSubview: datePicker];
    [parent bringSubviewToFront: shade];
    [parent bringSubviewToFront: datePicker];
    
}

-(void) hideDatePicker
{
    [shade removeFromSuperview];
    [datePicker removeFromSuperview];
}

-(BOOL) becomeFirstResponder
{
    if( ! [super becomeFirstResponder] )
        return NO;
    
    if( keyboardVisible )
        [self showDatePicker];
    
    if( self.text && [self.text length] )
        datePicker.date = [self.dateFormatter dateFromString: self.text];
    
    return YES;
}

-(BOOL) resignFirstResponder
{
    [self hideDatePicker];

    return [super resignFirstResponder];
}


-(void) keyboardDidShow: (NSNotification *) not
{
    if( keyboardVisible ) return;
    keyboardVisible = YES;

    if( self.isFirstResponder )
        [self showDatePicker];
}

-(void) keyboardDidHide: (NSNotification *) not
{
    if( ! keyboardVisible ) return;
    keyboardVisible = NO;
    
    [self hideDatePicker];
}

-(void) dateValueChanged: (id) sender forEvent: (UIEvent *) event
{
    NSDate * date = datePicker.date;
    NSString * dateString = [self.dateFormatter stringFromDate: date];
    
    NSLog( @"Updating date to: %@ / %@", dateString, date );
    
    self.text = dateString;
}

@end
