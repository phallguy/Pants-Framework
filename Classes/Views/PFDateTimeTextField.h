//
//  PFDateTimeTextField.h
//  Pants-Framework
//
//  Created by Paul Alexander on 11/8/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PFDateTimeTextField : UITextField
{

@private
    UIDatePicker * datePicker;
    NSDateFormatter * dateFormatter;
    BOOL keyboardVisible;
    
}

//@property( nonatomic, readonly ) UIDatePicker * datePicker;
@property( nonatomic, retain ) NSDateFormatter * dateFormatter;
@property( nonatomic, assign ) NSDate * date;
@property( nonatomic, assign ) UIDatePickerMode datePickerMode;
@end
