using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PhotoTunesDebugApp
{
    class Util
    {
        public HSVfloat RGBtoHSV(RGBfloat rgb)
        {
            HSVfloat hsv = new HSVfloat();

            float min = minValue(minValue(rgb.red, rgb.green), rgb.blue);
            float max = maxValue(maxValue(rgb.red, rgb.green), rgb.blue);

            float chroma = max - min;

            hsv.hue = 0;
            hsv.sat = 0;

            if (chroma != 0.0f)
            {
                if (rgb.red == max)
                {
                    hsv.hue = (rgb.green - rgb.blue) / chroma;

                    if (hsv.hue < 0.0f)
                    {
                        hsv.hue += 6.0f;
                    }
                }
                else if (rgb.green == max)
                {
                    hsv.hue = ((rgb.blue - rgb.red) / chroma) + 2.0f;
                }

                else
                {
                    hsv.hue = ((rgb.red - rgb.green) / chroma) + 4.0f;
                }

                hsv.hue *= 60.0f;
                hsv.sat = chroma / max;
            }

            hsv.val = max;

            return hsv;
        }

        public float minValue(float a, float b)
        {
            if (a < b)
                return a;

            else
                return b;
        }

        public float maxValue(float a, float b)
        {
            if (a > b)
                return a;

            else
                return b;
        }
    }
}
