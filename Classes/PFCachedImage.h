//
//  PFCachedImage.h
//  Pants-Framework
//
//  Created by Paul Alexander on 9/21/10.
//  Copyright (c) 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PFCachedImage : UIImage 
{

@private
    NSString * path;
    UIImage * realImage;
    time_t timestamp;
}

@property( nonatomic, assign, readonly ) time_t timestamp;

+(id) cachedImageWithPath: (NSString*) path;

-(id) initWithPath: (NSString *) newPath;
-(void) trim;

@end
