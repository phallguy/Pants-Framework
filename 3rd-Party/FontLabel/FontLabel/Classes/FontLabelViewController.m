//
//  FontLabelViewController.m
//  FontLabel
//
//  Created by Amanda Wixted on 4/30/09.
//  Modified by Kevin Ballard on 5/8/09.
//  Copyright © 2009 Zynga Game Networks
//
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//


#import "FontLabelViewController.h"
#import "FontLabel.h"
#import "FontLabelStringDrawing.h"
#import "FontManager.h"

@implementation FontLabelViewController

- (void)loadView {
	[super loadView];
	
	[self.view setBackgroundColor:[UIColor blackColor]];
	
	FontLabel *label = [[FontLabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0) fontName:@"Paint Boy" pointSize:40.0f];
	label.textColor = [UIColor magentaColor];
	label.text = @"lorem ipsum";
	[label sizeToFit];
	label.backgroundColor = nil;
	label.opaque = NO;
	[self.view addSubview:label];
	[label release];
	
	FontLabel *label2 = [[FontLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame) + 10, 300, 100)
												  fontName:@"Schwarzwald Regular" pointSize:20.0f];
	label2.textColor = [UIColor blackColor];
	label2.text = @"centered in a frame.\nthis is line two. Long lines should wrap, possibly multiple times. Really long lines should truncate with an ellipsis.";
	label2.textAlignment = UITextAlignmentCenter;
	label2.lineBreakMode = UILineBreakModeTailTruncation;
	label2.backgroundColor = [UIColor greenColor];
	label2.numberOfLines = 0;
	[self.view addSubview:label2];
	[label2 release];
	
	FontLabel *label3 = [[FontLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label2.frame) + 10, 300, 100)
												  fontName:@"Schwarzwald Regular" pointSize:20.0f];
	label3.textColor = [UIColor magentaColor];
	label3.text = @"right justified.\nThis is line two. Long lines should wrap";
	label3.textAlignment = UITextAlignmentRight;
	label3.backgroundColor = [UIColor blueColor];
	label3.numberOfLines = 0;
	[self.view addSubview:label3];
	[label3 release];
	
	FontLabel *label4 = [[FontLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label3.frame) + 10, 300, 100)];
	ZMutableAttributedString *str = [[ZMutableAttributedString alloc] initWithString:@"This is an attributed string.\nIt even supports underline."
																		  attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																					  [[FontManager sharedManager] zFontWithName:@"Schwarzwald Regular" pointSize:20],
																					  ZFontAttributeName,
																					  nil]];
	[str addAttribute:ZFontAttributeName value:[[FontManager sharedManager] zFontWithName:@"Abberancy" pointSize:30] range:NSMakeRange(11, 10)];
	[str addAttribute:ZForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(11, 10)];
	[str addAttribute:ZBackgroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(11, 10)];
	[str addAttribute:ZUnderlineStyleAttributeName value:[NSNumber numberWithInt:ZUnderlineStyleSingle] range:NSMakeRange(47, 9)];
	label4.zAttributedText = str;
	[str release];
	label4.textAlignment = UITextAlignmentLeft;
	label4.backgroundColor = [UIColor lightGrayColor];
	label4.numberOfLines = 0;
	[self.view addSubview:label4];
	[label4 release];
}

- (void)dealloc {
    [super dealloc];
}
@end
