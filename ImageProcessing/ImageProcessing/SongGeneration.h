//
//  SongGeneration.h
//  ImageProcessing
//
//  Created by user on 05/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageProperties;

@interface SongGeneration : NSObject

+(float)GetNote:(float*)scale :(int)size :(float)locationOnScale;

+(void)GenerateSong:(int)length:(ImageProperties*)image: (float*)notes;

@end
