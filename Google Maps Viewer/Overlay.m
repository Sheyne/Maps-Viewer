//
//  Overlay.m
//  Google Maps Viewer
//
//  Created by Sheyne Anderson on 7/28/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import "Overlay.h"
#import "Viewer.h"

@implementation Overlay

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor redColor]set];
	Viewer *sv=((Viewer *)self.superview);
	NSPoint pnt=GMMakePoint(41, -111, sv.zoom);
	NSRectFill(NSOffsetRect(NSMakeRect(pnt.x*IMAGE_WIDTH, pnt.y*IMAGE_HEIGHT, 10, 10),-sv.center.x-IMAGE_WIDTH,-sv.center.y-IMAGE_HEIGHT));
}
-(BOOL)acceptsFirstResponder{
	return YES;
}

/*-(void)mouseDown:(NSEvent *)theEvent{
	NSLog(@"event: %@",theEvent);
	
}*/

@end
