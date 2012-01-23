//
//  ImageProcessingTests.m
//  ImageProcessingTests
//
//  Created by MEng on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageProcessingTests.h"
#import "ImageSlice.h"

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

@end
