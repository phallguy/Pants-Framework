//
//  Utility.h
//  Surveyor
//
//  Created by Paul Alexander on 7/19/10.
//  Copyright 2010 XHEO INC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PFUtility : NSObject 
{

}

+(NSString*) createUuid;

@end

@interface NSString (PFUtility)

-(NSString*) md5;

@end

#if DEBUG
    extern bool AmIBeingDebugged(void);
    #if __ppc64__ || __ppc__
        #define DebugBreak() \
        if(AmIBeingDebugged()) \
        { \
        __asm__("li r0, 20\nsc\nnop\nli r0, 37\nli r4, 2\nsc\nnop\n" \
        : : : "memory","r0","r3","r4" ); \
        }
    #elif __i386__ || __x86_x64__
        #define DebugBreak() if(AmIBeingDebugged()) {__asm__("int $3\n" : : );}
    #elif __arm__   
#define DebugBreak() if( AmIBeingDebugged() ){ __asm__("mov r0, #20\nmov ip, r0\nsvc 128\nmov r1, #37\nmov ip, r1\nmov r1, #2\nmov r2, #1\n svc 128\n" \
: : : "memory","ip","r0","r1","r2"); }
    #else
        #error Seriously what happened! A new CPU!
        #define DebugBreak() if( AmIBeingDebugged() ){ raise( SIGINT ); }
    #endif

    #define PFAssert( condition, msg, ... ) \
        do { \
            if( ! ( condition ) ) { \
                NSLog( msg, ##__VA_ARGS__ ); \
                DebugBreak(); \
            } \
        } while( 0 )
#else
    #define DebugBreak()
    #define PFAssert(condition,msg,...)
#endif