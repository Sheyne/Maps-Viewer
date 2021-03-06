//
//  Google_Maps_ViewerAppDelegate.h
//  Google Maps Viewer
//
//  Created by Sheyne Anderson on 7/27/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <TCP/TCP.h>

@class Viewer;
@class Overlay;
@interface Google_Maps_ViewerAppDelegate : NSObject <NSApplicationDelegate, TCPListener> {
	NSWindow *window;
	NSMutableDictionary *paths;
	Viewer *_viewer;
	Overlay * _overlay;
	TCP*tcp;
	NSString *_callsign;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet Viewer *viewer;
@property (assign) IBOutlet Overlay *overlay;
@property (assign) NSMutableDictionary *paths;
@property (assign) NSString *sign;

-(IBAction)centerOnLastPacket:(id)sender;

@end
