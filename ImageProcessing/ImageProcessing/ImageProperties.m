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
    
    unsigned int red = 0;
    unsigned int green = 0;
    unsigned int blue = 0;
    
    unsigned int hue = 0;
    unsigned int sat = 0;
    unsigned int val = 0;    
    
    for (int x = 0; x < width; ++x)
    {
        ImageSlice* slice = [ImageSlice alloc];
        [slice init: (UInt8*)(pixels)+x*4: width*4: height];
        [_slices addObject: slice];
        
        red += [slice getAverageRed];
        green += [slice getAverageGreen];
        blue += [slice getAverageBlue];
        
        hue += [slice getAverageHue];
        sat += [slice getAverageSat];
        val += [slice getAverageVal];
    }
    
    _averageRed = (UInt8)(red / width);
    _averageGreen = (UInt8)(green / width);
    _averageBlue = (UInt8)(blue / width);
    
    _averageHue = (UInt8)(hue / width);
    _averageSat = (UInt8)(sat / width);
    _averageVal = (UInt8)(val / width);
    
    sat = 0;
    val = 0;
    
    for (int x = 0; x < width; ++x)
    {
        ImageSlice* slice = [self getSlice:x];
        int deltaSat = [slice getAverageSat] - _averageSat;
        sat += deltaSat * deltaSat;
        int deltaVal = [slice getAverageVal] - _averageVal;
        val += deltaVal * deltaVal;
    }
    
    _deviationVal = sqrt(val / (float)width) / 255.0f;
    _deviationSat = sqrt(sat / (float)width) / 255.0f;
    
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

-(UInt8)getAverageRed
{
    return _averageRed;
}

-(UInt8)getAverageBlue
{
    return _averageBlue;
}

-(UInt8)getAverageHue
{
    return _averageHue;
}

-(UInt8)getAverageSat
{
    return _averageSat;
}

-(UInt8)getAverageVal
{
    return _averageVal;
}

-(UInt8)getAverageGreen
{
    return _averageGreen;
}

-(float)getDeviationSat
{
    return _deviationSat;
}

-(float)getDeviationVal
{
    return _deviationVal;
}

+(void)LogPixel:(UInt32)pixel
{
    NSLog(@"r: %lu g: %lu b: %lu a: %lu", pixel & 0x000000FF, (pixel >> 8) & 0x000000FF, (pixel >> 16) & 0x000000FF, (pixel >> 24) & 0x000000FF);
}

@end