//
//  ImageGetter.m
//  Google Maps Viewer
//
//  Created by Sheyne Anderson on 7/28/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import "ImageGetter.h"
#import "Viewer.h"

@interface Coords : NSObject {
@private
	int _x, _y, _z;
}
@property (assign) int x, y, z;
+(id)coordWithX:(int)x y:(int)y z:(int)z;
-(id)initWithX:(int)x y:(int)y z:(int)z;
@end

@implementation Coords

@synthesize x=_x, y=_y, z=_z;

-(id)initWithX:(int)x y:(int)y z:(int)z{
	if(self=[super init]){
		_x=x;
		_y=y;
		_z=z;
	}return self;
}

+(id)coordWithX:(int)x y:(int)y z:(int)z{
	return [[[Coords alloc] initWithX:x y:y z:z] autorelease];
}

-(NSUInteger)hash{
	return _x+_y+_z;
}

-(BOOL)isEqual:(id)object{
	if ([object isMemberOfClass:Coords.class]) {
		return _x==((Coords *)object).x&&_y==((Coords *)object).y&&_z==((Coords *)object).z;
	}
	return FALSE;
}

-(id)copyWithZone:(NSZone *)zone{
	return [[Coords allocWithZone:zone] initWithX:self.x y:self.y z:self.z];
}

@end

@implementation ImageGetter

@synthesize viewer=_viewer;

- (id)init
{
    self = [super init];
    if (self) {
		addressQueue=[[NSMutableArray alloc] initWithCapacity:5];
		images=[[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    return self;
}
+(id)getter{
	return [[[ImageGetter alloc] init] autorelease];
}

-(void)dealloc{
	[images release];
	[addressQueue release];
	[super dealloc];
}

-(void)downloadImageAtCoords:(Coords *)coord{
	NSString *url, *formatString=@"http://khm1.google.com/kh/v=89&x=%d&y=%d&z=%d&s=Ga";
	url=[NSString stringWithFormat:formatString, coord.x, coord.y, coord.z];
	NSData* data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
	[data writeToFile:[[NSString stringWithFormat:@"~/Documents/Maps/x%d y%d z%d.jpg", coord.x, coord.y, coord.z] stringByExpandingTildeInPath]atomically:YES];
	if ([self.viewer respondsToSelector:@selector(setNeedsDisplay:)]) {
		[self.viewer setNeedsDisplay:YES];
	}
}


-(NSImage *)imageForX:(int)x y:(int)y z:(int)z{
	Coords *coord=[Coords coordWithX:x y:y z:z];
	NSImage *img;
	if (!(img=[images objectForKey:coord])) {
		NSString *formatString=@"~/Documents/Maps/x%d y%d z%d.jpg",
		*file=[[NSString stringWithFormat:formatString, x,y,z] stringByExpandingTildeInPath];
		NSData *data=[NSData dataWithContentsOfFile:file];
		if (!data) {
			if (self.viewer.shouldLoadNewImages)
				[self performSelectorInBackground:@selector(downloadImageAtCoords:) withObject:coord];
			return nil;
		}	
		img=[[NSImage alloc] initWithData:data];
		if (img.size.width==0||img.size.height==0)
			return nil;
		[images setObject:img forKey:coord];
		[img release];
	}
	return img;
}

@end
