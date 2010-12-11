//
//  UIDevice+PFExtensions.h
//  Pants-Framework
//
//  Created by Paul Alexander on 12/10/10.
//  Copyright 2010 n/a. All rights reserved.
//
// Based on code from Dutchie432
// http://stackoverflow.com/questions/448162/determine-device-iphone-ipod-touch-with-iphone-sdk/1561920#1561920
//
// Based on code from Jess
// http://iphoneincubator.com/blog/device-information/how-to-obtain-total-and-available-disk-space-on-your-iphone-or-ipod-touch

#import <Foundation/Foundation.h>


@interface UIDevice (PFExtensions)

-(NSString *) platform;
-(NSString *) platformCommonName;
-(unsigned long long) storageSize;
-(NSString *) storageSizeCommonName;

-(NSString *) versionString;
@end
