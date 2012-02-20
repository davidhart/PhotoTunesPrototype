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

-(void)sinePressed:(id)sender
{ 
    [PdBase sendBangToReceiver:@"sine"];
}

-(void)sawPressed:(id)sender
{ 
    [PdBase sendBangToReceiver:@"saw"];
}

-(void)harmonicPressed:(id)sender
{ 
    [PdBase sendBangToReceiver:@"harm"];
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

- (void)initialize
{
    _numNotes = 20;
    
    // Init camera picker
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    _imagePropertes = [ImageProperties alloc];
    
    [PdBase setDelegate:self];
    
    _patch = [PdFile openFileNamed:@"wavetable.pd" path:[[NSBundle mainBundle] bundlePath]];
    
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
    
    myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 63, 320, 200)];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;

    toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 19, self.view.frame.size.width, 44);
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarDone)];
    
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
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarBack)];  
    
    NSArray *buttons = [NSArray arrayWithObjects: item3, item2, item1, nil];
    [toolbar setItems: buttons animated:NO];
    
    [self.view addSubview:subView];
    [subView addSubview:myPickerView];
    [subView addSubview:toolbar];
    
    [subView setHidden:TRUE];
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
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
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
    float* values = malloc(_numNotes * sizeof(float));
    
    for (int i = 0; i < _numNotes; i++)
    {
        ImageSlice* slice = [_imagePropertes getSlice: (int)((i / (float)_numNotes) * ([_imagePropertes numSlices]-1))];
        
        float f = 20.0f * [slice getAverageVal] / 255.0f + 60.0f;        
        values[i] = f;
    }
    
    [PdBase copyArray:values toArrayNamed:@"seq" withOffset:0 count:_numNotes];
    [PdBase sendFloat:_numNotes toReceiver:[NSString stringWithFormat:@"%d-length", _patch.dollarZero]];
    
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
    NSString *instrumentList[] = {@"Test 1", @"Test 2", @"Test 3", @"Test 4", @"Test 5"};

    return instrumentList[row];
} 

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component 
{ 
    int sectionWidth = 300;  
    return sectionWidth;
}

-(void)toolBarDone
{
    //Send _activeInstrument to PD here;
    [subView setHidden:TRUE];
}

-(void)toolBarBack
{
    [subView setHidden:TRUE];
}

@end
