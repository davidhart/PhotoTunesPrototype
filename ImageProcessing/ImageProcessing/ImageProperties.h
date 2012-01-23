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
}

-(void)init:(UIImage*)image;
-(ImageSlice*)getSlice:(int)slice;
-(unsigned int)numSlices;

+(void)LogPixel:(UInt32)pixel;

@end
