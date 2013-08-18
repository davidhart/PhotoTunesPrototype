#import <Foundation/Foundation.h>

@class ImageProperties;

@interface SongGeneration : NSObject

+(float)GetNote:(float*)scale :(int)size :(float)locationOnScale;

+(void)GenerateSong: (int)length :(ImageProperties*)image :(float*)notes;

@end
