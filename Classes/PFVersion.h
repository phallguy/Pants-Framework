//
//  PFVersion.h
//  Pants-Framework
//
//  Created by Paul Alexander on 12/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PFVersion : NSObject <NSCopying, NSCoding>
{

@private
    NSString * original;
    int major;
    int minor;
    int release;
    
    NSString * moniker;
    
}

@property( nonatomic, readonly ) NSString * original;
@property( nonatomic, assign ) int major;
@property( nonatomic, assign ) int minor;
@property( nonatomic, assign ) int release;
@property( nonatomic, assign ) NSString * moniker;


+(PFVersion *) versionFromString: (NSString *) version;
-(id) initWithString: (NSString *) version;


-(NSString *) stringValue;

-(NSComparisonResult) compare: (PFVersion *) comparand;
@end
