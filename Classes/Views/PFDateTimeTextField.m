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

@implementation PFDateTimeTextField

@synthesize dateFormatter;

-(void) dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [datePicker removeFromSuperview];
    
    SafeRelease( datePicker );
    SafeRelease( dateFormatter );
    
    [super dealloc];
}

-(void) initCommon
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardDidShow:) name: UIKeyboardWillShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardDidHide:) name: UIKeyboardDidHideNotification object: nil];

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

-(UIDatePicker *) datePicker
{
    if( ! datePicker )
    {
        datePicker = [[UIDatePicker alloc] init];
        
        [datePicker addTarget: self action: @selector(dateValueChanged:forEvent:) forControlEvents: UIControlEventValueChanged];
    }
    
    return datePicker;
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

-(UIDatePickerMode) datePickerMode { return self.datePicker.datePickerMode; }
-(void) setDatePickerMode: (UIDatePickerMode) datePickerMode
{
    self.datePicker.datePickerMode = datePickerMode;
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
    // Make sure we've created the date picker
    [self datePicker];
    
    UIView * parent = [self keyboardSuperview];
    
    CGRect frame = [datePicker frame];
    frame.origin = CGPointMake( 0, CGRectGetMaxY( parent.frame ) - CGRectGetHeight( frame ) );
    
    datePicker.frame = frame;
    [parent addSubview: datePicker];
    [parent bringSubviewToFront: datePicker];
}

-(void) hideDatePicker
{
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
