//
//  ImageGetter.h
//  Google Maps Viewer
//
//  Created by Sheyne Anderson on 7/28/11.
//  Copyright 2011 Sheyne Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Coords;
@interface ImageGetter : NSObject
{
	NSMutableDictionary *images;
	id _delegate;
	NSMutableArray *addressQueue;
}

@property (assign) id delegate;

-(NSImage *)imageForX: (int)x y:(int)y z:(int) z;
-(void)downloadImageAtCoords:(Coords *)coord;

+(id)getter;
@end


/* add loading images queue*/