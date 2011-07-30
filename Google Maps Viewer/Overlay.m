//
//  Overlay.m
//  Google Maps Viewer
//
//  Created by Sheyne Anderson on 7/28/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import "Overlay.h"
#import "Viewer.h"


@implementation LatitudeLongitude

@synthesize latitude=_latitude;
@synthesize longitude=_longitude;

-(id)initWithLatitude:(double)latitude longitude:(double)longitude{
	if(self=[super init]){
		_latitude=latitude;
		_longitude=longitude;
	}return self;
}

+(id)latitudeLongitudeWithLatitude:(double)latitude longitude:(double)longitude{
	return [[[LatitudeLongitude alloc] initWithLatitude:latitude longitude:longitude] autorelease];
}

-(NSUInteger)hash{
	return _latitude+_longitude;
}

-(BOOL)isEqual:(id)object{
	if ([object isMemberOfClass:LatitudeLongitude.class]) {
		return _latitude==((LatitudeLongitude *)object).latitude&&_longitude==((LatitudeLongitude *)object).longitude;
	}
	return FALSE;
}

-(id)copyWithZone:(NSZone *)zone{
	return [[LatitudeLongitude allocWithZone:zone] initWithLatitude:_latitude longitude:_longitude];
}

@end


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
	Viewer *sv=((Viewer *)self.superview);
	
	NSBezierPath *p=[NSBezierPath bezierPath];
	[self.paths enumerateKeysAndObjectsUsingBlock:^(id key, id path, BOOL *stop) {
		NSArray *pathA=path;
		LatitudeLongitude *firstPoint=[pathA objectAtIndex:0];
		NSPoint firstNSPoint=[sv pointForLatitude:firstPoint.latitude longitude:firstPoint.longitude];
		[p moveToPoint:firstNSPoint];
		[key drawAtPoint:NSMakePoint(firstNSPoint.x,firstNSPoint.y-15) withAttributes:nil];
		for(LatitudeLongitude *latlon in [pathA subarrayWithRange:NSMakeRange(1, pathA.count-1)]){
			[p lineToPoint:[sv pointForLatitude:latlon.latitude longitude:latlon.longitude]];
		}
	}];
	[p stroke];
	
	NSPoint pnt=[sv pointForLatitude: 41.254127 longitude:-111.842665];
	NSPoint pnt2=[sv pointForLatitude:41.172061 longitude:-111.923845];
	NSBezierPath *bp=[NSBezierPath bezierPath];
	[bp moveToPoint:pnt2];
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
