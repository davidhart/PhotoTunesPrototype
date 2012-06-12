using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;

namespace PhotoTunesDebugApp
{
    class ImageFilter
    {
        public static Image Downsample(Image image, int maximumSize)
        {
            int size = Math.Max(image.Width, image.Height);

            if (size <= maximumSize)
            {
                return image;
            }

            Size s = image.Size;

            if (image.Width > image.Height)
            {
                float ratio = (float)maximumSize / image.Width;

                s.Width = maximumSize;
                s.Height = (int)(image.Height * ratio);
            }
            else
            {
                float ratio = (float)maximumSize / image.Height;

                s.Height = maximumSize;
                s.Width = (int)(image.Width * ratio);
            }

            Bitmap bitmap = new Bitmap(image, s);

            return Image.FromHbitmap(bitmap.GetHbitmap());
        }

        public static int Index(int x, int y, int width)
        {
            return (x + y * width) * 4;
        }

        public static byte Clamp255(int i)
        {
            i = Math.Abs(i);

            if (i >= 255)
                return 255;
            if (i <= 0)
                return 0;

            return (byte)i;
        }

        public static void FilterPixel(int x, int y, byte[] dataIn, byte[] dataOut, int w)
        {
            int [,] hfilter = { { -2, 0, 2 },
                                  { -1, 0, 1 },
                                  { -2, 0, 2 } };

            int [,] vfilter = { { 2, 1, 2 },
                                  { -0, 0, 0 },
                                  { -2, -1, -2 } };

            int rH = 0;
            int gH = 0; 
            int bH = 0;

            int rV = 0;
            int gV = 0;
            int bV = 0;

            for (int i = 0; i < 3; i++)
            {
                for (int j = 0; j < 3; j++)
                {
                    int p = Index(x+i-1, y+j-1, w);

                    rH += dataIn[p+2] * hfilter[j,i];
                    gH += dataIn[p+1] * hfilter[j,i];
                    bH += dataIn[p] * hfilter[j,i];

                    rV += dataIn[p+2] * vfilter[j,i];
                    gV += dataIn[p+1] * vfilter[j,i];
                    bV += dataIn[p] * vfilter[j,i];
                }
            }

            int pO = Index(x, y, w);

            /*
            dataOut[pO] = 0;
            dataOut[pO + 1] = 0;
            dataOut[pO + 2] = dataIn[pO+2];
            dataOut[pO + 3] = 255;*/

            dataOut[pO] = Clamp255(bH + bV);
            dataOut[pO + 1] = Clamp255(gH + gV);
            dataOut[pO + 2] = Clamp255(rH + rV);
            dataOut[pO + 3] = 255;
        }

        public static Image SobelFilter(Image image)
        {
            int w = image.Width;
            int h = image.Height;                        

            Bitmap bitmap = new Bitmap(image);
            BitmapData bmDataIn = bitmap.LockBits(new Rectangle(0, 0, image.Width, image.Height), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
            byte[] dataIn = new byte[image.Width * image.Height * 4];
            Marshal.Copy(bmDataIn.Scan0, dataIn, 0, dataIn.Length);
            bitmap.UnlockBits(bmDataIn);

            byte[] filteredData = new byte[image.Width * image.Height * 4];

            for (int x = 0; x < image.Width; ++x)
            {
                for (int y = 0; y < image.Height; ++y)
                {
                    if (x == 0 || x == w - 1 || y == 0 || y == h - 1)
                    {
                        int i = Index(x, y, w);

                        filteredData[i] = 0;
                        filteredData[i + 1] = 0;
                        filteredData[i + 2] = 0;
                        filteredData[i + 3] = 255;
                    }
                    else
                    {
                        FilterPixel(x, y, dataIn, filteredData, w);
                    }

                }
            }

            Bitmap filteredBitmap = new Bitmap(image.Width, image.Height, PixelFormat.Format32bppArgb);
            BitmapData filteredBmData = filteredBitmap.LockBits(new Rectangle(0, 0, image.Width, image.Height), ImageLockMode.WriteOnly, PixelFormat.Format32bppArgb);
            Marshal.Copy(filteredData, 0, filteredBmData.Scan0, filteredData.Length);
            filteredBitmap.UnlockBits(filteredBmData);

            return Image.FromHbitmap(filteredBitmap.GetHbitmap());
        }
    }
}
