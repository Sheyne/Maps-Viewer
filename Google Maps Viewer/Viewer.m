//
//  Viewer.m
//  Google Maps Viewer
//
//  Created by Sheyne Anderson on 7/27/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import "Viewer.h"
#import "ImageGetter.h"

NSPoint GMMakePoint(double latitude, double	longitude, short zoom){
	double rad_lat = latitude / 180 * M_PI;
	double rad_lon = longitude / 180 * M_PI;

	double merc_x = rad_lon;
	double merc_y = log( tan(rad_lat) + 1/ cos(rad_lat) );

	double cart_x = merc_x + M_PI;
	double cart_y = M_PI - merc_y;

	double px0 = cart_x * 256 / (2 * M_PI );
	double py0 = cart_y * 256 / (2 * M_PI );
	NSPoint pnt = NSMakePoint(px0 * pow(2, zoom) / 256, py0 * pow(2, zoom) / 256);
	return pnt;
}

@implementation Viewer

@synthesize getter=_getter;
@synthesize center=_center;
@synthesize cells=_cells;
@synthesize zoom;

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	self.needsDisplay=YES;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:NULL];
		rect=NSMakeRect(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
		self.zoom=10;
		self.getter=[ImageGetter getter];
		self.getter.delegate=self;
		NSPoint pnt=GMMakePoint(41, -111, self.zoom);
		self.center=NSMakePoint(pnt.x*IMAGE_WIDTH, pnt.y*IMAGE_HEIGHT);
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	[[NSColor redColor] set];
	int arrayHeight=ceil(self.frame.size.height/IMAGE_HEIGHT)+2;
	int arrayWidth=ceil(self.frame.size.width/IMAGE_WIDTH)+2;
	int i=0,j=0;
	for (i=0; i<arrayWidth; i++)
		for (j=0; j<arrayHeight; j++){
			int xpos=((int)self.center.x/IMAGE_WIDTH)+i,
				ypos=((int)self.center.y/IMAGE_HEIGHT)+j;
			NSImage *image=[self.getter imageForX:xpos y:ypos z:self.zoom];
			NSPoint pnt=NSMakePoint((int)((i)*IMAGE_WIDTH-fmod(self.center.x,IMAGE_WIDTH)),
									(int)((arrayHeight-j-2)*IMAGE_HEIGHT+fmod(self.center.y, IMAGE_HEIGHT)));
			[image drawAtPoint:pnt fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	
		}
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}
-(void)mouseDown:(NSEvent *)event
{
	start=event.locationInWindow;
	preDragOffset=self.center;
}
-(void)mouseDragged:(NSEvent *)event
{
	self.center=NSMakePoint(start.x-event.locationInWindow.x+preDragOffset.x,event.locationInWindow.y-start.y+preDragOffset.y);
}



@end
