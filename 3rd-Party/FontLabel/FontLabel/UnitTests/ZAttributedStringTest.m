//
//  ZAttributedStringTest.m
//  FontLabel
//
//  Created by Kevin Ballard on 9/26/09.
//  Copyright 2009 Zynga Game Networks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>
#import "ZAttributedString.h"

@interface ZAttributedStringTest : SenTestCase
@end

@implementation ZAttributedStringTest
- (void)testInitWithString {
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"test"] autorelease];
	STAssertEqualObjects(str.string, @"test", @"-initWithString preserves the string");
	STAssertEquals(str.length, (NSUInteger)4, @"string length == 4");
	NSDictionary *attrs = [str attributesAtIndex:0 effectiveRange:NULL];
	STAssertEqualObjects(attrs, [NSDictionary dictionary], @"-initWithString sets an empty dictionary for attributes");
}

- (void)testInitWithAttributedString {
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"test"] autorelease];
	STAssertEqualObjects(str, [[[ZAttributedString alloc] initWithAttributedString:str] autorelease], @"- -initWithAttributedString should return an equal object");
}

- (void)testInitWithAttributedStringAttributes {
	NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
							  @"foo", @"mykey",
							  [UIColor redColor], ZForegroundColorAttributeName,
							  nil];
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"test" attributes:attrDict] autorelease];
	NSRange range;
	NSDictionary *attrs = [str attributesAtIndex:0 effectiveRange:&range];
	STAssertEqualObjects(attrs, attrDict, @"");
	STAssertEquals(range, NSMakeRange(0, 4), @"");
}

- (void)testDescription {
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"test"] autorelease];
	STAssertEqualObjects([str description], @"{} \"test\"", @"");
}

- (void)testAttributesAtIndex {
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"test"] autorelease];
	NSRange range;
	NSDictionary *attrs = [str attributesAtIndex:0 effectiveRange:&range];
	STAssertEqualObjects(attrs, [NSDictionary dictionary], @"attributes is an empty dictionary");
	STAssertEquals(range, NSMakeRange(0, 4), @"expected range is {0, 4}, was %@", NSStringFromRange(range));
}

- (void)testAttributesAtIndexLongestEffectiveRangeTruncation {
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"testing"] autorelease];
	NSRange range;
	[str attributesAtIndex:4 longestEffectiveRange:&range inRange:NSMakeRange(2,4)];
	STAssertEquals(range, NSMakeRange(2, 4), @"");
}

- (void)testAttributeAtIndex {
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"testing" attributes:[NSDictionary dictionaryWithObject:@"foo" forKey:@"bar"]] autorelease];
	NSRange range;
	id foo = [str attribute:@"bar" atIndex:4 longestEffectiveRange:&range inRange:NSMakeRange(2, 4)];
	STAssertEqualObjects(foo, @"foo", @"");
	STAssertEquals(range, NSMakeRange(2, 4), @"");
	foo = [str attribute:@"blah" atIndex:4 longestEffectiveRange:&range inRange:NSMakeRange(2, 4)];
	STAssertNil(foo, @"");
	STAssertEquals(range, NSMakeRange(2, 4), @"");
	foo = [str attribute:@"bar" atIndex:4 effectiveRange:&range];
	STAssertEqualObjects(foo, @"foo", @"");
	STAssertEquals(range, NSMakeRange(0, 7), @"");
	foo = [str attribute:@"blah" atIndex:4 effectiveRange:&range];
	STAssertNil(foo, @"");
	STAssertEquals(range, NSMakeRange(0, 7), @"");
}

- (void)testAttributedSubstring {
	ZMutableAttributedString *str = [[[ZMutableAttributedString alloc] initWithString:@"testing"
																		   attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																					   @"blah", @"baz", nil]] autorelease];
	[str addAttribute:@"foo" value:@"bar" range:NSMakeRange(4, 3)];
	NSLog(@"str: %@", str);
	ZAttributedString *substr = [str attributedSubstringFromRange:NSMakeRange(2, 4)];
	STAssertEqualObjects(substr.string, @"stin", nil);
	NSRange range;
	NSLog(@"substr: %@", substr);
	STAssertEqualObjects([substr attributesAtIndex:0 effectiveRange:&range],
						 ([NSDictionary dictionaryWithObjectsAndKeys:@"blah", @"baz", nil]), nil);
	STAssertEquals(range, NSMakeRange(0, 2), nil);
	STAssertEqualObjects([substr attributesAtIndex:2 effectiveRange:&range],
						 ([NSDictionary dictionaryWithObjectsAndKeys:@"blah", @"baz", @"bar", @"foo", nil]), nil);
	STAssertEquals(range, NSMakeRange(2, 2), nil);
}

- (void)testAppendAttributedString {
	ZMutableAttributedString *str = [[[ZMutableAttributedString alloc] initWithString:@"test"
																		   attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																					   @"bar", @"foo", nil]] autorelease];
	ZAttributedString *newstr = [[[ZAttributedString alloc] initWithString:@"ing"
																attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																			@"blah", @"baz", nil]] autorelease];
	[str appendAttributedString:newstr];
	STAssertEqualObjects(str.string, @"testing", nil);
	NSRange range;
	STAssertEqualObjects([str attributesAtIndex:0 effectiveRange:&range],
						 ([NSDictionary dictionaryWithObjectsAndKeys:@"bar", @"foo", nil]), nil);
	STAssertEquals(range, NSMakeRange(0, 4), nil);
	STAssertEqualObjects([str attributesAtIndex:4 effectiveRange:&range],
						 ([NSDictionary dictionaryWithObjectsAndKeys:@"blah", @"baz", nil]), nil);
	STAssertEquals(range, NSMakeRange(4, 3), nil);
}

- (void)testInsertAttributedString {
	ZMutableAttributedString *str = [[[ZMutableAttributedString alloc] initWithString:@"teing"
																		   attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																					   @"bar", @"foo", nil]] autorelease];
	ZAttributedString *newstr = [[[ZAttributedString alloc] initWithString:@"st"
																attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																			@"blah", @"baz", nil]] autorelease];
	[str insertAttributedString:newstr atIndex:2];
	STAssertEqualObjects(str.string, @"testing", nil);
	NSRange range;
	STAssertEqualObjects([str attributesAtIndex:0 effectiveRange:&range],
						 ([NSDictionary dictionaryWithObjectsAndKeys:@"bar", @"foo", nil]), nil);
	STAssertEquals(range, NSMakeRange(0, 2), nil);
	STAssertEqualObjects([str attributesAtIndex:2 effectiveRange:&range],
						 ([NSDictionary dictionaryWithObjectsAndKeys:@"blah", @"baz", nil]), nil);
	STAssertEquals(range, NSMakeRange(2, 2), nil);
	STAssertEqualObjects([str attributesAtIndex:6 effectiveRange:&range],
						 ([NSDictionary dictionaryWithObjectsAndKeys:@"bar", @"foo", nil]), nil);
	STAssertEquals(range, NSMakeRange(4, 3), nil);
}

- (void)testRemoveAttribute {
	ZMutableAttributedString *str = [[[ZMutableAttributedString alloc] initWithString:@"testing"
																		   attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																					   @"bar", @"foo", nil]] autorelease];
	[str removeAttribute:@"foo" range:NSMakeRange(2, 2)];
	STAssertEqualObjects(str.string, @"testing", nil);
	NSRange range;
	STAssertEqualObjects([str attributesAtIndex:0 effectiveRange:&range],
						 ([NSDictionary dictionaryWithObjectsAndKeys:@"bar", @"foo", nil]), nil);
	STAssertEquals(range, NSMakeRange(0, 2), nil);
	STAssertEqualObjects([str attributesAtIndex:2 effectiveRange:&range], [NSDictionary dictionary], nil);
	STAssertEquals(range, NSMakeRange(2, 2), nil);
	STAssertEqualObjects([str attributesAtIndex:4 effectiveRange:&range],
						 ([NSDictionary dictionaryWithObjectsAndKeys:@"bar", @"foo", nil]), nil);
	STAssertEquals(range, NSMakeRange(4, 3), nil);
}

- (void)testCoding {
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"test"
															 attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																		 @"foo", @"bar",
																		 @"blah", @"baz",
																		 nil]] autorelease];
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:str];
	ZAttributedString *newstr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	STAssertEqualObjects(str, newstr, @"");
}

- (void)testMutableCopy {
	ZAttributedString *str = [[[ZAttributedString alloc] initWithString:@"test"] autorelease];
	STAssertTrue([[[str mutableCopy] autorelease] isKindOfClass:[ZMutableAttributedString class]],
				 @"expected ZMutableAttributedString, was %@", NSStringFromClass([str class]));
}

- (void)testAddAttribute {
	ZMutableAttributedString *str = [[[ZMutableAttributedString alloc] initWithString:@"testing"
																		   attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																					   @"blah", @"baz", nil]] autorelease];
	[str addAttribute:@"foo" value:@"bar" range:NSMakeRange(2, 4)];
	NSRange range;
	id foo = [str attribute:@"foo" atIndex:0 longestEffectiveRange:&range inRange:NSMakeRange(0, 7)];
	id baz = [str attribute:@"baz" atIndex:0 longestEffectiveRange:NULL inRange:NSMakeRange(0, 7)];
	STAssertNil(foo, @"");
	STAssertEqualObjects(baz, @"blah", @"");
	STAssertEquals(range, NSMakeRange(0, 2), @"");
	foo = [str attribute:@"foo" atIndex:3 longestEffectiveRange:&range inRange:NSMakeRange(0, 7)];
	baz = [str attribute:@"baz" atIndex:3 longestEffectiveRange:NULL inRange:NSMakeRange(0, 7)];
	STAssertEqualObjects(foo, @"bar", @"");
	STAssertEqualObjects(baz, @"blah", @"");
	STAssertEquals(range, NSMakeRange(2, 4), @"");
	foo = [str attribute:@"foo" atIndex:6 longestEffectiveRange:&range inRange:NSMakeRange(0, 7)];
	baz = [str attribute:@"baz" atIndex:6 longestEffectiveRange:NULL inRange:NSMakeRange(0, 7)];
	STAssertNil(foo, @"");
	STAssertEqualObjects(baz, @"blah", @"");
	STAssertEquals(range, NSMakeRange(6, 1), @"");
}
@end
