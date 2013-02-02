#import <Foundation/Foundation.h>

@interface ImageSlice : NSObject
{
    @private unsigned int _height;
    
    @private UInt8 _averageRed;
    @private UInt8 _averageBlue;
    @private UInt8 _averageGreen;
    
    @private UInt8 _averageHue;
    @private UInt8 _averageSat;
    @private UInt8 _averageVal;
}

-(id)init:(const UInt8*)data: (uint)stride: (uint)height;
-(void)log;

-(UInt8)getAverageRed;
-(UInt8)getAverageGreen;
-(UInt8)getAverageBlue;

-(UInt8)getAverageHue;
-(UInt8)getAverageSat;
-(UInt8)getAverageVal;

@end
