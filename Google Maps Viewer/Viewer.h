//
//  Viewer.h
//  Google Maps Viewer
//
//  Created by Sheyne Anderson on 7/27/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define IMAGE_WIDTH 256
#define IMAGE_HEIGHT 256

@class ImageGetter;
NSPoint GMMakePoint(double latitude, double	longitude, short zoom);

@interface Viewer : NSView
{
	NSMutableArray *_cells;
	NSRect rect;
	NSPoint _center;
	NSPoint start;
	NSPoint preDragOffset;
	short zoom;
	ImageGetter *_getter;

	BOOL _shouldLoadNewImages;
}

@property (assign) BOOL shouldLoadNewImages;

@property (assign) short zoom;
@property (assign) NSPoint center;
@property (retain) NSMutableArray *cells;
@property (retain) ImageGetter * getter;

-(NSPoint)pointForLatitude:(double)latitude longitude:(double)longitude;
-(NSSize)calculateSizeRectArray;


@end
