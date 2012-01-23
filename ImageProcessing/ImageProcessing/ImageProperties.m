//
//  ImageProperties.m
//  Imagetest
//
//  Created by MEng on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageProperties.h"

@implementation ImageProperties

-(void)init:(UIImage*) image
{
    _image = image;
    
    CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt32 *pixels = (const UInt32*)CFDataGetBytePtr(imageData);
    
    uint width = CGImageGetWidth(image.CGImage);
    uint height = CGImageGetHeight(image.CGImage);
    NSLog(@"width: %u height: %u", width, height);
    
    _slices = [NSMutableArray arrayWithCapacity:width];
    
    for (int x = 0; x < width; ++x)
    {
        ImageSlice* slice = [ImageSlice alloc];
        [slice init: (UInt8*)(pixels)+x*4: width*4: height];
        [_slices addObject: slice];
    }
    
    [[_slices objectAtIndex:0] log];
    
    [ImageProperties LogPixel:pixels[0]];
    [ImageProperties LogPixel:pixels[1]];
    [ImageProperties LogPixel:pixels[2]];
    [ImageProperties LogPixel:pixels[3]];
    [ImageProperties LogPixel:pixels[86]];
    
    _numSlices = width;
}

-(ImageSlice*)getSlice:(int)slice
{
    return [_slices objectAtIndex:slice];
}

-(unsigned int)numSlices
{
    return _numSlices;
}

+(void)LogPixel:(UInt32)pixel
{
    NSLog(@"r: %lu g: %lu b: %lu a: %lu", pixel & 0x000000FF, (pixel >> 8) & 0x000000FF, (pixel >> 16) & 0x000000FF, (pixel >> 24) & 0x000000FF);
}

@end