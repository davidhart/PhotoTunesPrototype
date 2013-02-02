#import "Util.h"

@implementation Util

+(void)RGBtoHSV: (struct RGBfloat*) color_in : (struct HSVfloat*) color_out
{
    float min = [Util min: [Util min: color_in->red: color_in->green]: color_in->blue];
    float max = [Util max: [Util max: color_in->red: color_in->green]: color_in->blue];
    float chroma = max - min;
    
    color_out->hue = 0;
    color_out->sat = 0;
    
    if (chroma != 0.0f)
    {
        if (color_in->red == max)
        {
            color_out->hue = (color_in->green - color_in->blue) / chroma;
            if (color_out->hue < 0.0f)
            {
                color_out->hue += 6.0f;
            }
        }
        else if (color_in->green == max)
        {
            color_out->hue = ((color_in->blue - color_in->red) / chroma) + 2.0f;
        }
        else
        {
            color_out->hue = ((color_in->red - color_in->green) / chroma) + 4.0f;
        }
        color_out->hue *= 60.0f;
        color_out->sat = chroma / max;
    }
    
    color_out->val = max;
}

+(float) min: (float) a : (float) b
{
    if (a < b)
        return a;
    else
        return b;
}

+(float) max: (float) a : (float) b
{
    if (a > b)
        return a;
    else
        return b;
}

+(CGRect)frameForImage:(UIImage*)image inImageViewAspectFit:(UIImageView*)imageView
{
    // image.size.height returning wrong size on ios 4????
    
    float imageRatio = image.size.width / image.size.height;
    
    float viewRatio = imageView.frame.size.width / imageView.frame.size.height;
    
    if(imageRatio < viewRatio)
    {
        float scale = imageView.frame.size.height / image.size.height;
        
        float width = scale * image.size.width;
        
        float topLeftX = (imageView.frame.size.width - width) * 0.5;
        
        return CGRectMake(topLeftX, 0, width, imageView.frame.size.height);
    }
    else
    {
        float scale = imageView.frame.size.width / image.size.width;
        
        float height = scale * image.size.height;
        
        float topLeftY = (imageView.frame.size.height - height) * 0.5;
        
        return CGRectMake(0, topLeftY, imageView.frame.size.width, height);
    }
}

@end
