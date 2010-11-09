//
//  UIView+PFExtensions.m
//  Pants-Framework
//
//  Created by Paul Alexander on 11/7/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "UIView+PFExtensions.h"


@implementation UIView (PFExtensions)

-(UIView *) findFirstResponder
{
    if( self.isFirstResponder )
        return self;
    
    for( UIView * view in self.subviews )
    {
        UIView * first = [view findFirstResponder];
        if( first )
            return first;
    }    
    
    return nil;
}


+(UIView *) findFirstResponder
{
    return [[[UIApplication sharedApplication] keyWindow] findFirstResponder];
}

UIView * FindViewOfClass( UIView * root, const char * className )
{
    if( ! root ) return nil;
    
    if( strcmp( object_getClassName( root ), className ) == 0 )
        return root;
    
    for( UIView * v in [root subviews] )
    {
        UIView * child = FindViewOfClass( v, className );
        if( child )
            return child;
    }
    
    return nil;
}

+(UIView *) findKeyboardView
{
    NSArray * windows = [[UIApplication sharedApplication] windows];
    
    for( UIWindow * window in [windows reverseObjectEnumerator] )
    {
        UIView * kb = FindViewOfClass( window, "UIKeyboardImpl" );
        if( !kb )
            kb = FindViewOfClass( window, "UIKeyboard" );
        if( kb )
            return kb;
    }
    
    return nil;
}




@end
