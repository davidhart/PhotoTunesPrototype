//
//  ImageSlice.m
//  Imagetest
//
//  Created by MEng on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageSlice.h"

@implementation ImageSlice

-(void)init:(const UInt8*)data: (uint)stride: (uint)height
{
    _height = height;
    _pixels = [NSMutableData dataWithLength:height*4];
    UInt8* memberData = (UInt8*)[_pixels mutableBytes];
    
    int averageRed = 0, averageGreen = 0, averageBlue = 0;
    
    for (int y = 0; y < height; y++)
    {
        memberData[y*4] = data[y*stride];
        memberData[y*4+1] = data[y*stride+1];
        memberData[y*4+2] = data[y*stride+2];
        memberData[y*4+3] = data[y*stride+3];
        
        averageRed += memberData[y*4];
        averageGreen += memberData[y*4+1];
        averageBlue += memberData[y*4+2];
    }
    
    _averageRed = averageRed /= height;
    _averageGreen = averageGreen /= height;
    _averageBlue = averageBlue /= height;
}

-(void)log
{
    UInt8* memberData = (UInt8*)[_pixels mutableBytes];
    for(int y = 0; y < _height; ++y)
    {
        NSLog(@"[%i] r: %i g: %i b: %i a: %i", y, memberData[y*4], memberData[y*4+1], memberData[y*4+2], memberData[y*4+3]);
    }
    
    NSLog(@"averages r: %i g: %i b: %i", _averageRed, _averageGreen, _averageBlue);
}

-(UInt8)getAverageRed
{
    return _averageRed;
}

-(UInt8)getAverageBlue
{
    return _averageBlue;
}

-(UInt8)getAverageGreen
{
    return _averageGreen;
}

@end
