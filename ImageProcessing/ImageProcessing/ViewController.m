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

-(void)sliderMoved:(id)sender
{
    ImageSlice* slice = [_imagePropertes getSlice: (int)([slider value] * ([_imagePropertes numSlices]-1))];
    
    UIColor* col = [UIColor alloc];
    col = [col initWithRed:[slice getAverageRed]/255.0f green:[slice getAverageGreen]/255.0f blue:[slice getAverageBlue]/255.0f alpha:1.0f];
    [self.view setBackgroundColor: col];
}

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

-(void)cameraPressed:(id)sender
{ 
    [self activateImageChooser: YES];
}

-(void)loadPressed:(id)sender
{
    [self activateImageChooser: NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Init camera picker
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    
    _imagePropertes = [ImageProperties alloc];
    
    [PdBase setDelegate:self];
    
    _patch = [PdFile openFileNamed:@"wavetable.pd" path:[[NSBundle mainBundle] bundlePath]];
    
    [PdBase subscribe:[NSString stringWithFormat:@"%d-notifyProgress", _patch.dollarZero]];
    
    UIImage* image = [UIImage imageNamed:@"images.jpeg"];
    [self setImage: image];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
        float temp = received / 119;
        
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
}

-(void)updateValues:(UIImage *)image
{
    const int length = 120;
    
    float values [length];
    
    for (int i = 0; i < length; i++)
    {
        ImageSlice* slice = [_imagePropertes getSlice: (int)((i / (float)length) * ([_imagePropertes numSlices]-1))];
        
        float f = 20.0f * [slice getAverageVal] / 255.0f + 60.0f;        
        values[i] = f;
    }
    
    [PdBase copyArray:values toArrayNamed:@"seq" withOffset:0 count:length];
    [PdBase sendFloat:length toReceiver:[NSString stringWithFormat:@"%d-length", _patch.dollarZero]];
}

@end
