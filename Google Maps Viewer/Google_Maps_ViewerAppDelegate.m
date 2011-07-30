//
//  Google_Maps_ViewerAppDelegate.m
//  Google Maps Viewer
//
//  Created by Sheyne Anderson on 7/27/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import "Google_Maps_ViewerAppDelegate.h"

@implementation Google_Maps_ViewerAppDelegate

@synthesize window;
@synthesize viewer=_viewer;
@synthesize overlay=_overlay;
@synthesize paths;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[self bind:@"paths" toObject:self.overlay withKeyPath:@"paths" options:nil];
}

@end
