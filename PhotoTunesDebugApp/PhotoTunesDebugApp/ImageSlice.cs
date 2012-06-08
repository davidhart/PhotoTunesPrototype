using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace PhotoTunesDebugApp
{
    public struct RGBfloat
    {
        public float red;
        public float green;
        public float blue;
    }

    public struct HSVfloat
    {
        public float hue;
        public float sat;
        public float val;
    }

    class ImageSlice
    {
        int _height;

        float _averageRed = 0;
        float _averageGreen = 0;
        float _averageBlue = 0;

        float _averageHue = 0;
        float _averageSat = 0;
        float _averageVal = 0;

        Util util = new Util();

        public void init(Image image, int sliceNumber)
        {
            _height = image.Height;

            Bitmap slice = new Bitmap(image);

            Color[] pixelColumn = new Color[slice.Height];

            for (int i = 0; i < slice.Height; ++i)
            {
                pixelColumn[i] = slice.GetPixel(sliceNumber, i);
            } 

            for (int i = 0; i < _height; i++)
            {
                _averageRed += pixelColumn[i].R;
                _averageGreen += pixelColumn[i].G;
                _averageBlue += pixelColumn[i].B;
            }

            _averageRed = _averageRed /= _height;
            _averageGreen = _averageGreen /= _height;
            _averageBlue = _averageBlue /= _height;

            RGBfloat rgb;

            rgb.red = _averageRed / 255;
            rgb.green = _averageGreen / 255;
            rgb.blue = _averageBlue / 255;

            HSVfloat hsv = util.RGBtoHSV(rgb);

            _averageHue = (hsv.hue / 360) * 255;
            _averageSat = hsv.sat * 255;
            _averageVal = hsv.val * 255; 
        }

        public float getAverageRed() { return _averageRed; }
        public float getAverageGreen() { return _averageGreen; }
        public float getAverageBlue() { return _averageBlue; }
        public float getAverageHue() { return _averageHue; }
        public float getAverageSat() { return _averageSat; }
        public float getAverageVal() { return _averageVal; }
    }
}
