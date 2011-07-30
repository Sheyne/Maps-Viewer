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

@synthesize paths;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.paths=[NSMutableDictionary dictionaryWithCapacity:1];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor redColor]set];
	Viewer *sv=((Viewer *)self.superview);
	NSPoint pnt=[sv pointForLatitude:41.269878 longitude:-111.806490];
	NSBezierPath *bp=[NSBezierPath bezierPath];
	[bp moveToPoint:NSMakePoint(self.frame.size.width/2, self.frame.size.height/2)];
	[bp lineToPoint:pnt];
	[bp stroke];
	
	//NSRectFill(NSMakeRect(pnt.x, pnt.y, 2000, 2000));
}
-(BOOL)acceptsFirstResponder{
	return YES;
}

-(void)mouseDown:(NSEvent *)theEvent{
	//give event to super
	[self.superview mouseDown:theEvent];

}

@end
