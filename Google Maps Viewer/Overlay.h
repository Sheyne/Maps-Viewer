//
//  Overlay.h
//  Google Maps Viewer
//
//  Created by Sheyne Anderson on 7/28/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Overlay : NSView
{
	NSMutableDictionary *paths;
}
@property (retain) NSMutableDictionary *paths;
@end
