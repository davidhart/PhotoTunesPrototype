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
    @private UIImage* _image;
    @private NSMutableArray* _slices;
    @private unsigned int _numSlices;
    
    @private UInt8 _averageRed;
    @private UInt8 _averageGreen;
    @private UInt8 _averageBlue;
    
    @private UInt8 _averageHue;
    @private UInt8 _averageSat;
    @private UInt8 _averageVal;
    
    @private float _deviationVal;
    @private float _deviationSat;
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
