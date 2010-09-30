//
//  PFPageControl.m
//  Pants-Framework
//
//  Created by Paul Alexander on 9/29/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import "PFPageControl.h"

@interface PFPageControl()

-(void) overridePageImages;

@end

@implementation PFPageControl

- (void)dealloc 
{
    SafeRelease( defaultImage );
    SafeRelease( defaultHighlightedImage );
    SafeRelease( customImages );
    SafeRelease( customHighlitedImages );
    
    [super dealloc];
}

#pragma mark -
#pragma mark State


-(UIImage*) defaultImage{ return defaultImage; }
-(void) setDefaultImage: (UIImage *) newDefaultImage
{
    if( defaultImage == newDefaultImage )
        return;
    
    [defaultImage release];
    defaultImage = [newDefaultImage retain];    
    
    [self overridePageImages];
}

-(UIImage*) defaultHighlightedImage { return defaultHighlightedImage; }
-(void) setDefaultHighlightedImage: (UIImage *) newDeafultHighlightedImage
{
    if( defaultHighlightedImage == newDeafultHighlightedImage )
        return;
    
    [defaultHighlightedImage release];
    defaultHighlightedImage = [newDeafultHighlightedImage retain];
    
    [self overridePageImages];
}

-(UIImage *) imageForPage: (NSInteger) pageIndex forState: (UIControlState) state
{
    NSArray * images = state == UIControlStateHighlighted ? customHighlitedImages : customImages;
    
    if( images && pageIndex >= 0 && pageIndex < images.count )
    {
        id img = [images objectAtIndex: pageIndex];
        if( img != [NSNull null] )
            return img;
    }
    
    return state == UIControlStateHighlighted ? defaultHighlightedImage : defaultImage;
}

-(void) setImage: (UIImage *) image forPage: (NSInteger) pageIndex forState: (UIControlState) state
{
    if( state != UIControlStateNormal && state != UIControlStateHighlighted )
        return;

    if( ! customImages )
        customImages = [[NSMutableArray alloc] initWithCapacity: self.numberOfPages];
    
    if( ! customHighlitedImages )
        customHighlitedImages = [[NSMutableArray alloc] initWithCapacity: self.numberOfPages];
    
    NSMutableArray * images = state == UIControlStateHighlighted ? customHighlitedImages : customImages;
    

    while( images.count <= pageIndex )
        [images addObject: [NSNull null]];
    
    [images replaceObjectAtIndex: pageIndex withObject: image ? (id)image : [NSNull null]];    
    [self overridePageImages];
}

#pragma mark -
#pragma mark Events

-(void) endTrackingWithTouch: (UITouch *) touch withEvent: (UIEvent *) event
{
    [super endTrackingWithTouch: touch withEvent: event];
    [self overridePageImages];
}

#pragma mark -
#pragma mark Helpers


-(void) overridePageImages
{
   if( defaultImage || defaultHighlightedImage ||
       customImages || customHighlitedImages )
   {
       NSArray * dots = self.subviews;
       
       // If Apple ever does change how the segments are rendered then gracefully degrade
       // to the default Apple behavior.
       NSAssert( dots.count == self.numberOfPages, @"Hmmm, Apple changed how page controls are stuctured: expected %d but got %d. File a report at http://github.com/appsinyourpants/Pants-Framework/issues", self.numberOfPages, dots.count );
       
       if( dots.count != self.numberOfPages )
           return;
       
       for( int ix = 0; ix < dots.count; ix++ )
       {
           UIControlState state = ix == self.currentPage ? UIControlStateHighlighted : UIControlStateNormal;
           UIImage * img = [self imageForPage: ix forState: state];
           if( ! img ) continue;
           
           UIImageView * dot = [dots objectAtIndex: ix];
           CGPoint center = dot.center;
           dot.image = img;
           dot.bounds = CGRectMake( 0, 0, img.size.width, img.size.height );
           dot.center = center;
       }
   }
}


@end
