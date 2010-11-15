//
//  FontLabelAppDelegate.m
//  FontLabel
//
//  Created by Amanda Wixted on 4/30/09.
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


#import "FontLabelAppDelegate.h"
#import "FontLabelViewController.h"
#import "FontManager.h"

@implementation FontLabelAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[[FontManager sharedManager] loadFont:@"A Damn Mess"];
	[[FontManager sharedManager] loadFont:@"Abberancy"];
	[[FontManager sharedManager] loadFont:@"Abduction"];
	[[FontManager sharedManager] loadFont:@"Paint Boy"];
	[[FontManager sharedManager] loadFont:@"Schwarzwald Regular"];
	[[FontManager sharedManager] loadFont:@"Scissor Cuts"];
	
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
