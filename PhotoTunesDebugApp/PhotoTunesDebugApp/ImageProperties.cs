using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace PhotoTunesDebugApp
{
    class ImageProperties
    {
        int width, height;
        float hue, sat, val, _averageHue, _averageSat, _averageVal, red, green, blue, _averageRed, _averageGreen, _averageBlue;
        float _deviationVal, _deviationSat;
        ImageSlice[] _slices;

        public void init(Image image)
        {
            width = image.Width;
            height = image.Height;

            _slices = new ImageSlice[width];
            int _numSlices = width;

            for (int x = 0; x < width; x++)
            {
                ImageSlice slice = new ImageSlice();
                slice.init(image, x);

                _slices[x] = slice;

                red += slice.getAverageRed();
                green += slice.getAverageGreen();
                blue += slice.getAverageBlue();

                hue += slice.getAverageHue();
                sat += slice.getAverageSat();
                val += slice.getAverageVal();
            }

            _averageRed = red / width;
            _averageGreen = green / width;
            _averageBlue = blue / width;

            _averageHue = hue / width;
            _averageSat = sat / width;
            _averageVal = val / width;

            sat = 0;
            val = 0;

            for (int x = 0; x < width; ++x)
            {
                ImageSlice slice = _slices[x];
                float deltaSat = slice.getAverageSat() - _averageSat;
                sat += deltaSat * deltaSat;
                float deltaVal = slice.getAverageVal() - _averageVal;
                val += deltaVal * deltaVal;
            }
        
            _deviationVal = (float)Math.Sqrt((val / (float)width) / 255.0);
            _deviationSat = (float)Math.Sqrt((sat / (float)width) / 255.0);
        }

        public ImageSlice getSlice(int slice)
        {
            return _slices[slice];
        }

        public float getAverageRed() { return _averageRed; }
        public float getAverageGreen() { return _averageGreen; }
        public float getAverageBlue() { return _averageBlue; }
        public float getAverageHue() { return _averageHue; }
        public float getAverageSat() { return _averageSat; }
        public float getAverageVal() { return _averageVal; }

        public float getDeviationSat() { return _deviationSat; }
        public float getDeviationVal() { return _deviationVal; }

        public int getNumSlices() { return _slices.Length; }
    }
}
