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
