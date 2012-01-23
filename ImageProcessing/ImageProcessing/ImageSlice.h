//
//  ImageSlice.h
//  Imagetest
//
//  Created by MEng on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSlice : NSObject
{
    NSMutableData* _pixels;
    unsigned int _height;
    UInt8 _averageRed;
    UInt8 _averageBlue;
    UInt8 _averageGreen;
}

-(void)init:(const UInt8*)data: (uint)stride: (uint)height;
-(void)log;

-(UInt8)getAverageRed;
-(UInt8)getAverageGreen;
-(UInt8)getAverageBlue;

@end
