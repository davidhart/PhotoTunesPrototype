//
//  Util.h
//  ImageProcessing
//
//  Created by MEng on 23/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

struct RGBfloat
{
    float red;
    float blue;
    float green;
};

struct HSVfloat
{
    float hue;
    float sat;
    float val;
};

@interface Util : NSObject

+(void)RGBtoHSV: (struct RGBfloat*) color_in : (struct HSVfloat*) color_out;
+(float)min: (float) a : (float) b;
+(float)max: (float) a : (float) b;
+(CGRect)frameForImage:(UIImage*)image inImageViewAspectFit:(UIImageView*)imageView;

@end
