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


@synthesize shouldLoadNewImages=_shouldLoadNewImages;
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
		self.getter.viewer=self;
		NSPoint pnt=GMMakePoint( 41, -111, self.zoom);
		self.center=NSMakePoint(pnt.x*IMAGE_WIDTH+self.frame.size.width/2, pnt.y*IMAGE_HEIGHT+self.frame.size.height/2);
    }
    
    return self;
}

-(NSPoint)pointForLatitude:(double)latitude longitude:(double)longitude{
	NSPoint pnt=GMMakePoint(latitude, longitude, self.zoom);
	pnt.x+=1;
	//x may be subject to error;
	pnt.x*=IMAGE_WIDTH;	
	pnt.y-=[self calculateSizeRectArray].height-2;
	pnt.y*=-IMAGE_HEIGHT;
	pnt.x-=self.center.x+IMAGE_WIDTH;
	pnt.y+=IMAGE_WIDTH+self.center.y;
	return pnt;
}

-(NSSize)calculateSizeRectArray{
	return NSMakeSize(ceil(self.frame.size.width/IMAGE_WIDTH)+2,ceil(self.frame.size.height/IMAGE_HEIGHT)+2);
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	[[NSColor redColor] set];
	NSSize arraySize=[self calculateSizeRectArray];
	int i=0,j=0;
	for (i=0; i<arraySize.width; i++)
		for (j=0; j<arraySize.height; j++){
			int xpos=((int)self.center.x/IMAGE_WIDTH)+i,
				ypos=((int)self.center.y/IMAGE_HEIGHT)+j;
			NSImage *image=[self.getter imageForX:xpos y:ypos z:self.zoom];
			NSPoint pnt=NSMakePoint((int)((i)*IMAGE_WIDTH-fmod(self.center.x,IMAGE_WIDTH)),
									(int)((arraySize.height-j-2)*IMAGE_HEIGHT+fmod(self.center.y, IMAGE_HEIGHT)));
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
