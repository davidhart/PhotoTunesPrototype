//
//  ImageProperties.m
//  Imagetest
//
//  Created by MEng on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageProperties.h"

UIImage* scaleAndRotateImage(UIImage* image);

@implementation ImageProperties

-(void)init:(UIImage*) image
{
    _image = scaleAndRotateImage(image);
    
    CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(_image.CGImage));
    const UInt32 *pixels = (const UInt32*)CFDataGetBytePtr(imageData);
    
    uint width = CGImageGetWidth(_image.CGImage);
    uint height = CGImageGetHeight(_image.CGImage);
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


UIImage *scaleAndRotateImage(UIImage *image)
{
    int kMaxResolution = 320; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}
