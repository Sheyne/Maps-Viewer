//
//  ImageGetter.h
//  Google Maps Viewer
//
//  Created by Sheyne Anderson on 7/28/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Coords;
@class Viewer;
@interface ImageGetter : NSObject
{
	NSMutableDictionary *images;
	Viewer *_viewer;
	NSMutableArray *addressQueue;
}

@property (assign) Viewer *viewer;

-(NSImage *)imageForX: (int)x y:(int)y z:(int) z;
-(void)downloadImageAtCoords:(Coords *)coord;

+(id)getter;
@end


/* add loading images queue*/