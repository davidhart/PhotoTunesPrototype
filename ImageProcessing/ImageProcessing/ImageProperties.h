//
//  ImageProperties.h
//  Imagetest
//
//  Created by MEng on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageSlice.h"

@interface ImageProperties : NSObject
{
    UIImage* _image;
    NSMutableArray* _slices;
    unsigned int _numSlices;
    
    UInt8 _averageRed;
    UInt8 _averageGreen;
    UInt8 _averageBlue;
    
    UInt8 _averageHue;
    UInt8 _averageSat;
    UInt8 _averageVal;
    
    float _deviationVal;
    float _deviationSat;

    
}

-(id)init:(UIImage*)image;
-(ImageSlice*)getSlice:(int)slice;
-(unsigned int)numSlices;

-(UInt8)getAverageRed;
-(UInt8)getAverageGreen;
-(UInt8)getAverageBlue;

-(UInt8)getAverageHue;
-(UInt8)getAverageSat;
-(UInt8)getAverageVal;

-(float)getDeviationSat;
-(float)getDeviationVal;


+(void)LogPixel:(UInt32)pixel;

@end
