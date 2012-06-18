//
//  ViewController.m
//  ImageProcessing
//
//  Created by MEng on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Util.h"
#import "InstrumentSelector.h"
#import "ProgressScreen.h"
#import <SCUI.h>

#import <objc/objc-auto.h>

@implementation ViewController

@synthesize imageView;
@synthesize progress;

@synthesize buttonPlay;
@synthesize buttonRepeat;

@synthesize sliderTempo;
@synthesize sliderDrumVolume;
@synthesize sliderMelodyVolume;
@synthesize sliderSongLength;

@synthesize achievementsScrollView;
@synthesize achievementsToolbar;

-(void)sliderTempoReleased:(id)sender
{ 
    [PdBase sendFloat: 60000.0f / ([sliderTempo value] * 400.0f + 60.0f) toReceiver:[NSString stringWithFormat:@"%d-tempo", _patch.dollarZero]];
}

-(void)sliderDrumVolumeReleased:(id)sender
{
    // Change the master volume of instruments 0 through to 4
    
    NSArray* receivers = [NSArray arrayWithObjects:@"%d-instrument0", @"%d-instrument1", @"%d-instrument2",
                          @"%d-instrument3", @"%d-instrument4", nil];
    
    NSString* message = @"volume";
    NSArray* args = [NSArray arrayWithObject:[NSNumber numberWithFloat:[sliderDrumVolume value]]];
    
    
    for (int i = 0; i < [receivers count]; ++i)
    {
        NSString* receiver = [NSString stringWithFormat:[receivers objectAtIndex:i], _patch.dollarZero];
        
        [PdBase sendMessage: message withArguments:args toReceiver:receiver];
    }   
}

-(void)sliderMelodyVolumeReleased:(id)sender
{
    // Change the master volume of instrument 5
    NSString* receiver = [NSString stringWithFormat:@"%d-instrument5", _patch.dollarZero];
    NSString* message = @"volume";
    NSArray* args = [NSArray arrayWithObject:[NSNumber numberWithFloat:[sliderMelodyVolume value]]];    
    
    [PdBase sendMessage: message withArguments: args toReceiver: receiver];   
}

-(void)sliderSongLengthReleased:(id)sender
{    
    _numNotes = (int)(sliderSongLength.value + 0.5f) * 4; // 4 notes per notch on slider
    
    [self updateSongValues];
}

-(void)sliderSongLengthChanged:(id)sender
{
    sliderSongLength.value = (int)(sliderSongLength.value + 0.5f);
}

-(void)playPressed:(id)sender
{ 
    _playing = !_playing;
    
    if (_playing)
    {
        [PdBase sendBangToReceiver:@"startPlayback"];
        [self startedPlaying];
    }
    else
    {
        [PdBase sendBangToReceiver:@"pausePlayback"];
        [self stoppedPlaying];
    }
}

-(void)repeatPressed:(id)sender
{
    _repeatOn = !_repeatOn;
    
    [PdBase sendFloat: _repeatOn ? 1.0f : 0.0f toReceiver:[NSString stringWithFormat:@"%d-loopPlayback", _patch.dollarZero]];
    
    if (_repeatOn)
    {
        [buttonRepeat setImage:[UIImage imageNamed:@"simplereplaybuttonblue.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [buttonRepeat setImage:[UIImage imageNamed:@"replaybutton.png"] forState:UIControlStateNormal];
        
    }
}

-(void)stopPressed:(id)sender
{ 
    [PdBase sendBangToReceiver:@"stopPlayback"];
    [progress setProgress: 0];
}

-(void)cameraPressed:(id)sender
{ 
    [self activateImageChooser: YES];
}

-(void)loadPressed:(id)sender
{
    [self activateImageChooser: NO];
}

-(void)instrumentsPressed:(id)sender
{
    [_instrumentSelector show];
}

-(void)recordPressed:(id)sender
{
    // Make sure looping is disabled while recording
    if (_repeatOn)
        [PdBase sendFloat: 0.0f toReceiver:[NSString stringWithFormat:@"%d-loopPlayback", _patch.dollarZero]];
    
    // Start recording
    [PdBase sendBangToReceiver: @"recordSong"];
    
    [_progressScreen setTitle: @"Saving"];
    [_progressScreen setProgress:0];
    [_progressScreen show];
}

-(void)recordDone
{    
    // Re-enable looping
    if (_repeatOn)
        [PdBase sendFloat: 1.0f toReceiver:[NSString stringWithFormat:@"%d-loopPlayback", _patch.dollarZero]];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *savadataPath = [path stringByAppendingPathComponent:@"savedata.wav"];
    
    NSURL *trackURL = [NSURL fileURLWithPath:savadataPath]; // ... an URL to the audio file
    
    SCShareViewController* shareViewController = 
        [SCShareViewController shareViewControllerWithFileURL:trackURL
        completionHandler:^
         (NSDictionary *trackInfo, NSError *error)
         {
             if (SC_CANCELED(error))
             {
                 NSLog(@"Canceled!");
             }
             else if (error)
             {
                 NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
             }
             else
             {
                 // If you want to do something with the uploaded
                 // track this is the right place for that.
                 NSLog(@"Uploaded track: %@", trackInfo);
             }
        }];
    
    [shareViewController setCoverImage: [imageView image]];
    
    // If your app is a registered foursquare app, you can set the client id and secret.
    // The user will then see a place picker where a location can be selected.
    // If you don't set them, the user sees a plain plain text filed for the place.
    /*
     [shareViewController setFoursquareClientID:@"<foursquare client id>"
     clientSecret:@"<foursquare client secret>"];
     */
    
    // We can preset the title ...
    [shareViewController setTitle:@"Created with the phototunes app!"];
    
    // ... and other options like the private flag.
    [shareViewController setPrivate:NO];
    
    // Now present the share view controller.
    [self presentModalViewController:shareViewController animated:YES];
    
    [_progressScreen hide];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)initialize: (PdAudioController*) audio
{
    // Initialise soundcloud API
    [SCSoundCloud setClientID: @"c670c061ac40359ac3ca5f2213836714"
                       secret: @"fe998800f4183f2109ffa0b84bbd8c3b"
                  redirectURL: [NSURL URLWithString:@"phototunes://oauth"]];
    
    _audio = audio;
    
    // Initialise song length
    _numNotes = 12;
    
    // 5 drums + 1 instrument
    _numIntruments = 6;
    
    _repeatOn = false;
    _playing = false;
    
    // Init camera picker
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;

    // Initialise PD
    [PdBase setDelegate:self];
    _patch = [PdFile openFileNamed:@"soundsystem.pd" path:[[NSBundle mainBundle] bundlePath]];
    
    // Initialise number of instruments
    [PdBase sendFloat:_numIntruments toReceiver:[NSString stringWithFormat:@"%d-numInstruments", _patch.dollarZero]];
    
    // disable looping by default
    [PdBase sendFloat:0 toReceiver:[NSString stringWithFormat:@"%d-loopPlayback", _patch.dollarZero]];
    
    // listen for changes in progress bar & stop event
    [PdBase subscribe:[NSString stringWithFormat:@"%d-notifyProgress", _patch.dollarZero]];
    [PdBase subscribe:@"stopPlayback"];
    [PdBase subscribe:@"recordDone"];
    
    // Setup path in appdata folder for streaming the audio
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *samplePath = [path stringByAppendingPathComponent:@"savedata.wav"];
    [PdBase sendMessage:samplePath withArguments:NULL toReceiver:[NSString stringWithFormat:@"%d-saveFile", _patch.dollarZero]];
    
    // Initialise default image
    UIImage* image = [UIImage imageNamed:@"phototunes.png"];
    //UIImage* image = [UIImage imageNamed:@"test2.jpg"];
    [self setImage: image];
    
    // Hack for iPhone 4, fix the rectangle for the initial image
    progress.frame = CGRectMake(31, 225, 257, 10);
    
    
    _instrumentSelector = [[InstrumentSelector alloc] init: self];
    _progressScreen = [[ProgressScreen alloc] init: self];
    
    _acheivementsView = [[AchievementsView alloc] init: self];
    
    [_audio setActive:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Allow only upright portrait orientation
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)receiveFloat:(float)received fromSource:(NSString *)source
{
    NSString* notifyProgress = [NSString stringWithFormat:@"%d-notifyProgress", _patch.dollarZero];
    
    if ([notifyProgress isEqualToString:source])
    {        
        _progressValue = received;
        
        [self performSelectorOnMainThread:@selector(updateProgressView) withObject:nil waitUntilDone:NO];
    }
}

- (void)receiveBangFromSource:(NSString *)source
{
    NSString* stopPlayback = @"stopPlayback";
    NSString* recordDone = @"recordDone";
    
    if ([stopPlayback isEqualToString:source])
    {
        [self performSelectorOnMainThread:@selector(stoppedPlaying) withObject:nil waitUntilDone:NO];
    }
    else if ([recordDone isEqualToString:source])
    {
        [self performSelectorOnMainThread:@selector(recordDone) withObject:nil waitUntilDone:NO];         
    }
}

-(void)updateProgressView
{
    float temp = _progressValue / (_numNotes - 1);
    
    if ([_progressScreen isVisible])
    {
        if (temp != 0)
            [_progressScreen setProgress:temp];
    }
    else
    {
        [progress setProgress: temp];
    }
}

-(void)activateImageChooser:(BOOL) camera
{
    [self stopPressed:self];
    [_audio setActive:NO];
    
    if(camera)
    {
#if !TARGET_IPHONE_SIMULATOR	
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif        
    }
    else
    {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
 
    [self setImage: image];
    
    self.selectedIndex = 0;
    
    [_audio setActive:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    
    [_audio setActive:YES];
}

-(void)setImage:(UIImage *)image
{
    // Display image
    [imageView setImage: image];
    
    // Calculate image properties
    _imagePropertes = [[ImageProperties alloc] init:image];
    
    // Update the song
    [self updateSongValues];
    
    // Resize progress bar to fit underneath scaled image
    CGRect onScreenRect = [Util frameForImage:image inImageViewAspectFit:imageView];
    onScreenRect.origin.y = onScreenRect.origin.y + onScreenRect.size.height;
    onScreenRect.size.height = 10; //progress.frame.size.height;
    progress.frame = onScreenRect;
    
    // Stop playback
    [self stopPressed: self];
}

-(void)updateSongValues
{
    // Stop playback first
    [self stopPressed:self];
    float* values = malloc(_numNotes * sizeof(float) * _numIntruments);
    
    float* bassNotes = values;
    float* hihatNotes = values + _numNotes;
    float* rideNotes = values + _numNotes * 2;
    float* snareNotes = values + _numNotes * 3;
    float* splashNotes = values + _numNotes * 4;
    
    float* melodyNotes = values + _numNotes * 5;
    
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
    float* sliceAvArray = malloc(sizeof(float) * [_imagePropertes numSlices]);
    float* ModifiedSliceAvArray = malloc(sizeof(float) * [_imagePropertes numSlices]);
    float debugCounter =0.0;

 
    

    for (int i = 0; i < _numNotes; i++)
    {
        ImageSlice* slice = [_imagePropertes getSlice: (int)((i / (float)_numNotes) * ([_imagePropertes numSlices]-1))];
        
        //OPTTIMISATION - move i != 0 check out of loop
        //TOMS SHIT <----- 
        int sliceBack;
        //ImageSlice* slice;
        if ( i != 0 )
        {
            sliceBack = (int)(((i / (float)_numNotes) * ([_imagePropertes numSlices])) - prevSliceNumber) - 1;

            float sliceAv = 0;
            int numOfLoops = 0;

            for (int j = i; (j - i) < sliceBack; j++)
            {
                //-2 due to end slice and due to not wanting to go as far back as previous slice
                int sliceIndex = (int)(((i) / (float)_numNotes) * ([_imagePropertes numSlices]-1)-j-1);
                slice = [_imagePropertes getSlice: sliceIndex];
                sliceAv += ([slice getAverageVal] / 255.0f);
                numOfLoops++;    
            }
            sliceAv /= numOfLoops;
            sliceAvArray[i] = sliceAv;
            

        }
        else 
        {
            slice = [_imagePropertes getSlice: (int)((i / (float)_numNotes) * ([_imagePropertes numSlices]-1))];
            sliceAvArray[i] = [slice getAverageVal] / 255.0f;
        }
        
        prevSliceNumber = (int)((i / (float)_numNotes) * [_imagePropertes numSlices]);

        

        
        bassNotes[i] = i % 4 == 0 ? 1.0f : 0.0f;
        //hihatNotes[i] = [slice getAverageVal] < 60? 1.0f : 0.0f;
        hihatNotes[i] = 1;
        rideNotes[i] =  1 - hihatNotes[i];
        snareNotes[i] = i % 4 == 2 ? 1.0f : 0.0f;
    
        float change = ([slice getAverageSat] - [_imagePropertes getAverageSat]) / 255.0f;
        float splash = fabs(change) > ([_imagePropertes getDeviationSat]) ? 1.0f : 0.0f;
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
    for (int j=0; j<_numNotes; j++) 
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
    for (int i = 0; i < _numNotes; i++)
    {
        sliceAvArray[i]= (sliceAvArray[i]-lowSlice)/(highSlice-lowSlice);
    }
    
    ModifiedSliceAvArray[0] = 0.5;
    for (int i = 0; i < _numNotes; i++)
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
    

       
    melodyNotes[i] = [ViewController getNote:scale :sizeof(scale)/sizeof(float) :(ModifiedSliceAvArray[i])];
        //melodyNotes[i] = 1.4983;

 NSLog(@"%f",melodyNotes[i]);        debugCounter += 0.05;

    }
    
    for (int i =0; i < _numNotes; i++) 

    
    [PdBase sendFloat:_numNotes toReceiver:[NSString stringWithFormat:@"%d-length", _patch.dollarZero]];
    [PdBase copyArray:values toArrayNamed:@"pattern" withOffset:0 count:_numNotes * _numIntruments];
    
    free(values);
    free(sliceAvArray);
}

+(float)getNote:(float*)scale :(int)size :(float)locationOnScale
{

    int index = (int)(locationOnScale * (size - 1) + 0.5f);
    
    assert(index >= 0);
    assert(index < size);
    
    return scale[index];
}

-(void)startedPlaying
{
    //[buttonPlay setTitle:@"Pause" forState:UIControlStateNormal];
    [buttonPlay setImage:[UIImage imageNamed:@"pausebutton.png"] forState:UIControlStateNormal];
    
    _playing = true;
}

-(void)stoppedPlaying
{
    if (_progressValue == _numNotes - 1)
    {
        _progressValue = 0;
        [self updateProgressView];
    }

    [buttonPlay setImage:[UIImage imageNamed:@"playbutton.png"] forState:UIControlStateNormal];
    _playing = false;
}

-(void)changeInstrument:(NSString *)soundFile
{
    NSString* message = @"sample";
    NSArray* args = [NSArray arrayWithObject: soundFile];
    
    [PdBase sendMessage:message withArguments:args toReceiver:[NSString stringWithFormat:@"%d-instrument5", _patch.dollarZero]];
}
- (void)receivePrint:(NSString *)message
{
    NSLog(message);
}
@end
