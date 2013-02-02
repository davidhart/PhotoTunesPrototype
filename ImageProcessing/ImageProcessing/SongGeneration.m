#import "SongGeneration.h"
#import "ImageProperties.h"

static float step1 = 0.05f;
static float step2 = 0.10f;
static float step3 = 0.15f;
static float step4 = 0.20f;

@implementation SongGeneration

+(float)GetNote:(float*)scale :(int)size :(float)locationOnScale
{
    
    int index = (int)(locationOnScale * (size - 1) + 0.5f);
    
    assert(index >= 0);
    assert(index < size);
    
    return scale[index];
}

+(void)GenerateSong:(int)length :(ImageProperties *)image :(float *)notes
{
    /*
    float* bassNotes = notes;
    float* hihatNotes = notes + length;
    float* rideNotes = notes + length * 2;
    float* snareNotes = notes + length * 3;
    float* splashNotes = notes + length * 4;
    
    float* melodyNotes = notes + length * 5;
    
    //float scale[] = { 0.25f,0.0f, 0.5f, 0.0f,0.0f, 0.75f, 0.0f, 1.0f, 0.0f, 1.25f,0.0f, 1.5f, 0.0f, 0.0f, 1.75, 2.0f,0.0f };
    
    // C SCALE 
    float scale[] = {0.5f, 0.56122f, 0.6299f, 0.6674f, 0.7491f, 0.8408f, 0.9438f, 1.0f, 1.1124f, 1.2600f, 1.3348f,1.4983f, 1.684f, 1.8877f};
    
    
    const float bassVolume = 0.6f;
    const float hihatVolume = 0.6f;
    const float rideVolume = 0.6f;
    const float snareVolume = 0.6f;
    const float splashVolume = 0.6f;
    
    const float bassVariation = 0.5;
    const float hihatVariation = 0.5f;
    const float rideVariation = 0.5f;
    const float snareVariation = 0.5f;
    const float splashVariation = 0.5f;
    //float tempNum = 0;
    int prevSliceNumber = 0;
    float* sliceAvArray = malloc(sizeof(float) * [image numSlices]);
    float* ModifiedSliceAvArray = malloc(sizeof(float) * [image numSlices]);
    float debugCounter =0.0;
    
    
    
    
    for (int i = 0; i < length; i++)
    {
        ImageSlice* slice = [image getSlice: (int)((i / (float)length) * ([image numSlices]-1))];
        
        //OPTTIMISATION - move i != 0 check out of loop
        //TOMS SHIT <----- 
        int sliceBack;
        //ImageSlice* slice;
        if ( i != 0 )
        {
            sliceBack = (int)(((i / (float)length) * ([image numSlices])) - prevSliceNumber) - 1;
            
            float sliceAv = 0;
            int numOfLoops = 0;
            
            for (int j = i; (j - i) < sliceBack; j++)
            {
                //-2 due to end slice and due to not wanting to go as far back as previous slice
                int sliceIndex = (int)(((i) / (float)length) * ([image numSlices]-1)-j-1);
                slice = [image getSlice: sliceIndex];
                sliceAv += ([slice getAverageVal] / 255.0f);
                numOfLoops++;    
            }
            sliceAv /= numOfLoops;
            sliceAvArray[i] = sliceAv;
            
            
        }
        else 
        {
            slice = [image getSlice: (int)((i / (float)length) * ([image numSlices]-1))];
            sliceAvArray[i] = [slice getAverageVal] / 255.0f;
        }
        
        prevSliceNumber = (int)((i / (float)length) * [image numSlices]);
        
        
        
        
        bassNotes[i] = i % 4 == 0 ? 1.0f : 0.0f;
        //hihatNotes[i] = [slice getAverageVal] < 60? 1.0f : 0.0f;
        hihatNotes[i] = 1;
        rideNotes[i] =  1 - hihatNotes[i];
        snareNotes[i] = i % 4 == 2 ? 1.0f : 0.0f;
        
        float change = ([slice getAverageSat] - [image getAverageSat]) / 255.0f;
        float splash = fabs(change) > ([image getDeviationSat]) ? 1.0f : 0.0f;
        splashNotes[i] = splash;
        
        
        if (bassNotes[i] > 0)
            bassNotes[i] += - bassVariation / 2 - bassVariation * [slice getAverageRed] / 255.0f;
        
        if (hihatNotes[i] > 0)
            hihatNotes[i] += - hihatVariation / 2 + hihatVariation * [slice getAverageGreen] / 255.0f;
        
        if (rideNotes[i] > 0)
            rideNotes[i] += - rideVariation / 2 - rideVariation * [slice getAverageBlue] / 255.0f;
        
        if (snareNotes[i] > 0)
            snareNotes[i] += - rideVariation / 2 - snareVariation * [slice getAverageRed] / 255.0f;
        
        if (splashNotes[i] > 0)
            splashNotes[i] += - splashVariation / 2 - splashVariation * [slice getAverageGreen] / 255.0f;
        
        
        bassNotes[i] *= bassVolume;
        hihatNotes[i] *= hihatVolume;
        rideNotes[i] *= rideVolume;
        snareNotes[i] *= snareVolume;
        splashNotes[i] *= splashVolume;
        
        
    }
    
    // MORE OF TOMS SHIT
    //Gets Highest and lowest slices and maps to a range of 0 - 1
    float lowSlice = 0;
    float highSlice = 0;
    for (int j=0; j<length; j++) 
    {          
        
        if(sliceAvArray[j] < lowSlice||j==0)
        {
            lowSlice = (float)sliceAvArray[j];
            
        }
        if(sliceAvArray[j] > highSlice||j==0)
        {
            highSlice = (float)sliceAvArray[j];
        }
        
    }
    for (int i = 0; i < length; i++)
    {
        sliceAvArray[i]= (sliceAvArray[i]-lowSlice)/(highSlice-lowSlice);
    }
    
    ModifiedSliceAvArray[0] = 0.5;
    for (int i = 0; i < length; i++)
    {
        
        float step = sliceAvArray[i+1] - sliceAvArray[i];
        
        if(step>0)
        {
            if(fabs(step) < 0.01)
            {
                ModifiedSliceAvArray[i+1] = 0.05 + ModifiedSliceAvArray[i];
                
            }
            else if (fabs(step) < 0.05) {
                ModifiedSliceAvArray[i+1] = 0.10 + ModifiedSliceAvArray[i];
                
            }
            else if (fabs(step) < 0.1) {
                
                
                ModifiedSliceAvArray[i+1] = 0.15 + ModifiedSliceAvArray[i];
                
            }
            else {
                ModifiedSliceAvArray[i+1] = 0.30 + ModifiedSliceAvArray[i];
                
                
            }
            if(ModifiedSliceAvArray[i+1] > 1.0 && i > 0)
            {
                
                ModifiedSliceAvArray[i+1] = ModifiedSliceAvArray[i-1];
                
            }
            else if (ModifiedSliceAvArray[i+1] > 1.0) {
                ModifiedSliceAvArray[i+1] = 0.5;
            }
            if(ModifiedSliceAvArray[i+1] < 0.0 && i > 0)
            {
                ModifiedSliceAvArray[i+1] = ModifiedSliceAvArray[i-1];
                
            }            
            else if (ModifiedSliceAvArray[i+1] < 0.0) {
                ModifiedSliceAvArray[i+1] = 0.5;
            }
        }
        else {
            if(fabs(step) < 0.01)
            {
                ModifiedSliceAvArray[i+1] = ModifiedSliceAvArray[i] - 0.05;
                
            }
            else if (fabs(step) < 0.05) {
                ModifiedSliceAvArray[i+1] = ModifiedSliceAvArray[i]- 0.10;
                
            }
            else if (fabs(step) < 0.1) {
                ModifiedSliceAvArray[i+1] = ModifiedSliceAvArray[i]- 0.15;
                
            }
            else {
                ModifiedSliceAvArray[i+1] = ModifiedSliceAvArray[i]- 0.30;
                
            }
            
            if(ModifiedSliceAvArray[i+1] > 1.0 && i > 0)
            {
                ModifiedSliceAvArray[i+1] = ModifiedSliceAvArray[i-1];
                
            }
            else if (ModifiedSliceAvArray[i+1] > 1.0) {
                ModifiedSliceAvArray[i+1] = 0.5;
            }
            if(ModifiedSliceAvArray[i+1] < 0.0 && i > 0)
            {
                ModifiedSliceAvArray[i+1] = ModifiedSliceAvArray[i-1];
            }
            else if (ModifiedSliceAvArray[i+1] < 0.0) {
                ModifiedSliceAvArray[i+1] = 0.5;
            }
        }
        
        
        
        melodyNotes[i] = [SongGeneration GetNote:scale :sizeof(scale)/sizeof(float) :(ModifiedSliceAvArray[i])];
        //melodyNotes[i] = 1.4983;
        
        NSLog(@"%f",melodyNotes[i]);        debugCounter += 0.05;
        
    }

    free(sliceAvArray);
     */
    
    float* sliceAvArray = malloc(length * sizeof(float));
    //float* filteredSliceAvArray = new float[songLength];
    float* ModifiedSliceAvArray = malloc(length * sizeof(float));
    bool* rests = malloc(length * sizeof(bool));
                         
    float* bassNotes = notes;
    float* hihatNotes = notes + length;
    float* rideNotes = notes + length * 2;
    float* snareNotes = notes + length * 3;
    float* splashNotes = notes + length * 4;
    float* melodyNotes = notes + length * 5;
    
    int prevSliceNumber = 0;
    for (int i = 1; i < length+1; i++)
    {
        int sliceBack;
        int sliceNum = (int)(i / (float)length * ([image numSlices] - 1));
        ImageSlice* slice = [image getSlice:sliceNum];
        //ImageSlice* filteredSlice = filteredimageprop.getSlice(sliceNum);
        
        
        sliceBack = (int)((i / (float)length) * [image numSlices] - prevSliceNumber) - 1;
        
        //Console.WriteLine("from slice" + (sliceNum - sliceBack) + "to" +  sliceNum);
        
        float sliceAv = 0;
        float filteredSliceAv = 0;
        int numOfLoops = 0;
        
        for (int j = i; (j - i) < sliceBack; j++)
        {
            int sliceIndex = (int)(((i / (float)length) * ([image numSlices] - 1)) - j);
            slice = [image getSlice:sliceIndex];
            //filteredSlice = filteredimageprop.getSlice(sliceIndex);
            sliceAv += [slice getAverageVal];
            //filteredSliceAv += filteredSlice.getAverageVal();
            numOfLoops++;
        }
        sliceAv /= numOfLoops;
        filteredSliceAv /= numOfLoops;
        i--;// to adjust for array
        sliceAvArray[i] = sliceAv;
        //filteredSliceAvArray[i] = filteredSliceAv;
        
        //if (filteredSliceAvArray[i] > filteredimageprop.getAverageVal())
        if (sliceAvArray[i] > [image getAverageVal])
        {
            rests[i] = false;
        }
        else
        {
            rests[i] = true;
        }
        
        
        prevSliceNumber = sliceNum;
        const float bassVolume = 0.6f;
        const float hihatVolume = 0.6f;
        const float rideVolume = 0.6f;
        const float snareVolume = 0.6f;
        const float splashVolume = 0.6f;
        
        const float bassVariation = 0.5f;
        const float hihatVariation = 0.5f;
        const float rideVariation = 0.5f;
        const float snareVariation = 0.5f;
        const float splashVariation = 0.5f;
        
        float change = [slice getAverageSat] - [image getAverageSat];;
        float splash = fabs(change) > ([image getDeviationSat]*10) ? 1.0f : 0.0f;
        
        //switch (mode)
        {
        //    case playbackMode.rock:
                bassNotes[i] = i % 4 == 0 ? 1.0f : 0.0f;
                //drums.hihatNotes[i] = [slice getAverageVal] < 60? 1.0f : 0.0f;
                hihatNotes[i] = 1;
                rideNotes[i] = 1 - hihatNotes[i];
                snareNotes[i] = i % 4 == 2 ? 1.0f : 0.0f;
                splashNotes[i] = splash;
        //        break;
                
        //    case playbackMode.dance:
        //        drums.bassNotes[i] = i % 2 == 0 ? 1.0f : 0.0f;
        //        drums.hihatNotes[i] = i % 2 == 1 ? 1.0f : 0.0f;
        //        drums.rideNotes[i] = 0.0f;
        //        drums.snareNotes[i] = splash;
        //        drums.splashNotes[i] = i % 4 == 3 ? 1.0f : 0.0f;
        //        break;
                
        //    default:
        //        break;
        }
        
        
        
        
        
        
        if (bassNotes[i] > 0)
            bassNotes[i] += - bassVariation / 2 - bassVariation * [slice getAverageRed] / 255.0f;
        
        if (hihatNotes[i] > 0)
            hihatNotes[i] += - hihatVariation / 2 + hihatVariation * [slice getAverageGreen] / 255.0f;
        
        if (rideNotes[i] > 0)
            rideNotes[i] += - rideVariation / 2 - rideVariation * [slice getAverageBlue] / 255.0f;
        
        if (snareNotes[i] > 0)
            snareNotes[i] += - rideVariation / 2 - snareVariation * [slice getAverageRed] / 255.0f;
        
        if (splashNotes[i] > 0)
            splashNotes[i] += - splashVariation / 2 - splashVariation * [slice getAverageGreen] / 255.0f;
        
        
        bassNotes[i] *= bassVolume;
        hihatNotes[i] *= hihatVolume;
        rideNotes[i] *= rideVolume;
        snareNotes[i] *= snareVolume;
        splashNotes[i] *= splashVolume;
        i++;//readjust for array
    }
    //Gets Highest and lowest slices and maps to a range of 0 - 1
    float lowSlice = 0;
    float highSlice = 0;
    for (int j = 0; j < length; j++)
    {
        
        if (sliceAvArray[j] < lowSlice || j == 0)
        {
            lowSlice = (float)sliceAvArray[j];
            
        }
        if (sliceAvArray[j] > highSlice || j == 0)
        {
            highSlice = (float)sliceAvArray[j];
        }
        
    }
    for (int i = 0; i < length; i++)
    {
        sliceAvArray[i] = (sliceAvArray[i] - lowSlice) / (highSlice - lowSlice);
    }
    
    ModifiedSliceAvArray[0] = 0.5f;
    for (int i = 0; i < length-1;/*!-1 may be bug in obj c code*/ i++)
    {
        
        float step = sliceAvArray[i + 1] - sliceAvArray[i];
        
        if (step > 0)
        {
            if (fabs(step) < 0.01)
            {
                ModifiedSliceAvArray[i + 1] = step1 + ModifiedSliceAvArray[i];
                
            }
            else if (fabs(step) < 0.05)
            {
                ModifiedSliceAvArray[i + 1] = step2 + ModifiedSliceAvArray[i];
                
            }
            else if (fabs(step) < 0.1)
            {
                
                
                ModifiedSliceAvArray[i + 1] = step3 + ModifiedSliceAvArray[i];
                
            }
            else
            {
                ModifiedSliceAvArray[i + 1] = step4 + ModifiedSliceAvArray[i];
                
                
            }
            if (ModifiedSliceAvArray[i + 1] > 1.0 && i > 0)
            {
                
                ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i - 1];
                
            }
            else if (ModifiedSliceAvArray[i + 1] > 1.0)
            {
                ModifiedSliceAvArray[i + 1] = step1;
            }
            if (ModifiedSliceAvArray[i + 1] < 0.0 && i > 0)
            {
                ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i - 1];
                
            }
            else if (ModifiedSliceAvArray[i + 1] < 0.0)
            {
                ModifiedSliceAvArray[i + 1] = step1;
            }
        }
        else
        {
            if (fabs(step) < 0.01)
            {
                ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i];
                
            }
            else if (fabs(step) < 0.05)
            {
                ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i] - step2;
                
            }
            else if (fabs(step) < 0.1)
            {
                ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i] - step3;
                
            }
            else
            {
                ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i] - step4;
            }
            
            if (ModifiedSliceAvArray[i + 1] > 1.0 && i > 0)
            {
                ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i - 1];
                
            }
            else if (ModifiedSliceAvArray[i + 1] > 1.0)
            {
                ModifiedSliceAvArray[i + 1] = step1;
            }
            if (ModifiedSliceAvArray[i + 1] < 0.0 && i > 0)
            {
                ModifiedSliceAvArray[i + 1] = ModifiedSliceAvArray[i - 1];
            }
            else if (ModifiedSliceAvArray[i + 1] < 0.0)
            {
                ModifiedSliceAvArray[i + 1] = step1;
            }
        }
        
        
    }
        
    //C Scale
    float scale[] = { 0.5f, 0.56122f, 0.6299f, 0.6674f, 0.7491f, 0.8408f, 0.9438f, 1.0f, 1.1124f, 1.2600f, 1.3348f, 1.4983f, 1.684f, 1.8877f };
        
    const int scaleLength = sizeof(scale)/sizeof(float);
        
    for (int i = 0; i < length; i++)
    {
        if (!rests[i])
        {
            melodyNotes[i] = [SongGeneration GetNote: scale: scaleLength: ModifiedSliceAvArray[i]];
        }
        else
        {
            melodyNotes[i] = 0;
        }
    }
}

@end
