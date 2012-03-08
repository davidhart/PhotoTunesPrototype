//
//  ViewController.m
//  ImageProcessing
//
//  Created by MEng on 28/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize imageView;
@synthesize slider;
@synthesize progress;

@synthesize repeatSwitch;
@synthesize drumsSwitch;

-(void)sliderReleased:(id)sender
{ 
    [PdBase sendFloat: 60000.0f / ([slider value] * 400.0f + 60.0f) toReceiver:[NSString stringWithFormat:@"%d-tempo", _patch.dollarZero]];
}

-(void)playPressed:(id)sender
{ 
    [PdBase sendBangToReceiver:@"startPlayback"];
}

-(void)pausePressed:(id)sender
{ 
    [PdBase sendBangToReceiver:@"pausePlayback"];
}

-(void)stopPressed:(id)sender
{ 
    [PdBase sendBangToReceiver:@"stopPlayback"];
    [progress setProgress: 0];
}

-(void)repeatPressed:(id)sender
{ 
    BOOL temp = [repeatSwitch isOn];
    
    if (temp)
        [PdBase sendFloat:1 toReceiver:[NSString stringWithFormat:@"%d-loopPlayback", _patch.dollarZero]];
    
    else if (!temp)
        [PdBase sendFloat:0 toReceiver:[NSString stringWithFormat:@"%d-loopPlayback", _patch.dollarZero]];
}

-(void)drumsPressed:(id)sender
{ 
    BOOL temp = [drumsSwitch isOn];
    
    if (temp)
        [PdBase sendFloat:1 toReceiver:[NSString stringWithFormat:@"%d-drumVolume", _patch.dollarZero]];
    
    else if (!temp)
        [PdBase sendFloat:0 toReceiver:[NSString stringWithFormat:@"%d-drumVolume", _patch.dollarZero]];
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
    [subView setHidden:FALSE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)initialize: (PdAudio*) audio
{
    _audio = audio;
    _numNotes = 24;
    _numIntruments = 6;
    
    // Init camera picker
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    _imagePropertes = [ImageProperties alloc];
    
    [PdBase setDelegate:self];
    
    _patch = [PdFile openFileNamed:@"wavetable.pd" path:[[NSBundle mainBundle] bundlePath]];
    
    [PdBase sendFloat:_numIntruments toReceiver:[NSString stringWithFormat:@"%d-numInstruments", _patch.dollarZero]];
    [PdBase sendFloat:0 toReceiver:[NSString stringWithFormat:@"%d-drumVolume", _patch.dollarZero]];
    [PdBase sendFloat:0 toReceiver:[NSString stringWithFormat:@"%d-loopPlayback", _patch.dollarZero]];
    
    [PdBase subscribe:[NSString stringWithFormat:@"%d-notifyProgress", _patch.dollarZero]];
    
    UIImage* image = [UIImage imageNamed:@"images.jpeg"];
    [self setImage: image];
    
    subView=[[UIView alloc] init];
    subView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    subView.backgroundColor = [UIColor colorWithRed:0.0 
                                              green:0.0 
                                               blue:0.0 
                                              alpha:1.0];
    
    //  Make a new picker view for instrument selector subview
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 63, 320, 200)];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;

    // Make a new toolbar for instrument selector subview
    toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 19, self.view.frame.size.width, 44);
    
    //Add a done button
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarDone)];
    
    // Add a title and padding to centre the title
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 172, 23)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor colorWithRed:0.0 
                                        green:0.0 
                                         blue:0.0 
                                        alpha:1.0];
    label.shadowOffset = CGSizeMake(0, 1);
    label.textColor = [UIColor colorWithRed:1.0 
                                      green:1.0 
                                       blue:1.0 
                                      alpha:1.0];
    label.text = @"Instruments";
    label.font = [UIFont boldSystemFontOfSize:20.0];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:label];
    
    // Add a cancel button
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarBack)];  
    
    // Add buttons to toolbar
    NSArray *buttons = [NSArray arrayWithObjects: item3, item2, item1, nil];
    [toolbar setItems: buttons animated:NO];
    
    // Set up the subview for the instruments selector and hide it untill used
    [self.view addSubview:subView];
    [subView addSubview:myPickerView];
    [subView addSubview:toolbar];
    [subView setHidden:TRUE];
    
    [_audio play];
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
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)receiveFloat:(float)received fromSource:(NSString *)source
{
    NSString* pitch = [NSString stringWithFormat:@"%d-notifyProgress", _patch.dollarZero];
    if ([pitch isEqualToString:source])
    {
        float temp = received / (_numNotes - 1);
        
        _progressValue = temp;
        
        [self performSelectorOnMainThread:@selector(updateProgressView) withObject:nil waitUntilDone:NO];
    }
}

-(void)updateProgressView
{
    [progress setProgress: _progressValue];
}

-(void)activateImageChooser:(BOOL) camera
{
    [self stopPressed:self];
    [_audio pause];
    if(camera)
    {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
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
    
    [_audio play];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    
    [_audio play];
}

-(void)setImage:(UIImage *)image
{
    [imageView setImage: image];
    [_imagePropertes init:image];
    
    [self updateValues:image];
    
    [self stopPressed: self];
}

-(void)updateValues:(UIImage *)image
{
    float* values = malloc(_numNotes * sizeof(float) * _numIntruments);
    
    float* bassNotes = values;
    float* hihatNotes = values + _numNotes;
    float* rideNotes = values + _numNotes * 2;
    float* snareNotes = values + _numNotes * 3;
    float* splashNotes = values + _numNotes * 4;
    
    float* melodyNotes = values + _numNotes * 5;
    
    float scale[] = { 0.0f, 100.0f, 200.0f, 300.0f, 400.0f, 500.0f, 600.0f };
    
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
    
    for (int i = 0; i < _numNotes; i++)
    {
        ImageSlice* slice = [_imagePropertes getSlice: (int)((i / (float)_numNotes) * ([_imagePropertes numSlices]-1))];

        
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
        
        NSLog(@"%d ,  %f ", [slice getAverageGreen], hihatNotes[i]);
        
        melodyNotes[i] = [ViewController getNote:scale :7 :[slice getAverageHue] / 255.0f];
    }
    
    [PdBase sendFloat:_numNotes toReceiver:[NSString stringWithFormat:@"%d-length", _patch.dollarZero]];
    [PdBase copyArray:values toArrayNamed:@"pattern" withOffset:0 count:_numNotes * _numIntruments];
    
    free(values);
}

// Handle the selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component 
{    
    _activeInstrument = row;
} 

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component 
{    
    NSUInteger numRows = 5;     
    return numRows;
} 

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView 
{ 
    return 1;
} 

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{    
    NSString *instrumentList[] = {@"Bell", @"Guitar", @"Test 3", @"Test 4", @"Test 5"};

    return instrumentList[row];
} 

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component 
{ 
    int sectionWidth = 300;  
    return sectionWidth;
}

// Done button on toolbar in UIPicker
-(void)toolBarDone
{
    NSString *instrumentList[] = {@"bell.aiff", @"a.wav", @"Test 3", @"Test 4", @"Test 5"};
    
    [PdBase sendMessage:instrumentList[_activeInstrument] withArguments:NULL toReceiver:[NSString stringWithFormat:@"%d-soundfile5", _patch.dollarZero]];
    
    [subView setHidden:TRUE];
}

// Back button on toolbar in UIPicker
-(void)toolBarBack
{
    [subView setHidden:TRUE];
}

+(float)getNote:(float*)scale :(int)size :(float)locationOnScale
{
    int index = (int)(locationOnScale * (size - 1) + 0.5f);
    return scale[index];
}

@end
