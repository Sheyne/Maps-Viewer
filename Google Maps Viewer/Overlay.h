//
//  Overlay.h
//  Google Maps Viewer
//
//  Created by Sheyne Anderson on 7/28/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LatitudeLongitude : NSObject {
@private
	double _latitude, _longitude;
}
@property (assign) double latitude, longitude;
+(id)latitudeLongitudeWithLatitude:(double)latitude longitude:(double)longitude;
-(id)initWithLatitude:(double)latitude longitude:(double)longitude;
@end


@interface Overlay : NSView
{
	NSMutableDictionary *paths;
}
@property (retain) NSMutableDictionary *paths;
@end
