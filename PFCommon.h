/*
 *  Common.h
 *  Surveyor
 *
 *  Created by Paul Alexander on 7/14/10.
 *  Copyright 2010 XHEO INC. All rights reserved.
 *
 */


#define SafeRelease(obj) [obj release]; obj = nil


//
//  SynthesizeSingleton.h
//
//  Created by Matt Gallagher on 20/10/08.
//

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
static classname *shared##classname = nil; \
+ (classname *)shared##classname { @synchronized(self) { if (shared##classname == nil) { [[self alloc] init]; } } return shared##classname; } \
+ (id)allocWithZone:(NSZone *)zone { @synchronized(self) { if (shared##classname == nil) { shared##classname = [super allocWithZone:zone]; return shared##classname; } } return nil; } \
- (id)copyWithZone:(NSZone *)zone { return self; } \
- (id)retain { return self; } \
- (NSUInteger)retainCount { return NSUIntegerMax; } \
- (void)release { } \
- (id)autorelease { return self; }


#define DegreesToRadians(degrees) ( ( degrees ) * M_PI / 180 )
#define RadiansToDegrees(radians) ( ( radians ) * 180 / M_PI )
