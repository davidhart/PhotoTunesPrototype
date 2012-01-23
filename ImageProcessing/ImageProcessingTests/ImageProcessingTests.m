//
//  ImageProcessingTests.m
//  ImageProcessingTests
//
//  Created by MEng on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageProcessingTests.h"
#import "ImageSlice.h"
#import "ImageProperties.h"

@implementation ImageProcessingTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testImageSlice
{
    ImageSlice* slice = [ImageSlice alloc];
    STAssertNotNil(slice, @"Error creating slice");
    
    UInt8 pixels [] = { 0xFFu, 0xFFu, 0xFFu, 0xFFu };
    [slice init: pixels: 4: 1];
    
    STAssertEquals([slice getAverageRed], pixels[0], @"Error average red value incorrect (1x1 image)");
    STAssertEquals([slice getAverageGreen], pixels[1], @"Error average green value incorrect (1x1 image)");
    STAssertEquals([slice getAverageBlue], pixels[2], @"Error average blue value incorrect (1x1 image)");
    
    UInt8 pixels2 [] ={ 0xFFu, 0xFFu, 0xFFu, 0xFFu, 
        0x0u, 0x0u, 0x0u, 0xFFu };
    
    [slice init: pixels2: 4: 2];
    
    STAssertEquals([slice getAverageRed], (UInt8)127, @"Error average red value incorrect (1x2 image)");
    STAssertEquals([slice getAverageGreen], (UInt8)127, @"Error average green value incorrect (1x2 image)");
    STAssertEquals([slice getAverageBlue], (UInt8)127, @"Error average blue value incorrect (1x2 image)");
    
    
    UInt8 pixels3 [] ={ 0x2u, 0x2u, 0x2u, 0x2u, 0x20u, 0x20u, 0x20u, 0xFFu, 
        0x0u, 0x0u, 0x0u, 0xFFu, 0x0u, 0x0u, 0x0u, 0xFFu };
    
    [slice init: pixels3: 8: 2];
    
    STAssertEquals([slice getAverageRed], (UInt8)0x1u, @"Error average red value incorrect (2x2 image)");
    STAssertEquals([slice getAverageGreen], (UInt8)0x1u, @"Error average green value incorrect (2x2 image)");
    STAssertEquals([slice getAverageBlue], (UInt8)0x1u, @"Error average blue value incorrect (2x2 image)");
}

- (void)testImageProperties
{
    UInt8 pixels [5*5*4];
    
    int c = 0;
    for (int i = 0; i < 5; ++i)
    {
        pixels[c++] = 0xFF;
        pixels[c++] = 0xFF;
        pixels[c++] = 0xFF;
        pixels[c++] = 0xFF;
        
        pixels[c++] = 0x00;
        pixels[c++] = 0x00;
        pixels[c++] = 0x00;
        pixels[c++] = 0xFF;
        
        pixels[c++] = 0xFF;
        pixels[c++] = 0x00;
        pixels[c++] = 0x00;
        pixels[c++] = 0xFF;
        
        pixels[c++] = 0x00;
        pixels[c++] = 0xFF;
        pixels[c++] = 0x00;
        pixels[c++] = 0xFF;
        
        pixels[c++] = 0x00;
        pixels[c++] = 0x00;
        pixels[c++] = 0xFF;
        pixels[c++] = 0xFF;
    };
    
    
    CGContextRef context;
	context = CGBitmapContextCreate(pixels,
                                    5,
                                    5,
                                    8,
                                    5*4,
                                    CGColorSpaceCreateDeviceRGB(),
                                    kCGImageAlphaNoneSkipLast);
    
	CGImageRef newCGImage = CGBitmapContextCreateImage(context);
	UIImage *image = [UIImage imageWithCGImage:newCGImage];
	CGContextRelease(context);
    
    ImageProperties* imageProperties = [ImageProperties alloc];
    STAssertNotNil(imageProperties, @"Error could not create image properties");
    
    [imageProperties init:image];
    
    STAssertEquals([imageProperties numSlices], 5u, @"Error incorrect number of slices");
    
    for (int i = 0; i < 5; ++i)
    {
        ImageSlice* slice = [imageProperties getSlice:i];
        STAssertNotNil(slice, @"Error getSlice returned null");
        
        STAssertEquals([slice getAverageRed], pixels[i*4], @"Error incorrect average red");
        STAssertEquals([slice getAverageGreen], pixels[i*4+1], @"Error incorrect average green");
        STAssertEquals([slice getAverageBlue], pixels[i*4+2], @"Error incorrect average blue");
    }
}

@end
