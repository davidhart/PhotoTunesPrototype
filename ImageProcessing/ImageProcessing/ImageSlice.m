//
//  ImageSlice.m
//  Imagetest
//
//  Created by MEng on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageSlice.h"
#import "Util.h"

@implementation ImageSlice

-(id)init:(const UInt8*)data: (uint)stride: (uint)height
{
    self = [super init];
    
    if (self)
    {
        _height = height;
    
        int averageRed = 0, averageGreen = 0, averageBlue = 0;
    
        for (int y = 0; y < height; y++)
        {
            averageRed += data[y*stride];
            averageGreen += data[y*stride+1];
            averageBlue +=  data[y*stride+2];
        }
    
        _averageRed = averageRed /= height;
        _averageGreen = averageGreen /= height;
        _averageBlue = averageBlue /= height;
    
        struct RGBfloat rgb;
        struct HSVfloat hsv;
    
        rgb.red = _averageRed / 255.0f;
        rgb.green = _averageGreen / 255.0f;
        rgb.blue = _averageBlue / 255.0f;
        
        [Util RGBtoHSV: &rgb: &hsv];
    
        _averageHue = (hsv.hue / 360.0f) * 255.0f;
        _averageSat = hsv.sat * 255.0f;
        _averageVal = hsv.val * 255.0f;
    }
    
    return self;
}

-(void)log
{    
    NSLog(@"averages r: %i g: %i b: %i", _averageRed, _averageGreen, _averageBlue);
    NSLog(@"h: %i s: %i v: %i", _averageHue, _averageSat, _averageVal);
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

@end
