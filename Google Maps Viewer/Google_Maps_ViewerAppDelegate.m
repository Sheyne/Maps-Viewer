//
//  Google_Maps_ViewerAppDelegate.m
//  Google Maps Viewer
//
//  Created by Sheyne Anderson on 7/27/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import "Google_Maps_ViewerAppDelegate.h"
#import "Overlay.h"
#import "Viewer.h"
#import "JSONKit.h"

@implementation Google_Maps_ViewerAppDelegate

@synthesize window;
@synthesize viewer=_viewer;
@synthesize overlay=_overlay;
@synthesize paths;
@synthesize sign=_callsign;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	tcp=[[TCP alloc] init];
	[self bind:@"paths" toObject:self.overlay withKeyPath:@"paths" options:nil];
	[self.paths setObject:[NSMutableArray arrayWithObjects:
						   [LatitudeLongitude latitudeLongitudeWithLatitude:41 longitude:-111],
						   [LatitudeLongitude latitudeLongitudeWithLatitude:41.05 longitude:-110.95],
						   nil] forKey:@"a path"];
	[self.viewer centerOnLatitude:41 longitude:-111];
	tcp.delegate=self;
	[tcp connectToServer:@"localhost" onPort:54730];
}

-(IBAction)centerOnLastPacket:(id)sender{
	NSLog(@"centering on: %@",self.t);
	NSMutableArray *a;
	if ((a=[self.paths objectForKey:self.t])) {
		LatitudeLongitude *ll=[a lastObject];
		[self.viewer centerOnLatitude:ll.latitude longitude:ll.longitude];
	}
}

-(void)receivedMessage:(NSData *)message socket:(CFSocketRef)socket{
	NSDictionary *jsonPacket=[message objectFromJSONData];
	[jsonPacket enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		NSString *latitude=[obj objectForKey:@"latitude"],
				 *longitude=[obj objectForKey:@"longitude"];
		if (latitude&&longitude) {
			LatitudeLongitude *latlon=[LatitudeLongitude latitudeLongitudeWithLatitude:latitude.doubleValue longitude:longitude.doubleValue];
			NSMutableArray *path=[self.paths objectForKey:key];
			if (!path) {
				path=[NSMutableArray arrayWithObject:latlon];
				[self.paths setObject:path forKey:key];
			}else{
				[path addObject:latlon];
			}
		}
	}];
}

@end
